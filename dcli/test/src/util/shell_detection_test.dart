/*
 * Copyright (c) 2025 S. Brett Sutton 2022+
 *
 * This software is licensed under the MIT License.
 * SPDX-License-Identifier: MIT
 */

import 'package:path/path.dart';
import 'package:test/test.dart';
import 'package:tom_dcli/dcli.dart';

/// @Throwing(ArgumentError)
void main() {
  test('Detect Shell', () {
    final shell = Shell.current;
    print(shell.name);

    if (!Settings().isWindows && env['SHELL'] != null) {
      expect(shell.name, basename(env['SHELL']!).toLowerCase());
    } else {
      expect(shell.name, isNotEmpty);
      expect(shell.matchByName(shell.name), isTrue);
    }
  });
}
