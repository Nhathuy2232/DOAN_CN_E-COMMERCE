import { Request, Response, NextFunction } from 'express';
import flashSaleService from './flash-sale.service';

export class FlashSaleController {
  async createFlashSale(req: Request, res: Response, next: NextFunction) {
    try {
      const { product_id, discount_percentage, start_time, end_time, status } = req.body;

      if (!product_id || !discount_percentage || !start_time || !end_time) {
        return res.status(400).json({
          success: false,
          message: 'Vui lòng cung cấp đầy đủ thông tin',
        });
      }

      const flashSale = await flashSaleService.createFlashSale({
        product_id,
        discount_percentage,
        start_time,
        end_time,
        status,
      });

      res.status(201).json({
        success: true,
        message: 'Tạo flash sale thành công',
        data: flashSale,
      });
    } catch (error) {
      if (error instanceof Error) {
        return res.status(400).json({
          success: false,
          message: error.message,
        });
      }
      next(error);
    }
  }

  async getActiveFlashSales(req: Request, res: Response, next: NextFunction) {
    try {
      const flashSales = await flashSaleService.getActiveFlashSales();

      res.json({
        success: true,
        data: flashSales,
      });
    } catch (error) {
      next(error);
    }
  }

  async getAllFlashSales(req: Request, res: Response, next: NextFunction) {
    try {
      const { status, limit, offset } = req.query;

      const filterOptions: any = {};
      if (status) filterOptions.status = status as string;
      if (limit) filterOptions.limit = Number(limit);
      if (offset) filterOptions.offset = Number(offset);
      
      const result = await flashSaleService.getAllFlashSales(filterOptions);

      res.json({
        success: true,
        data: result.items,
        pagination: {
          total: result.total,
          limit: limit ? Number(limit) : 20,
          offset: offset ? Number(offset) : 0,
        },
      });
    } catch (error) {
      next(error);
    }
  }

  async getFlashSaleById(req: Request, res: Response, next: NextFunction) {
    try {
      const { id } = req.params;

      if (!id) {
        return res.status(400).json({
          success: false,
          message: 'ID không hợp lệ',
        });
      }

      const flashSale = await flashSaleService.getFlashSaleById(Number(id));

      res.json({
        success: true,
        data: flashSale,
      });
    } catch (error) {
      if (error instanceof Error && error.message === 'Không tìm thấy flash sale') {
        return res.status(404).json({
          success: false,
          message: error.message,
        });
      }
      next(error);
    }
  }

  async updateFlashSale(req: Request, res: Response, next: NextFunction) {
    try {
      const { id } = req.params;
      const { discount_percentage, start_time, end_time, status } = req.body;

      if (!id) {
        return res.status(400).json({
          success: false,
          message: 'ID không hợp lệ',
        });
      }

      const flashSale = await flashSaleService.updateFlashSale(Number(id), {
        discount_percentage,
        start_time,
        end_time,
        status,
      });

      res.json({
        success: true,
        message: 'Cập nhật flash sale thành công',
        data: flashSale,
      });
    } catch (error) {
      if (error instanceof Error) {
        return res.status(400).json({
          success: false,
          message: error.message,
        });
      }
      next(error);
    }
  }

  async deleteFlashSale(req: Request, res: Response, next: NextFunction) {
    try {
      const { id } = req.params;

      if (!id) {
        return res.status(400).json({
          success: false,
          message: 'ID không hợp lệ',
        });
      }

      const result = await flashSaleService.deleteFlashSale(Number(id));

      res.json({
        success: true,
        message: result.message,
      });
    } catch (error) {
      if (error instanceof Error) {
        return res.status(400).json({
          success: false,
          message: error.message,
        });
      }
      next(error);
    }
  }
}

export default new FlashSaleController();
