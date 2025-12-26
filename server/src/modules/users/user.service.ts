import userRepository, { UserRecord } from '../../infrastructure/repositories/userRepositoryImpl';

class UserService {
  list(): Promise<UserRecord[]> {
    return userRepository.list();
  }
}

const userService = new UserService();

export default userService;

