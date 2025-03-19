abstract interface class ILocalStorage {
  Future<String?> getData(String key);
  Future<void> setData(String key , String value);

  Future<void> remove(String key);

}