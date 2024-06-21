import 'package:indi_tool/models/navigation/work_item.dart';

class InvalidWorkItemType implements Exception {
  final WorkItemType type;

  InvalidWorkItemType(this.type);

  @override
  String toString() {
    return 'Invalid work item type: type=$type';
  }
}
