# HƯỚNG DẪN TÍCH HỢP GHN - GIAO HÀNG NHANH

## ✅ Đã tích hợp đầy đủ

### 1. Cấu hình (.env)
```env
GHN_BASE_URL=https://online-gateway.ghn.vn
GHN_TOKEN=27b6a6da-d0f0-11f0-bcb9-a63866d22c8d
GHN_SHOP_ID=6148508
```

### 2. Các API đã tích hợp

#### 2.1 Lấy danh sách tỉnh/thành phố
- **Endpoint**: `GET /api/shipping/provinces`
- **Response**: Danh sách tỉnh/thành phố

#### 2.2 Lấy danh sách quận/huyện
- **Endpoint**: `GET /api/shipping/districts/:provinceId`
- **Response**: Danh sách quận/huyện theo tỉnh

#### 2.3 Lấy danh sách phường/xã
- **Endpoint**: `GET /api/shipping/wards/:districtId`
- **Response**: Danh sách phường/xã theo quận

#### 2.4 Tính phí vận chuyển
- **Endpoint**: `POST /api/shipping/calculate-fee`
- **Body**:
```json
{
  "toDistrictId": 1442,
  "toWardCode": "10101",
  "weight": 1000,
  "insuranceValue": 500000
}
```

#### 2.5 Tạo đơn hàng GHN (Tự động khi đặt hàng)
- **Endpoint**: Tự động gọi khi tạo order qua `POST /api/orders`
- **Kết quả**: Đơn hàng sẽ xuất hiện trên [khachhang.ghn.vn/order](https://khachhang.ghn.vn/order)

### 3. Luồng đặt hàng

```
1. Khách hàng thêm sản phẩm vào giỏ
   ↓
2. Vào trang giỏ hàng (/cart)
   ↓
3. Chọn địa chỉ giao hàng (Tỉnh/Quận/Phường)
   ↓
4. Hệ thống tự động tính phí vận chuyển
   ↓
5. Khách hàng điền thông tin và đặt hàng
   ↓
6. Backend tạo order trong database
   ↓
7. Backend tự động gọi API GHN tạo đơn vận chuyển
   ↓
8. Lưu ghn_order_code vào database
   ↓
9. Đơn hàng xuất hiện trên GHN
```

### 4. Cấu trúc database

Bảng `orders` đã có các cột GHN:
```sql
shipping_fee DECIMAL(12,2)          -- Phí vận chuyển
ghn_order_code VARCHAR(50)          -- Mã đơn GHN
recipient_name VARCHAR(120)         -- Tên người nhận
recipient_phone VARCHAR(20)         -- SĐT người nhận
recipient_address TEXT              -- Địa chỉ chi tiết
province_id INT                     -- ID tỉnh GHN
district_id INT                     -- ID quận GHN
ward_code VARCHAR(20)               -- Mã phường GHN
```

### 5. Thông tin shop gửi hàng (Mặc định)

```javascript
from_name: 'nhathuy'
from_phone: '0376911677'
from_address: 'Trà Vinh'
from_ward_name: 'Phường 6'
from_district_name: 'Thành phố Trà Vinh'
from_province_name: 'Trà Vinh'
```

### 6. Kiểm tra đơn hàng trên GHN

1. Đăng nhập: https://khachhang.ghn.vn/
2. Vào mục **Quản lý đơn hàng**
3. Tìm theo mã đơn `ghn_order_code`

### 7. Test API

#### Test tính phí vận chuyển:
```bash
curl -X POST http://localhost:4000/api/shipping/calculate-fee \
  -H "Content-Type: application/json" \
  -d '{
    "toDistrictId": 1442,
    "toWardCode": "10101",
    "weight": 1000,
    "insuranceValue": 500000
  }'
```

#### Test tạo đơn (qua API orders):
```bash
curl -X POST http://localhost:4000/api/orders \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "items": [
      {
        "product_id": 1,
        "quantity": 2,
        "price": 250000
      }
    ],
    "shipping_info": {
      "recipient_name": "Nguyễn Văn A",
      "recipient_phone": "0901234567",
      "address": "123 Đường ABC",
      "province_id": 202,
      "district_id": 1442,
      "ward_code": "10101"
    },
    "shipping_fee": 30000,
    "payment_method": "cod",
    "note": "Giao giờ hành chính"
  }'
```

### 8. Các tham số quan trọng

- **payment_type_id**: 
  - `1`: Người bán trả phí
  - `2`: Người mua trả phí (COD)

- **required_note**:
  - `KHONGCHOXEMHANG`: Không cho xem hàng
  - `CHOXEMHANGKHONGTHU`: Cho xem không cho thử
  - `CHOTHUHANG`: Cho thử hàng

- **service_id**: `53320` (Dịch vụ vận chuyển tiêu chuẩn)
- **service_type_id**: `2` (E-commerce delivery)

### 9. Lưu ý

1. Địa chỉ shop phải được đăng ký trong tài khoản GHN
2. Token và ShopId phải hợp lệ
3. Trọng lượng tính bằng gram (mặc định 500g/sản phẩm)
4. Kích thước mặc định: 15x15x10 cm

### 10. Troubleshooting

**Nếu không thấy đơn trên GHN:**
- Kiểm tra log server: `console.log('✅ Tạo đơn GHN thành công')`
- Kiểm tra GHN_TOKEN và GHN_SHOP_ID trong .env
- Kiểm tra địa chỉ shop đã đăng ký chưa
- Xem response lỗi trong server logs

**Xem logs:**
```bash
# Terminal đang chạy server sẽ hiển thị:
Đang tạo đơn GHN với thông tin: {...}
✅ Tạo đơn GHN thành công: ORDER_CODE
# hoặc
❌ Lỗi tạo đơn GHN: error_message
```
