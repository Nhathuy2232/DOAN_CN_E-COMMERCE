import { ConfigService } from '@nestjs/config';
export declare class ShippingService {
    private configService;
    private readonly ghnApiUrl;
    private readonly ghnToken;
    private readonly ghnShopId;
    constructor(configService: ConfigService);
    createShippingOrder(orderData: any): Promise<any>;
    getShippingFee(data: any): Promise<any>;
    getProvinces(): Promise<any>;
    getDistricts(provinceId: number): Promise<any>;
    getWards(districtId: number): Promise<any>;
    getOrderStatus(orderCode: string): Promise<any>;
}
//# sourceMappingURL=shipping.service.d.ts.map