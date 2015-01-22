# TodoMVC + FRP + Polymer

An experiment building TodoMVC using Polymer and FRP principles.

## Architecture Overview

The `ModelController` is responsible for driving the logic for model updates. It defines a property `model` that returns a stream that contains the latest model. The controller also defines a method `update()` which takes an `Action` function that's responsible for updating the model. The `Action` is passed the current model and is expected to return a new model with the action's changes.


**Example:** A `ModelController` that updates the manages the `ClickCounter` model.

    class ClickCounter {
      final int clickCount;

      ClickCounter(this.clickCount);
    }

    var button = new ButtonElement();

    var controller = new ModelController(new ClickCounter(0));
    controller.model.listen((model) => print(model.clickCount));

    button.onClick.forEach((_) {
      controller.update((counter) => new ClickCounter(counter.clickCount + 1));
    });

    // [click button] .. prints 1
    // [click button] .. prints 2


The `ModelController` is intended to be sub-classed and to contain methods for performing model changes. For example, we could create a sub-class `ClickCounterController` to make it easier to update the click count.

**Example:** The `ClickCounterController`.

    class ClickCounterController extends ModelController<ClickCounter> {
      ClickCounterController() : super(new ClickCounter(0));

      void increaseCount() {
        update((model) => new ClickCounter(model.clickCount + 1));
      }
    }

    var controller = new ClickCounterController();
    controller.model.listen((model) => print(model.clickCount));

    button.onClick.forEach((_) => controller.increaseCount());

The view is responsible for listening to the controller's `model` stream and updating itself. Template bindings in Polymer.dart let you bind directly to a stream.

    <polymer-element name="main-app">
      <template>
        <button id="button">Click me</button>
        <template id="test" repeat="{{ model }}">
          <div>click count: {{value}}</div>
        </template>
      </template>

      <script type="application/dart">
        import 'dart:async';
        import 'dart:html';
        import 'package:polymer/polymer.dart';

        @CustomTag('main-app')
        class MainApp extends PolymerElement {
          var controller = new ClickCounterController();

          Stream<ClickCounter> get model => controller.model;

          MainApp.created() : super.created() {
            $["button"].onClick.forEach((_) => controller.increaseCount());
          }

        }
      </script>
    </polymer-element>

## Issues with Polymer
The app uses an immutable data structure to model the list of tasks. Polymer's `<template repeat>` is effecient at insertions and removals, but will completely recreate nodes for tasks that have been modified. This is problematic when building views that contain animations, and makes it extremely difficult to animate between a tasks' completed and active states.
