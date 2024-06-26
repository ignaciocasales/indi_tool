import 'package:indi_tool/providers/injection/dependency_prov.dart';
import 'package:indi_tool/schema/workspace.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

part 'workspaces_prov.g.dart';

@riverpod
class Workspaces extends _$Workspaces {
  @override
  Future<List<Workspace>> build() async {
    final Database db = await ref.watch(sqliteProvider.future);
    return await _getAllWorkspaces(db);
  }

  Future<Workspace> addWorkspace(final Workspace workspace) async {
    final Database db = await ref.watch(sqliteProvider.future);

    await db.insert(
      Workspace.tableName,
      workspace.toInsert(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    state = AsyncValue.data(await _getAllWorkspaces(db));

    return workspace;
  }

  Future<Workspace> getWorkspace(final String id) async {
    final Database db = await ref.watch(sqliteProvider.future);

    return await db.query(
      Workspace.tableName,
      where: 'id = ?',
      whereArgs: [id],
    ).then((v) {
      return Workspace.fromJson(v.first);
    });
  }

  Future<Workspace> updateWorkspace(final Workspace workspace) async {
    final Database db = await ref.watch(sqliteProvider.future);

    await db.update(
      Workspace.tableName,
      workspace.toInsert(),
      where: 'id = ?',
      whereArgs: [workspace.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    state = AsyncValue.data(await _getAllWorkspaces(db));

    return workspace;
  }

  Future<List<Workspace>> _getAllWorkspaces(final Database db) async {
    return await db.query(Workspace.tableName).then((v) {
      return v.map((e) => Workspace.fromJson(e)).toList();
    });
  }
}
