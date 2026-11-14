import 'package:capyscript/api_clients/host/extension_host.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/dependencies/dependency_registry.dart';

class ModuleContext {
  final ExtensionHost host;
  final DependencyRegistry dependencies;
  final BaseModule? Function(String moduleName) module;

  const ModuleContext({
    required this.host,
    required this.dependencies,
    required this.module,
  });
}
