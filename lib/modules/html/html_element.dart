/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:html/dom.dart';

import 'package:capyscript/modules/abstract/external_object.dart';

class HtmlElement extends ExternalObject {
  final Element element;

  @override
  callFunction(String name, {List? ordinalArguments}) {
    switch (name) {
      case 'getElementsByClassName':
        return element
            .getElementsByClassName(ordinalArguments![0])
            .map((e) => HtmlElement(e))
            .toList();
      case 'getElementsByTagName':
        return element
            .getElementsByTagName(ordinalArguments![0])
            .map((e) => HtmlElement(e))
            .toList();
      case "text":
        return element.text;
    }
    throw Exception("Method $name not found");
  }

  @override
  getField(String name) {
    switch (name) {
      case "text":
        return element.text;
      case "outerHtml":
        return element.outerHtml;
      case "id":
        return element.id;
      case "classes":
        return element.classes;
      case "children":
        return element.children.map((e) => HtmlElement(e)).toList();
      case "attributes":
        return Map.from(element.attributes);
    }
    throw Exception("Field $name not found");
  }

  @override
  void setField(String name, value) {
    throw Exception("Field $name not found");
  }

  operator [](String key) => getField(key);

  const HtmlElement(this.element);
}
