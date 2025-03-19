
import 'package:taski_todo/app/core/exceptions/user_exception.dart';
import 'package:taski_todo/app/data/local/preferences/i_local_storage.dart';
import 'package:taski_todo/app/domain/model/user.dart';
import 'package:taski_todo/app/domain/repository/I_user_repository.dart';

class UserRepository  implements IUserRepository{
   final ILocalStorage _localStorage; 
   static const _key ="user";

   UserRepository({required ILocalStorage localStorage}): _localStorage =localStorage ; 
 
  @override
  Future<(UserException?,User?)> getData()  async {
      final data =  await _localStorage.getData(_key);
      if (data == null) {
         return (UserNotFound(),null);
      }
      return(null,User.fromJson(data));
  }

  @override
  Future<void> remove(String key) async {
     await _localStorage.remove(key);
  }

  @override
  Future<void> setData(User user) async {
     await  _localStorage.setData(_key, user.toJson());
  }
  
}