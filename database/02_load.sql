-- =============================================================
-- 02_data_ingestion.sql
-- Nạp dữ liệu từ CSV vào các bảng (Star Schema)
-- Thư mục CSV được mount tại: /mnt/shared_data/
-- =============================================================

BEGIN;

SET session_replication_role = replica;

-- -------------------------------------------------------------
-- 1. dim_date
-- -------------------------------------------------------------
COPY dim_date (date_id, transaction_date, year, month, day, day_of_week, is_weekend)
FROM '/mnt/shared_data/dim_date.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- -------------------------------------------------------------
-- 2. dim_merchants
-- -------------------------------------------------------------
COPY dim_merchants (merchant_id, merchant_category)
FROM '/mnt/shared_data/dim_merchants.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- -------------------------------------------------------------
-- 3. dim_locations
-- -------------------------------------------------------------
COPY dim_locations (location_id, location)
FROM '/mnt/shared_data/dim_locations.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- -------------------------------------------------------------
-- 4. dim_devices
-- -------------------------------------------------------------
COPY dim_devices (device_id, device_used, device_hash, ip_address)
FROM '/mnt/shared_data/dim_devices.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- -------------------------------------------------------------
-- 5. fact_transactions
-- -------------------------------------------------------------
COPY fact_transactions (
    transaction_id, sender_account, receiver_account,
    date_id, hour, merchant_id, location_id, device_id,
    amount, time_since_last_transaction, spending_deviation_score,
    velocity_score, geo_anomaly_score, payment_channel,
    is_fraud, fraud_type
)
FROM '/mnt/shared_data/fact_transactions.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

SET session_replication_role = DEFAULT;

-- -------------------------------------------------------------
-- Kiểm tra số bản ghi
-- -------------------------------------------------------------
SELECT 'dim_date'          AS table_name, COUNT(*) AS rows FROM dim_date
UNION ALL SELECT 'dim_merchants',          COUNT(*) FROM dim_merchants
UNION ALL SELECT 'dim_locations',          COUNT(*) FROM dim_locations
UNION ALL SELECT 'dim_devices',            COUNT(*) FROM dim_devices
UNION ALL SELECT 'fact_transactions',      COUNT(*) FROM fact_transactions
ORDER BY table_name;

COMMIT;