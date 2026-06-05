import 'package:capyscript/Interpreter/interpreter.dart';

Future<dynamic> run(String src) => Interpreter(data: src).interpret();
