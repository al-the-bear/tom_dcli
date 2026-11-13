/*
 * Copyright (c) 2025 S. Brett Sutton 2022+
 *
 * This software is licensed under the MIT License.
 * SPDX-License-Identifier: MIT
 */

import 'package:dcli/src/util/ini_config.dart';
import 'package:test/test.dart';

void main() {
  group('IniConfig', () {
    test('reads sections, defaults, both separators and continuations', () {
      final config = IniConfig.fromStrings([
        '# leading comment',
        'owner = me',
        '',
        '[server]',
        'host = example.com',
        'port: 8080',
        'motd = first',
        '\tsecond',
        '; another comment',
        '[empty]',
      ]);
      expect(config.defaults(), {'owner': 'me'});
      expect(config.sections(), ['server', 'empty']);
      expect(config.get('server', 'host'), 'example.com');
      expect(config.get('server', 'port'), '8080');
      expect(config.get('server', 'motd'), 'first\nsecond');
      expect(config.options('empty'), isEmpty);
      expect(config.hasOption('server', 'host'), isTrue);
      expect(config.hasOption('server', 'missing'), isFalse);
      expect(config.get('missing', 'host'), isNull);
      expect(config.items('server'), [
        ['host', 'example.com'],
        ['port', '8080'],
        ['motd', 'first\nsecond'],
      ]);
    });

    test('a value keeps a separator after the first', () {
      final config = IniConfig.fromStrings(['[a]', 'url = http://x:1/y=z']);
      expect(config.get('a', 'url'), 'http://x:1/y=z');
    });

    test('a line that is no option is a FormatException naming it', () {
      expect(
        () => IniConfig.fromStrings(['[a]', 'not an option']),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('line 2'),
          ),
        ),
      );
    });

    test('edits and writes back', () {
      final config = IniConfig()
        ..addSection('a')
        ..set('a', 'k', 'v');
      expect(() => config.addSection('a'), throwsArgumentError);
      expect(() => config.set('b', 'k', 'v'), throwsArgumentError);
      final again = IniConfig.fromStrings(config.toString().split('\n'));
      expect(again.get('a', 'k'), 'v');
      expect(config.removeOption('a', 'k'), isTrue);
      expect(config.removeSection('a'), isTrue);
      expect(config.sections(), isEmpty);
    });
  });
}
