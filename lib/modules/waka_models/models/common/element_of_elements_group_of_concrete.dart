/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/modules/abstract/external_object.dart';

abstract class ElementOfElementsGroupOfConcrete extends ExternalObject {
  final String uid;
  final String title;
  final Map<String, dynamic> data;

  const ElementOfElementsGroupOfConcrete(
      {required this.uid, required this.title, required this.data});
}
