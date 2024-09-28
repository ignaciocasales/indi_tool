import 'dart:io';

import 'package:indi_tool/models/common/body_type.dart';
import 'package:indi_tool/models/workspace/indi_http_request.dart';
import 'package:indi_tool/models/workspace/indi_http_response.dart';

class GenericHttpService {
  Future<IndiHttpResponse> sendRequest(
    final IndiHttpRequest indiRequest, {
    final bool sslVerify = true,
  }) async {
    final HttpClient client = HttpClient();

    client.connectionTimeout = Duration(
      milliseconds: indiRequest.timeoutMillis,
    );

    if (!sslVerify) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    }

    try {
      final HttpClientRequest request = await client.openUrl(
        indiRequest.method.name,
        Uri.parse(indiRequest.url),
      );

      indiRequest.headers.where((e) => e.enabled).forEach(
            (header) => request.headers.add(
              Uri.encodeComponent(header.key),
              header.value,
            ),
          );

      switch (indiRequest.bodyType) {
        case BodyType.raw:
          request.add(indiRequest.body);
          break;
        case BodyType.form:
          request.headers.contentType =
              ContentType('application', 'x-www-form-urlencoded');
          request.write(String.fromCharCodes(indiRequest.body));
          break;
        default:
          break;
      }

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
    }
  }
}
