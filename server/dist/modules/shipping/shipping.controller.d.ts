import { ShippingService } from './shipping.service';
export declare class ShippingController {
    private readonly shippingService;
    constructor(shippingService: ShippingService);
    getShippingFee(data: any): Promise<any>;
    getProvinces(): Promise<any>;
    getDistricts(provinceId: string): Promise<any>;
    getWards(districtId: string): Promise<any>;
    getOrderStatus(orderCode: string): Promise<any>;
}
//# sourceMappingURL=shipping.controller.d.ts.map