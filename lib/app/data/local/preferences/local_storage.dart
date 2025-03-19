
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taski_todo/app/data/local/preferences/i_local_storage.dart';

class LocalStorage implements ILocalStorage {
  final preferences = SharedPreferencesAsync();

  @override
  Future<String?> getData(String key) async{
   return  await preferences.getString(key);
  }
  @override
  Future<void> setData(String key , String value)async{
     await preferences.setString(key, value);
  }  

  @override
  Future<void> remove(String key) async{
      await preferences.remove(key);
  }



}