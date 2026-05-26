-- ========================================================
-- COCOGLO SOAP ERP - SUPABASE DATABASE SETUP
-- Execute this script in your Supabase SQL Editor
-- Project URL: https://wnvpyncniudpibtflnja.supabase.co
-- ========================================================

-- 1. CLEANUP (Optional / Re-runnable)
drop table if exists recipe_ingredients cascade;
drop table if exists soaps cascade;
drop table if exists ingredients_master cascade;

-- 2. INGREDIENTS MASTER TABLE
create table ingredients_master (
    id uuid default gen_random_uuid() primary key,
    name text unique not null,
    rate numeric not null default 0.00,
    created_at timestamptz default now()
);

-- 3. SOAPS TABLE
create table soaps (
    id uuid default gen_random_uuid() primary key,
    name text not null,
    labour numeric not null default 250.00,
    total_grams numeric not null default 1500.00,
    yield_mode text not null default 'count',
    yield_a numeric not null default 18.00,
    yield_b numeric not null default 16.00,
    weight_a numeric not null default 90.00,
    weight_b numeric not null default 100.00,
    slab_grams numeric not null default 1500.00,
    created_at timestamptz default now()
);

-- 4. RECIPE INGREDIENTS RELATION TABLE
create table recipe_ingredients (
    id uuid default gen_random_uuid() primary key,
    soap_id uuid references soaps(id) on delete cascade not null,
    ingredient text references ingredients_master(name) on update cascade on delete cascade not null,
    percentage numeric, -- Optional (e.g. Infuse coconut or Carrot/Beetroot has no percentage)
    gram numeric not null default 0.00,
    created_at timestamptz default now()
);

-- 5. PERFORMANCE INDEXES
create index idx_recipe_ingredients_soap on recipe_ingredients(soap_id);
create index idx_recipe_ingredients_ingredient on recipe_ingredients(ingredient);

-- 6. ROW LEVEL SECURITY (RLS) FOR PUBLIC ACCESS (API Key Direct Connection)
alter table ingredients_master enable row level security;
alter table soaps enable row level security;
alter table recipe_ingredients enable row level security;

-- Policies for ingredients_master
create policy "Allow public read access to ingredients_master" on ingredients_master for select using (true);
create policy "Allow public insert access to ingredients_master" on ingredients_master for insert with check (true);
create policy "Allow public update access to ingredients_master" on ingredients_master for update using (true);
create policy "Allow public delete access to ingredients_master" on ingredients_master for delete using (true);

-- Policies for soaps
create policy "Allow public read access to soaps" on soaps for select using (true);
create policy "Allow public insert access to soaps" on soaps for insert with check (true);
create policy "Allow public update access to soaps" on soaps for update using (true);
create policy "Allow public delete access to soaps" on soaps for delete using (true);

-- Policies for recipe_ingredients
create policy "Allow public read access to recipe_ingredients" on recipe_ingredients for select using (true);
create policy "Allow public insert access to recipe_ingredients" on recipe_ingredients for insert with check (true);
create policy "Allow public update access to recipe_ingredients" on recipe_ingredients for update using (true);
create policy "Allow public delete access to recipe_ingredients" on recipe_ingredients for delete using (true);

-- ========================================================
-- SEED DATA
-- ========================================================

-- Seed Master Ingredients
insert into ingredients_master (name, rate) values
('Coconut oil', 0.47),
('Infuse coconut', 0.47),
('Olive oil', 0.61),
('Sheabutter', 0.74),
('Almond oil', 0.95),
('Castor oil', 0.35),
('Kumkumadi oil', 3.50),
('NaOH', 0.27),
('Goat milk', 0.50),
('Water', 0.00),
('Salt', 0.00),
('Sodium Lactate', 0.79),
('Colour', 1.29),
('Fragrance', 4.99),
('Carrot/Beetroot', 100.00)
on conflict (name) do update set rate = excluded.rate;

-- Seed Default Soaps & Recipes
-- Soap 1: Kumkumadi Goat Milk Soap
with new_soap as (
    insert into soaps (name, labour) 
    values ('Kumkumadi Goat Milk Soap', 250.00) 
    returning id
)
insert into recipe_ingredients (soap_id, ingredient, percentage, gram)
select (select id from new_soap), t.ingredient, t.percentage, t.gram
from (
    values 
    ('Coconut oil', 29.00, 435.00),
    ('Infuse coconut', null, 635.00),
    ('Olive oil', 34.00, 510.00),
    ('Sheabutter', 25.00, 375.00),
    ('Almond oil', 6.00, 90.00),
    ('Castor oil', 6.00, 90.00),
    ('Kumkumadi oil', 2.00, 30.00),
    ('NaOH', 33.00, 209.69),
    ('Goat milk', 2.03, 425.74),
    ('Salt', 1.00, 15.00),
    ('Sodium Lactate', 2.00, 30.00),
    ('Colour', 2.00, 30.00),
    ('Fragrance', 3.00, 45.00),
    ('Carrot/Beetroot', null, 1.00)
) as t(ingredient, percentage, gram);

-- Soap 2: Kumkumadi Water Soap
with new_soap as (
    insert into soaps (name, labour) 
    values ('Kumkumadi Water Soap', 250.00) 
    returning id
)
insert into recipe_ingredients (soap_id, ingredient, percentage, gram)
select (select id from new_soap), t.ingredient, t.percentage, t.gram
from (
    values 
    ('Coconut oil', 29.00, 435.00),
    ('Infuse coconut', null, 635.00),
    ('Olive oil', 34.00, 510.00),
    ('Sheabutter', 25.00, 375.00),
    ('Almond oil', 6.00, 90.00),
    ('Castor oil', 6.00, 90.00),
    ('Kumkumadi oil', 2.00, 30.00),
    ('NaOH', 33.00, 209.69),
    ('Water', 2.03, 425.74),
    ('Salt', 1.00, 15.00),
    ('Sodium Lactate', 2.00, 30.00),
    ('Colour', 2.00, 30.00),
    ('Fragrance', 3.00, 45.00),
    ('Carrot/Beetroot', null, 1.00)
) as t(ingredient, percentage, gram);
