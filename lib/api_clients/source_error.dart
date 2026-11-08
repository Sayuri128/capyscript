enum SourceErrorKind {
  loginRequired,
  rateLimited,
  notFound,
  regionBlocked,
  sourceDown,
  unsupported,
}

SourceErrorKind? sourceErrorKindFromName(String? name) {
  if (name == null) {
    return null;
  }
  for (final SourceErrorKind kind in SourceErrorKind.values) {
    if (kind.name == name) {
      return kind;
    }
  }
  return null;
}

class SourceError implements Exception {
  final SourceErrorKind kind;
  final String message;

  const SourceError(this.kind, [this.message = '']);

  @override
  String toString() {
    if (message.isEmpty) {
      return 'SourceError(${kind.name})';
    }
    return 'SourceError(${kind.name}): $message';
  }
}
