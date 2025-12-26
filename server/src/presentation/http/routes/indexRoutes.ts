import { Router } from 'express';
import authRoutes from './auth';
import productRoutes from './products';
import categoryRoutes from './categories';
import cartRoutes from './cart';
import orderRoutes from './orders';
import adminRoutes from './admin';
import blogRoutes from './blogs';
import shippingRoutes from './shipping';
import reviewRoutes from './reviews';
import wishlistRoutes from './wishlist';
import flashSaleRoutes from './flash-sales';

const router = Router();

router.use('/auth', authRoutes);
router.use('/products', productRoutes);
router.use('/categories', categoryRoutes);
router.use('/cart', cartRoutes);
router.use('/orders', orderRoutes);
router.use('/admin', adminRoutes);
router.use('/blogs', blogRoutes);
router.use('/shipping', shippingRoutes);
router.use('/reviews', reviewRoutes);
router.use('/wishlist', wishlistRoutes);
router.use('/flash-sales', flashSaleRoutes);

export default router;
