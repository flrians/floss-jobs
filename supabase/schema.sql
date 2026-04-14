-- 1. Identity Table
create table if not exists public.profiles (
  id uuid references auth.users on delete cascade not null primary key,
  updated_at timestamp with time zone default timezone('utc'::text, now()),
  first_name text,
  last_name text,
  location text,
  email text,
  avatar_url text
);

-- 2. Precision Job Match Formula Table
create table if not exists public.job_preferences (
  id uuid references auth.users on delete cascade not null primary key,
  updated_at timestamp with time zone default timezone('utc'::text, now()),
  job_title text,
  location_preference text,
  work_type text, -- Remote, Hybrid, On-site
  min_salary text,
  ready_to_relocate boolean default false,
  
  -- Specialized Detailed Datapoints
  management_level text, -- IC, Team Lead, Manager, Director, Executive
  team_dynamic text, -- Individual Contributor, Small Team, Collaborative Unit
  travel_percentage text, -- 0%, 25%, 50%, 75%+
  company_culture text, -- Performance-driven, Work-life balance, Innovation-first
  tech_stack_focus text -- Main languages/tools
);

-- 3. Jobs Table
create table jobs (
  id uuid default uuid_generate_v4() primary key,
  title text not null,
  company text not null,
  location text not null,
  salary_min integer,
  salary_max integer,
  work_type text,
  description text,
  tags text[],
  benefits text[],
  contact_email text,
  is_active boolean default true,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable RLS
alter table jobs enable row level security;

-- Policies: Authenticated users can read all jobs
create policy "Anyone can view jobs" on jobs for select using (true);

-- Sample Data
insert into jobs (title, company, location, salary, work_type, description, tags, benefits, contact_email)
values 
('Senior Frontend Architect', 'TechFlow Solutions', 'San Francisco, CA', 165000, 'Remote', 'Lead our frontend evolution using Next.js and high-performance patterns.', ARRAY['React', 'Next.js', 'System Design'], ARRAY['Stock Options', 'Health', '401k'], 'careers@techflow.com'),
('AI Platform Engineer', 'DeepMind Labs', 'London, UK', 190000, 'Hybrid', 'Build the infrastructure scaling our next generation of neural networks.', ARRAY['Python', 'K8s', 'MLOps'], ARRAY['Free Lunch', 'Relocation', 'Gym'], 'hr@deepmind.com'),
('Principal Product Designer', 'InnovateX', 'Berlin, DE', 110000, 'On-site', 'Define the visual language for our fintech disruption suite.', ARRAY['Figma', 'UI/UX', 'Strategy'], ARRAY['Equity', 'Pension', 'Workshops'], 'design@innovatex.de');

-- 4. Enable RLS
alter table public.profiles enable row level security;
alter table public.job_preferences enable row level security;

-- 5. Policies (Profiles)
drop policy if exists "Users can view own profile" on profiles;
drop policy if exists "Users can update own profile" on profiles;
drop policy if exists "Users can insert own profile" on profiles;
create policy "Users can view own profile" on profiles for select using (auth.uid() = id);
create policy "Users can update own profile" on profiles for update using (auth.uid() = id);
create policy "Users can insert own profile" on profiles for insert with check (auth.uid() = id);

-- 5. Policies (Preferences)
drop policy if exists "Users can view own preferences" on job_preferences;
drop policy if exists "Users can update own preferences" on job_preferences;
drop policy if exists "Users can insert own preferences" on job_preferences;
create policy "Users can view own preferences" on job_preferences for select using (auth.uid() = id);
create policy "Users can update own preferences" on job_preferences for update using (auth.uid() = id);
create policy "Users can insert own preferences" on job_preferences for insert with check (auth.uid() = id);

-- 6. Trigger
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, first_name, last_name, email)
  values (new.id, new.raw_user_meta_data->>'first_name', new.raw_user_meta_data->>'last_name', new.email);
  insert into public.job_preferences (id) values (new.id);
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();
