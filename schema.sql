CREATE TYPE order_status AS ENUM ('pending' , 'delivered','canceled');
CREATE TYPE user_role AS ENUM ('customer','admin','seller');
CREATE TABLE users
(
    id SERIAL PRIMARY KEY ,
    email VARCHAR(255) UNIQUE NOT NULL CHECK ( position('@' in email) >0 ),
    password_hash TEXT        NOT NULL ,
    role    user_role         NOT NULL       DEFAULT 'customer',
    is_active BOOLEAN         NOT NULL       DEFAULT false,
    created_at TIMESTAMP                     DEFAULT NOW()
);
CREATE TABLE customer_profiles
(
    user_id         INT REFERENCES users (id) ON DELETE CASCADE,
    full_name       VARCHAR(255) NOT NULL ,
    phone           VARCHAR(15)  NOT NULL ,
    loyalty_points  INT          NOT NULL DEFAULT 0   CHECK ( loyalty_points >=0 ),
    dob             DATE
);
CREATE TABLE products
(
    id          SERIAL PRIMARY KEY ,
    name        VARCHAR(255)       NOT NULL ,
    price       NUMERIC(10,2)      NOT NULL DEFAULT 1 CHECK ( price >0 ),
    stock       INT                NOT NULL DEFAULT 1 CHECK ( stock >=0 ),
    created_at  TIMESTAMP          NOT NULL DEFAULT NOW(),
    metadata    jsonb              NOT NULL DEFAULT '{}'
);

CREATE TABLE orders
(
   id           SERIAL PRIMARY KEY ,
   user_id      INT    REFERENCES users (id)         ON DELETE RESTRICT ,
   status       order_status      NOT NULL DEFAULT 'pending',
   total        NUMERIC (10,2)    NOT NULL           CHECK ( total>0 ),
   created_at   TIMESTAMP                  DEFAULT NOW(),
   delivered_at TIMESTAMP
);
CREATE TABLE order_items
(
   id           SERIAL PRIMARY KEY ,
   order_id     INT    REFERENCES orders(id)         ON DELETE CASCADE ,
   product_id   INT    REFERENCES products(id)       ON DELETE RESTRICT,
   quantity     INT               NOT NULL           CHECK (quantity>0 ),
   unit_price   NUMERIC(10,2)     NOT NULL           CHECK ( unit_price>0 )
);

INSERT INTO users (email,password_hash,role)
VALUES ('3laamedany@g.com','hash_13547','admin')
RETURNING id;

SELECT id,email,role FROM users;

INSERT INTO customer_profiles (user_id, full_name, phone, dob)
VALUES (2,'rabe3a','01024708095','1996-08-06');
SELECT * FROM customer_profiles;