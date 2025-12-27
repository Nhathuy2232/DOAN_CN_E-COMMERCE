async function testCalculateFee() {
  try {
    console.log('Testing calculate-fee API...');
    const response = await fetch('http://localhost:4000/api/shipping/calculate-fee', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        toDistrictId: 3695,  // TP Thủ Đức
        toWardCode: '90768', // Phường An Khánh
        weight: 1000,
        insuranceValue: 500000
      })
    });

    const data = await response.json();
    console.log('Status:', response.status);
    console.log('Response:', JSON.stringify(data, null, 2));
  } catch (error) {
    console.error('Error:', error.message);
  }
}

testCalculateFee();