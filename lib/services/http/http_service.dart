import 'dart:io';

import 'package:indi_tool/schema/request.dart';

class GenericHttpService {
  Future<HttpClientResponse> sendRequest(IndiHttpRequest indiRequest) async {
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

      final HttpClientResponse response = await request.close();

      // return await response.transform(utf8.decoder).join();
      return response;
    } finally {
      client.close();
      print('Finished request at ${DateTime.now()}');
    }
  }
}
