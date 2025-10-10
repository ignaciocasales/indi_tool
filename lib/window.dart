import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:indi_tool/consts.dart';
import 'package:window_manager/window_manager.dart';

void setupWindow() async {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    await windowManager.ensureInitialized();

    final size = Platform.isWindows
        ? const Size(
            // On Windows, we need to add some extra width to account for window borders
            kMinScreenWidth + 16,
            // On Windows, we need to add some extra height to account for window title bar and borders
            kMinScreenHeight + kToolbarHeight + 40,
          )
        : const Size(kMinScreenWidth, kMinScreenHeight + kToolbarHeight);

    WindowOptions windowOptions = WindowOptions(
      size: size,
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: kAppName,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
}
