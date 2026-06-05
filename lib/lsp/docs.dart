const Map<String, ({String detail, String doc})> completionDocs = {
  // Class / OOP keywords
  'class': (
    detail: 'class Name { }',
    doc: 'Declare a class.\n\n**Example:**\n```\nclass Point {\n  x: int;\n  y: int;\n  function constructor(x: int, y: int) {\n    this.x = x;\n    this.y = y;\n  }\n}\n```',
  ),
  'interface': (
    detail: 'interface Name { function method(); }',
    doc: 'Declare an interface that classes must implement.\n\n**Example:**\n```\ninterface Drawable {\n  function draw();\n}\n```',
  ),
  'extends': (
    detail: 'class Child extends Parent { }',
    doc: 'Inherit from a parent class. Call `super()` in the constructor to initialize the parent.',
  ),
  'implements': (
    detail: 'class Foo implements IBar { }',
    doc: 'Declare that a class implements one or more interfaces. A runtime error is thrown if any required method is missing.',
  ),
  'new': (
    detail: 'new ClassName(args)',
    doc: 'Instantiate a class.\n\n**Example:**\n```\nvar p = new Point(3, 4);\n```',
  ),
  'this': (
    detail: 'this.field',
    doc: 'Reference the current class instance. Use `this.field` to access or set instance fields inside methods.',
  ),
  'super': (
    detail: 'super(args) / super.method(args)',
    doc: 'Call the parent class constructor or a parent method.\n\n**Example:**\n```\nfunction constructor(x) {\n  super(x);\n}\n```',
  ),
  // `var` keyword
  'var': (
    detail: 'var name: Type = value',
    doc: 'Declare a typed local variable. The type annotation is optional — omitting it allows any value.\n\n**Example:**\n```\nvar x: int = 5;\nvar name: string = "hello";\nvar items: List<string> = [];\n```',
  ),
  // Built-in type names
  'int': (detail: 'int', doc: 'Integer type. Accepts whole numbers only.\n\n**Example:** `var count: int = 0;`'),
  'float': (detail: 'float', doc: 'Floating-point number type.\n\n**Example:** `var ratio: float = 3.14;`'),
  'string': (detail: 'string', doc: 'String type.\n\n**Example:** `var name: string = "hello";`'),
  'bool': (detail: 'bool', doc: 'Boolean type. Values: `true` or `false`.\n\n**Example:** `var flag: bool = true;`'),
  'void': (detail: 'void', doc: 'Return type for functions that return no meaningful value.'),
  'any': (detail: 'any', doc: 'Dynamic type — disables type checking. Any value is accepted.'),
  'dynamic': (detail: 'dynamic', doc: 'Dynamic type — disables type checking. Same as `any`.'),
  'List': (detail: 'List<T>', doc: 'List (array) type.\n\n**Example:** `var items: List<string> = [];`'),
  'Map': (detail: 'Map<K, V>', doc: 'Map (dictionary) type.\n\n**Example:** `var data: Map<string, int> = {};`'),

  // Keywords
  'import': (
    detail: 'import "module"',
    doc: 'Import a built-in module.\n\n**Example:**\n```\nimport "http"\nimport "json"\n```',
  ),
  'function': (
    detail: 'function name(params) { }',
    doc: 'Declare a function.\n\n**Example:**\n```\nfunction greet(name) {\n  return "Hello " + name;\n}\n```',
  ),
  'if': (
    detail: 'if (condition) { }',
    doc: 'Execute a block if the condition is true.\n\n**Example:**\n```\nif (x == 1) {\n  print("one");\n} else {\n  print("other");\n}\n```',
  ),
  'else': (
    detail: 'else { }',
    doc: 'Alternative branch of an `if` statement.',
  ),
  'for': (
    detail: 'for (init; condition; increment) { }',
    doc: 'Loop statement.\n\n**Example:**\n```\nfor (i = 0; i < 10; i++) {\n  print(i);\n}\n```',
  ),
  'return': (
    detail: 'return value',
    doc: 'Return a value from the current function.',
  ),
  'break': (
    detail: 'break',
    doc: 'Exit the current `for` loop immediately.',
  ),
  'continue': (
    detail: 'continue',
    doc: 'Skip the rest of the current loop iteration.\n\n**Note:** Put the increment before `continue` — it does not run automatically on `continue`.',
  ),
  'null': (detail: 'null', doc: 'The null value.'),
  'true': (detail: 'true', doc: 'Boolean true.'),
  'false': (detail: 'false', doc: 'Boolean false.'),

  // http module
  'httpGet': (
    detail: 'httpGet(url)',
    doc: 'Make an HTTP GET request and return the response body as a string.',
  ),
  'httpPost': (
    detail: 'httpPost(url, body)',
    doc: 'Make an HTTP POST request with the given body and return the response body as a string.',
  ),
  'useHeaders': (
    detail: 'useHeaders(headers)',
    doc: 'Set default headers (a map) to be sent with every subsequent HTTP request.',
  ),
  'getHeaders': (
    detail: 'getHeaders()',
    doc: 'Return the current default headers map.',
  ),
  'registerInterceptorController': (
    detail: 'registerInterceptorController(controller)',
    doc: 'Register a web-browser interceptor controller for in-app browser requests.',
  ),
  'executeJsScript': (
    detail: 'executeJsScript(script)',
    doc: 'Execute a JavaScript string inside the in-app browser and return the result.',
  ),

  // io module
  'print': (
    detail: 'print(value)',
    doc: 'Print a value to the console.',
  ),

  // json module
  'jsonEncode': (
    detail: 'jsonEncode(value)',
    doc: 'Encode a value (map, list, string, number, bool, null) to a JSON string.',
  ),
  'jsonDecode': (
    detail: 'jsonDecode(jsonString)',
    doc: 'Decode a JSON string into a Capyscript value (map, list, string, number, bool, or null).',
  ),

  // converter module
  'parseInt': (
    detail: 'parseInt(value)',
    doc: 'Parse a value as an integer.',
  ),
  'parseDouble': (
    detail: 'parseDouble(value)',
    doc: 'Parse a value as a double.',
  ),
  'parseString': (
    detail: 'parseString(value)',
    doc: 'Convert a value to its string representation.',
  ),

  // date module
  'createDateFormatter': (
    detail: 'createDateFormatter(format)',
    doc: 'Create a date formatter with the given format pattern.',
  ),
  'parseDate': (
    detail: 'parseDate(string)',
    doc: 'Parse a date string and return a date object.',
  ),

  // html module
  'createHTMLParser': (
    detail: 'createHTMLParser(html)',
    doc: 'Create an HTML parser from an HTML string. Returns an object for DOM traversal.',
  ),

  // manga_models module
  'buildGallery': (
    detail: 'buildGallery(params)',
    doc: 'Build a gallery (list) model for manga.',
  ),
  'buildConcrete': (
    detail: 'buildConcrete(params)',
    doc: 'Build a concrete manga entry model.',
  ),
  'buildChapter': (
    detail: 'buildChapter(params)',
    doc: 'Build a single chapter model.',
  ),
  'buildChapterGroups': (
    detail: 'buildChapterGroups(params)',
    doc: 'Build a grouped chapter list model.',
  ),
  'buildPages': (
    detail: 'buildPages(params)',
    doc: 'Build a pages model for a chapter.',
  ),
  'buildAnimeVideo': (
    detail: 'buildAnimeVideo(params)',
    doc: 'Build a single anime video model.',
  ),
  'buildAnimeVideoGroup': (
    detail: 'buildAnimeVideoGroup(params)',
    doc: 'Build a grouped anime video list model.',
  ),
  'statusAnnounce': (detail: 'statusAnnounce', doc: 'Status constant: announced.'),
  'statusCanceled': (detail: 'statusCanceled', doc: 'Status constant: canceled.'),
  'statusOngoing': (detail: 'statusOngoing', doc: 'Status constant: ongoing.'),
  'statusPaused': (detail: 'statusPaused', doc: 'Status constant: paused.'),
  'statusReleased': (detail: 'statusReleased', doc: 'Status constant: released/completed.'),
  'statusUndefined': (detail: 'statusUndefined', doc: 'Status constant: unknown/undefined.'),
  'typeIframe': (detail: 'typeIframe', doc: 'Video type constant: iframe embed.'),

  // String members
  'length': (detail: '.length → int', doc: 'The number of characters (string) or elements (array/map).'),
  'isEmpty': (detail: '.isEmpty → bool', doc: 'True if the string or array has no elements.'),
  'isNotEmpty': (detail: '.isNotEmpty → bool', doc: 'True if the string or array has at least one element.'),
  'contains': (detail: '.contains(value) → bool', doc: 'True if the string contains the given substring, or the array contains the given element.'),
  'split': (detail: '.split(separator) → array', doc: 'Split a string by a separator and return an array of parts.'),
  'substring': (detail: '.substring(start, end) → string', doc: 'Return the substring from `start` (inclusive) to `end` (exclusive).'),
  'trim': (detail: '.trim() → string', doc: 'Remove leading and trailing whitespace.'),
  'trimLeft': (detail: '.trimLeft() → string', doc: 'Remove leading whitespace.'),
  'trimRight': (detail: '.trimRight() → string', doc: 'Remove trailing whitespace.'),
  'toLowerCase': (detail: '.toLowerCase() → string', doc: 'Return the string converted to lowercase.'),
  'toUpperCase': (detail: '.toUpperCase() → string', doc: 'Return the string converted to uppercase.'),
  'replaceAll': (detail: '.replaceAll(from, to) → string', doc: 'Replace all occurrences of `from` with `to`.'),
  'replaceFirst': (detail: '.replaceFirst(from, to) → string', doc: 'Replace the first occurrence of `from` with `to`.'),

  // Array members
  'first': (detail: '.first → value', doc: 'The first element of the array.'),
  'last': (detail: '.last → value', doc: 'The last element of the array.'),
  'push': (detail: '.push(value)', doc: 'Append a value to the end of the array.'),
  'pop': (detail: '.pop() → value', doc: 'Remove and return the last element of the array.'),
  'elementAt': (detail: '.elementAt(index) → value', doc: 'Return the element at the given index.'),
  'removeAt': (detail: '.removeAt(index)', doc: 'Remove the element at the given index.'),

  // Map members
  'containsKey': (detail: '.containsKey(key) → bool', doc: 'True if the map contains the given key.'),
  'containsValue': (detail: '.containsValue(value) → bool', doc: 'True if the map contains the given value.'),
  'remove': (detail: '.remove(key)', doc: 'Remove the entry with the given key.'),
  'clear': (detail: '.clear()', doc: 'Remove all entries from the map.'),
  'addAll': (detail: '.addAll(other)', doc: 'Add all entries from another map into this map.'),
  'values': (detail: '.values → array', doc: 'Return all values in the map as an array.'),
  'keys': (detail: '.keys → array', doc: 'Return all keys in the map as an array.'),
};
