"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ShippingController = void 0;
const common_1 = require("@nestjs/common");
@(0, common_1.Controller)('shipping')
class ShippingController {
    shippingService;
    constructor(shippingService) {
        this.shippingService = shippingService;
    }
    @(0, common_1.Post)('fee')
    async getShippingFee(
    @(0, common_1.Body)()
    data) {
        return this.shippingService.getShippingFee(data);
    }
    @(0, common_1.Get)('provinces')
    async getProvinces() {
        return this.shippingService.getProvinces();
    }
    @(0, common_1.Get)('districts/:provinceId')
    async getDistricts(
    @(0, common_1.Param)('provinceId')
    provinceId) {
        return this.shippingService.getDistricts(+provinceId);
    }
    @(0, common_1.Get)('wards/:districtId')
    async getWards(
    @(0, common_1.Param)('districtId')
    districtId) {
        return this.shippingService.getWards(+districtId);
    }
    @(0, common_1.Get)('order/:orderCode')
    async getOrderStatus(
    @(0, common_1.Param)('orderCode')
    orderCode) {
        return this.shippingService.getOrderStatus(orderCode);
    }
}
exports.ShippingController = ShippingController;
//# sourceMappingURL=shipping.controller.js.map