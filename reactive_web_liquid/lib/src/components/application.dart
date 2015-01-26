part of components;

class ApplicationView extends Component<DivElement> {
  final _controller = new ApplicationController();

  Application _model;

  ApplicationView() {
    _controller.model.listen((model) {
      _model = model;
      invalidate();
    });

    _controller.model
        .map((model) => JSON.encode(model))
        .listen((json) => window.localStorage["todomvc"] = json);
  }

  void create() {
    super.create();

    element.onKeyPress
        .matches(".task-input")
        .where((KeyboardEvent event) => event.keyCode == 13)
        .map((event) => event.target.value)
        .where((value) => value.isNotEmpty)
        .forEach((value) => _controller.addTask(value));

    element.on["complete"].forEach((CustomEvent event) => _controller.toggleTask(event.detail));
    element.on["delete"].forEach((CustomEvent event) => _controller.removeTask(event.detail));
  }

  _renderTaskInput() =>
      input(attributes: {"class": "task-input", "placeholder": "Add task"});

  _renderTasks(Iterable<Task> tasks) =>
      ul()(tasks.map((task) => li()(taskView(classes: ["task-view"], task: task))));

  _renderTask(Task task) => li()(task.description);

  build() => root()([_renderTaskInput(), _renderTasks(_model.tasks)]);
}