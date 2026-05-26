-- ========================================================
-- COCOGLO SOAP ERP - DATABASE MIGRATION SCRIPT
-- Add total_grams, yield mode, weights, and slab parameters to soaps table
-- Run this in your Supabase SQL Editor if you have an existing database
-- ========================================================

alter table soaps add column if not exists total_grams numeric not null default 1500.00;
alter table soaps add column if not exists yield_mode text not null default 'count';
alter table soaps add column if not exists yield_a numeric not null default 18.00;
alter table soaps add column if not exists yield_b numeric not null default 16.00;
alter table soaps add column if not exists weight_a numeric not null default 90.00;
alter table soaps add column if not exists weight_b numeric not null default 100.00;
alter table soaps add column if not exists slab_grams numeric not null default 1500.00;
