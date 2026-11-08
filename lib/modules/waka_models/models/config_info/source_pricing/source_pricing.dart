import 'package:json_annotation/json_annotation.dart';

class SourcePricing {
  static const String free = 'free';
  static const String partial = 'partial';
  static const String paid = 'paid';

  static const List<String> known = <String>[free, partial, paid];

  static String parse(Object? json) {
    if (json is! String) {
      return free;
    }
    final String value = json.trim().toLowerCase();
    if (known.contains(value)) {
      return value;
    }
    return free;
  }
}

class SourcePricingJsonConverter extends JsonConverter<String, Object?> {
  const SourcePricingJsonConverter();

  @override
  String fromJson(Object? json) => SourcePricing.parse(json);

  @override
  Object? toJson(String object) => object;
}
