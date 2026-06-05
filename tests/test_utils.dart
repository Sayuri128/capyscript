/*
 * Copyright (c) 2024 armatura24
 * All right reserved
 */

import 'package:capyscript/Interpreter/interpreter.dart';
import 'package:test/test.dart';

Future<dynamic> runCode(String code,
    {String functions = "", List<String> modules = const []}) async {
  final source = '''
    ${modules.map((m) => "import \"$m\";").join("\n")}
  
    $functions
  
    function main() {
      ${code}
    }
  ''';

  final interpreter = Interpreter(data: source);
  return interpreter.interpret();
}

// throws error matcher
final throwsError = throwsA(isA<Error>());
