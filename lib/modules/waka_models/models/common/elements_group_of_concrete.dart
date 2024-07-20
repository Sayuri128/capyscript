/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/modules/abstract/external_object.dart';
import 'package:capyscript/modules/waka_models/models/common/element_of_elements_group_of_concrete.dart';

abstract class ElementsGroupOfConcrete<
    T extends ElementOfElementsGroupOfConcrete> extends ExternalObject {
  final String title;
  final List<T> elements;

  const ElementsGroupOfConcrete({
    required this.elements,
    required this.title,
  });

  @override
  String toString() {
    return 'ElementsGroupOfConcrete{title: $title, elements: $elements}';
  }

  @override
  callFunction(String name, {List? ordinalArguments}) {}

  @override
  getField(String name) {
    if (name == 'title') {
      return title;
    }
    if (name == 'elements') {
      return elements;
    }
  }

  @override
  void setField(String name, value) {
    if (name == 'elements') {
      elements
        ..clear()
        ..addAll(value);
    }
  }
}
