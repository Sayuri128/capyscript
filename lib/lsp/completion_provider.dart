import 'package:capyscript/lsp/module_functions.dart';
import 'package:capyscript/parser/parser.dart';

const _keywords = [
  'function', 'import', 'if', 'else', 'for', 'return',
  'break', 'continue', 'null', 'true', 'false',
];

// LSP CompletionItemKind values
const _kindKeyword = 14;
const _kindFunction = 3;
const _kindVariable = 6;

class CompletionProvider {
  List<Map<String, dynamic>> getCompletions(String content) {
    final seen = <String>{};
    final items = <Map<String, dynamic>>[];

    void add(Map<String, dynamic> item) {
      if (seen.add(item['label'] as String)) items.add(item);
    }

    for (final kw in _keywords) {
      add(_item(kw, _kindKeyword));
    }

    for (final name in _functionsFromContent(content)) {
      add(_item(name, _kindFunction));
    }

    for (final module in _importsFromContent(content)) {
      for (final fn in moduleFunctions[module] ?? const <String>[]) {
        add(_item(fn, _kindFunction));
      }
    }

    for (final variable in _variablesFromContent(content)) {
      add(_item(variable, _kindVariable));
    }

    return items;
  }

  List<String> _functionsFromContent(String content) {
    try {
      final tree = Parser(source: content).parse();
      return tree.functions
          .map((f) => f.functionName)
          .where((n) => n.isNotEmpty)
          .toList();
    } catch (_) {
      // File is incomplete while the user is typing — fall back to regex
      return RegExp(r'\bfunction\s+([a-zA-Z_]\w*)')
          .allMatches(content)
          .map((m) => m.group(1)!)
          .toList();
    }
  }

  List<String> _importsFromContent(String content) {
    return RegExp(r'''import\s+["'`]([^"'`]+)["'`]''')
        .allMatches(content)
        .map((m) => m.group(1)!)
        .toList();
  }

  List<String> _variablesFromContent(String content) {
    final vars = RegExp(r'\b([a-zA-Z_]\w*)\s*=(?!=)')
        .allMatches(content)
        .map((m) => m.group(1)!)
        .toSet();
    vars.removeAll(_keywords);
    return vars.toList();
  }

  Map<String, dynamic> _item(String label, int kind) => {
    'label': label,
    'kind': kind,
    'insertText': label,
  };
}
