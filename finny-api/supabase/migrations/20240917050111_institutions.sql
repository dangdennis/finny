CREATE TABLE institutions (
    id SERIAL PRIMARY KEY,
    institution_id VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    oauth BOOLEAN NOT NULL,
    logo VARCHAR(255),
    primary_color VARCHAR(7),
    url VARCHAR(255),
    country_codes TEXT[],
    dtc_numbers TEXT[],
    products TEXT[],
    routing_numbers TEXT[]
);