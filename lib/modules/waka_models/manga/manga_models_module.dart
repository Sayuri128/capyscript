/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/manga/manga_build_chapter_node.dart';
import 'package:capyscript/modules/waka_models/manga/manga_build_chapters_group_node.dart';
import 'package:capyscript/modules/waka_models/manga/manga_build_concrete_node.dart';
import 'package:capyscript/modules/waka_models/manga/manga_build_gallery_node.dart';
import 'package:capyscript/modules/waka_models/manga/manga_build_pages_node.dart';
import 'package:capyscript/modules/waka_models/manga/manga_build_status_announce_node.dart';
import 'package:capyscript/modules/waka_models/manga/manga_build_status_canceled_node.dart';
import 'package:capyscript/modules/waka_models/manga/manga_build_status_node.dart';
import 'package:capyscript/modules/waka_models/manga/manga_build_status_ongoing_node.dart';
import 'package:capyscript/modules/waka_models/manga/manga_build_status_paused_node.dart';
import 'package:capyscript/modules/waka_models/manga/manga_build_status_released_node.dart';
import 'package:capyscript/modules/waka_models/manga/manga_build_status_undefined_node.dart';

class MangaModelsModule extends BaseModule {
  static const String module_name = "manga_models";

  MangaModelsModule() : super(moduleName: module_name) {
    final List<ASTFunctionDeclarationNode> functions = [];

    functions.add(MangaBuildChapterNode().toDeclarationNode());
    functions.add(MangaBuildChaptersGroupNode().toDeclarationNode());
    functions.add(MangaBuildConcreteNode().toDeclarationNode());
    functions.add(MangaBuildGalleryNode().toDeclarationNode());
    functions.add(MangaBuildPagesNode().toDeclarationNode());

    functions.add(MangaBuildStatusNode().toDeclarationNode());

    // will be removed
    // *
    functions.add(MangaBuildStatusAnnounceNode().toDeclarationNode());
    functions.add(MangaBuildStatusCanceledNode().toDeclarationNode());
    functions.add(MangaBuildStatusOngoingNode().toDeclarationNode());
    functions.add(MangaBuildStatusPausedNode().toDeclarationNode());
    functions.add(MangaBuildStatusReleasedNode().toDeclarationNode());
    functions.add(MangaBuildStatusUndefinedNode().toDeclarationNode());
    // *

    body = ASTTree(functions: functions, modules: []);
  }
}
