import 'package:flutter/material.dart';
import 'package:indi_tool/consts.dart';

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Welcome to the $kAppName!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Your go-to tool for testing the performance of your web services. Easily create, manage, and analyze load tests to ensure your services are robust and reliable.',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
