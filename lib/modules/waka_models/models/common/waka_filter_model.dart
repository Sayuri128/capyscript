/*
 * Copyright (c) 2024 armatura24
 * All right reserved
 */

import 'package:capyscript/modules/abstract/external_object.dart';

abstract class WakaFilterModel extends ExternalObject{
  final String title;

  const WakaFilterModel({
    required this.title,
  });
}