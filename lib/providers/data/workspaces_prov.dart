import 'package:indi_tool/providers/injection/dependency_prov.dart';
import 'package:indi_tool/schema/workspace.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workspaces_prov.g.dart';

@riverpod
class Workspaces extends _$Workspaces {
  @override
  Future<List<Workspace>> build() async {
    final Isar isar = await ref.read(isarProvider.future);
    return isar.workspaces.where().findAll();
  }

  Future<Workspace> addWorkspace() async {
    final Isar isar = await ref.read(isarProvider.future);

    final workspace = Workspace.newWith(
      id: isar.workspaces.autoIncrement(),
      name: 'New Workspace',
    );

    await isar.write((isar) async {
      isar.workspaces.put(workspace);
    });

    state = AsyncValue.data(isar.workspaces.where().findAll());

    return workspace;
  }

  Future<Workspace> getWorkspace(final int id) async {
    final Isar isar = await ref.read(isarProvider.future);

    return isar.workspaces.get(id)!;
  }

  Future<Workspace> updateWorkspace(final Workspace workspace) async {
    final Isar isar = await ref.read(isarProvider.future);

    await isar.write((isar) async {
      isar.workspaces.put(workspace);
    });

    state = AsyncValue.data(isar.workspaces.where().findAll());

    return workspace;
  }
}
