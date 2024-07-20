/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/modules/abstract/external_object.dart';
import 'package:capyscript/modules/waka_models/models/common/element_of_elements_group_of_concrete.dart';
import 'package:capyscript/modules/waka_models/models/common/elements_group_of_concrete.dart';

abstract class ConcreteView<
        C extends ElementsGroupOfConcrete<ElementOfElementsGroupOfConcrete>>
    extends ExternalObject {
  final String uid;
  final List<C> groups;
  final String title;
  final String description;
  final String cover;
  final List<String> alternativeTitles;
  final List<String> tags;

  const ConcreteView(
      {required this.uid,
      required this.groups,
      required this.title,
      required this.description,
      required this.cover,
      required this.alternativeTitles,
      required this.tags});
}
