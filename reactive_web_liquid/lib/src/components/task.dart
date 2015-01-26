part of components;

final taskView = componentFactory(TaskView);

class TaskView extends Component<DivElement> {
  @property
  Task task;

  void create() {
    super.create();

    element.onClick.matches(".complete-button")
        .map((event) => new CustomEvent("complete", detail: task))
        .forEach((event) => element.dispatchEvent(event));

    element.onClick.matches(".delete-button")
        .map((event) => new CustomEvent("delete", detail: task))
        .forEach((event) => element.dispatchEvent(event));
  }

  build() =>
      root(classes: [task.isCompleted ? "completed" : ""])([
          text(task.description),
          button(classes: ["complete-button"])("Complete"),
          button(classes: ["delete-button"])("Delete")]);
}