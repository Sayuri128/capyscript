import 'dart:io';

import 'package:capyscript/Interpreter/interpreter.dart';
import 'package:test/test.dart';

Interpreter _interpFromFile(String mainPath) =>
    Interpreter.fromFile(path: mainPath);

void main() {
  late Directory tmp;

  setUp(() {
    tmp = Directory.systemTemp.createTempSync('capyscript_file_imports_');
  });

  tearDown(() {
    tmp.deleteSync(recursive: true);
  });

  File _write(String relativePath, String content) {
    final f = File('${tmp.path}/$relativePath');
    f.parent.createSync(recursive: true);
    f.writeAsStringSync(content);
    return f;
  }

  group('File imports — basic', () {
    test('imports a sibling file with .capyscript extension in import path',
        () async {
      _write('lib.capyscript', '''
        function add(a, b) { return a + b; }
      ''');
      final main = _write('main.capyscript', '''
        import "lib.capyscript";
        function main() { return add(3, 4); }
      ''');

      expect(await _interpFromFile(main.path).interpret(), equals(7));
    });

    test('auto-appends .capyscript extension when omitted', () async {
      _write('helpers.capyscript', '''
        function greet() { return "hello"; }
      ''');
      final main = _write('main.capyscript', '''
        import "helpers";
        function main() { return greet(); }
      ''');

      expect(await _interpFromFile(main.path).interpret(), equals('hello'));
    });

    test('imported file can define multiple functions', () async {
      _write('math.capyscript', '''
        function square(x) { return x * x; }
        function cube(x) { return x * x * x; }
      ''');
      final main = _write('main.capyscript', '''
        import "math";
        function main() { return square(3) + cube(2); }
      ''');

      expect(await _interpFromFile(main.path).interpret(), equals(17));
    });
  });

  group('File imports — relative paths', () {
    test('imports a file in a subdirectory', () async {
      _write('utils/strings.capyscript', '''
        function upper(s) { return s; }
      ''');
      final main = _write('main.capyscript', '''
        import "utils/strings";
        function main() { return upper("x"); }
      ''');

      expect(await _interpFromFile(main.path).interpret(), equals('x'));
    });

    test('imports a file via ../ relative path', () async {
      _write('shared/common.capyscript', '''
        function pi() { return 3; }
      ''');
      _write('scripts/sub.capyscript', '''
        function val() { return pi(); }
      ''');
      final main = _write('scripts/main.capyscript', '''
        import "../shared/common";
        import "sub";
        function main() { return val(); }
      ''');

      expect(await _interpFromFile(main.path).interpret(), equals(3));
    });
  });

  group('File imports — transitive', () {
    test('transitively imports functions from a chain of files', () async {
      _write('base.capyscript', '''
        function base() { return 10; }
      ''');
      _write('mid.capyscript', '''
        import "base";
        function mid() { return base() + 5; }
      ''');
      final main = _write('main.capyscript', '''
        import "mid";
        function main() { return mid(); }
      ''');

      expect(await _interpFromFile(main.path).interpret(), equals(15));
    });

    test('same file imported from two places is loaded only once', () async {
      _write('shared.capyscript', '''
        function shared() { return 1; }
      ''');
      _write('a.capyscript', '''
        import "shared";
        function fromA() { return shared(); }
      ''');
      _write('b.capyscript', '''
        import "shared";
        function fromB() { return shared(); }
      ''');
      final main = _write('main.capyscript', '''
        import "a";
        import "b";
        function main() { return fromA() + fromB(); }
      ''');

      expect(await _interpFromFile(main.path).interpret(), equals(2));
    });
  });

  group('File imports — classes', () {
    test('imported file can define a class used in the main file', () async {
      _write('models.capyscript', '''
        class Point {
          x;
          y;
          function constructor(px, py) {
            this.x = px;
            this.y = py;
          }
          function sum() { return this.x + this.y; }
        }
      ''');
      final main = _write('main.capyscript', '''
        import "models";
        function main() {
          var p = new Point(3, 4);
          return p.sum();
        }
      ''');

      expect(await _interpFromFile(main.path).interpret(), equals(7));
    });
  });

  group('File imports — errors', () {
    test('throws when imported file does not exist', () async {
      final main = _write('main.capyscript', '''
        import "nonexistent";
        function main() { return 1; }
      ''');

      await expectLater(
        _interpFromFile(main.path).interpret(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
