/*
 * Copyright (c) 2025 S. Brett Sutton 2022+
 *
 * This software is licensed under the MIT License.
 * SPDX-License-Identifier: MIT
 */

@TestOn('posix')
library;

import 'dart:io';

import 'package:test/test.dart';
import 'package:tom_dcli/dcli.dart';
import 'package:tom_dcli/posix.dart';

/// @Throwing(ArgumentError)
void main() {
  test('bash shell loggedInUser', () {
    final effectiveUser = 'whoami'.firstLine!.trim();
    final expected = effectiveUser == 'root'
        ? env['SUDO_USER'] ?? effectiveUser
        : effectiveUser;
    expect(Shell.current.loggedInUser, expected);
  });

  test('isPrivilegedPasswordRequired', () {
    /// ensure the sudo password has been flushed.
    'sudo -K'.run;

    /// Force dcli to see the bash shell.
    env['SHELL'] = BashShell.shellName;

    final sudoResult = Process.runSync('sudo', ['-nv']);
    final sudoOutput = '${sudoResult.stdout}${sudoResult.stderr}';
    final expected =
        sudoResult.exitCode != 0 &&
        (sudoOutput.contains('a password is required') ||
            sudoOutput.contains('interactive authentication is required'));

    expect(Shell.current.isPrivilegedPasswordRequired, expected);
  });

  // don't know how to automat this test as we need the sudo password.
  // test('bash shell loggedInUser under sudo', () async {
  //   expect(Shell.current.loggedInUser, env['USER'));
  // });
}
