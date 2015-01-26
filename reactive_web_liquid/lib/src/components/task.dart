part of components;

final taskView = componentFactory(TaskView);

class TaskView extends Component<DivElement> {
  @property
  Task task;

  void create() {
    super.create();

    element.onClick.matches(".task-view--complete-button")
        .map((event) => new CustomEvent("complete", detail: task))
        .forEach((event) => element.dispatchEvent(event));

    element.onClick.matches(".task-view--delete-button")
        .map((event) => new CustomEvent("delete", detail: task))
        .forEach((event) => element.dispatchEvent(event));
  }

  build() =>
      root(classes: [task.isCompleted ? "completed" : ""])([
          div(classes: ["task-view--text"])(task.description),
          button(classes: ["task-view--complete-button"])("Complete"),
          button(classes: ["task-view--delete-button"])("Delete")]);
}