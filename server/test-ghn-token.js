const axios = require('axios');

async function testGHNToken() {
  const token = '27b6a6da-d0f0-11f0-bcb9-a63866d22c8d';
  const shopId = 6148508;

  console.log('Testing GHN Token and Shop ID...\n');
  console.log('Token:', token);
  console.log('Shop ID:', shopId);
  console.log('---\n');

  try {
    // Test 1: Get shop info
    console.log('Test 1: Getting shop info...');
    const shopResponse = await axios.get('https://online-gateway.ghn.vn/shiip/public-api/v2/shop/all', {
      headers: {
        'Token': token,
      },
    });
    console.log('✅ Shop info retrieved successfully');
    console.log('Shops:', JSON.stringify(shopResponse.data, null, 2));
    console.log('\n---\n');
  } catch (error) {
    console.error('❌ Failed to get shop info:');
    console.error('Status:', error.response?.status);
    console.error('Data:', JSON.stringify(error.response?.data, null, 2));
    console.log('\n---\n');
  }

  try {
    // Test 2: Calculate shipping fee
    console.log('Test 2: Calculating shipping fee...');
    const feeResponse = await axios.post(
      'https://online-gateway.ghn.vn/shiip/public-api/v2/shipping-order/fee',
      {
        service_id: 53320,
        service_type_id: 2,
        to_district_id: 1560,
        to_ward_code: '580108',
        height: 10,
        length: 15,
        weight: 500,
        width: 15,
        insurance_value: 100000,
      },
      {
        headers: {
          'Token': token,
          'ShopId': shopId,
          'Content-Type': 'application/json',
        },
      }
    );
    console.log('✅ Shipping fee calculated successfully');
    console.log('Fee:', JSON.stringify(feeResponse.data, null, 2));
    console.log('\n---\n');
  } catch (error) {
    console.error('❌ Failed to calculate shipping fee:');
    console.error('Status:', error.response?.status);
    console.error('Data:', JSON.stringify(error.response?.data, null, 2));
    console.log('\n---\n');
  }

  try {
    // Test 3: Create order
    console.log('Test 3: Creating order on GHN...');
    const orderResponse = await axios.post(
      'https://online-gateway.ghn.vn/shiip/public-api/v2/shipping-order/create',
      {
        payment_type_id: 2,
        note: 'Test order',
        required_note: 'KHONGCHOXEMHANG',
        from_name: 'nhathuy',
        from_phone: '0376911677',
        from_address: 'Trà Vinh',
        from_ward_name: 'Phường 6',
        from_district_name: 'Thành phố Trà Vinh',
        from_province_name: 'Trà Vinh',
        to_name: 'Nguyễn Văn Test',
        to_phone: '0376911677',
        to_address: '90 Phường 6, Thành phố Trà Vinh',
        to_ward_code: '580108',
        to_district_id: 1560,
        cod_amount: 145000,
        content: 'Dụng cụ câu cá',
        weight: 500,
        length: 15,
        width: 15,
        height: 10,
        service_id: 53320,
        service_type_id: 2,
        insurance_value: 100000,
        items: [
          {
            name: 'Cần câu test',
            quantity: 1,
            price: 100000,
          },
        ],
      },
      {
        headers: {
          'Token': token,
          'ShopId': shopId,
          'Content-Type': 'application/json',
        },
      }
    );
    console.log('✅ Order created successfully on GHN!');
    console.log('Order:', JSON.stringify(orderResponse.data, null, 2));
    console.log('\n---\n');
  } catch (error) {
    console.error('❌ Failed to create order on GHN:');
    console.error('Status:', error.response?.status);
    console.error('Data:', JSON.stringify(error.response?.data, null, 2));
    if (error.response?.data?.message) {
      console.error('Message:', error.response.data.message);
    }
    console.log('\n---\n');
  }
}

testGHNToken();
