/*
 * Copyright (c) 2024 armatura24
 * All right reserved
 */

import 'package:capyscript/modules/waka_models/models/filters/filter_selection_model.dart';
import 'package:capyscript/modules/waka_models/models/filters/filter_selection_option_model.dart';
import 'package:capyscript/modules/waka_models/models/filters/filter_selection_type.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  group("filters build selection type node", () {
    test("should return FilterSelectionModel.single", () async {
      expect(
        await runCode(
          '''
          return buildSelectionType("single");
        ''',
          modules: ["filters_models"],
        ),
        FilterSelectionType.single,
      );
    });

    test("should return FilterSelectionModel.multiple", () async {
      expect(
        await runCode(
          '''
          return buildSelectionType("multiple");
        ''',
          modules: ["filters_models"],
        ),
        FilterSelectionType.multiple,
      );
    });

    test("should return FilterSelectionModel.sort", () async {
      expect(
        await runCode(
          '''
          return buildSelectionType("sort");
        ''',
          modules: ["filters_models"],
        ),
        FilterSelectionType.sort,
      );
    });

    test("should return null", () async {
      expect(
        await runCode(
          '''
          return buildSelectionType("unknown");
        ''',
          modules: ["filters_models"],
        ),
        null,
      );
    });
  });

  group("filters build selection option node", () {
    test("should return FilterSelectionOptionModel", () async {
      expect(
        await runCode(
          '''
          return buildSelectionOption("title", "value");
        ''',
          modules: ["filters_models"],
        ),
        FilterSelectionOptionModel(title: "title", value: "value"),
      );
    });

    test("should return FilterSelectionOptionModel", () async {
      expect(
        await runCode(
          '''
          return buildSelectionOption("", "");
        ''',
          modules: ["filters_models"],
        ),
        FilterSelectionOptionModel(title: "", value: ""),
      );
    });

    test("should throw exception", () async {
      expect(
         runCode(
          '''
          return buildSelectionOption(null, "test");
        ''',
          modules: ["filters_models"],
        ),
        throwsError,
      );
    });

    test("should throw exception", () async {
      expect(
         runCode(
          '''
          return buildSelectionOption("test", null);
        ''',
          modules: ["filters_models"],
        ),
        throwsError,
      );
    });
  });



  group("filters build selection node", () {
    test("should return FilterSelectionModel", () async {
      expect(
        await runCode(
          '''
          return buildSelection("title", [], buildSelectionType("sort"));
        ''',
          modules: ["filters_models"],
        ),
        FilterSelectionModel(
          title: "title",
          options: [],
          mode: FilterSelectionType.sort,
        ),
      );
    });

    test("should return FilterSelectionModel", () async {
      expect(
        await runCode(
          '''
          return buildSelection("title", [], buildSelectionType("single"));
        ''',
          modules: ["filters_models"],
        ),
        FilterSelectionModel(
          title: "title",
          options: [],
          mode: FilterSelectionType.single,
        ),
      );
    });

    test("should return FilterSelectionModel", () async {
      expect(
        await runCode(
          '''
          return buildSelection("title",
           [
              buildSelectionOption("test", "value")
           ], 
          buildSelectionType("multiple"));
        ''',
          modules: ["filters_models"],
        ),
        FilterSelectionModel(
          title: "title",
          options: [
            FilterSelectionOptionModel(title: "test", value: "value")
          ],
          mode: FilterSelectionType.multiple,
        ),
      );
    });

    test("should throw exception", () async {
      expect(
         runCode(
          '''
          return buildSelection(null, [], buildSelectionType("sort"));
        ''',
          modules: ["filters_models"],
        ),
        throwsError,
      );
    });

    test("should throw exception", () async {
      expect(
         runCode(
          '''
          return buildSelection("title", null, buildSelectionType("sort"));
        ''',
          modules: ["filters_models"],
        ),
        throwsError,
      );
    });

    test("should throw exception", () async {
      expect(
         runCode(
          '''
          return buildSelection("title", [], null);
        ''',
          modules: ["filters_models"],
        ),
        throwsError,
      );
    });
  });
}
