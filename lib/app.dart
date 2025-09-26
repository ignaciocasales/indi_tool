import 'package:flutter/material.dart';
import 'package:indi_tool/consts.dart';
import 'package:indi_tool/features/home/presentation/indi_home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const IndiHomePage(),
    );
  }
}
