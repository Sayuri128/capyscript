class CapyScriptError implements Exception {
  final dynamic value;

  CapyScriptError(this.value);

  @override
  String toString() => value.toString();
}
