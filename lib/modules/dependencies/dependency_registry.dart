import 'package:capyscript/AST/lambda/ast_closure.dart';
import 'package:capyscript/Interpreter/interpreter_environment.dart';

class DependencyRegistry {
  final Map<String, dynamic> _values = {};
  final Map<String, ASTClosure> _factories = {};
  final Map<String, Future<dynamic>> _pending = {};

  List<String> get names => {..._values.keys, ..._factories.keys}.toList()..sort();

  bool isProvided(String name) =>
      _values.containsKey(name) || _factories.containsKey(name);

  void provide(String name, dynamic value) {
    _factories.remove(name);
    _pending.remove(name);
    _values[name] = value;
  }

  void provideLazy(String name, ASTClosure factory) {
    _values.remove(name);
    _pending.remove(name);
    _factories[name] = factory;
  }

  void forget(String name) {
    _values.remove(name);
    _factories.remove(name);
    _pending.remove(name);
  }

  void clear() {
    _values.clear();
    _factories.clear();
    _pending.clear();
  }

  Future<dynamic> inject(String name, InterpreterEnvironment environment) async {
    if (_values.containsKey(name)) {
      return _values[name];
    }
    final ASTClosure? factory = _factories[name];
    if (factory == null) {
      final String provided = names.isEmpty ? 'none' : names.join(', ');
      throw Exception(
          'dependency "$name" is not provided (provided: $provided); provide it in onInit');
    }
    final Future<dynamic> pending =
        _pending[name] ??= factory.call(environment, const []);
    try {
      final dynamic value = await pending;
      if (identical(_pending[name], pending)) {
        _pending.remove(name);
        _factories.remove(name);
        _values[name] = value;
      }
      return value;
    } catch (_) {
      if (identical(_pending[name], pending)) {
        _pending.remove(name);
      }
      rethrow;
    }
  }
}
