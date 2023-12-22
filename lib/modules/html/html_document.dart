/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */
import 'package:capyscript/modules/html/html_element.dart';
import 'package:html/dom.dart';

import 'package:capyscript/modules/abstract/external_object.dart';

class HtmlDocument extends ExternalObject {
  final Document _document;

  const HtmlDocument({
    required Document document,
  }) : _document = document;

  @override
  getField(String name) {
    switch (name) {
      case 'text':
        return _document.text;
      case 'outerHtml':
        return _document.outerHtml;
    }
    throw Exception("Field $name not found");
  }

  @override
  void setField(String name, value) {
    throw Exception("Field $name not found");
  }

  @override
  dynamic callFunction(String name, {List? ordinalArguments}) {
    switch (name) {
      case 'getElementById':
        final element = _document.getElementById(ordinalArguments![0]);
        return element != null ? HtmlElement(element) : null;
      case 'getElementsByClassName':
        return _document
            .getElementsByClassName(ordinalArguments![0])
            .map((e) => HtmlElement(e))
            .toList();
      case 'getElementsByTagName':
        return _document
            .getElementsByTagName(ordinalArguments![0])
            .map((e) => HtmlElement(e))
            .toList();
      case 'querySelectorAll':
        return _document
            .querySelectorAll(ordinalArguments![0])
            .map((e) => HtmlElement(e))
            .toList();
      case "querySelector":
        final element = _document.querySelector(ordinalArguments![0]);
        return element != null ? HtmlElement(element) : null;
      case "text":
        return _document.text;
    }
    throw Exception("Method $name not found");
  }

  operator[](String key) => getField(key);
}
