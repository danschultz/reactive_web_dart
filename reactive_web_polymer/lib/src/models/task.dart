part of models;

class Task {
  final int id;
  final String description;
  final bool isCompleted;

  Task(this.id, this.description, this.isCompleted);

  factory Task.fromJson(Map json) {
    return new Task(json["id"], json["description"], json["isCompleted"]);
  }

  Map toJson() => {
      "id": id,
      "description": description,
      "isCompleted": isCompleted
  };
}