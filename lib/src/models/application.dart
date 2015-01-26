part of models;

class Application {
  final Iterable<Task> tasks;
  final int nextId;
  final Visibility visibility;

  Iterable<Task> get active => tasks.where((task) => !task.isCompleted);
  Iterable<Task> get completed => tasks.where((task) => task.isCompleted);

  Application(this.tasks, this.nextId, this.visibility);

  factory Application.fromJson(Map json) {
    return new Application(
        json["tasks"].map((json) => new Task.fromJson(json)).toList(),
        json["nextId"],
        new Visibility(json["visibility"]));
  }

  Map toJson() => {
      "tasks": tasks.toList(),
      "nextId": nextId,
      "visibility": visibility
  };
}

class ApplicationController extends ModelController<Application> {
  ApplicationController() : super(initialModel());

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

Application initialModel() => window.localStorage.containsKey("todomvc")
    ? new Application.fromJson(JSON.decode(window.localStorage["todomvc"]))
    : new Application([], 0, Visibility.ALL);
