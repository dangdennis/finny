CREATE TABLE finalytics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id),
    key TEXT NOT NULL,
    value TEXT NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX ix_finalytics_user_id ON finalytics(user_id);

CREATE UNIQUE INDEX ix_finalytics_user_id_key ON finalytics(user_id, key);