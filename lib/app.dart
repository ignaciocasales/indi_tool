import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indi_tool/consts.dart';
import 'package:indi_tool/ui/home.dart';

class IndiApp extends StatelessWidget {
  const IndiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      fontFamily: GoogleFonts.openSans().fontFamily,
      colorSchemeSeed: Colors.deepPurple,
      useMaterial3: true,
      brightness: Brightness.dark,
      visualDensity: VisualDensity.compact,
    );

    return MaterialApp(
      title: kAppName,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: theme,
      theme: theme,
      home: const Home(),
    );
  }
}
