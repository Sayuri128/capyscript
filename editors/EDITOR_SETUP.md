# Editor Setup for Capyscript

Both editors get syntax highlighting and LSP-powered completions (triggered on `.` and `:`, with class-aware suggestions).

---

## VS Code

### 1. Install the extension

Open VS Code, press `Cmd+Shift+P`, choose **Extensions: Install from VSIX…**, and select:

```
editors/vscode/capyscript-0.1.0.vsix
```

This gives you syntax highlighting immediately.

### 2. Enable the LSP

The extension auto-starts the language server when you open a `.capyscript` file, provided:

- The workspace root contains `pubspec.yaml` **and** `bin/lsp_server.dart`
- `dart` is on your `PATH`

The server is launched as:
```
dart run bin/lsp_server.dart
```
from the repo root. No extra configuration is needed.

### 3. Rebuilding the extension (after grammar changes)

```bash
cd editors/vscode
npm install
npx vsce package --no-dependencies
```

This produces a new `capyscript-0.1.0.vsix`. Reinstall it via **Extensions: Install from VSIX…**.

---

## IntelliJ / Android Studio

IntelliJ does not support `.vsix` files. Use the TextMate bundle instead.

### 1. Install the TextMate bundle (syntax highlighting)

1. Open **IntelliJ IDEA** (or Android Studio).
2. Go to **Preferences → Editor → TextMate Bundles**.
3. Click **+** and select the bundle directory:
   ```
   editors/intellij/capyscript.tmbundle
   ```
4. Make sure the bundle is enabled (checkbox ticked).
5. Click **OK** / **Apply**.

`.capyscript` files now get syntax highlighting.

### 2. Enable the LSP

IntelliJ supports LSP via the **LSP4IJ** plugin (free, JetBrains Marketplace).

#### Install LSP4IJ

1. Go to **Preferences → Plugins → Marketplace**.
2. Search for **LSP4IJ** and install it.
3. Restart the IDE.

#### Configure the Capyscript server

1. Go to **Preferences → Languages & Frameworks → Language Servers**.
2. Click **+** to add a new server.
3. Fill in:

   | Field | Value |
   |---|---|
   | **Name** | Capyscript |
   | **Command** | `dart run bin/lsp_server.dart` |
   | **Working directory** | `/path/to/capyscript` (the repo root) |
   | **File patterns** | `*.capyscript` |

4. Click **OK** / **Apply**.

Open any `.capyscript` file — the LSP starts automatically and completions become available.

---

## What the LSP provides

| Trigger | Completions offered |
|---|---|
| `.` after a variable | Class methods and fields (if `var x = new MyClass()` is in scope), otherwise string/array/map members |
| `new ` | All class names declared in the file |
| `: ` | Built-in type names (`int`, `float`, `string`, `bool`, `void`, `any`, `dynamic`, `List`, `Map`) + class names |
| Anywhere in a block | Keywords, function names, imported module functions, variable names, class names |
| Top level | `import`, `function`, `class`, `interface` |

All completion items include inline documentation.
