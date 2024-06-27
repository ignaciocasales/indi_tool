import 'package:indi_tool/models/common/http_method.dart';

class IndiHttpResponse {
  IndiHttpResponse({
    required this.method,
    required this.status,
    required this.startTime,
    required this.duration,
    this.body = const [],
    this.size = 0,
    this.headers = const {},
  });

  final HttpMethod method;
  final String status;
  final String startTime;
  final double duration;
  final List<int> body;
  final int size;
  final Map<String, String> headers;
}
