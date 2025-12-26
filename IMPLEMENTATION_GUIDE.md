# Tài liệu Tính năng Mới - E-Commerce Fishing Shop

## Ngày cập nhật: 25/12/2025

---

## 1. Tích hợp Giao Hàng Nhanh (GHN)

### 1.1 Cấu hình GHN API

**Thông tin kết nối:**
- Shop ID: `5073856`
- Token: `27b6a6da-d0f0-11f0-bcb9-a63866d22c8d`
- Số điện thoại: `0376911677`
- API URL: `https://online-gateway.ghn.vn/shiip/public-api`

**File cấu hình:**
- `server/.env` - Chứa thông tin xác thực GHN
- `server/src/config/env.ts` - Xuất cấu hình môi trường
- `server/src/infrastructure/services/ghnService.ts` - Service tích hợp GHN API

### 1.2 Tính năng đã triển khai

#### Tạo đơn hàng tự động trên GHN
- Khi khách hàng đặt hàng và thanh toán, đơn hàng tự động được tạo trên hệ thống GHN
- Đơn hàng sẽ hiện trên portal: https://khachhang.ghn.vn/order
- Mã đơn GHN được lưu vào database (`ghn_order_code`)
- Hỗ trợ cả COD và thanh toán trước

#### Tính phí giao hàng
- API: `POST /api/shipping/calculate-fee`
- Lấy phí ship từ GHN dựa trên:
  - Địa chỉ giao hàng (tỉnh/quận/phường)
  - Trọng lượng đơn hàng (500g/sản phẩm)
  - Giá trị đơn hàng

#### Lấy danh sách địa chỉ
- `GET /api/shipping/provinces` - Danh sách tỉnh/thành phố
- `GET /api/shipping/districts/:provinceId` - Danh sách quận/huyện
- `GET /api/shipping/wards/:districtId` - Danh sách phường/xã

---

## 2. Hệ thống Thanh toán và Giỏ hàng

### 2.1 Phương thức thanh toán

Hỗ trợ 3 phương thức:
- **COD** (Cash on Delivery) - Thanh toán khi nhận hàng
- **Bank Transfer** - Chuyển khoản ngân hàng
- **E-Wallet** - Ví điện tử

### 2.2 Xác nhận thanh toán

**API Endpoint:** `POST /api/orders/confirm-payment`

**Request Body:**
```json
{
  "order_id": 123
}
```

**Chức năng:**
- Cập nhật trạng thái đơn hàng thành "paid"
- Tự động xóa các sản phẩm đã thanh toán khỏi giỏ hàng
- Chỉ người dùng sở hữu đơn hàng mới có thể xác nhận

### 2.3 Flow đặt hàng hoàn chỉnh

1. Khách hàng thêm sản phẩm vào giỏ
2. Chọn địa chỉ giao hàng (tỉnh/quận/phường)
3. Hệ thống tính phí ship từ GHN
4. Chọn phương thức thanh toán
5. Đặt hàng → Tạo đơn trong database + tạo đơn trên GHN
6. Xác nhận thanh toán → Giỏ hàng được xóa tự động

---

## 3. Hệ thống Flash Sale

### 3.1 Database Schema

**Bảng:** `flash_sales`

```sql
CREATE TABLE flash_sales (
  id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT NOT NULL,
  discount_percentage DECIMAL(5, 2) NOT NULL,
  start_time DATETIME NOT NULL,
  end_time DATETIME NOT NULL,
  status ENUM('active', 'inactive', 'expired') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);
```

**Chạy migration:**
```bash
mysql -u root -p fishing_shop < server/database/add_flash_sales.sql
```

### 3.2 API Endpoints

#### Public Endpoints
- `GET /api/flash-sales/active` - Lấy danh sách flash sale đang hoạt động

#### Admin Endpoints (Yêu cầu xác thực + quyền admin)
- `POST /api/flash-sales` - Tạo flash sale mới
- `GET /api/flash-sales` - Lấy tất cả flash sale
- `GET /api/flash-sales/:id` - Chi tiết flash sale
- `PATCH /api/flash-sales/:id` - Cập nhật flash sale
- `DELETE /api/flash-sales/:id` - Xóa flash sale

**Ví dụ tạo flash sale:**
```json
POST /api/flash-sales
{
  "product_id": 1,
  "discount_percentage": 25,
  "start_time": "2025-12-25T00:00:00",
  "end_time": "2025-12-26T23:59:59",
  "status": "active"
}
```

### 3.3 Admin Dashboard

**URL:** `/admin/flash-sales`

**Chức năng:**
- Thêm sản phẩm vào chương trình flash sale
- Thiết lập phần trăm giảm giá (1-100%)
- Đặt thời gian bắt đầu và kết thúc
- Quản lý trạng thái (active/inactive/expired)
- Xem giá sau giảm tự động tính toán
- Sửa và xóa flash sale

**Lưu ý:**
- Không tạo sản phẩm mới, chỉ thêm khung giảm giá vào sản phẩm có sẵn
- Mỗi sản phẩm chỉ có thể có 1 flash sale active tại một thời điểm
- Hệ thống tự động cập nhật status thành "expired" khi hết thời gian

### 3.4 Trang Flash Sale

**URL:** `/flash-sale`

**Tính năng:**
- Hiển thị tất cả sản phẩm đang flash sale (status=active)
- Đếm ngược thời gian còn lại
- Hiển thị badge giảm giá (%)
- Hiển thị giá gốc (gạch ngang) và giá sau giảm
- Thanh tiến trình số lượng đã bán (simulation)
- Sắp xếp theo: Mặc định, Giá tăng dần, Giá giảm dần, Giảm giá nhiều nhất

**Dữ liệu hiển thị:**
- Thông tin sản phẩm đầy đủ (tên, hình ảnh từ bảng products)
- Phần trăm giảm giá
- Giá gốc và giá sau giảm
- Thời gian kết thúc chương trình

---

## 4. Cấu trúc File và Module

### Backend (Server)

```
server/
├── database/
│   └── add_flash_sales.sql                    # Migration cho bảng flash_sales
├── src/
│   ├── api/
│   │   ├── flash-sales.ts                     # Routes flash sale
│   │   ├── orders.ts                          # Routes đơn hàng (đã thêm confirm-payment)
│   │   └── index.ts                           # Router chính
│   ├── config/
│   │   └── env.ts                             # Cấu hình GHN
│   ├── infrastructure/
│   │   ├── repositories/
│   │   │   └── flashSaleRepository.ts         # Repository flash sale
│   │   └── services/
│   │       └── ghnService.ts                  # Service GHN API
│   └── modules/
│       ├── flash-sales/
│       │   ├── flash-sale.controller.ts       # Controller flash sale
│       │   └── flash-sale.service.ts          # Business logic flash sale
│       └── orders/
│           ├── order.controller.ts            # Controller đơn hàng (thêm confirmPayment)
│           └── order.service.ts               # Service đơn hàng (tích hợp GHN)
└── .env                                       # Biến môi trường (GHN credentials)
```

### Frontend (Web)

```
web/src/
├── app/
│   ├── admin/
│   │   ├── flash-sales/
│   │   │   └── page.tsx                       # Quản lý flash sale admin
│   │   └── layout.tsx                         # Thêm menu Flash Sale
│   └── flash-sale/
│       └── page.tsx                           # Trang flash sale công khai
```

---

## 5. Hướng dẫn Sử dụng

### 5.1 Cài đặt và khởi động

1. **Cài đặt dependencies:**
```bash
cd server
npm install

cd ../web
npm install
```

2. **Chạy migration database:**
```bash
mysql -u root -p fishing_shop < server/database/add_flash_sales.sql
```

3. **Khởi động server:**
```bash
cd server
npm run dev
# Server chạy tại http://localhost:4000
```

4. **Khởi động web:**
```bash
cd web
npm run dev
# Web chạy tại http://localhost:3000
```

### 5.2 Tạo Flash Sale (Admin)

1. Đăng nhập với tài khoản admin
2. Vào menu "Quản lý Flash Sale"
3. Click "Thêm Flash Sale"
4. Chọn sản phẩm từ dropdown
5. Nhập % giảm giá (1-100)
6. Chọn thời gian bắt đầu và kết thúc
7. Chọn trạng thái (Đang hoạt động / Không hoạt động)
8. Click "Thêm mới"

### 5.3 Đặt hàng với GHN

1. Thêm sản phẩm vào giỏ hàng
2. Vào giỏ hàng, click "Thanh toán"
3. Điền thông tin giao hàng:
   - Họ tên người nhận
   - Số điện thoại
   - Chọn Tỉnh/Quận/Phường
   - Nhập địa chỉ chi tiết
4. Hệ thống tự động tính phí ship
5. Chọn phương thức thanh toán
6. Click "Đặt hàng"
7. Đơn hàng sẽ tự động tạo trên GHN

### 5.4 Xác nhận Thanh toán

**Cách 1: API Call**
```javascript
fetch('http://localhost:4000/api/orders/confirm-payment', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer YOUR_TOKEN'
  },
  body: JSON.stringify({ order_id: 123 })
});
```

**Cách 2: Admin Dashboard**
- Vào "Quản lý Đơn hàng"
- Chọn đơn hàng
- Cập nhật trạng thái thành "Đã thanh toán"

---

## 6. Kiểm tra và Xác thực

### 6.1 Test GHN Integration

1. Kiểm tra token GHN còn hiệu lực:
```bash
curl -X GET https://online-gateway.ghn.vn/shiip/public-api/v2/shop/all \
  -H "token: 27b6a6da-d0f0-11f0-bcb9-a63866d22c8d"
```

2. Kiểm tra đơn hàng trên GHN Portal:
   - Đăng nhập: https://khachhang.ghn.vn/order
   - Username: nhathuy (ID: 5073856)
   - Xem danh sách đơn hàng đã tạo

### 6.2 Test Flash Sale

1. Tạo flash sale từ admin dashboard
2. Kiểm tra API:
```bash
curl http://localhost:4000/api/flash-sales/active
```
3. Truy cập trang flash sale: http://localhost:3000/flash-sale
4. Xác nhận sản phẩm hiển thị với giá giảm đúng

### 6.3 Test Cart Clear

1. Thêm sản phẩm vào giỏ
2. Đặt hàng
3. Xác nhận thanh toán
4. Kiểm tra giỏ hàng đã trống

---

## 7. Lưu ý Quan trọng

### 7.1 Bảo mật
- Token GHN được lưu trong `.env`, không commit lên git
- API flash-sales admin yêu cầu xác thực và role admin
- Validate tất cả input từ frontend

### 7.2 Performance
- Flash sale query được tối ưu với index
- Cache danh sách tỉnh/quận/phường (nếu cần)
- Sử dụng pagination cho danh sách đơn hàng

### 7.3 Xử lý lỗi
- Nếu GHN API fail, đơn hàng vẫn được tạo trong database
- Log lỗi GHN để debug
- Thông báo lỗi rõ ràng cho người dùng

### 7.4 Maintenance
- Tự động cập nhật status flash sale = expired khi hết hạn
- Kiểm tra định kỳ token GHN
- Backup database thường xuyên

---

## 8. API Reference

### 8.1 GHN Endpoints (Internal)
- `POST /api/shipping/calculate-fee` - Tính phí ship
- `GET /api/shipping/provinces` - Danh sách tỉnh
- `GET /api/shipping/districts/:provinceId` - Danh sách quận
- `GET /api/shipping/wards/:districtId` - Danh sách phường

### 8.2 Orders Endpoints
- `POST /api/orders` - Tạo đơn hàng (tích hợp GHN)
- `POST /api/orders/confirm-payment` - Xác nhận thanh toán
- `GET /api/orders` - Danh sách đơn hàng của user
- `GET /api/orders/:id` - Chi tiết đơn hàng
- `PATCH /api/orders/:id/status` - Cập nhật trạng thái (admin)

### 8.3 Flash Sales Endpoints
- `GET /api/flash-sales/active` - Lấy flash sale đang hoạt động (public)
- `POST /api/flash-sales` - Tạo flash sale (admin)
- `GET /api/flash-sales` - Danh sách tất cả flash sale (admin)
- `GET /api/flash-sales/:id` - Chi tiết flash sale (admin)
- `PATCH /api/flash-sales/:id` - Cập nhật flash sale (admin)
- `DELETE /api/flash-sales/:id` - Xóa flash sale (admin)

---

## 9. Troubleshooting

### Lỗi "GHN API failed"
- Kiểm tra token còn hiệu lực
- Kiểm tra ShopID đúng
- Xem log chi tiết trong console

### Flash sale không hiển thị
- Kiểm tra status = 'active'
- Kiểm tra thời gian start_time <= now < end_time
- Chạy lại migration nếu thiếu bảng

### Giỏ hàng không xóa sau thanh toán
- Kiểm tra API confirm-payment đã được gọi
- Kiểm tra user_id match với đơn hàng
- Xem log trong server console

---

## 10. Tương lai và Mở rộng

### 10.1 Tính năng có thể thêm
- [ ] Webhook GHN để cập nhật trạng thái vận chuyển
- [ ] Email/SMS thông báo khi đơn hàng được tạo trên GHN
- [ ] In nhãn vận chuyển GHN
- [ ] Lịch sử flash sale đã kết thúc
- [ ] Thống kê doanh thu từ flash sale
- [ ] Giới hạn số lượng sản phẩm flash sale
- [ ] Payment gateway integration (VNPay, Momo)

### 10.2 Tối ưu hóa
- [ ] Cache GHN address data
- [ ] Queue system cho GHN order creation
- [ ] Real-time countdown với WebSocket
- [ ] Progressive Web App (PWA)

---

**Phiên bản:** 1.0.0
**Ngày cập nhật:** 25/12/2025
**Người thực hiện:** GitHub Copilot
