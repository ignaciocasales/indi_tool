import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workspace_prov.g.dart';

@Riverpod(keepAlive: true)
class SelectedWorkspace extends _$SelectedWorkspace {
  @override
  int? build() {
    return null;
  }

  Future<void> select(final int id) async {
    state = id;
  }
}
