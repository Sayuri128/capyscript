import 'package:test/test.dart';
import 'helpers.dart';

void main() {
  group('ASTMethodCallNode - typed lists from ExternalObject.getField', () {
    test('add() onto a List<Chapter> handed out by getField', () async {
      final result = await run('''
        import "manga_models";
        function main() {
          group = buildChapterGroups("Main", []);
          chapter = buildChapter("c1", "One", "", {});
          group.elements.add(chapter);
          return group.elements.length;
        }
      ''');
      expect(result, 1);
    });

    test('push() onto a List<Chapter> handed out by getField', () async {
      final result = await run('''
        import "manga_models";
        function main() {
          group = buildChapterGroups("Main", []);
          group.elements.push(buildChapter("c1", "One", "", {}));
          group.elements.push(buildChapter("c2", "Two", "", {}));
          return group.elements.length;
        }
      ''');
      expect(result, 2);
    });

    test('add() onto a plain script array still works', () async {
      final result = await run('''
        function main() {
          items = [];
          items.add(1);
          items.add(2, 3);
          return items.length;
        }
      ''');
      expect(result, 3);
    });

    test('map addAll merges entries into a typed map', () async {
      final result = await run('''
        function main() {
          target = {"a": 1};
          target.addAll({"b": 2});
          return target["b"];
        }
      ''');
      expect(result, 2);
    });

    test('adding a wrong element type to a typed list throws', () async {
      expect(
        () => run('''
          import "manga_models";
          function main() {
            group = buildChapterGroups("Main", []);
            group.elements.add("not a chapter");
            return group.elements.length;
          }
        '''),
        throwsA(isA<TypeError>()),
      );
    });
  });
}
