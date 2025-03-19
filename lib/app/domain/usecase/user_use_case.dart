import 'package:taski_todo/app/core/exceptions/user_exception.dart';
import 'package:taski_todo/app/domain/model/user.dart';
import 'package:taski_todo/app/domain/repository/I_user_repository.dart';

class UserUseCase {
  final IUserRepository _userRepository;

  UserUseCase({required IUserRepository userRepository})
      : _userRepository = userRepository;

  Future<(UserException?, User?)> getData() =>
      _userRepository.getData();
  Future<void> setData(User user) => _userRepository.setData(user);
  Future<void> remove(String key) => _userRepository.remove(key);
}
