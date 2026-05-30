import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:capyscript/lsp/completion_provider.dart';

class LspServer {
  final _documents = <String, String>{};
  final _completionProvider = CompletionProvider();

  Future<void> run() async {
    stderr.writeln('[capyscript-lsp] server started');
    await for (final message in _incomingMessages()) {
      final method = message['method'];
      stderr.writeln('[capyscript-lsp] << $method');
      final response = await _dispatch(message);
      if (response != null) {
        stderr.writeln('[capyscript-lsp] >> response to $method');
        _send(response);
      }
    }
  }

  // ── Transport ──────────────────────────────────────────────────────────────

  Stream<Map<String, dynamic>> _incomingMessages() async* {
    final buffer = <int>[];
    int? contentLength;

    await for (final chunk in stdin) {
      buffer.addAll(chunk);

      while (true) {
        if (contentLength == null) {
          final headerEnd = _indexOfCrlfCrlf(buffer);
          if (headerEnd == -1) break;

          final headerText = utf8.decode(buffer.sublist(0, headerEnd));
          for (final line in headerText.split('\r\n')) {
            if (line.toLowerCase().startsWith('content-length:')) {
              contentLength = int.parse(line.split(':')[1].trim());
            }
          }
          buffer.removeRange(0, headerEnd + 4); // consume headers + \r\n\r\n
        }

        final len = contentLength;
        if (len != null && buffer.length >= len) {
          final body = buffer.sublist(0, len);
          buffer.removeRange(0, len);
          contentLength = null;

          try {
            yield jsonDecode(utf8.decode(body)) as Map<String, dynamic>;
          } catch (e) {
            stderr.writeln('[capyscript-lsp] malformed message: $e');
          }
        } else {
          break;
        }
      }
    }
  }

  int _indexOfCrlfCrlf(List<int> bytes) {
    for (var i = 0; i < bytes.length - 3; i++) {
      if (bytes[i] == 13 && bytes[i + 1] == 10 &&
          bytes[i + 2] == 13 && bytes[i + 3] == 10) {
        return i;
      }
    }
    return -1;
  }

  void _send(Map<String, dynamic> message) {
    final body = jsonEncode(message);
    final bodyBytes = utf8.encode(body);
    stdout.write('Content-Length: ${bodyBytes.length}\r\n\r\n');
    stdout.add(bodyBytes);
    stdout.flush();
  }

  Map<String, dynamic> _response(dynamic id, dynamic result) =>
      {'jsonrpc': '2.0', 'id': id, 'result': result};

  Map<String, dynamic> _error(dynamic id, int code, String message) => {
        'jsonrpc': '2.0',
        'id': id,
        'error': {'code': code, 'message': message},
      };

  // ── Dispatch ───────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> _dispatch(Map<String, dynamic> msg) async {
    final method = msg['method'] as String?;
    final id = msg['id'];
    final params = msg['params'] as Map<String, dynamic>?;

    switch (method) {
      case 'initialize':
        return _response(id, {
          'capabilities': {
            'textDocumentSync': {
              'openClose': true,
              'change': 1, // full document sync
            },
            'completionProvider': {
              'resolveProvider': false,
              'triggerCharacters': [],
            },
          },
          'serverInfo': {'name': 'capyscript-lsp', 'version': '0.1.0'},
        });

      case 'initialized':
        return null;

      case 'textDocument/didOpen':
        final doc = params?['textDocument'] as Map?;
        if (doc != null) {
          _documents[doc['uri'] as String] = doc['text'] as String? ?? '';
        }
        return null;

      case 'textDocument/didChange':
        final doc = params?['textDocument'] as Map?;
        final changes = params?['contentChanges'] as List?;
        if (doc != null && changes != null && changes.isNotEmpty) {
          _documents[doc['uri'] as String] =
              (changes.last as Map)['text'] as String? ?? '';
        }
        return null;

      case 'textDocument/didClose':
        final doc = params?['textDocument'] as Map?;
        if (doc != null) _documents.remove(doc['uri'] as String);
        return null;

      case 'textDocument/completion':
        final uri = (params?['textDocument'] as Map?)?['uri'] as String?;
        final content = (uri != null ? _documents[uri] : null) ?? '';
        final pos = params?['position'] as Map?;
        final line = (pos?['line'] as num?)?.toInt() ?? 0;
        final character = (pos?['character'] as num?)?.toInt() ?? 0;
        final items = _completionProvider.getCompletions(content, line, character);
        return _response(id, {'isIncomplete': false, 'items': items});

      case 'shutdown':
        return _response(id, null);

      case 'exit':
        exit(0);

      default:
        if (id != null) {
          return _error(id, -32601, 'Method not found: $method');
        }
        return null;
    }
  }
}
