part of model_controller;

class ModelController<T> {
  StreamController _updates = new StreamController.broadcast();

  Stream<T> _model;
  Stream<T> get model => _model;

  ModelController(T initial) {
    // Updates the model using a "fold" behavior. Whenever an update action is observed, `Scan`
    // will use an accumulator function that is passed a copy of the previous model and the
    // action to perform on it. The action will be invoked with the previous model and returns
    // a version of the model with the action's changes. The updated copy of the model will then
    // be pushed out to any observers of the `model` stream.
    _model = _updates.stream.transform(new Scan(initial, (T model, Action<T> action) => action(model)));
  }

  void update(Action<T> action) {
    _updates.add(action);
  }
}