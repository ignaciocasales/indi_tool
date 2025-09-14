import 'package:flutter/material.dart';
import 'package:indi_tool/app/consts.dart';
import 'package:indi_tool/views/indi_home_page.dart';

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
