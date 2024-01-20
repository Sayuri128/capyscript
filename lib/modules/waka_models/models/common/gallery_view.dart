/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/modules/abstract/external_object.dart';

abstract class GalleryView extends ExternalObject {
  final String uid;
  final Map<String, dynamic> data;

  const GalleryView({
    required this.uid,
    required this.data,
  });
}
