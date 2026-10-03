/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/modules/abstract/external_object.dart';
import 'package:json_annotation/json_annotation.dart';
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
  @JsonKey(defaultValue: <String>[])
  final List<String> authors;
  @JsonKey(defaultValue: <String>[])
  final List<String> artists;
  final int? year;
  final num? rating;
  final String? url;

  const ConcreteView(
      {required this.uid,
      required this.groups,
      required this.title,
      required this.description,
      required this.cover,
      required this.alternativeTitles,
      required this.tags,
      this.authors = const <String>[],
      this.artists = const <String>[],
      this.year,
      this.rating,
      this.url});

  dynamic getMetadataField(String name) {
    switch (name) {
      case 'authors':
        return authors;
      case 'artists':
        return artists;
      case 'year':
        return year;
      case 'rating':
        return rating;
      case 'url':
        return url;
    }
    return null;
  }
}
