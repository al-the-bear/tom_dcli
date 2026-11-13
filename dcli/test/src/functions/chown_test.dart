/*
 * Copyright (c) 2025 S. Brett Sutton 2022+
 *
 * This software is licensed under the MIT License.
 * SPDX-License-Identifier: MIT
 */

import 'package:test/test.dart';
import 'package:tom_dcli/dcli.dart';
import 'package:tom_dcli/posix.dart';

/// @Throwing(ArgumentError)
/// @Throwing(DeleteException)
/// @Throwing(TouchException)
void main() {
  test('chown ...', () async {
    await withTempFileAsync((test) async {
      final user = Shell.current.loggedInUser;

      chown(test, group: user, user: user);
    });
  },
      tags: ['privileged'],
      skip: Settings().isWindows || !Shell.current.isPrivilegedUser);
}
