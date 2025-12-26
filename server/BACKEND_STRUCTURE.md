# 🏗️ Cấu Trúc Backend - Clean Architecture

## 📁 Tổ chức thư mục hiện tại

```
server/src/
├── domain/                          # ⭐ Tầng Domain (Business Logic Core)
│   ├── repositories/                # Interface định nghĩa repositories
│   │   ├── IUserRepository.ts
│   │   ├── IProductRepository.ts
│   │   └── IOrderRepository.ts
│   └── services/                    # Interface định nghĩa external services
│       ├── IEmailService.ts
│       └── IGHNService.ts
│
├── application/                     # 🎯 Tầng Application (Use Cases)
│   └── use-cases/                   # Business workflows
│       ├── LoginUseCase.ts
│       └── CreateOrderUseCase.ts
│
├── infrastructure/                  # 🔧 Tầng Infrastructure (Implementation)
│   ├── database.ts                  # Cấu hình MySQL connection pool
│   ├── repositories/                # Implementation của domain repositories
│   │   ├── index.ts                # Export tập trung
│   │   ├── userRepositoryImpl.ts
│   │   ├── productRepositoryImpl.ts
│   │   ├── orderRepositoryImpl.ts
│   │   ├── cartRepositoryImpl.ts
│   │   ├── categoryRepositoryImpl.ts
│   │   ├── blogRepositoryImpl.ts
│   │   ├── reviewRepositoryImpl.ts
│   │   ├── wishlistRepositoryImpl.ts
│   │   ├── couponRepositoryImpl.ts
│   │   └── flashSaleRepositoryImpl.ts
│   └── external-services/           # Implementation external services
│       ├── index.ts                # Export tập trung
│       ├── EmailServiceImpl.ts     # Nodemailer integration
│       └── GHNServiceImpl.ts       # Giao Hàng Nhanh API
│
├── presentation/                    # 🌐 Tầng Presentation (API Layer)
│   └── http/
│       ├── controllers/            # HTTP request handlers (từ modules)
│       │   ├── AuthController.ts
│       │   ├── CartController.ts
│       │   ├── OrderController.ts
│       │   ├── ProductController.ts
│       │   └── CategoryController.ts
│       ├── routes/                 # Route definitions
│       │   ├── index.ts           # Router chính
│       │   ├── authRoutes.ts
│       │   ├── productsRoutes.ts
│       │   ├── cartRoutes.ts
│       │   ├── ordersRoutes.ts
│       │   ├── blogsRoutes.ts
│       │   ├── reviewsRoutes.ts
│       │   ├── wishlistRoutes.ts
│       │   ├── shippingRoutes.ts
│       │   ├── flash-salesRoutes.ts
│       │   └── adminRoutes.ts
│       └── middlewares/            # HTTP middlewares
│           ├── index.ts
│           ├── authMiddleware.ts
│           └── errorHandler.ts
│
├── modules/                        # 📦 Feature Modules (Services layer - đang chuyển đổi)
│   ├── auth/
│   │   ├── auth.controller.ts
│   │   └── auth.service.ts
│   ├── cart/
│   ├── categories/
│   ├── flash-sales/
│   ├── orders/
│   ├── products/
│   └── users/
│
├── config/                         # ⚙️ Configuration
│   ├── env.ts                     # Environment variables
│   ├── logger.ts                  # Pino logger config
│   └── swagger.ts                 # Swagger/OpenAPI config
│
├── types/                          # 📝 TypeScript type definitions
│   └── express.d.ts
│
├── app.ts                          # Express app setup
└── server.ts                       # Entry point

## 🔄 Migration Status

### ✅ Đã hoàn thành
- [x] Tạo cấu trúc thư mục Clean Architecture
- [x] Di chuyển repositories sang `infrastructure/repositories/` với hậu tố `Impl`
- [x] Di chuyển services sang `infrastructure/external-services/`
- [x] Di chuyển middlewares sang `presentation/http/middlewares/`
- [x] Copy routes sang `presentation/http/routes/`
- [x] Copy controllers sang `presentation/http/controllers/`
- [x] Cập nhật tất cả import paths
- [x] Tạo index files cho dễ import

### 🔄 Đang thực hiện
- [ ] Refactor services thành Use Cases
- [ ] Tạo Domain Entities
- [ ] Implement Dependency Injection
- [ ] Viết Unit Tests

### 📋 Kế hoạch tiếp theo
- [ ] Di chuyển logic từ services sang use cases
- [ ] Xóa thư mục `api/` cũ (đã copy sang routes)
- [ ] Xóa thư mục `interfaces/` cũ (đã copy sang presentation)
- [ ] Implement validation layer
- [ ] Thêm logging và monitoring

## 🎯 Nguyên tắc Clean Architecture

### 1. Dependency Rule
```
Domain ← Application ← Infrastructure
                    ← Presentation
```

- **Domain**: Không phụ thuộc ai, chứa business logic thuần túy
- **Application**: Phụ thuộc Domain, chứa use cases
- **Infrastructure**: Phụ thuộc Domain, implement các interface
- **Presentation**: Phụ thuộc Application, xử lý HTTP requests

### 2. Trách nhiệm từng tầng

#### 🌟 Domain Layer
- Định nghĩa entities và value objects
- Định nghĩa repository interfaces
- Định nghĩa service interfaces
- Chứa business rules

#### 🎯 Application Layer
- Use cases (workflows nghiệp vụ)
- DTOs cho input/output
- Orchestration logic

#### 🔧 Infrastructure Layer
- Database access (repositories implementation)
- External API calls (services implementation)
- File system, caching, etc.

#### 🌐 Presentation Layer
- HTTP routes và controllers
- Request validation
- Response formatting
- Authentication middleware

## 📝 Ví dụ sử dụng

### Import Repositories
```typescript
// Cách cũ
import userRepository from '../../infrastructure/repositories/userRepository';

// Cách mới (Clean Architecture)
import userRepository from '../../infrastructure/repositories/userRepositoryImpl';

// Hoặc import từ index
import { userRepository } from '../../infrastructure/repositories';
```

### Import Services
```typescript
// Cách cũ
import emailService from '../../infrastructure/services/emailService';
import ghnService from '../../infrastructure/services/ghnService';

// Cách mới (Clean Architecture)
import emailService from '../../infrastructure/external-services/EmailServiceImpl';
import ghnService from '../../infrastructure/external-services/GHNServiceImpl';

// Hoặc import từ index
import { emailService, ghnService } from '../../infrastructure/external-services';
```

### Sử dụng trong Routes
```typescript
// presentation/http/routes/authRoutes.ts
import { Router } from 'express';
import authController from '../../../modules/auth/auth.controller';
import { authenticate } from '../middlewares/authMiddleware';

const router = Router();

router.post('/login', authController.login);
router.post('/register', authController.register);
router.get('/me', authenticate, authController.me);

export default router;
```

### Sử dụng Use Case (Mẫu)
```typescript
// application/use-cases/LoginUseCase.ts
export class LoginUseCase {
  constructor(
    private userRepository: IUserRepository,
    private jwtSecret: string
  ) {}

  async execute(dto: LoginDTO): Promise<LoginResponse> {
    const user = await this.userRepository.findByEmail(dto.email);
    // ... business logic
    return { accessToken, user };
  }
}

// Sử dụng trong controller
const loginUseCase = new LoginUseCase(userRepository, env.jwt.secret);
const result = await loginUseCase.execute({ email, password });
```

## 🚀 Chạy ứng dụng

```bash
# Development
npm run dev

# Production
npm run build
npm start

# Lint
npm run lint
```

## 📚 Tài liệu

- [Clean Architecture Guide](./CLEAN_ARCHITECTURE.md)
- [Migration Guide](./MIGRATION_GUIDE.md)
- [API Documentation](http://localhost:5000/api-docs)

## 🔍 Testing

```bash
# Run tests
npm test

# Test with coverage
npm run test:coverage
```

## 💡 Best Practices

1. **Single Responsibility**: Mỗi class/module chỉ làm một việc
2. **Dependency Inversion**: Phụ thuộc vào abstraction, không phụ thuộc vào implementation
3. **Interface Segregation**: Tạo interface nhỏ, tập trung
4. **Keep business logic in Domain**: Logic nghiệp vụ nằm ở Domain, không ở Infrastructure
5. **Use DTOs**: Sử dụng DTOs để truyền dữ liệu giữa các layer

## 🤝 Contributing

Khi thêm tính năng mới, tuân theo cấu trúc Clean Architecture:

1. Tạo interface trong `domain/`
2. Tạo use case trong `application/use-cases/`
3. Implement trong `infrastructure/`
4. Tạo controller và routes trong `presentation/`

## 📖 Ghi chú

- Cấu trúc hiện tại đang trong giai đoạn chuyển đổi
- Thư mục `modules/` sẽ dần được refactor thành use cases
- Thư mục `api/` và `interfaces/` cũ có thể xóa sau khi verify
- Frontend (web/) không bị ảnh hưởng, chỉ backend thay đổi
