"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ShippingModule = void 0;
const common_1 = require("@nestjs/common");
const shipping_controller_1 = require("./shipping.controller");
const shipping_service_1 = require("./shipping.service");
@(0, common_1.Module)({
    controllers: [shipping_controller_1.ShippingController],
    providers: [shipping_service_1.ShippingService],
    exports: [shipping_service_1.ShippingService],
})
class ShippingModule {
}
exports.ShippingModule = ShippingModule;
//# sourceMappingURL=shipping.module.js.map