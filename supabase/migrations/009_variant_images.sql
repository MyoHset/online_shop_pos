-- ============================================================
-- Migration 009: Variant Images
-- ============================================================

-- ── variant_images table ──────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS variant_images (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  variant_id  uuid NOT NULL REFERENCES product_variants(id) ON DELETE CASCADE,
  image_url   text NOT NULL,
  is_primary  boolean NOT NULL DEFAULT false,
  sort_order  integer NOT NULL DEFAULT 0,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS variant_images_variant_id_idx ON variant_images(variant_id);

-- Auto-update updated_at on row modification
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger
    WHERE tgname = 'variant_images_updated_at'
  ) THEN
    CREATE TRIGGER variant_images_updated_at
      BEFORE UPDATE ON variant_images
      FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
  END IF;
END;
$$;

-- ── Trigger: set_single_primary_image ──────────────────────────────────────────
-- Ensures only one image per variant can have is_primary = true.
-- When a new image is set to primary, any existing primary images for that variant
-- are automatically set to false.

CREATE OR REPLACE FUNCTION set_single_primary_image()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  IF NEW.is_primary = true THEN
    UPDATE variant_images
    SET is_primary = false
    WHERE variant_id = NEW.variant_id
      AND id != NEW.id
      AND is_primary = true;
  END IF;
  RETURN NEW;
END;
$$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger
    WHERE tgname = 'enforce_single_primary_image'
  ) THEN
    CREATE TRIGGER enforce_single_primary_image
      BEFORE INSERT OR UPDATE OF is_primary ON variant_images
      FOR EACH ROW
      WHEN (NEW.is_primary = true)
      EXECUTE FUNCTION set_single_primary_image();
  END IF;
END;
$$;
