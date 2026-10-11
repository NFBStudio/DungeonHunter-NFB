-- Dungeon Hunter online leaderboard setup (Supabase)
-- 1. Create a Supabase project.
-- 2. In Authentication settings, allow anonymous sign-ins.
-- 3. Run this script in the Supabase SQL Editor.
-- 4. In the game HTML, set SUPABASE_URL and SUPABASE_PUBLISHABLE_KEY.
--    Use the public publishable/anon client key only; never expose service_role.
--
-- Anonymous identities persist in the same browser profile. Clearing browser
-- storage or changing devices creates a new identity unless account linking is
-- added. Scores are client-reported in this playtest, so they are not cheat-proof;
-- a production leaderboard should validate runs on a server.

create table if not exists public.hunter_leaderboard (
  player_id uuid primary key references auth.users(id) on delete cascade,
  player_name text not null
    check (
      char_length(player_name) between 3 and 20
      and player_name ~ '^[A-Za-z0-9][A-Za-z0-9 _-]{2,19}$'
    ),
  lifetime_score bigint not null default 0 check (lifetime_score >= 0),
  updated_at timestamptz not null default now()
);

create unique index if not exists hunter_leaderboard_player_name_ci
  on public.hunter_leaderboard (lower(player_name));

alter table public.hunter_leaderboard enable row level security;

drop policy if exists "Leaderboard is readable by players" on public.hunter_leaderboard;
create policy "Leaderboard is readable by players"
  on public.hunter_leaderboard for select
  to authenticated
  using (true);

drop policy if exists "Players can add their own score row" on public.hunter_leaderboard;
create policy "Players can add their own score row"
  on public.hunter_leaderboard for insert
  to authenticated
  with check ((select auth.uid()) = player_id);

drop policy if exists "Players can update their own score row" on public.hunter_leaderboard;
create policy "Players can update their own score row"
  on public.hunter_leaderboard for update
  to authenticated
  using ((select auth.uid()) = player_id)
  with check ((select auth.uid()) = player_id);

grant select, insert, update on public.hunter_leaderboard to authenticated;
