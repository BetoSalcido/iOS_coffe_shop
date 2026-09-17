-- CoffeeShop — Seed sample payment methods for local / demo testing
-- Run AFTER:
--   1) 009_payment_methods.sql
--   2) You have at least one user in Authentication → Users (sign up in the app)
--
-- Option A (recommended): set your login email below.
-- Option B: comment Option A and uncomment Option B to seed the most recent user.

-- ---------------------------------------------------------------------------
-- Option A — seed for a specific email
-- ---------------------------------------------------------------------------

do $$
declare
    target_user_id uuid;
begin
    select id
      into target_user_id
      from auth.users
     where email = 'YOUR_EMAIL@example.com'  -- ← replace with your Supabase Auth email
     limit 1;

    if target_user_id is null then
        raise exception
            'No auth.users row for that email. Sign up in the app first, then update the email in this script.';
    end if;

    -- Idempotent: remove previous seed rows for this user (fixed demo IDs)
    delete from public.payment_methods
     where user_id = target_user_id
       and id in (
           'c3000001-0001-4001-8001-000000000001',
           'c3000001-0001-4001-8001-000000000002',
           'c3000001-0001-4001-8001-000000000003'
       );

    insert into public.payment_methods (
        id,
        user_id,
        brand,
        last4,
        cardholder_name,
        expiration_month,
        expiration_year,
        is_default
    ) values
        (
            'c3000001-0001-4001-8001-000000000001',
            target_user_id,
            'visa',
            '4242',
            'Beto Salcido',
            12,
            2028,
            true
        ),
        (
            'c3000001-0001-4001-8001-000000000002',
            target_user_id,
            'mastercard',
            '4444',
            'Beto Salcido',
            6,
            2027,
            false
        ),
        (
            'c3000001-0001-4001-8001-000000000003',
            target_user_id,
            'amex',
            '0005',
            'Coffee Shop Guest',
            3,
            2029,
            false
        );
end $$;

-- ---------------------------------------------------------------------------
-- Option B — seed for the most recently created auth user
-- (uncomment and run instead of Option A if you prefer)
-- ---------------------------------------------------------------------------
/*
do $$
declare
    target_user_id uuid;
begin
    select id
      into target_user_id
      from auth.users
     order by created_at desc
     limit 1;

    if target_user_id is null then
        raise exception 'No auth.users found. Sign up in the app first.';
    end if;

    delete from public.payment_methods
     where user_id = target_user_id
       and id in (
           'c3000001-0001-4001-8001-000000000001',
           'c3000001-0001-4001-8001-000000000002',
           'c3000001-0001-4001-8001-000000000003'
       );

    insert into public.payment_methods (
        id, user_id, brand, last4, cardholder_name,
        expiration_month, expiration_year, is_default
    ) values
        ('c3000001-0001-4001-8001-000000000001', target_user_id, 'visa',       '4242', 'Beto Salcido',       12, 2028, true),
        ('c3000001-0001-4001-8001-000000000002', target_user_id, 'mastercard', '4444', 'Beto Salcido',        6, 2027, false),
        ('c3000001-0001-4001-8001-000000000003', target_user_id, 'amex',       '0005', 'Coffee Shop Guest',   3, 2029, false);
end $$;
*/
