/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/modules/waka_models/models/common/element_of_elements_group_of_concrete.dart';

abstract class ElementsGroupOfConcrete<
    T extends ElementOfElementsGroupOfConcrete> {
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
}
