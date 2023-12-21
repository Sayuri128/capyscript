/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

abstract class ExternalObject {
  dynamic getField(String name);

  void setField(String name, dynamic value);

  dynamic callFunction(String name, {List<dynamic>? ordinalArguments});

  const ExternalObject();
}
