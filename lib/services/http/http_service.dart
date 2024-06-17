import 'dart:convert';
import 'dart:io';

import 'package:indi_tool/schema/test_scenario.dart';

class GenericHttpService {
  Future<String> sendRequest(TestScenario testScenario) async {
    final HttpClient client = HttpClient()
      // Allow self-signed certificates. TODO: This will be a setting per request.
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    try {
      final Uri uri = Uri.parse(testScenario.request.url);

      var method = testScenario.request.method.name;

      final HttpClientRequest request = await client.openUrl(
        method,
        uri,
      );

      testScenario.request.headers.where((element) => element.enabled).forEach(
        (header) {
          request.headers.add(header.key, header.value);
        },
      );

      final HttpClientResponse response = await request.close();

      return await response.transform(utf8.decoder).join();
    } finally {
      client.close();
    }
  }
}
