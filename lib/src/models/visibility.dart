part of models;

class Visibility {
  static const ALL = const Visibility(0);
  static const ACTIVE = const Visibility(1);
  static const COMPLETED = const Visibility(2);

  final int value;

  const Visibility(this.value);
}