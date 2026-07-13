-- CoffeeShop — Saved payment methods (card metadata only; never store PAN/CVV)
-- Run after 000_auth_profiles.sql (requires auth.users).

-- ---------------------------------------------------------------------------
-- Table
-- ---------------------------------------------------------------------------

create table if not exists public.payment_methods (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null references auth.users (id) on delete cascade,
    brand text not null
        check (brand in ('visa', 'mastercard', 'amex', 'discover', 'unknown')),
    last4 text not null
        check (last4 ~ '^\d{4}$'),
    cardholder_name text not null
        check (char_length(trim(cardholder_name)) > 0),
    expiration_month integer not null
        check (expiration_month between 1 and 12),
    expiration_year integer not null
        check (expiration_year >= 2000),
    is_default boolean not null default false,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

comment on table public.payment_methods is
    'Saved cards for a user. Stores brand + last4 only — never full card number or CVV.';

create index if not exists payment_methods_user_id_idx
    on public.payment_methods (user_id);

create unique index if not exists payment_methods_one_default_per_user_idx
    on public.payment_methods (user_id)
    where is_default = true;

-- ---------------------------------------------------------------------------
-- updated_at trigger
-- ---------------------------------------------------------------------------

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
    new.updated_at = now();
    return new;
end;
$$;

drop trigger if exists payment_methods_set_updated_at on public.payment_methods;
create trigger payment_methods_set_updated_at
    before update on public.payment_methods
    for each row
    execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- Row Level Security — owner only
-- ---------------------------------------------------------------------------

alter table public.payment_methods enable row level security;

create policy "payment_methods_select_own"
    on public.payment_methods
    for select
    to authenticated
    using (auth.uid() = user_id);

create policy "payment_methods_insert_own"
    on public.payment_methods
    for insert
    to authenticated
    with check (auth.uid() = user_id);

create policy "payment_methods_update_own"
    on public.payment_methods
    for update
    to authenticated
    using (auth.uid() = user_id)
    with check (auth.uid() = user_id);

create policy "payment_methods_delete_own"
    on public.payment_methods
    for delete
    to authenticated
    using (auth.uid() = user_id);

grant select, insert, update, delete on public.payment_methods to authenticated;
