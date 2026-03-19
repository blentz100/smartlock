defmodule Smartlock.Repo.Migrations.EnableRlsOnLocks do
  use Ecto.Migration

  def up do
    # Enable RLS (won't fail if already enabled)
    execute("""
    ALTER TABLE internal.locks ENABLE ROW LEVEL SECURITY;
    """)

    # Create policy only if it doesn't exist
    execute("""
    DO $$
    BEGIN
      IF NOT EXISTS (
        SELECT 1
        FROM pg_policies
        WHERE schemaname = 'internal'
          AND tablename = 'locks'
          AND policyname = 'Allow full access to everyone'
      ) THEN
        CREATE POLICY "Allow full access to everyone"
        ON internal.locks
        FOR ALL
        TO anon
        USING (true)
        WITH CHECK (true);
      END IF;
    END;
    $$;
    """)
  end

  def down do
    execute("""
    DROP POLICY IF EXISTS "Allow full access to everyone" ON internal.locks;
    """)

    execute("""
    ALTER TABLE internal.locks DISABLE ROW LEVEL SECURITY;
    """)
  end
end