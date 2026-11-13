import 'package:test/test.dart';
import 'package:tom_dcli/dcli.dart';

/// @Throwing(ArgumentError)
/// @Throwing(DeleteException)
/// @Throwing(TouchException)
void main() {
  test('simple run', () async {
    await withTempFileAsync((testFile) async {
      'touch $testFile'.run;
    });
  });
}
