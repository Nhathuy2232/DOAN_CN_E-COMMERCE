# Clean Architecture - Dự án E-Commerce Câu Cá

## Cấu trúc dự án theo Clean Architecture

```
server/src/
├── domain/                      # Tầng Domain (Core Business Logic)
│   ├── entities/               # Các thực thể nghiệp vụ
│   │   ├── User.ts
│   │   ├── Product.ts
│   │   ├── Order.ts
│   │   ├── Cart.ts
│   │   └── ...
│   ├── repositories/           # Interface của repositories
│   │   ├── IUserRepository.ts
│   │   ├── IProductRepository.ts
│   │   └── ...
│   ├── services/               # Interface của các service bên ngoài
│   │   ├── IEmailService.ts
│   │   ├── IGHNService.ts
│   │   └── ...
│   └── value-objects/          # Các Value Objects
│       ├── Email.ts
│       ├── Money.ts
│       └── ...
│
├── application/                 # Tầng Application (Use Cases)
│   ├── use-cases/              # Các use case nghiệp vụ
│   │   ├── auth/
│   │   │   ├── LoginUseCase.ts
│   │   │   ├── RegisterUseCase.ts
│   │   │   └── ...
│   │   ├── cart/
│   │   │   ├── AddToCartUseCase.ts
│   │   │   ├── UpdateCartItemUseCase.ts
│   │   │   └── ...
│   │   ├── order/
│   │   │   ├── CreateOrderUseCase.ts
│   │   │   ├── GetOrderDetailsUseCase.ts
│   │   │   └── ...
│   │   └── ...
│   ├── dto/                    # Data Transfer Objects
│   │   ├── CreateOrderDTO.ts
│   │   ├── LoginDTO.ts
│   │   └── ...
│   └── mappers/                # Mappers để chuyển đổi giữa các layer
│       ├── UserMapper.ts
│       ├── ProductMapper.ts
│       └── ...
│
├── infrastructure/              # Tầng Infrastructure
│   ├── database/               # Cấu hình database
│   │   ├── mysql.ts
│   │   └── migrations/
│   ├── repositories/           # Implementation của repositories
│   │   ├── UserRepositoryImpl.ts
│   │   ├── ProductRepositoryImpl.ts
│   │   └── ...
│   ├── external-services/      # Implementation các service bên ngoài
│   │   ├── EmailServiceImpl.ts
│   │   ├── GHNServiceImpl.ts
│   │   └── ...
│   └── logging/               # Logging configuration
│       └── logger.ts
│
├── presentation/               # Tầng Presentation (API Layer)
│   ├── http/
│   │   ├── controllers/       # Controllers xử lý HTTP requests
│   │   │   ├── AuthController.ts
│   │   │   ├── ProductController.ts
│   │   │   ├── OrderController.ts
│   │   │   └── ...
│   │   ├── middlewares/       # HTTP middlewares
│   │   │   ├── authMiddleware.ts
│   │   │   ├── errorMiddleware.ts
│   │   │   └── ...
│   │   ├── routes/           # Route definitions
│   │   │   ├── authRoutes.ts
│   │   │   ├── productRoutes.ts
│   │   │   └── ...
│   │   └── validators/       # Request validators
│   │       ├── authValidators.ts
│   │       └── ...
│   └── swagger/              # API Documentation
│       └── swagger.config.ts
│
├── config/                     # Cấu hình ứng dụng
│   ├── env.ts                 # Environment variables
│   └── constants.ts           # Hằng số
│
├── app.ts                     # Khởi tạo Express app
└── server.ts                  # Entry point

```

## Nguyên tắc Clean Architecture

### 1. Dependency Rule (Quy tắc phụ thuộc)
- **Domain** không phụ thuộc vào bất kỳ layer nào
- **Application** chỉ phụ thuộc vào Domain
- **Infrastructure** phụ thuộc vào Domain và Application
- **Presentation** phụ thuộc vào Application

### 2. Các tầng và trách nhiệm

#### Domain Layer (Tầng Lõi)
- Chứa logic nghiệp vụ thuần túy
- Định nghĩa entities và value objects
- Định nghĩa interfaces cho repositories và services
- Không phụ thuộc vào framework, database, hay UI

#### Application Layer (Tầng Ứng dụng)
- Chứa các use cases (business workflows)
- Điều phối giữa domain và infrastructure
- Xử lý transaction và orchestration
- Định nghĩa DTOs cho input/output

#### Infrastructure Layer (Tầng Hạ tầng)
- Implement các interface từ domain layer
- Xử lý database, external APIs, file system
- Chứa các chi tiết kỹ thuật cụ thể

#### Presentation Layer (Tầng Giao diện)
- Controllers xử lý HTTP requests
- Validation đầu vào
- Format response
- Authentication & Authorization middleware

## Lợi ích của Clean Architecture

1. **Testability**: Dễ dàng test từng layer độc lập
2. **Maintainability**: Code dễ bảo trì và mở rộng
3. **Flexibility**: Dễ thay đổi implementation mà không ảnh hưởng business logic
4. **Separation of Concerns**: Mỗi layer có trách nhiệm rõ ràng
5. **Independence**: Không phụ thuộc vào framework cụ thể

## Migration Plan

### Phase 1: Tạo cấu trúc mới
- [ ] Tạo các thư mục theo cấu trúc Clean Architecture
- [ ] Di chuyển các file hiện tại vào vị trí phù hợp
- [ ] Tạo interfaces cho repositories và services

### Phase 2: Refactor Domain Layer
- [ ] Tạo các entity classes
- [ ] Tạo value objects
- [ ] Định nghĩa repository interfaces

### Phase 3: Refactor Application Layer
- [ ] Tạo use cases từ service methods hiện tại
- [ ] Tạo DTOs cho input/output
- [ ] Implement mappers

### Phase 4: Refactor Infrastructure
- [ ] Rename repositories thành *RepositoryImpl
- [ ] Implement interfaces từ domain
- [ ] Refactor external services

### Phase 5: Refactor Presentation
- [ ] Refactor controllers để sử dụng use cases
- [ ] Cập nhật routes
- [ ] Cải thiện validation

### Phase 6: Testing & Documentation
- [ ] Viết unit tests cho từng layer
- [ ] Cập nhật documentation
- [ ] Refactor và optimize
