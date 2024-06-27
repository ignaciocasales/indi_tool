import 'package:indi_tool/models/workspace/indi_http_request.dart';

class TestScenario {
  TestScenario({
    this.id,
    String? name,
    String? description,
    int? numberOfRequests,
    int? threadPoolSize,
    IndiHttpRequest? request,
  })  : name = name ?? '',
        description = description ?? '',
        numberOfRequests = numberOfRequests ?? 1,
        threadPoolSize = threadPoolSize ?? 1,
        request = request ?? IndiHttpRequest();

  final int? id;
  final String name;
  final String description;
  final int numberOfRequests;
  final int threadPoolSize;
  final IndiHttpRequest request;

  TestScenario copyWith({
    String? name,
    String? description,
    int? numberOfRequests,
    int? threadPoolSize,
    IndiHttpRequest? request,
  }) {
    return TestScenario(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      numberOfRequests: numberOfRequests ?? this.numberOfRequests,
      threadPoolSize: threadPoolSize ?? this.threadPoolSize,
      request: request ?? this.request,
    );
  }
}
