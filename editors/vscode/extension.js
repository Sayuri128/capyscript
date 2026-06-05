const { LanguageClient } = require('vscode-languageclient/node');
const vscode = require('vscode');
const path = require('path');
const fs = require('fs');

let client;

function findProjectRoot(startDir) {
  let dir = startDir;
  while (true) {
    if (
      fs.existsSync(path.join(dir, 'pubspec.yaml')) &&
      fs.existsSync(path.join(dir, 'bin', 'lsp_server.dart'))
    ) {
      return dir;
    }
    const parent = path.dirname(dir);
    if (parent === dir) return null;
    dir = parent;
  }
}

function tryStart() {
  if (client) return;

  const candidates = [];

  const workspaceRoot = vscode.workspace.workspaceFolders?.[0]?.uri.fsPath;
  if (workspaceRoot) candidates.push(workspaceRoot);

  for (const doc of vscode.workspace.textDocuments) {
    candidates.push(path.dirname(doc.uri.fsPath));
  }

  const activeFile = vscode.window.activeTextEditor?.document.uri.fsPath;
  if (activeFile) candidates.push(path.dirname(activeFile));

  let projectRoot = null;
  for (const start of candidates) {
    projectRoot = findProjectRoot(start);
    if (projectRoot) break;
  }

  if (!projectRoot) return;

  const serverOptions = {
    command: 'dart',
    args: ['run', path.join(projectRoot, 'bin', 'lsp_server.dart')],
    options: { cwd: projectRoot },
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

function activate(context) {
  context.subscriptions.push(
    vscode.workspace.onDidOpenTextDocument((doc) => {
      if (doc.languageId === 'capyscript') tryStart();
    }),
    vscode.window.onDidChangeActiveTextEditor((editor) => {
      if (editor?.document.languageId === 'capyscript') tryStart();
    }),
  );

  // Also try immediately in case a capyscript file is already open
  tryStart();
  setTimeout(tryStart, 500);
}

function deactivate() {
  return client?.stop();
}

module.exports = { activate, deactivate };
