import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:indi_tool/consts.dart';
import 'package:window_manager/window_manager.dart';

void setupWindow() async {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();

    await windowManager.ensureInitialized();

    await windowManager.maximize();

    final size = await windowManager.getSize();

    // FIXME
    // final double width = size.width * 0.65;
    final double width = size.width;

    // FIXME
    // final double height = size.height * 0.65;
    final double height = size.height;

    WindowOptions windowOptions = WindowOptions(
      size: Size(width, height),
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
