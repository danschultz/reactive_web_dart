part of storage;

class LocalStorageController {
  final Storage _localStorage;

  LocalStorageController(this._localStorage);

  StreamSubscription save(String key, Stream data) {
    return data.listen((value) {
      print("persist data");
      _localStorage[key] = value;
    });
  }

  StreamSubscription saveAsJson(String key, Stream data) {
    return save(key, data.map((value) => JSON.encode(value)));
  }
}