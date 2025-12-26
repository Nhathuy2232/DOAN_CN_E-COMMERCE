-- Xóa bảng nếu đã tồn tại
DROP TABLE IF EXISTS flash_sales;

-- Bảng flash_sales: lưu thông tin sản phẩm giảm giá
CREATE TABLE flash_sales (
  id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT NOT NULL,
  discount_percentage DECIMAL(5, 2) NOT NULL,
  start_time DATETIME NOT NULL,
  end_time DATETIME NOT NULL,
  status ENUM('active', 'inactive', 'expired') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_flash_sales_product (product_id),
  INDEX idx_flash_sales_status (status),
  INDEX idx_flash_sales_time (start_time, end_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
