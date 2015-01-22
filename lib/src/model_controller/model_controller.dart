part of model_controller;

class ModelController<T> {
  StreamController _updates = new StreamController.broadcast();

  Stream<T> _model;
  Stream<T> get model => _model;

  ModelController(T initial) {
    _model = _updates.stream.transform(new Scan(initial, (T model, Action<T> action) => action(model)));
  }

  void update(Action<T> action) {
    _updates.add(action);
  }
}