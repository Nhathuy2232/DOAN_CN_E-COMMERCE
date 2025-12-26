
-- ============================================
-- FISHING SHOP - FULL DATABASE SETUP
-- Gộp từ fishing_shop.sql, add_ghn_columns.sql, add_wishlist_and_reviews.sql
-- Date: 2025-12-25
-- ============================================

-- ============================================
-- FISHING SHOP - DATABASE SETUP COMPLETE
-- Tạo database hoàn chỉnh với tất cả bảng và dữ liệu mẫu
-- Version: 1.0
-- Date: 2025-12-04
-- ============================================

-- Xóa database cũ nếu tồn tại và tạo mới
DROP DATABASE IF EXISTS fishing_shop;
CREATE DATABASE fishing_shop
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE fishing_shop;

-- ============================================
-- BẢNG NGƯỜI DÙNG (USERS)
-- ============================================
CREATE TABLE users (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'ID người dùng',
  full_name VARCHAR(120) NOT NULL COMMENT 'Họ và tên',
  email VARCHAR(150) NOT NULL UNIQUE COMMENT 'Email đăng nhập',
  password_hash VARCHAR(255) NOT NULL COMMENT 'Mật khẩu đã mã hóa',
  role ENUM('customer', 'admin') NOT NULL DEFAULT 'customer' COMMENT 'Vai trò: khách hàng hoặc quản trị viên',
  phone VARCHAR(20) COMMENT 'Số điện thoại',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Thời gian cập nhật'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng người dùng';

-- ============================================
-- BẢNG DANH MỤC SẢN PHẨM (CATEGORIES)
-- ============================================
CREATE TABLE categories (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'ID danh mục',
  name VARCHAR(120) NOT NULL UNIQUE COMMENT 'Tên danh mục',
  description TEXT COMMENT 'Mô tả danh mục',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng danh mục sản phẩm';

-- ============================================
-- BẢNG SẢN PHẨM (PRODUCTS)
-- ============================================
CREATE TABLE products (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'ID sản phẩm',
  category_id INT UNSIGNED COMMENT 'ID danh mục',
  name VARCHAR(200) NOT NULL COMMENT 'Tên sản phẩm',
  description TEXT COMMENT 'Mô tả chi tiết',
  price DECIMAL(12, 2) NOT NULL COMMENT 'Giá bán (VNĐ)',
  sku VARCHAR(80) NOT NULL UNIQUE COMMENT 'Mã SKU sản phẩm',
  stock_quantity INT NOT NULL DEFAULT 0 COMMENT 'Số lượng tồn kho',
  thumbnail_url VARCHAR(255) COMMENT 'URL ảnh đại diện',
  status ENUM('draft', 'active', 'inactive') DEFAULT 'active' COMMENT 'Trạng thái: nháp, đang bán, ngừng bán',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Thời gian cập nhật',
  CONSTRAINT fk_products_category FOREIGN KEY (category_id)
    REFERENCES categories (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng sản phẩm';

-- ============================================
-- BẢNG HÌNH ẢNH SẢN PHẨM (PRODUCT_IMAGES)
-- ============================================
CREATE TABLE product_images (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'ID hình ảnh',
  product_id INT UNSIGNED NOT NULL COMMENT 'ID sản phẩm',
  image_url VARCHAR(255) NOT NULL COMMENT 'URL hình ảnh',
  alt_text VARCHAR(120) COMMENT 'Mô tả ảnh (alt text)',
  is_primary TINYINT(1) DEFAULT 0 COMMENT 'Là ảnh chính (1) hay không (0)',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo',
  CONSTRAINT fk_images_product FOREIGN KEY (product_id)
    REFERENCES products (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng hình ảnh sản phẩm';

-- ============================================
-- BẢNG ĐỊA CHỈ GIAO HÀNG (ADDRESSES)
-- ============================================
CREATE TABLE addresses (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'ID địa chỉ',
  user_id INT UNSIGNED NOT NULL COMMENT 'ID người dùng',
  label VARCHAR(60) NOT NULL COMMENT 'Nhãn địa chỉ (ví dụ: Nhà riêng, Công ty)',
  full_name VARCHAR(120) NOT NULL COMMENT 'Họ tên người nhận',
  phone VARCHAR(20) NOT NULL COMMENT 'Số điện thoại',
  address_line TEXT NOT NULL COMMENT 'Địa chỉ chi tiết',
  province VARCHAR(80) NOT NULL COMMENT 'Tỉnh/Thành phố',
  district VARCHAR(80) NOT NULL COMMENT 'Quận/Huyện',
  ward VARCHAR(80) NOT NULL COMMENT 'Phường/Xã',
  is_default TINYINT(1) DEFAULT 0 COMMENT 'Địa chỉ mặc định (1) hay không (0)',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo',
  CONSTRAINT fk_addresses_user FOREIGN KEY (user_id)
    REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng địa chỉ giao hàng';

-- ============================================
-- BẢNG GIỎ HÀNG (CARTS)
-- ============================================
CREATE TABLE carts (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'ID giỏ hàng',
  user_id INT UNSIGNED NOT NULL COMMENT 'ID người dùng',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Thời gian cập nhật',
  CONSTRAINT fk_carts_user FOREIGN KEY (user_id)
    REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng giỏ hàng';

-- ============================================
-- BẢNG CHI TIẾT GIỎ HÀNG (CART_ITEMS)
-- ============================================
CREATE TABLE cart_items (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'ID chi tiết giỏ hàng',
  cart_id INT UNSIGNED NOT NULL COMMENT 'ID giỏ hàng',
  product_id INT UNSIGNED NOT NULL COMMENT 'ID sản phẩm',
  quantity INT NOT NULL DEFAULT 1 COMMENT 'Số lượng',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Thời gian cập nhật',
  UNIQUE KEY uniq_cart_product (cart_id, product_id),
  CONSTRAINT fk_cart_items_cart FOREIGN KEY (cart_id)
    REFERENCES carts (id) ON DELETE CASCADE,
  CONSTRAINT fk_cart_items_product FOREIGN KEY (product_id)
    REFERENCES products (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng chi tiết giỏ hàng';

-- ============================================
-- BẢNG ĐƠN HÀNG (ORDERS)
-- ============================================
CREATE TABLE orders (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'ID đơn hàng',
  user_id INT UNSIGNED NOT NULL COMMENT 'ID người dùng',
  address_id INT UNSIGNED NOT NULL COMMENT 'ID địa chỉ giao hàng',
  status ENUM('pending','paid','shipped','completed','cancelled') DEFAULT 'pending' COMMENT 'Trạng thái: chờ xử lý, đã thanh toán, đã giao hàng, hoàn thành, đã hủy',
  payment_method ENUM('cod','bank_transfer','e_wallet') DEFAULT 'cod' COMMENT 'Phương thức thanh toán: COD, chuyển khoản, ví điện tử',
  total_amount DECIMAL(12, 2) NOT NULL COMMENT 'Tổng tiền (VNĐ)',
  note TEXT COMMENT 'Ghi chú đơn hàng',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Thời gian cập nhật',
  CONSTRAINT fk_orders_user FOREIGN KEY (user_id)
    REFERENCES users (id) ON DELETE CASCADE,
  CONSTRAINT fk_orders_address FOREIGN KEY (address_id)
    REFERENCES addresses (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng đơn hàng';

-- ============================================
-- BẢNG CHI TIẾT ĐƠN HÀNG (ORDER_ITEMS)
-- ============================================
CREATE TABLE order_items (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'ID chi tiết đơn hàng',
  order_id INT UNSIGNED NOT NULL COMMENT 'ID đơn hàng',
  product_id INT UNSIGNED NOT NULL COMMENT 'ID sản phẩm',
  quantity INT NOT NULL COMMENT 'Số lượng',
  price DECIMAL(12, 2) NOT NULL COMMENT 'Giá tại thời điểm đặt hàng (VNĐ)',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo',
  CONSTRAINT fk_order_items_order FOREIGN KEY (order_id)
    REFERENCES orders (id) ON DELETE CASCADE,
  CONSTRAINT fk_order_items_product FOREIGN KEY (product_id)
    REFERENCES products (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng chi tiết đơn hàng';

-- ============================================
-- BẢNG TOKEN LÀM MỚI (REFRESH_TOKENS)
-- ============================================
CREATE TABLE refresh_tokens (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'ID token',
  user_id INT UNSIGNED NOT NULL COMMENT 'ID người dùng',
  token VARCHAR(255) NOT NULL COMMENT 'Token làm mới',
  expires_at DATETIME NOT NULL COMMENT 'Thời gian hết hạn',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo',
  CONSTRAINT fk_refresh_user FOREIGN KEY (user_id)
    REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng token làm mới phiên đăng nhập';

-- ============================================
-- BẢNG NHẬT KÝ HOẠT ĐỘNG (ACTIVITY_LOGS)
-- ============================================
CREATE TABLE activity_logs (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'ID bản ghi',
  user_id INT UNSIGNED COMMENT 'ID người dùng (NULL nếu là hệ thống)',
  action VARCHAR(120) NOT NULL COMMENT 'Hành động (ví dụ: login, create_order, update_product)',
  metadata JSON COMMENT 'Dữ liệu bổ sung dạng JSON',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo',
  INDEX idx_logs_user (user_id),
  CONSTRAINT fk_logs_user FOREIGN KEY (user_id)
    REFERENCES users (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng nhật ký hoạt động người dùng và hệ thống';

-- ============================================
-- BẢNG MÃ GIẢM GIÁ (COUPONS)
-- ============================================
CREATE TABLE coupons (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'ID mã giảm giá',
  code VARCHAR(50) NOT NULL UNIQUE COMMENT 'Mã giảm giá',
  description TEXT COMMENT 'Mô tả khuyến mãi',
  discount_type ENUM('percentage', 'fixed') NOT NULL DEFAULT 'percentage' COMMENT 'Loại giảm: phần trăm hoặc cố định',
  discount_value DECIMAL(10,2) NOT NULL COMMENT 'Giá trị giảm',
  min_order_value DECIMAL(10,2) DEFAULT 0 COMMENT 'Giá trị đơn hàng tối thiểu',
  max_discount DECIMAL(10,2) COMMENT 'Giảm tối đa (cho % discount)',
  usage_limit INT COMMENT 'Số lần sử dụng tối đa',
  used_count INT DEFAULT 0 COMMENT 'Số lần đã sử dụng',
  start_date DATETIME NOT NULL COMMENT 'Ngày bắt đầu',
  end_date DATETIME NOT NULL COMMENT 'Ngày kết thúc',
  is_active BOOLEAN DEFAULT TRUE COMMENT 'Trạng thái kích hoạt',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Thời gian cập nhật'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng mã giảm giá';

-- ============================================
-- BẢNG BLOG (BLOGS)
-- ============================================
CREATE TABLE blogs (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'ID blog',
  title VARCHAR(255) NOT NULL COMMENT 'Tiêu đề bài viết',
  slug VARCHAR(255) NOT NULL UNIQUE COMMENT 'URL slug',
  excerpt TEXT COMMENT 'Tóm tắt ngắn',
  content LONGTEXT NOT NULL COMMENT 'Nội dung đầy đủ',
  thumbnail VARCHAR(500) COMMENT 'Ảnh đại diện',
  author_id INT UNSIGNED COMMENT 'ID người viết',
  category VARCHAR(100) COMMENT 'Danh mục blog',
  tags JSON COMMENT 'Các tag',
  view_count INT DEFAULT 0 COMMENT 'Số lượt xem',
  is_published BOOLEAN DEFAULT FALSE COMMENT 'Đã xuất bản',
  published_at DATETIME COMMENT 'Thời gian xuất bản',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Thời gian cập nhật',
  FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng blog';

-- ============================================
-- DỮ LIỆU MẪU - DANH MỤC
-- ============================================
INSERT INTO categories (name, description) VALUES
('Cần Câu', 'Các loại cần câu carbon, composite, telescopic'),
('Máy Câu', 'Máy câu cá các loại spinning, baitcasting, trolling'),
('Dây Cước', 'Dây câu PE, Carbon, Nylon, Fluorocarbon'),
('Lưỡi Câu', 'Móc câu các size và loại cho mọi đối tượng cá'),
('Mồi Câu', 'Mồi giả, mồi sống, wobbler, crankbait'),
('Phụ Kiện Cần', 'Túi đựng, hộp đồ nghề, găng tay, khăn'),
('Chì Câu', 'Chì câu, chì nổi, chì đáy các loại'),
('Kéo & Dao', 'Kéo cắt dây, dao phi lê, dao đa năng'),
('Quần Áo Câu', 'Áo chống nắng, quần câu cá, giày ủng'),
('Túi Đồ Nghề', 'Ba lô, túi đeo, hộp nhựa đựng đồ câu');

-- ============================================
-- DỮ LIỆU MẪU - NGƯỜI DÙNG
-- ============================================
-- Password mặc định cho tất cả: admin123
-- Hash: $2b$10$EKourMjlxZhgXt5XDjF47.9FVqlmryxqvsSojaaMQulAWuRV/NtSi
INSERT INTO users (full_name, email, password_hash, role, phone) VALUES
('Admin', 'admin@fishing-shop.com', '$2b$10$EKourMjlxZhgXt5XDjF47.9FVqlmryxqvsSojaaMQulAWuRV/NtSi', 'admin', '0123456789'),
('Nguyễn Văn A', 'user@example.com', '$2b$10$EKourMjlxZhgXt5XDjF47.9FVqlmryxqvsSojaaMQulAWuRV/NtSi', 'customer', '0987654321');

-- ============================================
-- DỮ LIỆU MẪU - SẢN PHẨM (100 sản phẩm - 10 sản phẩm/danh mục)
-- ============================================
INSERT INTO products (category_id, name, description, price, sku, stock_quantity, thumbnail_url, status) VALUES
-- DANH MỤC 1: CẦN CÂU (10 sản phẩm)
(1, 'Cần Câu Carbon Pro 2.1m', 'Cần câu carbon cao cấp chuyên dụng cho câu lure và bơi câu. Độ bền vượt trội, trọng lượng nhẹ 185g.', 1500000, 'CC-PRO-21', 50, '/images/products/can-cau-1.jpg', 'active'),
(1, 'Cần Câu Daiwa Legalis 1.8m', 'Cần câu Daiwa nhập khẩu chính hãng từ Nhật Bản. Thiết kế 2 khúc rời tiện lợi.', 1200000, 'CC-DAI-18', 45, '/images/products/can-cau-2.jpg', 'active'),
(1, 'Cần Câu Telescopic 3.6m', 'Cần câu rút gọn tiện lợi, dài 3.6m khi mở, chỉ 50cm khi gấp. Phù hợp cho câu xa bờ.', 850000, 'CC-TEL-36', 60, '/images/products/can-cau-3.jpg', 'active'),
(1, 'Cần Câu Shimano FX 2.4m', 'Cần câu giá tốt cho người mới bắt đầu, độ bền cao, chịu lực 10kg.', 980000, 'CC-SHI-24', 55, '/images/products/can-cau-4.jpg', 'active'),
(1, 'Cần Câu Jigging 1.65m', 'Cần câu jigging chuyên dụng cho câu cá biển, thân cứng, nhạy cảm tốt.', 2200000, 'CC-JIG-165', 30, '/images/products/can-cau-5.jpg', 'active'),
(1, 'Cần Câu Surf 4.2m', 'Cần câu surf casting dài 4.2m cho câu ném xa từ bờ biển.', 1800000, 'CC-SURF-42', 25, '/images/products/can-cau-6.jpg', 'active'),
(1, 'Cần Câu Lure Bass 1.98m', 'Cần câu lure chuyên săn cá bass, độ nhạy cao, thiết kế split grip.', 1650000, 'CC-BASS-198', 40, '/images/products/can-cau-7.jpg', 'active'),
(1, 'Cần Câu Abu Garcia 2.13m', 'Cần câu Abu Garcia chất lượng Mỹ, thiết kế robust cho câu cá lớn.', 1950000, 'CC-ABU-213', 35, '/images/products/can-cau-8.jpg', 'active'),
(1, 'Cần Câu Máy Ngang 1.8m', 'Cần câu chuyên dụng cho máy câu ngang baitcasting, chịu lực 15kg.', 1450000, 'CC-NGANG-18', 42, '/images/products/can-cau-9.jpg', 'active'),
(1, 'Cần Câu Cá Tre 5.4m', 'Cần câu cá tre truyền thống Nhật Bản, siêu nhẹ, độ bền tuyệt vời.', 3500000, 'CC-TRE-54', 15, '/images/products/can-cau-10.jpg', 'active'),

-- DANH MỤC 2: MÁY CÂU (10 sản phẩm)
(2, 'Máy Câu Shimano 3000', 'Máy câu spinning Shimano 3000 với công nghệ Hagane Body, 5+1BB.', 2500000, 'MC-SHI-3000', 38, '/images/products/may-cau-1.jpg', 'active'),
(2, 'Máy Câu Daiwa BG 4000', 'Máy câu Daiwa BG 4000 chuyên dụng cho cá biển và cá nước ngọt cỡ lớn.', 3200000, 'MC-DAI-4000', 28, '/images/products/may-cau-2.jpg', 'active'),
(2, 'Máy Câu Penn Battle III 2500', 'Máy câu Penn Battle chống nước mặn tuyệt đối, 6+1BB.', 2800000, 'MC-PENN-2500', 32, '/images/products/may-cau-3.jpg', 'active'),
(2, 'Máy Câu Abu Garcia Pro Max', 'Máy câu ngang Abu Garcia cho câu lure bass, tỷ số truyền 7.1:1.', 2100000, 'MC-ABU-PMAX', 35, '/images/products/may-cau-4.jpg', 'active'),
(2, 'Máy Câu Daiwa Tatula 100', 'Máy câu ngang Daiwa Tatula siêu nhẹ 190g, phanh từ tính TWS.', 3800000, 'MC-TAT-100', 22, '/images/products/may-cau-5.jpg', 'active'),
(2, 'Máy Câu Shimano Stradic 4000', 'Máy câu Shimano Stradic CI4+ siêu nhẹ, công nghệ X-Ship.', 4200000, 'MC-STR-4000', 18, '/images/products/may-cau-6.jpg', 'active'),
(2, 'Máy Câu Okuma Ceymar 3000', 'Máy câu giá rẻ chất lượng tốt cho người mới, 8BB.', 850000, 'MC-OKU-3000', 65, '/images/products/may-cau-7.jpg', 'active'),
(2, 'Máy Câu Shimano Sedona 2500', 'Máy câu Shimano Sedona entry level, độ bền cao.', 1200000, 'MC-SED-2500', 55, '/images/products/may-cau-8.jpg', 'active'),
(2, 'Máy Câu Jigging Daiwa Saltiga', 'Máy câu jigging cao cấp Daiwa Saltiga cho cá biển lớn.', 12500000, 'MC-SALT-JIG', 8, '/images/products/may-cau-9.jpg', 'active'),
(2, 'Máy Câu Fly Fishing Orvis', 'Máy câu ruồi Orvis chuyên nghiệp cho câu cá hồi.', 5800000, 'MC-FLY-ORV', 12, '/images/products/may-cau-10.jpg', 'active'),

-- DANH MỤC 3: DÂY CƯỚC (10 sản phẩm)
(3, 'Dây PE 8 Lõi 150m', 'Dây câu PE 8 lõi cao cấp, sức bền vượt trội, độ dãn giãn thấp.', 350000, 'DY-PE8-150', 120, '/images/products/day-cuoc-1.jpg', 'active'),
(3, 'Dây Carbon Fluorocarbon 50m', 'Dây Fluorocarbon 100% trong suốt dưới nước, độ chìm nhanh.', 280000, 'DY-CF-50', 95, '/images/products/day-cuoc-2.jpg', 'active'),
(3, 'Dây Nylon Asso 300m', 'Dây nylon chất lượng Đức, độ bền cao, giá cả phải chăng.', 150000, 'DY-NYL-300', 150, '/images/products/day-cuoc-3.jpg', 'active'),
(3, 'Dây PE 4 Lõi Sunline 200m', 'Dây PE 4 lõi Sunline Nhật Bản, mềm mại, ném xa.', 420000, 'DY-PE4-200', 85, '/images/products/day-cuoc-4.jpg', 'active'),
(3, 'Dây Leader Fluorocarbon 30m', 'Dây leader chống mài mòn cho câu cá có răng sắc.', 180000, 'DY-LD-30', 110, '/images/products/day-cuoc-5.jpg', 'active'),
(3, 'Dây Braid Daiwa J-Braid 300m', 'Dây braid Daiwa 8 sợi, độ bền cao, nhiều màu sắc.', 580000, 'DY-JBR-300', 75, '/images/products/day-cuoc-6.jpg', 'active'),
(3, 'Dây Monofilament 500m', 'Dây monofilament cơ bản cho câu cá phổ thông.', 85000, 'DY-MONO-500', 200, '/images/products/day-cuoc-7.jpg', 'active'),
(3, 'Dây PE Shimano Kairiki 150m', 'Dây PE Shimano Kairiki 8 sợi màu xanh lá.', 520000, 'DY-KAI-150', 68, '/images/products/day-cuoc-8.jpg', 'active'),
(3, 'Dây Casting Line 100m', 'Dây chuyên dụng cho máy câu ngang, độ cứng vừa phải.', 220000, 'DY-CAST-100', 90, '/images/products/day-cuoc-9.jpg', 'active'),
(3, 'Dây Fly Line Trout', 'Dây câu ruồi cho cá hồi, nổi, màu cam.', 850000, 'DY-FLY-TRT', 45, '/images/products/day-cuoc-10.jpg', 'active'),

-- DANH MỤC 4: LƯỠI CÂU (10 sản phẩm)
(4, 'Bộ 100 Lưỡi Câu Assorted', 'Bộ 100 chiếc lưỡi câu đa dạng size 1-10 trong hộp nhựa tiện lợi.', 150000, 'LC-ASS-100', 250, '/images/products/luoi-cau-1.jpg', 'active'),
(4, 'Lưỡi Câu Chuyên Dụng Size 8/0', 'Lưỡi câu cỡ lớn size 8/0 cho săn cá tra, cá hú, cá mú.', 80000, 'LC-BIG-80', 180, '/images/products/luoi-cau-2.jpg', 'active'),
(4, 'Lưỡi Câu Owner Treble Hook', 'Lưỡi câu 3 nhánh Owner Nhật Bản, cực sắc, chống gỉ.', 120000, 'LC-OWN-TRE', 140, '/images/products/luoi-cau-3.jpg', 'active'),
(4, 'Lưỡi Câu Circle Hook Size 2/0', 'Lưỡi câu tròn tự móc, giảm tỷ lệ cá chết, size 2/0.', 95000, 'LC-CIR-20', 165, '/images/products/luoi-cau-4.jpg', 'active'),
(4, 'Lưỡi Câu Jig Head 5g', 'Lưỡi jig head có chì 5g cho câu mồi mềm.', 45000, 'LC-JIG-5G', 220, '/images/products/luoi-cau-5.jpg', 'active'),
(4, 'Lưỡi Câu Worm Hook', 'Lưỡi câu worm offset cho mồi giun nhựa, size 2/0.', 75000, 'LC-WORM-20', 155, '/images/products/luoi-cau-6.jpg', 'active'),
(4, 'Lưỡi Câu Gamakatsu Octopus', 'Lưỡi câu Gamakatsu Octopus chống rỉ, size 1/0.', 110000, 'LC-GAM-OCT', 125, '/images/products/luoi-cau-7.jpg', 'active'),
(4, 'Lưỡi Câu Chống Rối Hair Rig', 'Lưỡi câu chống rối với lông cho câu cá chép.', 65000, 'LC-HAIR-RIG', 185, '/images/products/luoi-cau-8.jpg', 'active'),
(4, 'Lưỡi Câu Assist Hook Jigging', 'Lưỡi câu assist dành cho jigging cá biển lớn.', 180000, 'LC-AST-JIG', 95, '/images/products/luoi-cau-9.jpg', 'active'),
(4, 'Lưỡi Câu Drop Shot', 'Lưỡi câu drop shot size 1 cho kỹ thuật câu thả chìm.', 85000, 'LC-DROP-1', 170, '/images/products/luoi-cau-10.jpg', 'active'),

-- DANH MỤC 5: MỒI CÂU (10 sản phẩm)
(5, 'Mồi Giả Rapala 12cm', 'Mồi cá giả Rapala Original Floating 12cm, huyền thoại câu lure.', 250000, 'MG-RAP-12', 75, '/images/products/moi-cau-1.jpg', 'active'),
(5, 'Mồi Mềm Silicon 10 Con', 'Bộ 10 con mồi mềm silicon nhiều màu sắc cho câu cá lóc, cá rô.', 120000, 'MM-SIL-10', 110, '/images/products/moi-cau-2.jpg', 'active'),
(5, 'Mồi Crankbait Duo Realis', 'Mồi crankbait Duo Realis lặn sâu 2-3m, âm thanh hấp dẫn.', 320000, 'MC-DUO-CRK', 65, '/images/products/moi-cau-3.jpg', 'active'),
(5, 'Mồi Topwater Popper', 'Mồi nổi popper tạo âm thanh chộp nước, câu cá tầng mặt.', 180000, 'MT-POP-7CM', 88, '/images/products/moi-cau-4.jpg', 'active'),
(5, 'Mồi Spinner Mepps', 'Mồi quay Mepps cổ điển Pháp, lưỡi kim loại lấp lánh.', 95000, 'MS-MEP-3', 145, '/images/products/moi-cau-5.jpg', 'active'),
(5, 'Mồi Jig Rubber 14g', 'Mồi jig cao su 14g với váy silicon rung động mạnh.', 55000, 'MJ-RUB-14', 195, '/images/products/moi-cau-6.jpg', 'active'),
(5, 'Mồi Frog Topwater', 'Mồi nhái silicon cho câu cá lóc ở vùng đầm lầy.', 160000, 'MF-FROG-6CM', 92, '/images/products/moi-cau-7.jpg', 'active'),
(5, 'Mồi Shad Tail 12cm', 'Mồi đuôi quẹt 12cm mô phỏng cá mồi tự nhiên.', 85000, 'MS-SHAD-12', 135, '/images/products/moi-cau-8.jpg', 'active'),
(5, 'Mồi Metal Jig 60g', 'Mồi kim loại 60g cho jigging cá biển sâu.', 280000, 'MM-JIG-60', 72, '/images/products/moi-cau-9.jpg', 'active'),
(5, 'Mồi Sống Giun Nhật', 'Giun nhật tươi sống đóng hộp 50g cho câu cá tự nhiên.', 45000, 'MS-GIUN-50', 250, '/images/products/moi-cau-10.jpg', 'active'),

-- DANH MỤC 6: PHỤ KIỆN CẦN (10 sản phẩm)
(6, 'Túi Đựng Cần 2 Ngăn', 'Túi vải canvas bền chắc đựng 3-4 cần câu, 2 ngăn riêng biệt.', 450000, 'PK-TUI-2N', 58, '/images/products/phu-kien-1.jpg', 'active'),
(6, 'Hộp Đồ Nghề 4 Tầng', 'Hộp nhựa ABS 4 tầng, 40 ngăn chứa lưỡi câu và phụ kiện.', 320000, 'PK-HOP-4T', 68, '/images/products/phu-kien-2.jpg', 'active'),
(6, 'Găng Tay Câu Cá', 'Găng tay chống trượt, chống nắng, để lộ 3 ngón tiện dụng.', 85000, 'PK-GANG-TAY', 150, '/images/products/phu-kien-3.jpg', 'active'),
(6, 'Khăn Lau Đa Năng', 'Khăn microfiber thấm hút tốt, lau cần máy câu.', 35000, 'PK-KHAN-LAU', 220, '/images/products/phu-kien-4.jpg', 'active'),
(6, 'Kẹp Cần Câu Inox', 'Kẹp cần câu inox gắn thuyền hoặc ghế, xoay 360 độ.', 280000, 'PK-KEP-CAN', 42, '/images/products/phu-kien-5.jpg', 'active'),
(6, 'Giá Đỡ Cần 3 Chân', 'Giá đỡ cần câu tripod nhôm, điều chỉnh độ cao linh hoạt.', 420000, 'PK-GIA-DO', 35, '/images/products/phu-kien-6.jpg', 'active'),
(6, 'Dây Đeo Cần Câu', 'Dây đeo cần câu có đệm vai, giảm mỏi khi di chuyển.', 120000, 'PK-DAY-DEO', 95, '/images/products/phu-kien-7.jpg', 'active'),
(6, 'Đèn Pin Đội Đầu LED', 'Đèn pin đội đầu sạc USB, 3 chế độ sáng cho câu đêm.', 180000, 'PK-DEN-DAU', 78, '/images/products/phu-kien-8.jpg', 'active'),
(6, 'Thùng Đá Giữ Lạnh 30L', 'Thùng đá giữ lạnh cá 30L, giữ lạnh 48h.', 850000, 'PK-THUNG-DA', 28, '/images/products/phu-kien-9.jpg', 'active'),
(6, 'Kìm Bấm Chì Đa Năng', 'Kìm bấm chì, cắt dây, tháo lưỡi câu 3 trong 1.', 95000, 'PK-KIM-BAM', 125, '/images/products/phu-kien-10.jpg', 'active'),

-- DANH MỤC 7: CHÌ CÂU (10 sản phẩm)
(7, 'Chì Câu Hình Oliu 10g', 'Chì câu hình oliu 10g chống rối, dễ ném xa.', 25000, 'CH-OLIU-10', 280, '/images/products/chi-cau-1.jpg', 'active'),
(7, 'Chì Nổi Câu Cá Chép', 'Phao câu cá chép hình giọt nước, nhạy cảm cao.', 45000, 'CH-NOI-CHEP', 195, '/images/products/chi-cau-2.jpg', 'active'),
(7, 'Chì Đáy Dẹt 50g', 'Chì đáy dẹt 50g cho câu biển, chống trôi dòng nước.', 35000, 'CH-DAY-50', 220, '/images/products/chi-cau-3.jpg', 'active'),
(7, 'Chì Lê Dài 20g', 'Chì lê dài 20g cho câu ném xa, hình dáng aerodynamic.', 18000, 'CH-LE-20', 310, '/images/products/chi-cau-4.jpg', 'active'),
(7, 'Phao Câu Điện Tử LED', 'Phao câu điện tử phát sáng LED cho câu đêm.', 120000, 'CH-LED-PHAO', 85, '/images/products/chi-cau-5.jpg', 'active'),
(7, 'Chì Hình Tròn Assorted', 'Bộ chì hình tròn nhiều size từ 5g-30g.', 55000, 'CH-TRON-SET', 165, '/images/products/chi-cau-6.jpg', 'active'),
(7, 'Chì Texas Rig Bullet', 'Chì hình đạn cho texas rig, chống rối cỏ tốt.', 32000, 'CH-TEX-BUL', 240, '/images/products/chi-cau-7.jpg', 'active'),
(7, 'Chì Carolina Rig Egg', 'Chì hình trứng cho carolina rig câu bass.', 28000, 'CH-CAR-EGG', 255, '/images/products/chi-cau-8.jpg', 'active'),
(7, 'Phao Cá Sống Balsa', 'Phao gỗ balsa tự nhiên cho câu cá sống.', 65000, 'CH-BALSA-PHO', 125, '/images/products/chi-cau-9.jpg', 'active'),
(7, 'Chì Nổi Waggler', 'Phao waggler Anh Quốc cho câu xa, chống gió.', 95000, 'CH-WAGG-UK', 95, '/images/products/chi-cau-10.jpg', 'active'),

-- DANH MỤC 8: KÉO & DAO (10 sản phẩm)
(8, 'Kéo Cắt Dây Titan', 'Kéo cắt dây câu titan, sắc bén, chống gỉ hoàn toàn.', 120000, 'KD-KEO-TIT', 110, '/images/products/keo-dao-1.jpg', 'active'),
(8, 'Dao Phi Lê 7 Inch', 'Dao phi lê cá 7 inch lưỡi mỏng, linh hoạt.', 280000, 'KD-DAO-PHI', 68, '/images/products/keo-dao-2.jpg', 'active'),
(8, 'Kéo Đa Năng Rapala', 'Kéo đa năng Rapala có vỏ bảo vệ, mở nắp chai.', 180000, 'KD-KEO-RAP', 85, '/images/products/keo-dao-3.jpg', 'active'),
(8, 'Dao Swiss Army', 'Dao đa năng Swiss Army 12 chức năng cho câu cá.', 450000, 'KD-DAO-SWI', 52, '/images/products/keo-dao-4.jpg', 'active'),
(8, 'Kéo Cắt Braid Chuyên Dụng', 'Kéo cắt dây braid PE chuyên dụng, cực sắc.', 95000, 'KD-KEO-BRA', 125, '/images/products/keo-dao-5.jpg', 'active'),
(8, 'Dao Mổ Cá Mini', 'Dao mổ cá mini gọn nhẹ, lưỡi inox không gỉ.', 55000, 'KD-DAO-MIN', 180, '/images/products/keo-dao-6.jpg', 'active'),
(8, 'Kìm Bấm Chì & Cắt', 'Kìm bấm chì kiêm cắt dây, tay cầm cao su chống trượt.', 135000, 'KD-KIM-BAM', 95, '/images/products/keo-dao-7.jpg', 'active'),
(8, 'Dao Bỏ Vẩy Cá', 'Dao bỏ vẩy cá với răng cưa, tay cầm ergonomic.', 75000, 'KD-DAO-VAY', 145, '/images/products/keo-dao-8.jpg', 'active'),
(8, 'Kéo Tháo Lưỡi Câu', 'Kéo tháo lưỡi câu y tế, đầu cong, giảm tổn thương cá.', 85000, 'KD-KEO-THAO', 105, '/images/products/keo-dao-9.jpg', 'active'),
(8, 'Dao Gập Outdoor', 'Dao gập outdoor có khóa an toàn, lưỡi 3 inch.', 220000, 'KD-DAO-GAP', 72, '/images/products/keo-dao-10.jpg', 'active'),

-- DANH MỤC 9: QUẦN ÁO CÂU (10 sản phẩm)
(9, 'Áo Chống Nắng UPF50+', 'Áo chống nắng UPF50+ siêu mát, nhanh khô.', 180000, 'QA-AO-NANG', 125, '/images/products/quan-ao-1.jpg', 'active'),
(9, 'Quần Câu Cá Nhanh Khô', 'Quần câu cá nhanh khô, nhiều túi, co giãn 4 chiều.', 250000, 'QA-QUAN-NK', 95, '/images/products/quan-ao-2.jpg', 'active'),
(9, 'Giày Ủng Đi Biển', 'Giày ủng cao su đi biển, chống trượt, thoáng khí.', 320000, 'QA-GIAY-UNG', 68, '/images/products/quan-ao-3.jpg', 'active'),
(9, 'Áo Khoác Chống Thấm', 'Áo khoác chống thấm nước, chống gió cho câu mùa mưa.', 450000, 'QA-AO-THAM', 55, '/images/products/quan-ao-4.jpg', 'active'),
(9, 'Mũ Rộng Vành Chống Nắng', 'Mũ rộng vành chống nắng, thông gió tốt.', 95000, 'QA-MU-VANH', 165, '/images/products/quan-ao-5.jpg', 'active'),
(9, 'Găng Tay Lộ 3 Ngón', 'Găng tay câu cá lộ 3 ngón, chống nắng UV.', 75000, 'QA-GANG-3N', 185, '/images/products/quan-ao-6.jpg', 'active'),
(9, 'Áo Phao Cứu Sinh', 'Áo phao cứu sinh cho câu trên thuyền, đạt chuẩn.', 380000, 'QA-AO-PHAO', 48, '/images/products/quan-ao-7.jpg', 'active'),
(9, 'Khăn Trùm Đầu Ninja', 'Khăn trùm đầu ninja chống nắng toàn diện.', 55000, 'QA-KHAN-NIN', 210, '/images/products/quan-ao-8.jpg', 'active'),
(9, 'Quần Lội Nước Wader', 'Quần lội nước wader cao đến ngực cho câu suối.', 850000, 'QA-QUAN-WAD', 32, '/images/products/quan-ao-9.jpg', 'active'),
(9, 'Áo Gi-lê Đa Túi', 'Áo gi-lê đa túi chuyên dụng cho câu cá, 12 túi.', 420000, 'QA-AO-GILE', 62, '/images/products/quan-ao-10.jpg', 'active'),

-- DANH MỤC 10: TÚI ĐỒ NGHỀ (10 sản phẩm)
(10, 'Ba Lô Câu Cá 40L', 'Ba lô câu cá chống nước 40L, nhiều ngăn tiện dụng.', 650000, 'TUI-BALO-40', 45, '/images/products/tui-do-1.jpg', 'active'),
(10, 'Túi Đeo Hông Tactical', 'Túi đeo hông tactical, chứa hộp mồi và phụ kiện nhỏ.', 280000, 'TUI-DEO-TAC', 82, '/images/products/tui-do-2.jpg', 'active'),
(10, 'Hộp Nhựa 5 Tầng', 'Hộp nhựa trong suốt 5 tầng, 50 ngăn chia linh hoạt.', 380000, 'TUI-HOP-5T', 58, '/images/products/tui-do-3.jpg', 'active'),
(10, 'Túi Đựng Mồi Giả', 'Túi đựng mồi giả chuyên dụng, ngăn đệm mút xốp.', 220000, 'TUI-MOI-GIA', 95, '/images/products/tui-do-4.jpg', 'active'),
(10, 'Hộp Chống Nước IP67', 'Hộp chống nước IP67 cho điện thoại và ví.', 150000, 'TUI-HOP-IP67', 125, '/images/products/tui-do-5.jpg', 'active'),
(10, 'Túi Đựng Cá Lưới', 'Túi lưới đựng cá giữ tươi sống, kích thước 60cm.', 85000, 'TUI-LUOI-60', 155, '/images/products/tui-do-6.jpg', 'active'),
(10, 'Ba Lô Ghế Gấp 2in1', 'Ba lô kiêm ghế gấp cho câu cá ngồi lâu.', 780000, 'TUI-BALO-GHE', 35, '/images/products/tui-do-7.jpg', 'active'),
(10, 'Túi Giữ Nhiệt 15L', 'Túi giữ nhiệt 15L đựng đồ ăn uống và mồi sống.', 420000, 'TUI-NHIET-15', 68, '/images/products/tui-do-8.jpg', 'active'),
(10, 'Hộp Đựng Lưỡi Câu Từ Tính', 'Hộp đựng lưỡi câu có nam châm, chống rớt.', 95000, 'TUI-HOP-TU', 145, '/images/products/tui-do-9.jpg', 'active'),
(10, 'Túi Cuộn Cần Telescopic', 'Túi cuộn đựng cần telescopic gọn nhẹ, chống nước.', 180000, 'TUI-CUON-TEL', 88, '/images/products/tui-do-10.jpg', 'active');

-- ============================================
-- DỮ LIỆU MẪU - ĐỊA CHỈ
-- ============================================
INSERT INTO addresses (user_id, label, full_name, phone, address_line, province, district, ward, is_default) VALUES
(2, 'Nhà riêng', 'Nguyễn Văn A', '0987654321', '123 Đường ABC', 'Hà Nội', 'Cầu Giấy', 'Dịch Vọng', 1),
(2, 'Công ty', 'Nguyễn Văn A', '0987654321', '456 Đường XYZ', 'Hà Nội', 'Đống Đa', 'Láng Hạ', 0);

-- ============================================
-- DỮ LIỆU MẪU - HÌNH ẢNH SẢN PHẨM
-- ============================================
INSERT INTO product_images (product_id, image_url, alt_text, is_primary) VALUES
-- Sản phẩm 1: Cần Câu Carbon Pro 2.1m
(1, '/images/products/can-cau-carbon-pro-1.jpg', 'Cần câu carbon pro góc chính', 1),
(1, '/images/products/can-cau-carbon-pro-2.jpg', 'Chi tiết cần câu', 0),
(1, '/images/products/can-cau-carbon-pro-3.jpg', 'Cần câu trong sử dụng', 0),
(1, '/images/products/can-cau-carbon-pro-4.jpg', 'Chi tiết tay cầm', 0),

-- Sản phẩm 2: Cần Câu Daiwa Legalis 1.8m
(2, '/images/products/can-cau-daiwa-1.jpg', 'Cần câu Daiwa', 1),
(2, '/images/products/can-cau-daiwa-2.jpg', 'Chi tiết cần', 0),
(2, '/images/products/can-cau-daiwa-3.jpg', 'Góc sử dụng', 0),

-- Sản phẩm 3: Máy Câu Shimano 3000
(3, '/images/products/may-cau-shimano-1.jpg', 'Máy câu Shimano 3000', 1),
(3, '/images/products/may-cau-shimano-2.jpg', 'Chi tiết máy câu', 0),
(3, '/images/products/may-cau-shimano-3.jpg', 'Góc cận cảnh', 0),
(3, '/images/products/may-cau-shimano-4.jpg', 'Máy câu trên cần', 0),

-- Sản phẩm 4: Máy Câu Daiwa BG 4000
(4, '/images/products/may-cau-daiwa-1.jpg', 'Máy câu Daiwa BG', 1),
(4, '/images/products/may-cau-daiwa-2.jpg', 'Chi tiết máy', 0),
(4, '/images/products/may-cau-daiwa-3.jpg', 'Cận cảnh', 0),

-- Sản phẩm 5: Dây PE 8 Lõi 150m
(5, '/images/products/day-pe-8-loi-1.jpg', 'Cuộn dây PE', 1),
(5, '/images/products/day-pe-8-loi-2.jpg', 'Chi tiết dây', 0),
(5, '/images/products/day-pe-8-loi-3.jpg', 'Dây trên máy câu', 0),

-- Sản phẩm 6: Dây Carbon Fluorocarbon 50m
(6, '/images/products/day-carbon-1.jpg', 'Cuộn dây carbon', 1),
(6, '/images/products/day-carbon-2.jpg', 'Chi tiết', 0),

-- Sản phẩm 7: Bộ 100 Lưỡi Câu Assorted
(7, '/images/products/luoi-cau-assorted-1.jpg', 'Bộ lưỡi câu đa dạng', 1),
(7, '/images/products/luoi-cau-assorted-2.jpg', 'Chi tiết lưỡi câu', 0),
(7, '/images/products/luoi-cau-assorted-3.jpg', 'Các size khác nhau', 0),

-- Sản phẩm 8: Lưỡi Câu Chuyên Dụng Cá Lớn Size 8/0
(8, '/images/products/luoi-cau-ca-lon-1.jpg', 'Lưỡi câu cỡ lớn', 1),
(8, '/images/products/luoi-cau-ca-lon-2.jpg', 'Chi tiết móc', 0),

-- Sản phẩm 9: Mồi Giả Rapala 12cm
(9, '/images/products/moi-gia-rapala-1.jpg', 'Mồi giả Rapala', 1),
(9, '/images/products/moi-gia-rapala-2.jpg', 'Chi tiết mồi', 0),
(9, '/images/products/moi-gia-rapala-3.jpg', 'Góc khác', 0),
(9, '/images/products/moi-gia-rapala-4.jpg', 'Mồi trong nước', 0),

-- Sản phẩm 10: Mồi Mềm Silicon 10 Con
(10, '/images/products/moi-mem-silicon-1.jpg', 'Bộ mồi mềm silicon', 1),
(10, '/images/products/moi-mem-silicon-2.jpg', 'Chi tiết mồi mềm', 0),
(10, '/images/products/moi-mem-silicon-3.jpg', 'Các màu sắc', 0),

-- Sản phẩm 11: Túi Đựng Cần 2 Ngăn
(11, '/images/products/tui-dung-can-1.jpg', 'Túi đựng cần câu', 1),
(11, '/images/products/tui-dung-can-2.jpg', 'Chi tiết túi', 0),
(11, '/images/products/tui-dung-can-3.jpg', 'Ngăn chứa', 0),

-- Sản phẩm 12: Hộp Đồ Nghề Đa Năng
(12, '/images/products/hop-do-nghe-1.jpg', 'Hộp đồ nghề 4 tầng', 1),
(12, '/images/products/hop-do-nghe-2.jpg', 'Chi tiết các ngăn', 0),
(12, '/images/products/hop-do-nghe-3.jpg', 'Hộp mở ra', 0),
(12, '/images/products/hop-do-nghe-4.jpg', 'Đựng phụ kiện', 0);

-- ============================================
-- DỮ LIỆU MẪU - MÃ GIẢM GIÁ
-- ============================================
INSERT INTO coupons (code, description, discount_type, discount_value, min_order_value, max_discount, usage_limit, start_date, end_date, is_active) VALUES
('WELCOME10', 'Giảm 10% cho đơn hàng đầu tiên', 'percentage', 10.00, 500000, 100000, 100, '2025-01-01 00:00:00', '2025-12-31 23:59:59', TRUE),
('FLASHSALE', 'Flash Sale - Giảm 15%', 'percentage', 15.00, 1000000, 200000, 50, '2025-11-01 00:00:00', '2025-11-30 23:59:59', TRUE),
('FREESHIP', 'Miễn phí vận chuyển - Giảm 50k', 'fixed', 50000, 300000, NULL, 200, '2025-01-01 00:00:00', '2025-12-31 23:59:59', TRUE),
('VIP2025', 'Giảm 20% cho khách VIP', 'percentage', 20.00, 2000000, 500000, 30, '2025-01-01 00:00:00', '2025-12-31 23:59:59', TRUE),
('NEWYEAR', 'Tết 2025 - Giảm 200k', 'fixed', 200000, 1500000, NULL, 100, '2025-01-20 00:00:00', '2025-02-10 23:59:59', TRUE);

-- ============================================
-- DỮ LIỆU MẪU - BLOG
-- ============================================
INSERT INTO blogs (title, slug, excerpt, content, thumbnail, author_id, category, tags, view_count, is_published, published_at) VALUES
('Kỹ thuật câu cá lóc hiệu quả', 'ky-thuat-cau-ca-loc-hieu-qua', 'Chia sẻ kinh nghiệm và kỹ thuật câu cá lóc cho người mới bắt đầu', 
'<h2>Giới thiệu về cá lóc</h2><p>Cá lóc là loài cá nước ngọt phổ biến tại Việt Nam, được nhiều người yêu thích...</p><h2>Dụng cụ cần chuẩn bị</h2><p>Cần câu 1.8-2.4m, máy câu ngang size 3000-4000, dây PE 2-4...</p><h2>Kỹ thuật câu</h2><p>Sử dụng mồi giả như con quay, wobler, hoặc mồi tự nhiên như cá rô nhỏ...</p>', 
'/images/blog/ky-thuat-cau-ca-loc.jpg', 1, 'Kỹ thuật câu', '["cá lóc", "kỹ thuật", "hướng dẫn"]', 1250, TRUE, '2025-11-01 10:00:00'),

('Top 5 cần câu tốt nhất 2025', 'top-5-can-cau-tot-nhat-2025', 'Đánh giá và so sánh 5 cần câu được ưa chuộng nhất năm 2025', 
'<h2>1. Shimano Surf Leader 425 BX</h2><p>Thân carbon cao cấp, độ bền vượt trội...</p><h2>2. Daiwa Crossfire</h2><p>Thiết kế đa năng phù hợp nhiều địa hình...</p><h2>3. Abu Garcia Vengeance</h2><p>Giá cả phải chăng, chất lượng tốt...</p>', 
'/images/blog/top-5-can-cau.jpg', 1, 'Đánh giá sản phẩm', '["cần câu", "đánh giá", "top 5"]', 2340, TRUE, '2025-10-15 14:30:00'),

('Bảo quản dụng cụ câu cá đúng cách', 'bao-quan-dung-cu-cau-ca-dung-cach', 'Hướng dẫn cách bảo quản cần câu, máy câu và phụ kiện để sử dụng lâu dài', 
'<h2>Bảo quản cần câu</h2><p>Sau mỗi lần câu, cần rửa sạch bằng nước ngọt, lau khô...</p><h2>Bảo quản máy câu</h2><p>Định kỳ tra dầu, làm sạch bụi bẩn, bảo quản nơi khô ráo...</p><h2>Bảo quản dây cước</h2><p>Tránh ánh nắng trực tiếp, kiểm tra độ sợi thường xuyên...</p>', 
'/images/blog/bao-quan-dung-cu.jpg', 1, 'Hướng dẫn', '["bảo quản", "bảo trì", "dụng cụ"]', 890, TRUE, '2025-10-20 09:00:00');

-- ============================================
-- THÊM CÁC CỘT GHN VÀO BẢNG ORDERS (add_ghn_columns.sql)
-- ============================================
ALTER TABLE orders 
  ADD COLUMN shipping_fee DECIMAL(12,2) DEFAULT 0 COMMENT 'Phí vận chuyển',
  ADD COLUMN ghn_order_code VARCHAR(50) COMMENT 'Mã đơn hàng GHN',
  ADD COLUMN recipient_name VARCHAR(120) COMMENT 'Tên người nhận',
  ADD COLUMN recipient_phone VARCHAR(20) COMMENT 'SĐT người nhận',
  ADD COLUMN recipient_address TEXT COMMENT 'Địa chỉ chi tiết',
  ADD COLUMN province_id INT COMMENT 'ID tỉnh/thành GHN',
  ADD COLUMN district_id INT COMMENT 'ID quận/huyện GHN',
  ADD COLUMN ward_code VARCHAR(20) COMMENT 'Mã phường/xã GHN';

-- ============================================
-- BẢNG WISHLIST VÀ PRODUCT REVIEWS (add_wishlist_and_reviews.sql)
-- ============================================
CREATE TABLE IF NOT EXISTS wishlists (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'ID wishlist',
  user_id INT UNSIGNED NOT NULL COMMENT 'ID người dùng',
  product_id INT UNSIGNED NOT NULL COMMENT 'ID sản phẩm',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian thêm',
  UNIQUE KEY unique_user_product (user_id, product_id),
  CONSTRAINT fk_wishlist_user FOREIGN KEY (user_id)
    REFERENCES users (id) ON DELETE CASCADE,
  CONSTRAINT fk_wishlist_product FOREIGN KEY (product_id)
    REFERENCES products (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng danh sách yêu thích';

CREATE TABLE IF NOT EXISTS product_reviews (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'ID đánh giá',
  product_id INT UNSIGNED NOT NULL COMMENT 'ID sản phẩm',
  user_id INT UNSIGNED NOT NULL COMMENT 'ID người dùng',
  rating TINYINT NOT NULL COMMENT 'Điểm đánh giá (1-5 sao)',
  comment TEXT COMMENT 'Nội dung đánh giá',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Thời gian cập nhật',
  CONSTRAINT fk_review_product FOREIGN KEY (product_id)
    REFERENCES products (id) ON DELETE CASCADE,
  CONSTRAINT fk_review_user FOREIGN KEY (user_id)
    REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng đánh giá sản phẩm';

CREATE INDEX idx_review_product ON product_reviews(product_id);
CREATE INDEX idx_review_user ON product_reviews(user_id);

-- ============================================
-- HOÀN TẤT
-- ============================================
SELECT 'Database fishing_shop đã được tạo thành công!' AS Status,
       (SELECT COUNT(*) FROM users) AS Total_Users,
       (SELECT COUNT(*) FROM categories) AS Total_Categories,
       (SELECT COUNT(*) FROM products) AS Total_Products,
       (SELECT COUNT(*) FROM product_images) AS Total_Images,
       (SELECT COUNT(*) FROM coupons) AS Total_Coupons,
       (SELECT COUNT(*) FROM blogs) AS Total_Blogs;
