const axios = require('axios');

async function testCreateOrderLikeFrontend() {
  console.log('Testing order creation exactly like frontend...\n');

  // Đăng nhập để lấy token
  try {
    const loginResponse = await axios.post('http://localhost:4000/api/auth/login', {
      email: 'admin@example.com',
      password: 'admin123',
    });

    const token = loginResponse.data.data.accessToken;
    console.log('✅ Đăng nhập thành công, token:', token.substring(0, 20) + '...\n');

    // Tạo đơn hàng giống frontend
    const orderData = {
      items: [
        {
          product_id: 1,
          quantity: 2,
          price: 432750,
        },
      ],
      shipping_info: {
        recipient_name: 'Nguyễn Đình Nhật Huy TEST',
        recipient_phone: '0376911677',
        address: '100 Test Address Full',
        province_id: 214,
        district_id: 1560,
        ward_code: '580109',
      },
      shipping_fee: 15501,
      payment_method: 'cod',
      note: 'Đơn hàng test từ script',
    };

    console.log('📦 Đang gửi order data:', JSON.stringify(orderData, null, 2));
    console.log('\n');

    const orderResponse = await axios.post('http://localhost:4000/api/orders', orderData, {
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
    });

    console.log('✅ Đơn hàng được tạo thành công!');
    console.log('Response:', JSON.stringify(orderResponse.data, null, 2));

    if (orderResponse.data.data.ghn_order_code) {
      console.log('\n🎉 GHN ORDER CODE:', orderResponse.data.data.ghn_order_code);
    } else {
      console.log('\n⚠️ CẢNH BÁO: Không có GHN order code!');
    }
  } catch (error) {
    console.error('\n❌ Lỗi:');
    if (error.response) {
      console.error('Status:', error.response.status);
      console.error('Data:', JSON.stringify(error.response.data, null, 2));
    } else {
      console.error('Message:', error.message);
    }
  }
}

testCreateOrderLikeFrontend();
