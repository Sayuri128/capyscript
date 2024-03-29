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

  // print(await apiClient.getGallery(page: 0));
  // print(await apiClient
  //     .getConcrete(uid: "e97fdc93-21ec-47e0-b676-e45d67068932", data: {}));
  // print(
  //     await apiClient.getChapters(uid: "d65c0332-3764-4c89-84bd-b1a4e7278ad7"));
  print(await apiClient
      .getPages(uid: "f7cf6562-8cb6-41be-bcd0-143cce1b063f", data: {}));
}
