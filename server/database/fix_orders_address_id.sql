-- Sửa lỗi address_id không thể null
-- Cho phép address_id là null khi khách hàng nhập địa chỉ trực tiếp

ALTER TABLE orders MODIFY COLUMN address_id INT NULL;
