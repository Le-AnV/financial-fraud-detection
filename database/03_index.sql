-- =============================================================
-- 03_indexes.sql
-- Tạo chỉ mục tối ưu hóa hiệu năng truy vấn
-- Áp dụng sau khi nạp dữ liệu xong (02_data_ingestion.sql)
-- =============================================================

-- -------------------------------------------------------------
-- fact_transactions
-- -------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_fact_is_fraud
    ON fact_transactions (is_fraud);

CREATE INDEX IF NOT EXISTS idx_fact_fraud_type
    ON fact_transactions (fraud_type)
    WHERE fraud_type IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_fact_date_id
    ON fact_transactions (date_id);

CREATE INDEX IF NOT EXISTS idx_fact_sender
    ON fact_transactions (sender_account);

CREATE INDEX IF NOT EXISTS idx_fact_receiver
    ON fact_transactions (receiver_account);

CREATE INDEX IF NOT EXISTS idx_fact_payment_channel
    ON fact_transactions (payment_channel);

CREATE INDEX IF NOT EXISTS idx_fact_device_id
    ON fact_transactions (device_id);

CREATE INDEX IF NOT EXISTS idx_fact_location_id
    ON fact_transactions (location_id);

CREATE INDEX IF NOT EXISTS idx_fact_merchant_id
    ON fact_transactions (merchant_id);

CREATE INDEX IF NOT EXISTS idx_fact_hour
    ON fact_transactions (hour);

CREATE INDEX IF NOT EXISTS idx_fact_fraud_date
    ON fact_transactions (is_fraud, date_id);

-- -------------------------------------------------------------
-- dim_date
-- -------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_date_year_month
    ON dim_date (year, month);

CREATE INDEX IF NOT EXISTS idx_date_is_weekend
    ON dim_date (is_weekend);

-- -------------------------------------------------------------
-- dim_devices
-- -------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_devices_hash
    ON dim_devices (device_hash)
    WHERE device_hash IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_devices_ip
    ON dim_devices (ip_address)
    WHERE ip_address IS NOT NULL;

-- -------------------------------------------------------------
-- dim_merchants
-- -------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_merchants_category
    ON dim_merchants (merchant_category);

-- -------------------------------------------------------------
-- Kiểm tra danh sách index đã tạo
-- -------------------------------------------------------------
SELECT indexname, tablename, indexdef
FROM pg_indexes
WHERE schemaname = 'public'
  AND indexname LIKE 'idx_%'
ORDER BY tablename, indexname;