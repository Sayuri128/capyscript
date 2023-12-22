/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:args/args.dart';
import 'package:capyscript/Interpreter/interpreter.dart';
import 'package:capyscript/api_clients/manga_api_client.dart';

void main(List<String> args) async {
  final argsParser = ArgParser();
  argsParser.addOption('path');

  final results = argsParser.parse(args);

  final interpreter = Interpreter.fromFile(path: results['path']);
  final apiClient =
      MangaApiClient(code: interpreter.mainFile!.readAsStringSync());

  print(await apiClient.getGallery(page: 0));
}
