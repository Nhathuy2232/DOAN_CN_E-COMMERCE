"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ShippingService = void 0;
const common_1 = require("@nestjs/common");
const axios_1 = __importDefault(require("axios"));
@(0, common_1.Injectable)()
class ShippingService {
    configService;
    ghnApiUrl;
    ghnToken;
    ghnShopId;
    constructor(configService) {
        this.configService = configService;
        this.ghnApiUrl = this.configService.get('GHN_BASE_URL') || 'https://online-gateway.ghn.vn';
        this.ghnToken = this.configService.get('GHN_TOKEN');
        this.ghnShopId = this.configService.get('GHN_SHOP_ID');
    }
    async createShippingOrder(orderData) {
        try {
            const items = orderData.items.map((item) => ({
                name: item.productName,
                quantity: item.quantity,
                price: item.price,
            }));
            const payload = {
                payment_type_id: 2, // 1: Shop/Sender pays, 2: Buyer/Consignee pays
                note: `Đơn hàng #${orderData.orderId}`,
                required_note: 'KHONGCHOXEMHANG', // CHOTHUHANG, CHOXEMHANGKHONGTHU, KHONGCHOXEMHANG
                to_name: orderData.customerName,
                to_phone: orderData.phone,
                to_address: orderData.address,
                to_ward_code: '', // You need to get this from GHN API based on address
                to_district_id: 0, // You need to get this from GHN API based on address
                cod_amount: orderData.totalAmount,
                content: 'Đơn hàng từ Fishing Shop',
                weight: 1000, // gram - adjust based on products
                length: 20, // cm
                width: 20, // cm
                height: 10, // cm
                insurance_value: orderData.totalAmount,
                service_type_id: 2, // 2: E-commerce delivery
                items: items,
            };
            const response = await axios_1.default.post(`${this.ghnApiUrl}/shiip/public-api/v2/shipping-order/create`, payload, {
                headers: {
                    'Content-Type': 'application/json',
                    'Token': this.ghnToken,
                    'ShopId': this.ghnShopId,
                },
            });
            if (response.data && response.data.code === 200) {
                return response.data.data;
            }
            else {
                throw new common_1.HttpException(response.data.message || 'Failed to create shipping order', common_1.HttpStatus.BAD_REQUEST);
            }
        }
        catch (error) {
            console.error('GHN API Error:', error.response?.data || error.message);
            throw new common_1.HttpException(error.response?.data?.message || 'Failed to create shipping order with GHN', common_1.HttpStatus.BAD_REQUEST);
        }
    }
    async getShippingFee(data) {
        try {
            const response = await axios_1.default.post(`${this.ghnApiUrl}/shiip/public-api/v2/shipping-order/fee`, {
                from_district_id: data.fromDistrictId,
                service_type_id: 2,
                to_district_id: data.toDistrictId,
                to_ward_code: data.toWardCode,
                height: data.height || 10,
                length: data.length || 20,
                weight: data.weight || 1000,
                width: data.width || 20,
                insurance_value: data.insuranceValue || 0,
            }, {
                headers: {
                    'Content-Type': 'application/json',
                    'Token': this.ghnToken,
                    'ShopId': this.ghnShopId,
                },
            });
            return response.data.data;
        }
        catch (error) {
            console.error('GHN Fee Calculation Error:', error.response?.data || error.message);
            throw new common_1.HttpException('Failed to calculate shipping fee', common_1.HttpStatus.BAD_REQUEST);
        }
    }
    async getProvinces() {
        try {
            const response = await axios_1.default.get(`${this.ghnApiUrl}/shiip/public-api/master-data/province`, {
                headers: {
                    'Token': this.ghnToken,
                },
            });
            return response.data.data;
        }
        catch (error) {
            console.error('GHN Get Provinces Error:', error.response?.data || error.message);
            throw new common_1.HttpException('Failed to get provinces', common_1.HttpStatus.BAD_REQUEST);
        }
    }
    async getDistricts(provinceId) {
        try {
            const response = await axios_1.default.post(`${this.ghnApiUrl}/shiip/public-api/master-data/district`, { province_id: provinceId }, {
                headers: {
                    'Content-Type': 'application/json',
                    'Token': this.ghnToken,
                },
            });
            return response.data.data;
        }
        catch (error) {
            console.error('GHN Get Districts Error:', error.response?.data || error.message);
            throw new common_1.HttpException('Failed to get districts', common_1.HttpStatus.BAD_REQUEST);
        }
    }
    async getWards(districtId) {
        try {
            const response = await axios_1.default.post(`${this.ghnApiUrl}/shiip/public-api/master-data/ward`, { district_id: districtId }, {
                headers: {
                    'Content-Type': 'application/json',
                    'Token': this.ghnToken,
                },
            });
            return response.data.data;
        }
        catch (error) {
            console.error('GHN Get Wards Error:', error.response?.data || error.message);
            throw new common_1.HttpException('Failed to get wards', common_1.HttpStatus.BAD_REQUEST);
        }
    }
    async getOrderStatus(orderCode) {
        try {
            const response = await axios_1.default.post(`${this.ghnApiUrl}/shiip/public-api/v2/shipping-order/detail`, { order_code: orderCode }, {
                headers: {
                    'Content-Type': 'application/json',
                    'Token': this.ghnToken,
                    'ShopId': this.ghnShopId,
                },
            });
            return response.data.data;
        }
        catch (error) {
            console.error('GHN Get Order Status Error:', error.response?.data || error.message);
            throw new common_1.HttpException('Failed to get order status', common_1.HttpStatus.BAD_REQUEST);
        }
    }
}
exports.ShippingService = ShippingService;
//# sourceMappingURL=shipping.service.js.map