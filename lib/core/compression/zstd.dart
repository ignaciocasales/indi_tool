import 'dart:io';

import 'package:es_compression/zstd.dart';
import 'package:path/path.dart' as p;

class Zstd {
  const Zstd._();

  /// Setup the Zstd library for the current platform.
  static void setup() {
    // TODO: This might break on production.
    if (Platform.isWindows) {
      ZstdCodec.libraryPath = _buildPath('zstd-1_5_4-win64.dll');
    } else if (Platform.isLinux) {
      ZstdCodec.libraryPath = _buildPath('zstd-1_5_4-linux64.so');
    } else if (Platform.isMacOS) {
      ZstdCodec.libraryPath = _buildPath('zstd-1_5_4-mac64.dylib');
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String _buildPath(final String binName) {
    return p.normalize(
      p.join(Directory.current.path, 'assets', 'libs', 'zstd', binName),
    );
  }
}
