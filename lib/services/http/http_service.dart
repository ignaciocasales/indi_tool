import 'dart:io';

import 'package:indi_tool/models/workspace/indi_http_request.dart';
import 'package:indi_tool/models/workspace/indi_http_response.dart';

class GenericHttpService {
  Future<IndiHttpResponse> sendRequest(IndiHttpRequest indiRequest) async {
    print('Sending request to ${indiRequest.url} at ${DateTime.now()}');
    final HttpClient client = HttpClient()
      // Allow self-signed certificates. TODO: This will be a setting per request.
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    try {
      final HttpClientRequest request = await client.openUrl(
        indiRequest.method.name,
        Uri.parse(indiRequest.url),
      );

      indiRequest.headers.where((element) => element.enabled).forEach(
        (header) {
          request.headers.add(header.key, header.value);
        },
      );

      final DateTime start = DateTime.now();
      final HttpClientResponse response = await request.close();

      final double duration =
          DateTime.now().difference(start).inMilliseconds / 1000;

      final bodyBytes = await response.expand((e) => e).toList();

      final Map<String, String> headers = {};
      response.headers.forEach((key, value) {
        headers[key] = value.join(',');
      });

      final indiResponse = IndiHttpResponse(
        method: indiRequest.method,
        status: response.statusCode.toString(),
        startTime: start.toString(),
        duration: duration,
        body: bodyBytes,
        size: bodyBytes.length,
        headers: headers,
      );

      return indiResponse;
    } finally {
      client.close();
      print('Finished request at ${DateTime.now()}');
    }
  }
}
