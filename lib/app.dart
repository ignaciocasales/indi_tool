import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indi_tool/consts.dart';
import 'package:indi_tool/features/home/presentation/indi_home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = ThemeData(
      fontFamily: GoogleFonts.inter().fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.cyan,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      visualDensity: VisualDensity.compact,
      scrollbarTheme: const ScrollbarThemeData(
        radius: Radius.circular(2),
        thumbVisibility: WidgetStatePropertyAll(true),
        trackVisibility: WidgetStatePropertyAll(false),
        thickness: WidgetStatePropertyAll(kScrollThickness),
      ),
    );
    return MaterialApp(
      title: kAppName,
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const IndiHomePage(),
    );
  }
}
