-- Migration: Add profile_image_url to users table
-- Date: 2025-12-05
-- Description: Allows users to have a profile photo

ALTER TABLE users ADD COLUMN IF NOT EXISTS profile_image_url VARCHAR;

-- Add comment for documentation
COMMENT ON COLUMN users.profile_image_url IS 'URL of the user profile image stored in /static/profiles/';
