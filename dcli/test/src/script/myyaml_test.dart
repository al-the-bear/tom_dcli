@Timeout(Duration(minutes: 5))
library;

import 'package:dcli_test/dcli_test.dart';
import 'package:test/test.dart';
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'package:tom_dcli/dcli.dart';
import 'package:tom_dcli/src/script/my_yaml.dart';

/// @Throwing(ArgumentError)
void main() {
  test('Project Name', () async {
    await TestFileSystem().withinZone((fs) async {
      print(pwd);
      final yaml = MyYaml.fromFile('pubspec.yaml');
      final projectName = yaml.getValue('name');

      expect(projectName, equals('dcli'));
    });
  });
}
