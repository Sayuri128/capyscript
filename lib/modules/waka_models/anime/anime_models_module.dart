/*
 * Copyright (c) 2023 armatura24
 * All right reserved
 */

import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/anime/anime_build_concrete_node.dart';
import 'package:capyscript/modules/waka_models/anime/anime_build_episode_group_node.dart';
import 'package:capyscript/modules/waka_models/anime/anime_build_gallery_node.dart';
import 'package:capyscript/modules/waka_models/anime/anime_build_status_announce_node.dart';
import 'package:capyscript/modules/waka_models/anime/anime_build_status_canceled_node.dart';
import 'package:capyscript/modules/waka_models/anime/anime_build_status_paused_node.dart';
import 'package:capyscript/modules/waka_models/anime/anime_build_status_release_node.dart';
import 'package:capyscript/modules/waka_models/anime/anime_build_status_undefined_node.dart';
import 'package:capyscript/modules/waka_models/anime/anime_build_type_iframe_node.dart';
import 'package:capyscript/modules/waka_models/anime/anime_build_video_node.dart';

class AnimeModelsModule extends BaseModule {
  static const String module_name = "anime_models";

  AnimeModelsModule() : super(moduleName: module_name) {
    final List<ASTFunctionDeclarationNode> functions = [];

    functions.add(AnimeBuildGalleryNode().toDeclarationNode());
    functions.add(AnimeBuildConcreteNode().toDeclarationNode());
    functions.add(AnimeBuildEpisodeGroupNode().toDeclarationNode());
    functions.add(AnimeBuildVideoNode().toDeclarationNode());

    functions.add(AnimeBuildStatusAnnounceNode().toDeclarationNode());
    functions.add(AnimeBuildStatusCanceledNode().toDeclarationNode());
    functions.add(AnimeBuildStatusPausedNode().toDeclarationNode());
    functions.add(AnimeBuildStatusReleaseNode().toDeclarationNode());
    functions.add(AnimeBuildStatusUndefinedNode().toDeclarationNode());

    functions.add(AnimeBuildTypeIframeNode().toDeclarationNode());

    body = ASTTree(functions: functions, modules: []);
  }
}
