/*
 * Copyright (c) 2024 armatura24
 * All right reserved
 */

import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('Array tests', () {
    test('Array initialization', () async {
      final res = await runCode('''
        arr = [];
        
        return arr;
      ''');

      expect(res, []);
    });

    test('Array initialization with values', () async {
      final res = await runCode('''
        arr = [1, 2, 3];
        
        return arr;
      ''');

      expect(res, [1, 2, 3]);
    });

    test('Array push', () async {
      final res = await runCode('''
        arr = [];
        arr.push(1);
        arr.push(2);
        arr.push(3);
        
        return arr;
      ''');

      expect(res, [1, 2, 3]);
    });

    test('Array pop', () async {
      final res = await runCode('''
        arr = [1, 2, 3];
        arr.pop();
        
        return arr;
      ''');

      expect(res, [1, 2]);
    });

    test('Array access by index', () async {
      final res = await runCode('''
        arr = [1, 2, 3];
        
        return arr[1];
      ''');

      expect(res, 2);
    });

    test('Array access by index out of range', () {
      expect(runCode('''
        arr = [1, 2, 3];
        
        return arr[3];
      '''), throwsRangeError);
      expect(runCode('''
        arr = [1, 2, 3];
        
        return arr[-1];
      '''), throwsRangeError);
      expect(runCode('''
        arr = [1, 2, 3];
        
        return arr[1.5];
      '''), throwsError);
      expect(runCode('''
        arr = [1, 2, 3];
        
        return arr[1, 2];
      '''), throwsException);
    });

    test('Array modification', () async {
      final res = await runCode('''
        arr = [1, 2, 3];
        arr[1] = 4;
        
        return arr;
      ''');

      expect(res, [1, 4, 3]);
    });

    test('Array modification out of range', () {
      expect(runCode('''
        arr = [1, 2, 3];
        arr[3] = 4;
        
        return arr;
      '''), throwsRangeError);
      expect(runCode('''
        arr = [1, 2, 3];
        arr[-1] = 4;
        
        return arr;
      '''), throwsRangeError);
      expect(runCode('''
        arr = [1, 2, 3];
        arr[1.5] = 4;
        
        return arr;
      '''), throwsError);
    });

    test('Array length', () async {
      expect(await runCode('''
          arr = [1, 2, 3];
          
          return arr.length;
        '''), 3);

      expect(await runCode('''
          arr = [];
          
          return arr.length;
        '''), 0);
    });

    test('Array as function argument', () async {
      final sumFunction = '''
       function sum(arr) {
          sum = 0;
          for (i = 0; i < arr.length; i = i + 1) {
            sum = sum + arr[i];
          }
          return sum;
        }
        ''';

      expect(await runCode('''
                return sum([1, 2, 3]);
      ''', functions: sumFunction), 6);

      expect(await runCode('''
                return sum([]);
      ''', functions: sumFunction), 0);

      expect(await runCode('''
                return sum([1]);
      ''', functions: sumFunction), 1);

      expect(await runCode('''
                return sum([1, 2]);
      ''', functions: sumFunction), 3);
    });


  });
}
