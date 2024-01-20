/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:args/args.dart';
import 'package:capyscript/Interpreter/interpreter.dart';
import 'package:capyscript/api_clients/anime_api_client.dart';

void main(List<String> args) async {
  final argsParser = ArgParser();
  argsParser.addOption('path');

  final results = argsParser.parse(args);

  final interpreter = Interpreter.fromFile(path: results['path']);
  final apiClient =
      AnimeApiClient(code: interpreter.mainFile!.readAsStringSync());

  // print(await apiClient.getGallery(page: 0));
  print(
      await apiClient.getConcrete(uid: "4243-hiatari-ryoukou.html", data: {}));
}
