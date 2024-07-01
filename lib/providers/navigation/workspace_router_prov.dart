import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workspace_router_prov.g.dart';

@Riverpod(keepAlive: true)
class SelectedWorkspace extends _$SelectedWorkspace {
  @override
  int? build() {
    return null;
  }

  void select(final int id) {
    state = id;
  }

  void clear() {
    state = null;
  }
}

@riverpod
class SelectedTestGroup extends _$SelectedTestGroup {
  @override
  int? build() {
    return null;
  }

  void select(final int id) {
    state = id;
  }

  void clear() {
    state = null;
  }
}

@riverpod
class SelectedTestScenario extends _$SelectedTestScenario {
  @override
  int? build() {
    return null;
  }

  void select(final int id) {
    state = id;
  }

  void clear() {
    state = null;
  }
}
