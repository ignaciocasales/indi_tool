import 'dart:io';

import 'package:es_compression/zstd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/app.dart';
import 'package:indi_tool/window.dart';

import 'package:path/path.dart' as p;

void main() {
  // Setup the initial window
  setupWindow();

  // TODO: Encapsulate this in a function / class.
  // TODO: This might break on production.
  if (Platform.isWindows) {
    ZstdCodec.libraryPath = p.normalize(
        p.join(Directory.current.path, 'assets', 'libs', 'eszstd_win64.dll'));
  } else if (Platform.isLinux) {
    // TODO: get the binary for linux (EG: libeszstd.so).
    ZstdCodec.libraryPath = p.normalize(
        p.join(Directory.current.path, 'assets', 'libs', 'TODO'));
  } else {
    throw UnsupportedError('Unsupported platform');
  }

  // Entry point of the app
  runApp(
    // Riverpod app state management
    const ProviderScope(
      // Main app widget
      child: IndiApp(),
    ),
  );
}
