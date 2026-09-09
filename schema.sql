CREATE TYPE user_role AS ENUM ('customer','admin','seller');
CREATE TABLE users
(
    id SERIAL PRIMARY KEY ,
    email         VARCHAR(255)           NOT NULL CHECK ( position('@'in email) ),
    password_hash TEXT                   NOT NULL ,
    is_active     BOOLEAN                NOT NULL DEFAULT FALSE ,
    role          user_role              NOT NULL DEFAULT 'customer',
    created_at    TIMESTAMP              NOT NULL DEFAULT NOW()
);

CREATE TABLE customer_profiles
(
    id              INT PRIMARY KEY      NOT NULL REFERENCES users(id) ON DELETE CASCADE ,
    full_name       VARCHAR(150)         NOT NULL ,
    phone           VARCHAR(15)          NOT NULL , --010/+20
    loyalty_points  INT                  NOT NULL DEFAULT 0 CHECK ( loyalty_points >=0 ),
    dob             DATE
);

CREATE TABLE products
(
    id SERIAL PRIMARY KEY ,
    name           VARCHAR(255)           NOT NULL ,
    price          NUMERIC(10,2)          NOT NULL           CHECK ( price >0 ),
    stock          INT                    NOT NULL DEFAULT 1 CHECK ( stock >=0 ) ,
    created_at     TIMESTAMP                       DEFAULT NOW(),
    metadata       json                          DEFAULT '{}'
);
