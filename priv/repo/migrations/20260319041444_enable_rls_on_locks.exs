defmodule Smartlock.Repo.Migrations.EnableRlsOnLocks do
  use Ecto.Migration

  def up do
    execute("""
    ALTER TABLE public.locks ENABLE ROW LEVEL SECURITY;
    """)

    execute("""
    CREATE POLICY "Allow full access to everyone"
    ON public.locks
    FOR ALL
    TO anon
    USING (true)
    WITH CHECK (true);
    """)
  end

  def down do
    execute("""
    DROP POLICY IF EXISTS "Allow full access to everyone" ON public.locks;
    """)

    execute("""
    ALTER TABLE public.locks DISABLE ROW LEVEL SECURITY;
    """)
  end
end
