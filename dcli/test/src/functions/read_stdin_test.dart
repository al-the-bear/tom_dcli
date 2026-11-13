@Timeout(Duration(seconds: 600))
library;

import 'package:test/test.dart' as t;
import 'package:test/test.dart';
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'package:tom_dcli/dcli.dart';

void main() {
  // can't be run from within vscode as it needs console input.
  t.group('Read from stdin', () {
    t.test(
      'Read and then write ',
      () {
        readStdin().forEach(print);
      },
      skip: true,
    );
  });
}
