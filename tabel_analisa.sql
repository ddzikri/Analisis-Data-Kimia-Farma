-- Membuat dataset baru
CREATE SCHEMA IF NOT EXISTS `kimiafarma-448111.analysis_data`;

-- Membuat tabel analisa
CREATE TABLE `kimiafarma-448111.analysis_data.analysis_table` AS
SELECT
  ft.transaction_id,
  ft.date,
  kc.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating AS rating_cabang,
  ft.customer_name,
  ft.product_id,
  p.product_name,
  ft.price AS actual_price,
  ft.discount_percentage,

  -- Menghitung persentase gross laba
  CASE
    WHEN ft.price <= 50000 THEN 0.10
    WHEN ft.price > 50000 AND ft.price <= 100000 THEN 0.15
    WHEN ft.price > 100000 AND ft.price <= 300000 THEN 0.20
    WHEN ft.price > 300000 AND ft.price <= 500000 THEN 0.25
    WHEN ft.price > 500000 THEN 0.30
  END AS persentase_gross_laba,

  -- Menghitung nett_sales
  ft.price * (1 - ft.discount_percentage / 100) AS nett_sales,

  -- Menghitung nett_profit
  (ft.price * (1 - ft.discount_percentage / 100)) *
  CASE
    WHEN ft.price <= 50000 THEN 0.10
    WHEN ft.price > 50000 AND ft.price <= 100000 THEN 0.15
    WHEN ft.price > 100000 AND ft.price <= 300000 THEN 0.20
    WHEN ft.price > 300000 AND ft.price <= 500000 THEN 0.25
    WHEN ft.price > 500000 THEN 0.30
  END AS nett_profit,

  -- Menggunakan rating transaksi dari final_transaction
  ft.rating AS rating_transaksi

FROM `kimiafarma-448111.finaltransaction.final_transaction` ft

JOIN `kimiafarma-448111.product.product` p
  ON ft.product_id = p.product_id

JOIN `kimiafarma-448111.kantor_cabang.kantor_cabang` kc
  ON ft.branch_id = kc.branch_id;
