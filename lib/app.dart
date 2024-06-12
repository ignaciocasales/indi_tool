import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indi_tool/consts.dart';
import 'package:indi_tool/ui/workspace/workspace.dart';

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
      theme: theme,
      home: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: 32,
                    ),
                    color: Theme.of(context).colorScheme.primary,
                    child: const Center(
                      child: Text(kShortAppName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ),
              ],
            ),
            const Expanded(
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
