import { Router } from 'express';
import flashSaleController from '../modules/flash-sales/flash-sale.controller';
import { authenticate, authorize } from '../interfaces/http/middlewares/authMiddleware';

const router = Router();

// Public routes
router.get('/active', flashSaleController.getActiveFlashSales.bind(flashSaleController));

// Admin routes
router.use(authenticate);
router.use(authorize(['admin']));

router.post('/', flashSaleController.createFlashSale.bind(flashSaleController));
router.get('/', flashSaleController.getAllFlashSales.bind(flashSaleController));
router.get('/:id', flashSaleController.getFlashSaleById.bind(flashSaleController));
router.patch('/:id', flashSaleController.updateFlashSale.bind(flashSaleController));
router.delete('/:id', flashSaleController.deleteFlashSale.bind(flashSaleController));

export default router;
