import 'package:indi_tool/schema/indi_http_header.dart';
import 'package:indi_tool/schema/indi_http_param.dart';
import 'package:indi_tool/schema/indi_http_request.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

part 'test_scenario.g.dart';

@embedded
class TestScenario {
  TestScenario({
    required this.id,
    required this.name,
    this.description = '',
    this.numberOfRequests = 1,
    this.threadPoolSize = 1,
    required this.request,
  });

  final String id;
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

  static TestScenario newWith({
    String? name,
    String? description,
    int? numberOfRequests,
    int? threadPoolSize,
    IndiHttpRequest? request,
  }) {
    return TestScenario(
      id: const Uuid().v4(),
      name: name ?? '',
      description: description ?? '',
      numberOfRequests: numberOfRequests ?? 1,
      threadPoolSize: threadPoolSize ?? 1,
      request: request ?? IndiHttpRequest.newWith(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestScenario &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          numberOfRequests == other.numberOfRequests &&
          threadPoolSize == other.threadPoolSize &&
          request == other.request;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      numberOfRequests.hashCode ^
      threadPoolSize.hashCode ^
      request.hashCode;
}
