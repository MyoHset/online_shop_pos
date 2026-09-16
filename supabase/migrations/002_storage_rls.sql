-- ============================================================
-- Add Storage RLS policies for variant-images bucket
-- Run this in your Supabase SQL editor
-- ============================================================

-- Insert the bucket if it doesn't exist
INSERT INTO storage.buckets (id, name, public)
VALUES ('variant-images', 'variant-images', true)
ON CONFLICT DO NOTHING;

-- 1. Allow public read access to variant-images bucket
CREATE POLICY "Public Access" 
ON storage.objects FOR SELECT 
USING (bucket_id = 'variant-images');

-- 2. Allow authenticated users to upload to variant-images bucket
CREATE POLICY "Authenticated users can upload images"
ON storage.objects FOR INSERT 
WITH CHECK (bucket_id = 'variant-images' AND auth.role() = 'authenticated');

-- 3. Allow authenticated users to update images
CREATE POLICY "Authenticated users can update images"
ON storage.objects FOR UPDATE 
USING (bucket_id = 'variant-images' AND auth.role() = 'authenticated');

-- 4. Allow authenticated users to delete images
CREATE POLICY "Authenticated users can delete images"
ON storage.objects FOR DELETE 
USING (bucket_id = 'variant-images' AND auth.role() = 'authenticated');
