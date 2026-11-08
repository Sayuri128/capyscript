import 'package:capyscript/AST/ast_tree.dart';
import 'package:capyscript/AST/function_declaration/ast_funcation_declaration_node.dart';
import 'package:capyscript/modules/abstract/base_module.dart';
import 'package:capyscript/modules/waka_models/audio/audio_build_marker_node.dart';
import 'package:capyscript/modules/waka_models/audio/audio_build_source_node.dart';
import 'package:capyscript/modules/waka_models/manga/manga_build_chapter_node.dart';
import 'package:capyscript/modules/waka_models/manga/manga_build_chapters_group_node.dart';
import 'package:capyscript/modules/waka_models/manga/manga_build_concrete_node.dart';
import 'package:capyscript/modules/waka_models/manga/manga_build_gallery_node.dart';
import 'package:capyscript/modules/waka_models/manga/manga_build_status_announce_node.dart';
import 'package:capyscript/modules/waka_models/manga/manga_build_status_canceled_node.dart';
import 'package:capyscript/modules/waka_models/manga/manga_build_status_ongoing_node.dart';
import 'package:capyscript/modules/waka_models/manga/manga_build_status_paused_node.dart';
import 'package:capyscript/modules/waka_models/manga/manga_build_status_released_node.dart';
import 'package:capyscript/modules/waka_models/manga/manga_build_status_undefined_node.dart';

class AudioModelsModule extends BaseModule {
  static const String module_name = "audio_models";

  AudioModelsModule() : super(moduleName: module_name) {
    final List<ASTFunctionDeclarationNode> functions = [
      MangaBuildGalleryNode().toDeclarationNode(),
      MangaBuildConcreteNode().toDeclarationNode(),
      MangaBuildChapterNode().toDeclarationNode(),
      MangaBuildChaptersGroupNode().toDeclarationNode(),
      AudioBuildSourceNode().toDeclarationNode(),
      AudioBuildMarkerNode().toDeclarationNode(),
      MangaBuildStatusAnnounceNode().toDeclarationNode(),
      MangaBuildStatusCanceledNode().toDeclarationNode(),
      MangaBuildStatusOngoingNode().toDeclarationNode(),
      MangaBuildStatusPausedNode().toDeclarationNode(),
      MangaBuildStatusReleasedNode().toDeclarationNode(),
      MangaBuildStatusUndefinedNode().toDeclarationNode(),
    ];

    body = ASTTree(functions: functions, modules: []);
  }
}
