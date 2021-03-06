// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/src/dart/error/syntactic_errors.dart';

import 'partial_code_support.dart';

main() {
  new ImportDirectivesTest().buildAll();
}

class ImportDirectivesTest extends PartialCodeTest {
  buildAll() {
    List<String> allExceptEof =
        PartialCodeTest.prePartSuffixes.map((t) => t.name).toList();
    buildTests(
        'import_directive',
        [
          new TestDescriptor(
              'keyword',
              'import',
              [
                // TODO(danrubel): Consider an improved error message
                // ParserErrorCode.MISSING_URI,
                ParserErrorCode.EXPECTED_STRING_LITERAL,
                ParserErrorCode.EXPECTED_TOKEN
              ],
              "import '';"),
          new TestDescriptor('emptyUri', "import ''",
              [ParserErrorCode.EXPECTED_TOKEN], "import '';"),
          new TestDescriptor('fullUri', "import 'a.dart'",
              [ParserErrorCode.EXPECTED_TOKEN], "import 'a.dart';"),
          new TestDescriptor(
              'if',
              "import 'a.dart' if",
              [
                ParserErrorCode.EXPECTED_TOKEN,
                ParserErrorCode.EXPECTED_TOKEN,
                ParserErrorCode.EXPECTED_STRING_LITERAL
              ],
              "import 'a.dart' if (_s_) '';"),
          new TestDescriptor(
              'ifParen',
              "import 'a.dart' if (",
              [
                ParserErrorCode.MISSING_IDENTIFIER,
                ScannerErrorCode.EXPECTED_TOKEN,
                ParserErrorCode.EXPECTED_STRING_LITERAL,
                ParserErrorCode.EXPECTED_TOKEN
              ],
              "import 'a.dart' if (_s_) '';",
              failing: allExceptEof),
          new TestDescriptor(
              'ifId',
              "import 'a.dart' if (b",
              [
                ScannerErrorCode.EXPECTED_TOKEN,
                ParserErrorCode.EXPECTED_TOKEN,
                ParserErrorCode.EXPECTED_STRING_LITERAL
              ],
              "import 'a.dart' if (b) '';",
              failing: allExceptEof),
          new TestDescriptor(
              'ifEquals',
              "import 'a.dart' if (b ==",
              [
                ParserErrorCode.EXPECTED_STRING_LITERAL,
                ParserErrorCode.EXPECTED_TOKEN,
                ScannerErrorCode.EXPECTED_TOKEN,
                ParserErrorCode.EXPECTED_STRING_LITERAL
              ],
              "import 'a.dart' if (b == '') '';",
              failing: allExceptEof),
          new TestDescriptor(
              'ifCondition',
              "import 'a.dart' if (b)",
              [
                ParserErrorCode.EXPECTED_TOKEN,
                ParserErrorCode.EXPECTED_STRING_LITERAL
              ],
              "import 'a.dart' if (b) '';"),
        ],
        PartialCodeTest.prePartSuffixes);
  }
}
