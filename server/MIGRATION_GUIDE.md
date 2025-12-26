# Hướng Dẫn Di Chuyển Sang Clean Architecture

## 📝 Tổng quan

Document này hướng dẫn chi tiết cách di chuyển dự án từ cấu trúc hiện tại sang Clean Architecture một cách từng bước, an toàn và không ảnh hưởng đến hoạt động của hệ thống.

## 🎯 Mục tiêu

- Di chuyển code hiện tại sang cấu trúc Clean Architecture
- Tách biệt rõ ràng các layer: Domain, Application, Infrastructure, Presentation
- Giữ nguyên chức năng hiện tại trong quá trình di chuyển
- Cải thiện khả năng test và maintain code

## 📁 Cấu trúc hiện tại

```
server/src/
├── api/                    # Route handlers (mixing controller + validation)
├── config/                 # Configuration
├── infrastructure/
│   ├── database.ts
│   ├── repositories/      # Data access layer
│   └── services/          # External services (GHN, Email)
├── interfaces/http/
│   └── middlewares/       # HTTP middlewares
├── modules/               # Feature modules (mixing service + controller)
│   ├── auth/
│   ├── cart/
│   ├── categories/
│   └── orders/
└── types/                 # Type definitions
```

## 🏗️ Cấu trúc mục tiêu (Clean Architecture)

```
server/src/
├── domain/                     # ⭐ Business Logic Core
│   ├── entities/              # Business entities
│   ├── repositories/          # Repository interfaces
│   ├── services/              # External service interfaces
│   └── value-objects/         # Value objects
│
├── application/                # 🎯 Use Cases & Application Logic
│   ├── use-cases/             # Business workflows
│   ├── dto/                   # Data Transfer Objects
│   └── mappers/               # Data mappers
│
├── infrastructure/             # 🔧 Technical Implementation
│   ├── database/              # Database config & migrations
│   ├── repositories/          # Repository implementations
│   └── external-services/     # External API implementations
│
├── presentation/               # 🌐 API Layer
│   └── http/
│       ├── controllers/       # HTTP controllers
│       ├── routes/           # Route definitions
│       ├── middlewares/      # HTTP middlewares
│       └── validators/       # Request validators
│
└── config/                    # Configuration
```

## 🔄 Kế hoạch di chuyển từng bước

### ✅ Phase 1: Đã hoàn thành
- [x] Tạo cấu trúc thư mục Clean Architecture
- [x] Tạo Domain Interfaces (IUserRepository, IProductRepository, IOrderRepository)
- [x] Tạo Service Interfaces (IEmailService, IGHNService)
- [x] Tạo Use Case mẫu (LoginUseCase, CreateOrderUseCase)
- [x] Sửa tất cả lỗi TypeScript
- [x] Xóa các file test và document không dùng
- [x] Cập nhật README với thông tin Clean Architecture

### 🔄 Phase 2: Di chuyển Domain Layer (Tiếp theo)

#### 2.1. Tạo Domain Entities
```bash
# Tạo các entity classes từ interfaces hiện tại
server/src/domain/entities/
├── User.ts
├── Product.ts
├── Order.ts
├── Cart.ts
└── Category.ts
```

**Ví dụ: User Entity**
```typescript
// server/src/domain/entities/User.ts
export class User {
  constructor(
    public readonly id: number,
    public readonly fullName: string,
    public readonly email: string,
    public readonly passwordHash: string,
    public readonly role: 'customer' | 'admin',
    public readonly createdAt: Date,
    public readonly updatedAt: Date
  ) {}

  // Business methods
  isAdmin(): boolean {
    return this.role === 'admin';
  }

  canAccessAdminPanel(): boolean {
    return this.isAdmin();
  }
}
```

#### 2.2. Tạo Value Objects
```typescript
// server/src/domain/value-objects/Email.ts
export class Email {
  private constructor(private readonly value: string) {}

  static create(email: string): Email {
    if (!this.isValid(email)) {
      throw new Error('Email không hợp lệ');
    }
    return new Email(email);
  }

  private static isValid(email: string): boolean {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  getValue(): string {
    return this.value;
  }
}
```

### 🔄 Phase 3: Di chuyển Application Layer

#### 3.1. Tạo DTOs
```typescript
// server/src/application/dto/CreateProductDTO.ts
export interface CreateProductDTO {
  name: string;
  description: string;
  price: number;
  categoryId: number;
  stockQuantity: number;
  thumbnailUrl: string;
  images?: string[];
}
```

#### 3.2. Tạo Use Cases từ Services hiện tại

**Mapping:**
- `auth.service.ts` → `LoginUseCase.ts`, `RegisterUseCase.ts`
- `cart.service.ts` → `AddToCartUseCase.ts`, `UpdateCartUseCase.ts`, `RemoveFromCartUseCase.ts`
- `order.service.ts` → `CreateOrderUseCase.ts`, `GetOrderDetailsUseCase.ts`

**Ví dụ:**
```typescript
// server/src/application/use-cases/cart/AddToCartUseCase.ts
import { ICartRepository } from '../../../domain/repositories/ICartRepository';
import { IProductRepository } from '../../../domain/repositories/IProductRepository';

export class AddToCartUseCase {
  constructor(
    private cartRepository: ICartRepository,
    private productRepository: IProductRepository
  ) {}

  async execute(userId: number, productId: number, quantity: number) {
    // 1. Validate sản phẩm tồn tại
    const product = await this.productRepository.findById(productId);
    if (!product) {
      throw new Error('Sản phẩm không tồn tại');
    }

    // 2. Kiểm tra tồn kho
    const hasStock = await this.productRepository.checkStock(productId, quantity);
    if (!hasStock) {
      throw new Error('Sản phẩm không đủ số lượng');
    }

    // 3. Thêm vào giỏ hàng
    return await this.cartRepository.addItem(userId, productId, quantity);
  }
}
```

### 🔄 Phase 4: Refactor Infrastructure Layer

#### 4.1. Rename Repositories
```bash
# Đổi tên các repository hiện tại thành *Impl
mv userRepository.ts UserRepositoryImpl.ts
mv productRepository.ts ProductRepositoryImpl.ts
mv orderRepository.ts OrderRepositoryImpl.ts
```

#### 4.2. Implement Domain Interfaces
```typescript
// server/src/infrastructure/repositories/UserRepositoryImpl.ts
import { IUserRepository, User, CreateUserData } from '../../domain/repositories/IUserRepository';
import pool from '../database';

export class UserRepositoryImpl implements IUserRepository {
  async findByEmail(email: string): Promise<User | null> {
    const [rows] = await pool.query<RowDataPacket[]>(
      'SELECT * FROM users WHERE email = ? LIMIT 1',
      [email]
    );
    if (!rows.length) return null;
    return this.mapToEntity(rows[0]);
  }

  private mapToEntity(row: any): User {
    return {
      id: row.id,
      fullName: row.full_name,
      email: row.email,
      passwordHash: row.password_hash,
      role: row.role,
      createdAt: row.created_at,
      updatedAt: row.updated_at,
    };
  }

  // ... implement other methods
}
```

### 🔄 Phase 5: Refactor Presentation Layer

#### 5.1. Tạo Controllers mới sử dụng Use Cases
```typescript
// server/src/presentation/http/controllers/AuthController.ts
import { Request, Response, NextFunction } from 'express';
import { LoginUseCase } from '../../../application/use-cases/LoginUseCase';
import { RegisterUseCase } from '../../../application/use-cases/RegisterUseCase';

export class AuthController {
  constructor(
    private loginUseCase: LoginUseCase,
    private registerUseCase: RegisterUseCase
  ) {}

  async login(req: Request, res: Response, next: NextFunction) {
    try {
      const { email, password } = req.body;
      const result = await this.loginUseCase.execute({ email, password });
      
      res.json({
        success: true,
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }

  async register(req: Request, res: Response, next: NextFunction) {
    try {
      const { fullName, email, password } = req.body;
      const result = await this.registerUseCase.execute({ 
        fullName, 
        email, 
        password 
      });
      
      res.status(201).json({
        success: true,
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }
}
```

#### 5.2. Setup Dependency Injection
```typescript
// server/src/presentation/http/di-container.ts
import { UserRepositoryImpl } from '../../infrastructure/repositories/UserRepositoryImpl';
import { LoginUseCase } from '../../application/use-cases/LoginUseCase';
import { AuthController } from './controllers/AuthController';
import env from '../../config/env';

// Repositories
const userRepository = new UserRepositoryImpl();

// Use Cases
const loginUseCase = new LoginUseCase(
  userRepository,
  env.jwt.secret,
  env.jwt.expiresIn
);

// Controllers
export const authController = new AuthController(loginUseCase, registerUseCase);
```

#### 5.3. Cập nhật Routes
```typescript
// server/src/presentation/http/routes/authRoutes.ts
import { Router } from 'express';
import { authController } from '../di-container';

const router = Router();

router.post('/login', (req, res, next) => 
  authController.login(req, res, next)
);

router.post('/register', (req, res, next) => 
  authController.register(req, res, next)
);

export default router;
```

## 📋 Checklist di chuyển từng module

### Module Auth
- [ ] Tạo User Entity
- [ ] Tạo Email Value Object
- [ ] Tạo LoginUseCase
- [ ] Tạo RegisterUseCase
- [ ] Implement UserRepositoryImpl
- [ ] Tạo AuthController mới
- [ ] Cập nhật routes
- [ ] Test và verify

### Module Cart
- [ ] Tạo Cart Entity
- [ ] Tạo AddToCartUseCase
- [ ] Tạo UpdateCartItemUseCase
- [ ] Tạo RemoveFromCartUseCase
- [ ] Tạo GetCartUseCase
- [ ] Implement CartRepositoryImpl
- [ ] Tạo CartController mới
- [ ] Cập nhật routes
- [ ] Test và verify

### Module Order
- [ ] Tạo Order Entity
- [ ] Tạo CreateOrderUseCase (đã có)
- [ ] Tạo GetOrderDetailsUseCase
- [ ] Tạo ListOrdersUseCase
- [ ] Tạo UpdateOrderStatusUseCase
- [ ] Implement OrderRepositoryImpl
- [ ] Tạo OrderController mới
- [ ] Cập nhật routes
- [ ] Test và verify

### Module Product
- [ ] Tạo Product Entity
- [ ] Tạo GetProductListUseCase
- [ ] Tạo GetProductDetailsUseCase
- [ ] Tạo CreateProductUseCase (admin)
- [ ] Tạo UpdateProductUseCase (admin)
- [ ] Tạo DeleteProductUseCase (admin)
- [ ] Implement ProductRepositoryImpl
- [ ] Tạo ProductController mới
- [ ] Cập nhật routes
- [ ] Test và verify

## 🔍 Testing Strategy

### Unit Tests
```typescript
// server/src/application/use-cases/__tests__/LoginUseCase.test.ts
describe('LoginUseCase', () => {
  let loginUseCase: LoginUseCase;
  let mockUserRepository: jest.Mocked<IUserRepository>;

  beforeEach(() => {
    mockUserRepository = {
      findByEmail: jest.fn(),
      // ... other methods
    } as any;

    loginUseCase = new LoginUseCase(
      mockUserRepository,
      'test-secret',
      '1h'
    );
  });

  it('should login successfully with valid credentials', async () => {
    // Arrange
    const mockUser = {
      id: 1,
      email: 'test@example.com',
      passwordHash: await bcrypt.hash('password123', 10),
      fullName: 'Test User',
      role: 'customer' as const,
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    mockUserRepository.findByEmail.mockResolvedValue(mockUser);

    // Act
    const result = await loginUseCase.execute({
      email: 'test@example.com',
      password: 'password123',
    });

    // Assert
    expect(result.accessToken).toBeDefined();
    expect(result.user.email).toBe('test@example.com');
  });

  it('should throw error with invalid credentials', async () => {
    // Arrange
    mockUserRepository.findByEmail.mockResolvedValue(null);

    // Act & Assert
    await expect(
      loginUseCase.execute({
        email: 'wrong@example.com',
        password: 'wrongpass',
      })
    ).rejects.toThrow('Thông tin đăng nhập không chính xác');
  });
});
```

## 🚀 Deployment

Sau khi hoàn thành di chuyển từng module:

1. **Test kỹ càng** tất cả các chức năng
2. **Cập nhật documentation** cho từng use case
3. **Review code** với team
4. **Deploy lên staging** để test integration
5. **Monitor logs** và performance
6. **Deploy production** sau khi staging stable

## 📚 Tài liệu tham khảo

- [Clean Architecture - Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Domain-Driven Design](https://martinfowler.com/bliki/DomainDrivenDesign.html)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)

## 💡 Tips & Best Practices

1. **Di chuyển từng module một**: Không cố gắng refactor toàn bộ cùng lúc
2. **Giữ backward compatibility**: Đảm bảo API cũ vẫn hoạt động trong quá trình di chuyển
3. **Viết tests trước**: Có test suite tốt trước khi refactor
4. **Code review**: Review kỹ mỗi pull request
5. **Documentation**: Cập nhật docs ngay khi có thay đổi
6. **Monitoring**: Theo dõi logs và metrics sau mỗi lần deploy

## ❓ Q&A

### Q: Có cần di chuyển toàn bộ code ngay không?
**A:** Không! Bạn có thể di chuyển từng module và giữ cả hai cấu trúc song song. Ví dụ: module Auth dùng Clean Architecture, các module khác vẫn giữ nguyên.

### Q: Làm thế nào để test trong quá trình di chuyển?
**A:** Viết integration tests và e2e tests trước. Sau đó di chuyển và chạy lại tests để đảm bảo mọi thứ vẫn hoạt động.

### Q: Performance có bị ảnh hưởng không?
**A:** Không đáng kể. Clean Architecture thêm vài layer abstraction nhưng lợi ích về maintainability và testability lớn hơn nhiều.

### Q: Có nên dùng Dependency Injection container không?
**A:** Với dự án Node.js nhỏ/vừa, manual DI (như ví dụ trên) là đủ. Nếu dự án lớn hơn, có thể xem xét TypeDI hoặc InversifyJS.
