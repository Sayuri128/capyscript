const { LanguageClient, TransportKind } = require('vscode-languageclient/node');
const vscode = require('vscode');

let client;

function activate(context) {
  const workspaceRoot = vscode.workspace.workspaceFolders?.[0]?.uri.fsPath;
  const serverOptions = {
    command: 'dart',
    args: ['run', 'bin/lsp_server.dart'],
    options: { cwd: workspaceRoot },
    transport: TransportKind.stdio,
  };
  const clientOptions = {
    documentSelector: [{ scheme: 'file', language: 'capyscript' }],
  };
  client = new LanguageClient(
    'capyscript',
    'Capyscript Language Server',
    serverOptions,
    clientOptions,
  );
  client.start();
}

function deactivate() {
  return client?.stop();
}

module.exports = { activate, deactivate };
