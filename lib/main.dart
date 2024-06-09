import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indi_tool/consts.dart';
import 'package:indi_tool/screens/workspace/workspace.dart';

void main() {
  runApp(const Indi());
}

class Indi extends StatelessWidget {
  const Indi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      theme: ThemeData(
        fontFamily: GoogleFonts.openSans().fontFamily,
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                FlutterLogo(
                  size: 64,
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  Workspace(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
