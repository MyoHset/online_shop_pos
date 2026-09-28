// =====================================================================
// SUPABASE EDGE FUNCTION: invite-staff  (v2 — secure)
//
// Deploy (Dashboard): Edge Functions -> Create a new function ->
//   name it exactly `invite-staff` -> paste this file -> Deploy.
// Deploy (CLI):      supabase functions deploy invite-staff
//
// SUPABASE_URL, SUPABASE_ANON_KEY and SUPABASE_SERVICE_ROLE_KEY are
// injected automatically into Edge Functions — no secrets to set.
//
// Request body (JSON): { email, password, fullName, role }
//   role: 'manager' | 'staff'
// The caller's identity and shop are taken from the JWT, NOT from the
// request body, so a client cannot invite staff into someone else's shop.
// =====================================================================

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // 1. Identify the caller from their JWT.
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) return json({ error: "Missing authorization header." }, 401);

    const userClient = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_ANON_KEY")!,
      { global: { headers: { Authorization: authHeader } } },
    );

    const { data: userData, error: userError } = await userClient.auth.getUser();
    if (userError || !userData.user) {
      return json({ error: "Invalid or expired session." }, 401);
    }
    const callerId = userData.user.id;

    // 2. Validate input.
    const { email, password, fullName, role } = await req.json();

    if (!email || !/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)) {
      return json({ error: "A valid email is required." }, 400);
    }
    if (!password || String(password).length < 8) {
      return json({ error: "Password must be at least 8 characters." }, 400);
    }
    if (!["manager", "staff"].includes(role)) {
      return json({ error: "Role must be 'manager' or 'staff'." }, 400);
    }

    const admin = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );

    // 3. Caller must be an ACTIVE OWNER. Shop comes from their own row.
    const { data: callerRow, error: callerError } = await admin
      .from("shop_staff")
      .select("shop_id, role")
      .eq("user_id", callerId)
      .eq("is_active", true)
      .maybeSingle();

    if (callerError || !callerRow || callerRow.role !== "owner") {
      return json({ error: "Only the shop owner can invite staff." }, 403);
    }
    const shopId = callerRow.shop_id;

    // 4. Create the auth user, flagged so the signup trigger skips it.
    const { data: created, error: createError } =
      await admin.auth.admin.createUser({
        email,
        password,
        email_confirm: true,
        user_metadata: { is_staff_invite: true, full_name: fullName ?? null },
      });

    if (createError || !created.user) {
      return json(
        { error: createError?.message ?? "Could not create the user." },
        400,
      );
    }

    // 5. Link to the owner's shop. Roll back the auth user on failure so
    //    we never leave an orphaned account behind.
    const { error: linkError } = await admin.from("shop_staff").insert({
      shop_id: shopId,
      user_id: created.user.id,
      role,
      full_name: fullName ?? null,
    });

    if (linkError) {
      await admin.auth.admin.deleteUser(created.user.id);
      return json({ error: linkError.message }, 400);
    }

    return json({ success: true, userId: created.user.id });
  } catch (e) {
    return json({ error: String(e) }, 500);
  }
});