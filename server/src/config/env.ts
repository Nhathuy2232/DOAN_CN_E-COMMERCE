import dotenv from 'dotenv';

dotenv.config();

const env = {
  nodeEnv: process.env.NODE_ENV ?? 'development',
  port: Number(process.env.PORT ?? 4000),
  jwt: {
    secret: process.env.JWT_SECRET ?? 'super-secret-key',
    expiresIn: process.env.JWT_EXPIRES_IN ?? '1d',
  },
  database: {
    host: process.env.DB_HOST ?? 'localhost',
    port: Number(process.env.DB_PORT ?? 3306),
    user: process.env.DB_USER ?? 'root',
    password: process.env.DB_PASSWORD ?? '',
    database: process.env.DB_NAME ?? 'fishing_shop',
    connectionLimit: Number(process.env.DB_CONNECTION_LIMIT ?? 10),
  },
  pagination: {
    defaultLimit: Number(process.env.PAGINATION_LIMIT ?? 20),
  },
  ghn: {
    baseUrl: process.env.GHN_BASE_URL ?? 'https://dev-online-gateway.ghn.vn',
    shopId: process.env.GHN_SHOP_ID ?? '6148508',
    token: process.env.GHN_TOKEN ?? '27b6a6da-d0f0-11f0-bcb9-a63866d22c8d',
    phone: process.env.GHN_PHONE ?? '0376911677',
  },
};

export type Env = typeof env;

export default env;

