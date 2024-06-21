import 'package:indi_tool/models/navigation/work_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'work_item_prov.g.dart';

@riverpod
class SelectedWorkItem extends _$SelectedWorkItem {
  @override
  WorkItem? build() {
    return null;
  }

  void select(final WorkItem workItem) {
    state = workItem;
  }
}
