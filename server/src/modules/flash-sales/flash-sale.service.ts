import flashSaleRepository from '../../infrastructure/repositories/flashSaleRepository';
import productRepository from '../../infrastructure/repositories/productRepository';

class FlashSaleService {
  async createFlashSale(data: {
    product_id: number;
    discount_percentage: number;
    start_time: Date | string;
    end_time: Date | string;
    status?: 'active' | 'inactive';
  }) {
    // Kiểm tra sản phẩm tồn tại
    const product = await productRepository.findById(data.product_id);
    if (!product) {
      throw new Error('Không tìm thấy sản phẩm');
    }

    // Kiểm tra giá trị giảm giá
    if (data.discount_percentage <= 0 || data.discount_percentage > 100) {
      throw new Error('Phần trăm giảm giá phải từ 1 đến 100');
    }

    // Kiểm tra thời gian
    const startTime = new Date(data.start_time);
    const endTime = new Date(data.end_time);

    if (startTime >= endTime) {
      throw new Error('Thời gian kết thúc phải sau thời gian bắt đầu');
    }

    // Kiểm tra xem sản phẩm đã có flash sale active chưa
    const existingFlashSale = await flashSaleRepository.findByProductId(data.product_id);
    if (existingFlashSale) {
      throw new Error('Sản phẩm này đã có chương trình flash sale đang hoạt động');
    }

    return flashSaleRepository.create({
      product_id: data.product_id,
      discount_percentage: data.discount_percentage,
      start_time: startTime,
      end_time: endTime,
      status: data.status || 'active',
    });
  }

  async getActiveFlashSales() {
    return flashSaleRepository.listActive();
  }

  async getAllFlashSales(filter?: { status?: string; limit?: number; offset?: number }) {
    return flashSaleRepository.listAll(filter);
  }

  async getFlashSaleById(id: number) {
    const flashSale = await flashSaleRepository.findById(id);
    if (!flashSale) {
      throw new Error('Không tìm thấy flash sale');
    }
    return flashSale;
  }

  async updateFlashSale(
    id: number,
    data: {
      discount_percentage?: number;
      start_time?: Date | string;
      end_time?: Date | string;
      status?: 'active' | 'inactive' | 'expired';
    }
  ) {
    const flashSale = await flashSaleRepository.findById(id);
    if (!flashSale) {
      throw new Error('Không tìm thấy flash sale');
    }

    // Kiểm tra giá trị giảm giá
    if (data.discount_percentage !== undefined) {
      if (data.discount_percentage <= 0 || data.discount_percentage > 100) {
        throw new Error('Phần trăm giảm giá phải từ 1 đến 100');
      }
    }

    // Kiểm tra thời gian
    if (data.start_time || data.end_time) {
      const startTime = data.start_time ? new Date(data.start_time) : flashSale.start_time;
      const endTime = data.end_time ? new Date(data.end_time) : flashSale.end_time;

      if (startTime >= endTime) {
        throw new Error('Thời gian kết thúc phải sau thời gian bắt đầu');
      }
    }

    const updateData: any = {};
    if (data.discount_percentage !== undefined) updateData.discount_percentage = data.discount_percentage;
    if (data.start_time) updateData.start_time = new Date(data.start_time);
    if (data.end_time) updateData.end_time = new Date(data.end_time);
    if (data.status) updateData.status = data.status;

    return flashSaleRepository.update(id, updateData);
  }

  async deleteFlashSale(id: number) {
    const flashSale = await flashSaleRepository.findById(id);
    if (!flashSale) {
      throw new Error('Không tìm thấy flash sale');
    }

    const deleted = await flashSaleRepository.delete(id);
    if (!deleted) {
      throw new Error('Không thể xóa flash sale');
    }

    return { message: 'Xóa flash sale thành công' };
  }
}

export default new FlashSaleService();
