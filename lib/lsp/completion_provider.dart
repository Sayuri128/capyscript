import 'package:capyscript/lsp/docs.dart';
import 'package:capyscript/lsp/module_functions.dart';
import 'package:capyscript/parser/parser.dart';

const _topLevelKeywords = ['import', 'function', 'class', 'interface'];

const _blockKeywords = [
  'if', 'else', 'for', 'return', 'break', 'continue', 'null', 'true', 'false',
  'new', 'this', 'super', 'var',
];

const _typeNames = [
  'int', 'float', 'string', 'bool', 'void', 'any', 'dynamic', 'List', 'Map',
];

const _stringMembers = [
  'length', 'isEmpty', 'isNotEmpty', 'contains', 'split',
  'substring', 'trim', 'trimLeft', 'trimRight',
  'toLowerCase', 'toUpperCase', 'replaceAll', 'replaceFirst',
];

const _arrayMembers = [
  'length', 'isEmpty', 'isNotEmpty', 'first', 'last',
  'push', 'pop', 'elementAt', 'removeAt',
];

const _mapMembers = [
  'containsKey', 'containsValue', 'remove', 'clear',
  'addAll', 'values', 'keys',
];

// LSP CompletionItemKind values
const _kindKeyword = 14;
const _kindFunction = 3;
const _kindVariable = 6;
const _kindField = 5;
const _kindClass = 7;

class CompletionProvider {
  List<Map<String, dynamic>> getCompletions(String content, int line, int character) {
    final lines = content.split('\n');
    final currentLine = line < lines.length ? lines[line] : '';
    final textBeforeCursor = currentLine.substring(0, character.clamp(0, currentLine.length));

    // After a dot: offer class-specific or generic member completions
    final dotMatch = RegExp(r'([a-zA-Z_]\w*)\.$').firstMatch(textBeforeCursor);
    if (dotMatch != null) {
      final varName = dotMatch.group(1)!;
      final classMap = _variableClassMap(content);
      if (classMap.containsKey(varName)) {
        final className = classMap[varName]!;
        final members = _classMembersFromContent(content)[className] ?? [];
        if (members.isNotEmpty) {
          return members.map((m) => _item(m, _kindField)).toList();
        }
      }
      return _memberCompletions();
    }

    // After `new ` or `new Fo`: offer class names
    if (RegExp(r'\bnew\s+\w*$').hasMatch(textBeforeCursor)) {
      return _classNamesFromContent(content)
          .map((c) => _item(c, _kindClass))
          .toList();
    }

    // After `: ` (type annotation): offer type names + class names
    if (RegExp(r':\s*\w*$').hasMatch(textBeforeCursor)) {
      final seen = <String>{};
      final items = <Map<String, dynamic>>[];
      for (final t in _typeNames) {
        if (seen.add(t)) items.add(_item(t, _kindKeyword));
      }
      for (final c in _classNamesFromContent(content)) {
        if (seen.add(c)) items.add(_item(c, _kindClass));
      }
      return items;
    }

    final textUpToCursor = [
      ...lines.take(line),
      textBeforeCursor,
    ].join('\n');

    final inBlock = _braceDepth(textUpToCursor) > 0;

    final seen = <String>{};
    final items = <Map<String, dynamic>>[];

    void add(Map<String, dynamic> item) {
      if (seen.add(item['label'] as String)) items.add(item);
    }

    if (inBlock) {
      for (final kw in _blockKeywords) {
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
      for (final className in _classNamesFromContent(content)) {
        add(_item(className, _kindClass));
      }
      for (final t in _typeNames) {
        add(_item(t, _kindKeyword));
      }
    } else {
      for (final kw in _topLevelKeywords) {
        add(_item(kw, _kindKeyword));
      }
      for (final className in _classNamesFromContent(content)) {
        add(_item(className, _kindClass));
      }
    }

    return items;
  }

  // Counts unclosed { braces in source, skipping strings and comments.
  int _braceDepth(String source) {
    int depth = 0;
    int i = 0;
    while (i < source.length) {
      final c = source[i];
      final next = i + 1 < source.length ? source[i + 1] : '';

      // Line comment
      if (c == '/' && next == '/') {
        i += 2;
        while (i < source.length && source[i] != '\n') i++;
        continue;
      }
      // Block comment
      if (c == '/' && next == '*') {
        i += 2;
        while (i < source.length - 1 && !(source[i] == '*' && source[i + 1] == '/')) i++;
        i += 2;
        continue;
      }
      // String literals (single, double, backtick) — no escape sequences in Capyscript
      if (c == '"' || c == "'" || c == '`') {
        final quote = c;
        i++;
        while (i < source.length && source[i] != quote) i++;
        i++;
        continue;
      }

      if (c == '{') depth++;
      if (c == '}') depth--;
      i++;
    }
    return depth;
  }

  List<Map<String, dynamic>> _memberCompletions() {
    final seen = <String>{};
    final items = <Map<String, dynamic>>[];
    for (final m in {..._stringMembers, ..._arrayMembers, ..._mapMembers}) {
      if (seen.add(m)) items.add(_item(m, _kindField));
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
    vars.removeAll(_blockKeywords);
    vars.removeAll(_topLevelKeywords);
    return vars.toList();
  }

  List<String> _classNamesFromContent(String content) {
    try {
      final p = Parser(source: content);
      p.parse();
      return p.parsedClasses.map((c) => c.className).toList();
    } catch (_) {
      return RegExp(r'\bclass\s+([a-zA-Z_]\w*)')
          .allMatches(content)
          .map((m) => m.group(1)!)
          .toList();
    }
  }

  // Maps variable name → class name for `varName = new ClassName(...)` patterns.
  Map<String, String> _variableClassMap(String content) {
    final map = <String, String>{};
    for (final m in RegExp(r'([a-zA-Z_]\w*)\s*=\s*new\s+([a-zA-Z_]\w*)').allMatches(content)) {
      map[m.group(1)!] = m.group(2)!;
    }
    // Also match `var name = new ClassName(...)` and `var name: Type = new ClassName(...)`
    for (final m in RegExp(r'\bvar\s+([a-zA-Z_]\w*)(?:\s*:\s*[a-zA-Z_]\w*)?\s*=\s*new\s+([a-zA-Z_]\w*)').allMatches(content)) {
      map[m.group(1)!] = m.group(2)!;
    }
    return map;
  }

  // Maps class name → list of method and field names.
  Map<String, List<String>> _classMembersFromContent(String content) {
    try {
      final p = Parser(source: content);
      p.parse();
      return {
        for (final c in p.parsedClasses)
          c.className: [
            ...c.methods.map((m) => m.functionName),
            ...c.fields.map((f) => f.name),
          ]
      };
    } catch (_) {
      return {};
    }
  }

  Map<String, dynamic> _item(String label, int kind) {
    final d = completionDocs[label];
    return {
      'label': label,
      'kind': kind,
      'insertText': label,
      if (d != null) 'detail': d.detail,
      if (d != null) 'documentation': {'kind': 'markdown', 'value': d.doc},
    };
  }
}
