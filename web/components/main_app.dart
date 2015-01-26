// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:reactive_web_polymer/models.dart';
import 'package:reactive_web_polymer/storage.dart';

/// A Polymer `<main-app>` element.
@CustomTag('main-app')
class MainApp extends PolymerElement {
  final controller = new ApplicationController();
  final storage = new LocalStorageController(window.localStorage);

  InputElement get _taskInput => $["task-input"];

  Stream<Application> get model => controller.model;

  /// Constructor used to create instance of MainApp.
  MainApp.created() : super.created() {
    storage.saveAsJson("todomvc", controller.model);

    controller.model.listen((model) {
      print("model changed: ${model.toJson()}");
    });

    _taskInput.onKeyPress
        .where((event) => event.keyCode == 13)
        .map((_) => _taskInput.value)
        .forEach((value) {
          controller.addTask(value);
          _taskInput.value = "";
        });
  }

  filter(Visibility visibility) {
    return (Iterable<Task> tasks) {
      return tasks.where((task) {
        if (visibility == Visibility.ACTIVE) {
          return !task.isCompleted;
        } else if (visibility == Visibility.COMPLETED) {
          return task.isCompleted;
        } else {
          return true;
        }
      });
    };
  }

  void toggleTask(event, Task detail, target) {
    controller.toggleTask(detail);
  }

  void deleteTask(event, Task task, target) {
    controller.removeTask(task);
  }

  void showAll(event, detail, target) {
    controller.changeVisibility(Visibility.ALL);
  }

  void showActive(event, detail, target) {
    controller.changeVisibility(Visibility.ACTIVE);
  }

  void showCompleted(event, detail, target) {
    controller.changeVisibility(Visibility.COMPLETED);
  }
}
