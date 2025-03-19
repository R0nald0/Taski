import 'package:taski_todo/app/core/exceptions/user_exception.dart';
import 'package:taski_todo/app/domain/model/user.dart';

abstract interface class IUserRepository {
  Future<( UserException?,User?)> getData();
  Future<void> setData(User user);
  Future<void> remove(String key);

}