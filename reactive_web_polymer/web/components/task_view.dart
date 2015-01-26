import 'package:polymer/polymer.dart';
import 'package:reactive_web_core/models.dart';
import 'dart:html';

/**
 * A Polymer task-view element.
 */
@CustomTag('task-view')

class TaskView extends PolymerElement {
  @published
  Task task;

  Element get _descriptionElement => $["description"];
  ButtonElement get _completeButton => $["complete-button"];
  ButtonElement get _deleteButton => $["delete-button"];

  /// Constructor used to create instance of TaskView.
  TaskView.created() : super.created() {
    print("create task view");
  }

  void attached() {
    super.attached();

    _descriptionElement.classes.toggle("is-completed", task.isCompleted);
    _completeButton.onClick.forEach((_) => dispatchEvent(new CustomEvent("complete", detail: task)));
    _deleteButton.onClick.forEach((_) => dispatchEvent(new CustomEvent("delete", detail: task)));
  }
}
