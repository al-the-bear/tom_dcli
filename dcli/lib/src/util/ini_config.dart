/*
 * Copyright (c) 2025 S. Brett Sutton 2022+
 *
 * This software is licensed under the MIT License.
 * SPDX-License-Identifier: MIT
 */

/// An INI file, as `Parser.iniDecode` reads it.
///
/// The format read:
///
/// * `[section]` starts a section; entries before the first section header
///   belong to the defaults ([defaults]);
/// * `key = value` or `key: value` sets an option, key and value trimmed;
/// * a line that starts with whitespace continues the previous value (joined
///   with a newline);
/// * blank lines, and lines whose first non-blank character is `;` or `#`,
///   are ignored.
///
/// It replaces the `ini` package, whose LGPL-3.0 licence asks that a
/// recipient can relink an application against a modified copy — something
/// an ahead-of-time compiled Dart program does not offer. The method names
/// are the ones `ini`'s `Config` used, so code that called them keeps
/// working.
class IniConfig {
  final Map<String, String> _defaults = {};
  final Map<String, Map<String, String>> _sections = {};

  /// An empty configuration.
  IniConfig();

  /// Reads [lines] as an INI file.
  ///
  /// Throws a [FormatException] naming the line for a line that is neither a
  /// section header, an option, a continuation, a comment nor blank.
  factory IniConfig.fromStrings(List<String> lines) {
    final config = IniConfig();
    var current = config._defaults;
    String? lastKey;
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmed = line.trim();
      if (trimmed.isEmpty ||
          trimmed.startsWith(';') ||
          trimmed.startsWith('#')) {
        continue;
      }
      if (lastKey != null && (line.startsWith(' ') || line.startsWith('\t'))) {
        current[lastKey] = '${current[lastKey]}\n$trimmed';
        continue;
      }
      if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
        final name = trimmed.substring(1, trimmed.length - 1).trim();
        current = config._sections.putIfAbsent(name, () => {});
        lastKey = null;
        continue;
      }
      final separator = _separatorIndex(trimmed);
      if (separator <= 0) {
        throw FormatException(
          'line ${i + 1} is not a section, an option or a comment',
          line,
        );
      }
      lastKey = trimmed.substring(0, separator).trim();
      current[lastKey] = trimmed.substring(separator + 1).trim();
    }
    return config;
  }

  /// The first `=` or `:` in [line], or -1.
  static int _separatorIndex(String line) {
    final equals = line.indexOf('=');
    final colon = line.indexOf(':');
    if (equals < 0) {
      return colon;
    }
    if (colon < 0) {
      return equals;
    }
    return equals < colon ? equals : colon;
  }

  /// The options before the first section header.
  Map<String, String> defaults() => _defaults;

  /// The section names, in the order they first appear.
  Iterable<String> sections() => _sections.keys;

  /// Whether a section named [name] exists.
  bool hasSection(String name) => _sections.containsKey(name);

  /// Adds an empty section named [name].
  ///
  /// Throws an [ArgumentError] when it exists already.
  void addSection(String name) {
    if (_sections.containsKey(name)) {
      throw ArgumentError.value(name, 'name', 'the section exists already');
    }
    _sections[name] = {};
  }

  /// The option names of section [name], or null when there is no such
  /// section.
  Iterable<String>? options(String name) => _sections[name]?.keys;

  /// Whether section [name] has [option].
  bool hasOption(String name, String option) =>
      _sections[name]?.containsKey(option) ?? false;

  /// The value of [option] in section [name], or null.
  String? get(String name, String option) => _sections[name]?[option];

  /// The `[option, value]` pairs of section [name], or null when there is no
  /// such section.
  List<List<String?>>? items(String name) =>
      _sections[name]?.entries.map((e) => <String?>[e.key, e.value]).toList();

  /// Sets [option] in section [name] to [value].
  ///
  /// Throws an [ArgumentError] when the section does not exist.
  void set(String name, String option, String value) {
    final section = _sections[name];
    if (section == null) {
      throw ArgumentError.value(name, 'name', 'no such section');
    }
    section[option] = value;
  }

  /// Removes [option] from [section]; answers whether it was there.
  bool removeOption(String section, String option) =>
      _sections[section]?.remove(option) != null;

  /// Removes [section]; answers whether it was there.
  bool removeSection(String section) => _sections.remove(section) != null;

  /// The configuration written back as INI text.
  @override
  String toString() {
    final out = StringBuffer();
    void write(Map<String, String> options) {
      for (final entry in options.entries) {
        out.writeln(
          '${entry.key} = '
          '${entry.value.replaceAll('\n', '\n\t')}',
        );
      }
    }

    write(_defaults);
    for (final entry in _sections.entries) {
      if (out.isNotEmpty) {
        out.writeln();
      }
      out.writeln('[${entry.key}]');
      write(entry.value);
    }
    return out.toString();
  }
}
