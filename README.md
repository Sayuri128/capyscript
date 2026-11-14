# Capyscript

Capyscript is a small dynamically typed scripting language with a tree-walking interpreter written
in Dart. It runs the extensions of [Wakaranai](https://github.com/Sayuri128/wakaranai): each
extension is a `.capyscript` file that fetches and parses a source (manga, anime, novels, audio)
and returns typed models to the app.

Capyscript 0.5.0 implements extension API 3. API 2 shipped with Wakaranai 1.0.0 (capyscript 0.4.0).

The package contains:

- the lexer, parser and interpreter;
- the standard modules: `http`, `html`, `json`, `regex`, `converter`, `date`, `io`, `bytes`,
  `hash`, `graphql`, the model modules and the host modules `preferences`, `storage`, `errors`
  and `dependencies`;
- the extension lifecycle: an optional `onInit()` that runs once per client before its first call;
- the typed `ApiClient`s the app calls (`getGallery`, `getConcrete`, `getPages`,
  `getVideoSources`, ...);
- a language server and syntax highlighting for VS Code and IntelliJ (`editors/`).

## Writing extensions

The extension guides live in the Wakaranai repository:

- [Extensions](https://github.com/Sayuri128/wakaranai/blob/master/docs/guides/extensions.md):
  config fields, script functions, preferences, feeds and pagination
- [Syntax](https://github.com/Sayuri128/wakaranai/blob/master/docs/guides/capyscript_syntax.md)
- [Modules](https://github.com/Sayuri128/wakaranai/blob/master/docs/guides/caypscript_modules.md)

The official extensions are in
[wakaranai_configs](https://github.com/Sayuri128/wakaranai_configs) and are the best examples.

Extensions that use api 2 features (preferences, storage, typed source errors, feeds, pagination)
declare `"apiVersion": 2` and `"minAppVersion": "1.0.0"` in their config. Extensions that use api 3
features (`onInit`, the `dependencies`, `bytes`, `hash` and `graphql` modules, `bodyBytes`, or rely on
windows-1251/koi8 response decoding) declare `"apiVersion": 3` and the first app release that ships
capyscript 0.5.0 as `minAppVersion`. Older app builds can't run them.

## Development

```bash
dart pub get
dart test
dart analyze

dart run bin/interpreter.dart --path capyscript/main.capyscript
dart run bin/lsp_server.dart

dart run build_runner build --delete-conflicting-outputs
```

Generated `*.g.dart` files are committed; regenerate them after changing a `@JsonSerializable`
class.

## License

[Apache License 2.0](LICENSE)
