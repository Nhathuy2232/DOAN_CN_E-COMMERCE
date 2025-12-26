/**
 * Use Case: Đăng nhập người dùng
 * Xử lý logic nghiệp vụ cho việc đăng nhập
 */

import { IUserRepository } from '../../domain/repositories/IUserRepository';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';

export interface LoginDTO {
  email: string;
  password: string;
}

export interface LoginResponse {
  accessToken: string;
  user: {
    id: number;
    fullName: string;
    email: string;
    role: string;
  };
}

export class LoginUseCase {
  constructor(
    private userRepository: IUserRepository,
    private jwtSecret: string,
    private jwtExpiresIn: string | number
  ) {}

  async execute(dto: LoginDTO): Promise<LoginResponse> {
    // Tìm người dùng theo email
    const user = await this.userRepository.findByEmail(dto.email);
    
    if (!user) {
      throw new Error('Thông tin đăng nhập không chính xác');
    }

    // Kiểm tra mật khẩu
    const isPasswordValid = await bcrypt.compare(dto.password, user.passwordHash);
    
    if (!isPasswordValid) {
      throw new Error('Thông tin đăng nhập không chính xác');
    }

    // Tạo JWT token
    const payload = {
      id: user.id,
      fullName: user.fullName,
      email: user.email,
      role: user.role,
    };

    const options: any = {};
    if (this.jwtExpiresIn) {
      options.expiresIn = this.jwtExpiresIn;
    }

    const accessToken = jwt.sign(payload, this.jwtSecret, options);

    return {
      accessToken,
      user: payload,
    };
  }
}
