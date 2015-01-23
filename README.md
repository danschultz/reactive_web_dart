# TodoMVC + FRP + Polymer.dart

This is an experiment to build a TodoMVC app using Polymer and functional reactive programming (FRP).

## Architectural Overview

The application is structured using an MVC paradigm. The models are implemented as simple immutable classes, controllers are instances of `ModelController`, and views are implemented with Polymer.dart.

### Controllers

The `ModelController` is responsible for driving the logic for model updates, and is inspired by approaches seen in Elm. The controller is initialized with an empty model and is updated by passing an `Action` function to `ModelController.update()`. The `Action` function is passed a reference to the current model, and returns a new version with the action's changes. Model changes can be observed by listening to `ModelController.model` which returns a stream.

**Example:** A `ModelController` that manages the `ClickCounter` model.

```dart
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
```


`ModelController`s are intended to be sub-classed and should contain methods for performing model changes. For example, we could create a sub-class `ClickCounterController` that contain methods to update the click count.

**Example:** The `ClickCounterController`.

```dart
class ClickCounterController extends ModelController<ClickCounter> {
  ClickCounterController() : super(new ClickCounter(0));

  void increaseCount() {
    update((model) => new ClickCounter(model.clickCount + 1));
  }
}

var controller = new ClickCounterController();
controller.model.listen((model) => print(model.clickCount));

button.onClick.forEach((_) => controller.increaseCount());
```

Take a look at the app's [`ApplicationController`](https://github.com/danschultz/reactive_web_polymer/blob/master/lib/src/models/application.dart) to see how this works in practice.

### Views

Views are implemented as custom Polymer components and are responsible for listening to the controller's `model` stream and updating itself. This process is made easier by Polymer.dart's ability to bind directly to a stream in a template.

**Example:** Binding to the stream `model` from a template.

```html
<polymer-element name="main-app">
  <template>
    <button id="button">Click me</button>
    <template id="test" repeat="{{ model }}">
      <div>click count: {{ value }}</div>
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
```

## Issues with Polymer
The app uses an immutable data structure to model the list of tasks. Polymer's `<template repeat>` is effecient at insertions and removals, but will completely recreate nodes for tasks that have been modified. This is problematic when building views that contain animations, and makes it extremely difficult to animate between a tasks' completed and active states.
