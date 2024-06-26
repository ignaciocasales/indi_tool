import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workspace_router_prov.g.dart';

@Riverpod(keepAlive: true)
class SelectedWorkspace extends _$SelectedWorkspace {
  @override
  String? build() {
    return null;
  }

  void select(final String id) {
    state = id;
  }

  void clear() {
    state = null;
  }
}

@riverpod
class SelectedTestGroup extends _$SelectedTestGroup {
  @override
  String? build() {
    return null;
  }

  void select(final String id) {
    state = id;
  }

  void clear() {
    state = null;
  }
}

@riverpod
class SelectedTestScenario extends _$SelectedTestScenario {
  @override
  String? build() {
    return null;
  }

  void select(final String id) {
    state = id;
  }

  void clear() {
    state = null;
  }
}
