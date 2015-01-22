// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:reactive_web_polymer/models.dart';

/// A Polymer `<main-app>` element.
@CustomTag('main-app')
class MainApp extends PolymerElement {
  final controller = new ApplicationController();

  InputElement get _taskInput => $["task-input"];

  Stream<Application> get model => controller.model;

  /// Constructor used to create instance of MainApp.
  MainApp.created() : super.created() {
    _taskInput.onKeyPress
        .where((event) => event.keyCode == 13)
        .map((_) => _taskInput.value)
        .forEach((value) {
          controller.addTask(value);
          _taskInput.value = "";
        });
  }

  void toggleTask(event, Task detail, target) {
    controller.toggleTask(detail);
  }

  void deleteTask(event, Task task, target) {
    controller.removeTask(task);
  }
}
