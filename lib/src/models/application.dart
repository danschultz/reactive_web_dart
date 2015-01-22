part of models;

class Application {
  final Iterable<Task> tasks;
  final int nextId;
  final Visibility visibility;

  Application(this.tasks, this.nextId, this.visibility);
}

class ApplicationController extends ModelController<Application> {
  ApplicationController() : super(new Application([], 0, Visibility.ALL));

  void addTask(String description) {
    update((Application model) => new Application(
        cons(new Task(model.nextId, description, false), model.tasks),
        model.nextId + 1,
        model.visibility));
  }

  void toggleTask(Task task) {
    update((Application model) {
      PersistentVector tasks = persist(model.tasks);
      tasks = tasks.set(tasks.toList().indexOf(task), new Task(task.id, task.description, !task.isCompleted));
      return new Application(tasks, model.nextId, model.visibility);
    });
  }

  void removeTask(Task task) {
    update((Application model) => new Application(
        model.tasks.where((t) => t != task),
        model.nextId,
        model.visibility));
  }

  void changeVisibility(Visibility visibility) {
    update((Application model) => new Application(model.tasks, model.nextId, visibility));
  }
}
