import 'package:indi_tool/schema/request.dart';
import 'package:indi_tool/schema/request_header.dart';
import 'package:indi_tool/schema/request_param.dart';
import 'package:indi_tool/schema/test_group.dart';
import 'package:indi_tool/schema/test_scenario.dart';
import 'package:isar/isar.dart';

part 'workspace.g.dart';

@collection
class Workspace {
  Workspace({
    required this.id,
    required this.name,
    this.description = '',
    required this.testGroups,
  });

  final int id;
  final String name;
  final String description;
  final List<TestGroup> testGroups;

  static Workspace newWith({
    required int id,
    String? name,
    String? description,
    List<TestGroup>? testGroups,
  }) {
    return Workspace(
      id: id,
      name: name ?? '',
      description: description ?? '',
      testGroups: testGroups ?? List<TestGroup>.empty(growable: true),
    );
  }
}
