/*
 * Copyright (c) 2025 S. Brett Sutton 2022+
 *
 * This software is licensed under the MIT License.
 * SPDX-License-Identifier: MIT
 */

@TestOn('posix')
library;

import 'package:test/test.dart';
import 'package:tom_dcli/dcli.dart';
import 'package:tom_dcli/posix.dart';

/// @Throwing(ArgumentError)
void main() {
  test('loggedInUsersHome ...', () {
    final home = env['HOME'];
    expect((Shell.current as PosixShell).loggedInUsersHome, home);
  });
}
