library index;

import 'dart:html';
import 'package:liquid/liquid.dart';
import 'package:reactive_web_liquid/components.dart';

void main() {
  injectComponent(new ApplicationView(), document.body);
}