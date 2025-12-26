const axios = require('axios');

async function testCreateOrder() {
  try {
    console.log('Testing order creation with GHN...\n');

    const orderData = {
      userId: 1,
      paymentMethod: 'cod',
      note: 'Test đơn hàng',
      shipping_info: {
        recipient_name: 'Nguyễn Văn Test',
        recipient_phone: '0376911677',
        address: '90 Phường 6, Thành phố Trà Vinh',
        province_id: 214,
        district_id: 1560,
        ward_code: '580108',
      },
      shipping_fee: 45000,
      items: [
        {
          product_id: 1,
          quantity: 1,
          price: 100000,
        },
      ],
    };

    console.log('Sending order data:', JSON.stringify(orderData, null, 2));

    const response = await axios.post('http://localhost:4000/api/orders', orderData, {
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer test-token-for-user-1',
      },
    });

    console.log('\n✅ Order created successfully!');
    console.log('Response:', JSON.stringify(response.data, null, 2));
  } catch (error) {
    console.error('\n❌ Error creating order:');
    console.error('Status:', error.response?.status);
    console.error('Data:', JSON.stringify(error.response?.data, null, 2));
    console.error('Message:', error.message);
  }
}

testCreateOrder();
