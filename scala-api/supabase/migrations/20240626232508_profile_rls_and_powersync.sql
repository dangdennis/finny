create policy "Enable profile read for authenticated users" on "public"."profiles" as PERMISSIVE for
SELECT
    to authenticated using (
        (
            select
                auth.uid()
        ) = id
    );

CREATE publication powersync FOR TABLE public.accounts,
public.assets,
public.goals,
public.profiles,
public.transactions;