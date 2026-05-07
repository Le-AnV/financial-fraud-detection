-- =============================================================
-- 01_schema_definition.sql
-- Tạo cấu trúc bảng cho hệ thống phát hiện gian lận tài chính
-- Database: fraud_detection | Engine: PostgreSQL
-- =============================================================
DROP TABLE IF EXISTS fact_transactions CASCADE;
DROP TABLE IF EXISTS dim_date        CASCADE;
DROP TABLE IF EXISTS dim_merchants   CASCADE;
DROP TABLE IF EXISTS dim_locations   CASCADE;
DROP TABLE IF EXISTS dim_devices     CASCADE;

-- -------------------------------------------------------------
-- DIMENSION TABLES
-- -------------------------------------------------------------

CREATE TABLE dim_date (
    date_id          DATE     PRIMARY KEY,
    transaction_date DATE     NOT NULL,
    year             SMALLINT NOT NULL CHECK (year >= 2000),
    month            SMALLINT NOT NULL CHECK (month BETWEEN 1 AND 12),
    day              SMALLINT NOT NULL CHECK (day   BETWEEN 1 AND 31),
    day_of_week      SMALLINT NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),
    is_weekend       BOOLEAN  NOT NULL
);

CREATE TABLE dim_merchants (
    merchant_id       INT         PRIMARY KEY,
    merchant_category VARCHAR(128)
);

CREATE TABLE dim_locations (
    location_id INT          PRIMARY KEY,
    location    VARCHAR(256) NOT NULL
);

CREATE TABLE dim_devices (
    device_id   BIGINT       PRIMARY KEY,
    device_used VARCHAR(128),
    device_hash VARCHAR(256),
    ip_address  INET
);

-- -------------------------------------------------------------
-- FACT TABLE
--
-- -------------------------------------------------------------

CREATE TABLE fact_transactions (
    transaction_id              VARCHAR(64)    PRIMARY KEY,

    sender_account              VARCHAR(64)    NOT NULL,
    receiver_account            VARCHAR(64)    NOT NULL,
    date_id                     DATE           NOT NULL REFERENCES dim_date(date_id),
    hour                        SMALLINT       CHECK (hour BETWEEN 0 AND 23),
    merchant_id                 INT            REFERENCES dim_merchants(merchant_id),
    location_id                 INT            REFERENCES dim_locations(location_id),
    device_id                   BIGINT         REFERENCES dim_devices(device_id),

    amount                      NUMERIC(18, 2) NOT NULL CHECK (amount >= 0),
    time_since_last_transaction NUMERIC(16, 6),
    spending_deviation_score    NUMERIC(10, 4),
    velocity_score              NUMERIC(10, 4),
    geo_anomaly_score           NUMERIC(10, 4),
    payment_channel             VARCHAR(64),

    is_fraud                    BOOLEAN        NOT NULL DEFAULT FALSE,
    fraud_type                  VARCHAR(128)
);