/*
 * Copyright (c) 2024 armatura24
 * All right reserved
 */

import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  group("Assignment tests", () {
    test("Assignment test 1", () async {
      expect(await runCode('''
        a = 1;
        return a;
      '''), 1);

      expect(await runCode('''
        a = 1;
        a = 2;
        return a;
      '''), 2);

      expect(await runCode('''
        a = 1;
        b = a;
        return b;
      '''), 1);

      expect(await runCode('''
        a = 1;
        b = a;
        a = 2;
        return b;
      '''), 1);

      expect(await runCode('''
        a = 1;
        b = a;
        b = 2;
        return a;
      '''), 1);

      expect(await runCode('''
        a = 1;
        b = a;
        b = 2;
        a = 3;
        return b;
      '''), 2);
    });

    test("Assignment test 2", () async {
      expect(await runCode('''
        a = 1;
        b = 2;
        c = a + b;
        return c;
      '''), 3);

      expect(await runCode('''
        a = 1;
        b = 2;
        c = a + b;
        a = 3;
        return c;
      '''), 3);

      expect(await runCode('''
        a = 1;
        b = 2;
        c = a + b;
        b = 3;
        return c;
      '''), 3);

      expect(await runCode('''
        a = 1;
        b = 2;
        c = a + b;
        c = 4;
        return c;
      '''), 4);

      // assignment in function
      expect(await runCode('''
        return add(1, 2);
      ''', functions: '''
       function add(a, b) {
          return a + b;
        }        
        '''), 3);

      expect(await runCode('''
        return add(1, 2);
      ''', functions: '''
       function add(a, b) {
          a = 3;
          return a + b;
        }        
        '''), 5);


      expect(await runCode('''
        a = 1;
        b = 2;
        add(a, b);
        return a;
      ''', functions: '''
       function add(a, b) {
          a = 3;
          return a + b;
        }        
        '''), 1);


    });
  });
}
