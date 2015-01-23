# TodoMVC + FRP + Polymer.dart

This is an experiment building TodoMVC in Dart using Polymer and functional reactive programming (FRP).

## Architectural Overview

The application is structured using an MVC paradigm. Models are implemented as immutable classes, controllers are subclasses of `ModelController`s, and views are implemented as custom components in Polymer.dart.

### Model

Models are implemented as immutable classes. [Persistent data structures](https://pub.dartlang.org/packages/vacuum_persistent) are used whenever modeling collections of data for their performance and immutability features. By keeping the data model immutable, we're assured that it can't be changed in ways that cause unwanted side-effects across the app. It also makes features like undo/redo trivial.

### Controllers

`ModelController`s are responsible for driving the logic for model updates, and are inspired by approaches I've seen in [Elm](https://github.com/evancz/elm-todomvc).

Changes to the model are initiated from external inputs flowing into the app, such as mouse clicks, key presses, network responses or system events. The app filters these events into `Action`s that are passed to `ModelController.update()` to update the model.

The result of these changes are observed by listening to the `ModelController.model` stream, and is used to generate the output from inputs flowing into the app. For example, view's might observe this stream to update the UI, or a persistence layer might observe this stream to save data to a local or remote store.

**Example:** A `ModelController` that manages a `ClickCounter` model.

```dart
class ClickCounter {
  final int clickCount;
  ClickCounter(this.clickCount);
}

var controller = new ModelController(new ClickCounter(0));

var button = new ButtonElement();
button.onClick.forEach((_) {
  controller.update((counter) => new ClickCounter(counter.clickCount + 1));
});

controller.model.listen((model) => print(model.clickCount));

// [click button] .. prints 1
// [click button] .. prints 2
```

`ModelController`s are intended to be sub-classed and should contain methods for performing model changes. For example, we could create a sub-class `ClickCounterController` that contains a method to update the click count.

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

Take a look at [`ApplicationController`](https://github.com/danschultz/reactive_web_polymer/blob/master/lib/src/models/application.dart) to see how this works in the app.

### Views

Views are implemented as custom Polymer components and are responsible for listening to the controller's `model` stream and updating itself. This process is made easier by Polymer.dart's ability to bind directly to a stream from within a template.

**Example:** Binding to a controller's `model` from a template.

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
The app uses an immutable data structure to model the list of tasks. Polymer's `<template repeat>` is efficient at insertions and removals, but will completely recreate nodes for tasks that have been modified. This is problematic when building views that contain animations, and makes it difficult to animate between a tasks' completed and active states.
