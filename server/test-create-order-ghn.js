/**
 * Script kiểm tra tạo đơn hàng và gửi lên GHN
 * Chạy: node test-create-order-ghn.js
 */

const axios = require('axios');
require('dotenv').config();

const API_URL = 'http://localhost:4000/api';
const GHN_TOKEN = process.env.GHN_TOKEN;
const GHN_SHOP_ID = process.env.GHN_SHOP_ID;

// Test login và lấy token
async function login() {
  try {
    // Thử đăng ký trước (nếu chưa có)
    try {
      await axios.post(`${API_URL}/auth/register`, {
        full_name: 'Test User',
        email: 'test@ghn.com',
        password: 'test123',
      });
      console.log('✅ Đã tạo tài khoản test');
    } catch (e) {
      // User đã tồn tại, không sao
    }

    const response = await axios.post(`${API_URL}/auth/login`, {
      email: 'test@ghn.com',
      password: 'test123',
    });
    
    if (response.data.success) {
      console.log('✅ Đăng nhập thành công');
      return response.data.data.accessToken;
    } else {
      console.error('❌ Lỗi đăng nhập:', response.data);
      return null;
    }
  } catch (error) {
    console.error('❌ Lỗi đăng nhập:', error.code, error.message);
    if (error.response) {
      console.error('Response:', error.response.data);
    }
    return null;
  }
}

// Test tạo đơn hàng
async function createOrder(token) {
  try {
    console.log('\n📦 Đang tạo đơn hàng...');
    
    const orderData = {
      items: [
        {
          product_id: 1,
          quantity: 2,
          price: 250000
        }
      ],
      shipping_info: {
        recipient_name: 'Nguyễn Văn Test',
        recipient_phone: '0901234567',
        address: '123 Đường Nguyễn Trãi',
        province_id: 202,      // Hồ Chí Minh
        district_id: 1442,     // Quận 1
        ward_code: '1A0101'    // Phường Bến Nghé - ward code thật từ GHN
      },
      shipping_fee: 30000,
      payment_method: 'cod',
      note: 'Đơn test tích hợp GHN'
    };

    console.log('📤 Dữ liệu gửi:', JSON.stringify(orderData, null, 2));

    const response = await axios.post(`${API_URL}/orders`, orderData, {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      }
    });

    if (response.data.success) {
      console.log('\n✅ Tạo đơn hàng thành công!');
      console.log('📝 Order ID:', response.data.data.id);
      console.log('📝 GHN Order Code:', response.data.data.ghn_order_code);
      
      if (response.data.data.ghn_order_code) {
        console.log('\n🎉 ĐƠN HÀNG ĐÃ ĐƯỢC TẠO TRÊN GHN!');
        console.log('🔗 Xem tại: https://khachhang.ghn.vn/order');
        console.log('🔍 Mã vận đơn:', response.data.data.ghn_order_code);
      } else {
        console.log('\n⚠️ Đơn hàng đã tạo trong database nhưng CHƯA có mã GHN');
        console.log('💡 Kiểm tra log server để xem lỗi gì');
      }

      return response.data.data;
    }
  } catch (error) {
    console.error('\n❌ Lỗi tạo đơn hàng:');
    console.error('Status:', error.response?.status);
    console.error('Message:', error.response?.data?.message || error.message);
    console.error('Data:', error.response?.data);
    return null;
  }
}

// Test kiểm tra đơn trên GHN
async function checkGHNOrder(orderCode) {
  try {
    console.log(`\n🔍 Kiểm tra đơn ${orderCode} trên GHN...`);
    
    const response = await axios.get('https://online-gateway.ghn.vn/shiip/public-api/v2/shipping-order/detail', {
      params: { order_code: orderCode },
      headers: {
        'Token': GHN_TOKEN,
        'ShopId': GHN_SHOP_ID
      }
    });

    if (response.data.code === 200) {
      console.log('✅ Đơn hàng tồn tại trên GHN!');
      console.log('📋 Trạng thái:', response.data.data.status);
      console.log('📦 Tên người nhận:', response.data.data.to_name);
      console.log('📞 SĐT:', response.data.data.to_phone);
      return true;
    }
  } catch (error) {
    console.error('❌ Không tìm thấy đơn trên GHN:', error.response?.data?.message || error.message);
    return false;
  }
}

// Test GHN credentials
async function testGHNCredentials() {
  try {
    console.log('\n🔑 Kiểm tra thông tin GHN...');
    console.log('GHN_TOKEN:', GHN_TOKEN ? '✅ Có' : '❌ Không có');
    console.log('GHN_SHOP_ID:', GHN_SHOP_ID ? '✅ Có' : '❌ Không có');

    // Test lấy danh sách tỉnh
    const response = await axios.get('https://online-gateway.ghn.vn/shiip/public-api/master-data/province', {
      headers: {
        'Token': GHN_TOKEN
      }
    });

    if (response.data.code === 200) {
      console.log('✅ Token GHN hợp lệ');
      return true;
    }
  } catch (error) {
    console.error('❌ Token GHN không hợp lệ:', error.response?.data?.message || error.message);
    return false;
  }
}

// Main
async function main() {
  console.log('🚀 BẮT ĐẦU TEST TẠO ĐỠN HÀNG VÀ GỬI LÊN GHN\n');
  console.log('='.repeat(60));

  // 1. Test GHN credentials
  const ghnValid = await testGHNCredentials();
  if (!ghnValid) {
    console.log('\n❌ Vui lòng kiểm tra lại GHN_TOKEN trong file .env');
    return;
  }

  // 2. Login
  console.log('\n' + '='.repeat(60));
  const token = await login();
  if (!token) {
    console.log('\n❌ Không thể đăng nhập. Kiểm tra tài khoản admin@example.com / admin123');
    return;
  }

  // 3. Tạo đơn hàng
  console.log('\n' + '='.repeat(60));
  const order = await createOrder(token);
  
  if (order && order.ghn_order_code) {
    // 4. Kiểm tra đơn trên GHN
    console.log('\n' + '='.repeat(60));
    await checkGHNOrder(order.ghn_order_code);
  }

  console.log('\n' + '='.repeat(60));
  console.log('✅ HOÀN THÀNH TEST');
}

main();
