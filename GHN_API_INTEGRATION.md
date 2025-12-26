# HƯỚNG DẪN SỬ DỤNG CÁC API GHN ĐÃ TÍCH HỢP

## 📦 Danh sách API đã tích hợp

### 1. Lấy thông tin đơn hàng
**Endpoint**: `GET /api/shipping/order/:orderCode`

```bash
curl http://localhost:4000/api/shipping/order/GHNORDERCODE
```

**Response**: Trạng thái đơn hàng, vị trí hiện tại, lịch sử di chuyển

---

### 2. Cập nhật giá trị COD
**Endpoint**: `POST /api/shipping/update-cod`

```bash
curl -X POST http://localhost:4000/api/shipping/update-cod \
  -H "Content-Type: application/json" \
  -d '{
    "order_code": "GHNORDERCODE",
    "cod_amount": 500000
  }'
```

**Sử dụng khi**: Khách hàng thay đổi đơn hàng, cần điều chỉnh số tiền thu COD

---

### 3. Xem trước đơn hàng (Preview Order)
**Endpoint**: `POST /api/shipping/preview-order`

```bash
curl -X POST http://localhost:4000/api/shipping/preview-order \
  -H "Content-Type: application/json" \
  -d '{
    "payment_type_id": 2,
    "from_name": "nhathuy",
    "from_phone": "0376911677",
    "from_address": "Trà Vinh",
    "from_ward_name": "Phường 6",
    "from_district_name": "Thành phố Trà Vinh",
    "from_province_name": "Trà Vinh",
    "to_name": "Nguyễn Văn A",
    "to_phone": "0901234567",
    "to_address": "123 Đường ABC",
    "to_ward_code": "1A0101",
    "to_district_id": 1442,
    "cod_amount": 500000,
    "content": "Dụng cụ câu cá",
    "weight": 1000,
    "length": 15,
    "width": 15,
    "height": 10,
    "service_id": 53320,
    "service_type_id": 2,
    "items": [
      {
        "name": "Cần câu",
        "quantity": 1,
        "price": 500000
      }
    ]
  }'
```

**Response**: 
- Phí vận chuyển dự kiến
- Thời gian giao hàng dự kiến
- Các dịch vụ khả dụng

**Sử dụng khi**: Muốn tính toán chi phí trước khi tạo đơn chính thức

---

### 4. Lấy ca lấy hàng
**Endpoint**: `GET /api/shipping/pick-shift`

```bash
curl http://localhost:4000/api/shipping/pick-shift
```

**Response**: Danh sách các ca lấy hàng khả dụng (sáng/chiều/tối)

**Sử dụng khi**: Cho phép khách hàng chọn ca lấy hàng khi tạo đơn

---

### 5. Tạo ticket hỗ trợ
**Endpoint**: `POST /api/shipping/create-ticket`

```bash
curl -X POST http://localhost:4000/api/shipping/create-ticket \
  -H "Content-Type: application/json" \
  -d '{
    "order_code": "GHNORDERCODE",
    "category": "Tư vấn",
    "description": "Khách hàng muốn thay đổi địa chỉ giao hàng",
    "c_email": "customer@email.com"
  }'
```

**Categories**:
- `Tư vấn`: Câu hỏi tư vấn
- `Khiếu nại`: Khiếu nại về dịch vụ
- `Thay đổi thông tin`: Thay đổi địa chỉ, SĐT...

**Sử dụng khi**: 
- Khách hàng cần thay đổi thông tin đơn hàng
- Có vấn đề với giao hàng
- Cần hỗ trợ từ GHN

---

### 6. Lấy thông tin đơn theo Client Order Code
**Endpoint**: `POST /api/shipping/order-by-client-code`

```bash
curl -X POST http://localhost:4000/api/shipping/order-by-client-code \
  -H "Content-Type: application/json" \
  -d '{
    "client_order_code": "ORDER123"
  }'
```

**Sử dụng khi**: Tra cứu đơn hàng GHN bằng mã đơn hàng nội bộ

---

### 7. Hủy đơn hàng
**Endpoint**: `POST /api/shipping/cancel-order`

```bash
curl -X POST http://localhost:4000/api/shipping/cancel-order \
  -H "Content-Type: application/json" \
  -d '{
    "order_codes": ["GHNCODE1", "GHNCODE2"]
  }'
```

**Lưu ý**: Chỉ hủy được đơn hàng chưa lấy hàng

---

## 🔔 Webhook Callbacks

### 8. Webhook cập nhật trạng thái đơn hàng
**Endpoint**: `POST /api/shipping/webhook/order-status`

**Cấu hình trên GHN**:
1. Vào https://khachhang.ghn.vn/
2. Cài đặt → Webhook
3. Nhập URL: `https://yourdomain.com/api/shipping/webhook/order-status`

**GHN sẽ gửi thông báo khi**:
- Đơn hàng được lấy
- Đang giao hàng
- Giao thành công
- Giao thất bại
- Đơn hoàn

**Xử lý trong code**:
```typescript
// src/api/shipping.ts
router.post('/webhook/order-status', async (req, res) => {
  const { OrderCode, Status, StatusName } = req.body;
  
  // Cập nhật database
  await orderRepository.updateStatus(OrderCode, Status);
  
  // Gửi email thông báo
  await emailService.sendOrderStatusUpdate(OrderCode, StatusName);
  
  res.status(200).json({ success: true });
});
```

---

### 9. Webhook phản hồi ticket
**Endpoint**: `POST /api/shipping/webhook/ticket`

**GHN sẽ gửi thông báo khi**: Có phản hồi từ bộ phận hỗ trợ

---

## 🎯 Tích hợp vào flow đặt hàng

### Luồng đặt hàng đầy đủ:

```javascript
// 1. Xem trước đơn hàng (optional)
const preview = await fetch('/api/shipping/preview-order', {...});
console.log('Phí vận chuyển:', preview.data.total_fee);
console.log('Thời gian giao:', preview.data.expected_delivery_time);

// 2. Chọn ca lấy hàng (optional)
const pickShifts = await fetch('/api/shipping/pick-shift');
console.log('Các ca:', pickShifts.data);

// 3. Tạo đơn hàng
const order = await fetch('/api/orders', {
  method: 'POST',
  body: JSON.stringify({
    items: [...],
    shipping_info: {...},
    payment_method: 'cod'
  })
});

console.log('Mã GHN:', order.data.ghn_order_code);

// 4. Theo dõi đơn hàng
const tracking = await fetch(`/api/shipping/order/${order.data.ghn_order_code}`);
console.log('Trạng thái:', tracking.data.status);

// 5. Nếu cần hỗ trợ
const ticket = await fetch('/api/shipping/create-ticket', {
  method: 'POST',
  body: JSON.stringify({
    order_code: order.data.ghn_order_code,
    category: 'Tư vấn',
    description: 'Cần thay đổi địa chỉ'
  })
});
```

---

## 📊 Admin Dashboard - Quản lý đơn hàng

### Tạo trang theo dõi đơn hàng:

```typescript
// components/OrderTracking.tsx
const OrderTracking = ({ ghnOrderCode }) => {
  const [tracking, setTracking] = useState(null);
  
  useEffect(() => {
    fetch(`/api/shipping/order/${ghnOrderCode}`)
      .then(res => res.json())
      .then(data => setTracking(data.data));
  }, [ghnOrderCode]);
  
  return (
    <div>
      <h3>Trạng thái: {tracking?.status}</h3>
      <Timeline>
        {tracking?.log?.map(log => (
          <TimelineItem key={log.time}>
            <strong>{log.status_name}</strong>
            <p>{log.location}</p>
            <small>{new Date(log.time).toLocaleString()}</small>
          </TimelineItem>
        ))}
      </Timeline>
    </div>
  );
};
```

---

## 🔧 Troubleshooting

### Lỗi thường gặp:

**1. "Giá trị COD vượt quá mức cho phép"**
- Giải pháp: Giảm COD hoặc liên hệ GHN tăng hạn mức

**2. "Phường/xã không tồn tại"**
- Giải pháp: Phải lấy ward_code từ API GHN, không tự đặt

**3. "Token không hợp lệ"**
- Kiểm tra GHN_TOKEN trong .env

**4. Webhook không nhận được**
- Đảm bảo domain public và HTTPS
- Kiểm tra firewall
- Test bằng ngrok: `ngrok http 4000`

---

## 📝 Checklist tích hợp hoàn chỉnh

- [x] Tạo đơn hàng GHN tự động
- [x] Tính phí vận chuyển
- [x] Lấy thông tin địa chỉ (Tỉnh/Quận/Phường)
- [x] Preview đơn hàng
- [x] Cập nhật COD
- [x] Tạo ticket hỗ trợ
- [x] Theo dõi đơn hàng
- [x] Webhook nhận trạng thái
- [ ] Gửi email tự động khi có update
- [ ] Hiển thị tracking trên web
- [ ] Admin dashboard quản lý đơn GHN
- [ ] In nhãn vận đơn
- [ ] Báo cáo thống kê

---

## 🚀 Next Steps

1. **Tích hợp tracking vào trang khách hàng**
2. **Xử lý webhook để tự động cập nhật trạng thái**
3. **Gửi SMS/Email thông báo cho khách**
4. **Tạo dashboard theo dõi đơn hàng cho admin**
5. **Tích hợp in nhãn vận đơn**

---

## 📞 Hỗ trợ

- Tài liệu GHN: https://api.ghn.vn/home/docs/
- Hotline GHN: 1900 636677
- Email: support@ghn.vn
