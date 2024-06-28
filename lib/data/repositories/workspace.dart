import 'package:indi_tool/data/mapper/workspace.dart';
import 'package:indi_tool/data/source/database.dart';
import 'package:indi_tool/models/workspace/workspace.dart';

class WorkspaceRepository {
  const WorkspaceRepository(this._db);

  final DriftDb _db;

  Stream<List<Workspace>> watchWorkspaceList() {
    return _db.managers.workspaceTable.watch().map((d) {
      return WorkspaceListMapper.fromEntries(d);
    });
  }

  Future<int> createWorkspaceEntry({
    final String name = '',
    final String description = '',
  }) async {
    return await _db.managers.workspaceTable.create((o) => o(
          name: name,
          description: description,
        ));
  }

  Future<bool> updateWorkspaceEntry({
    required final int id,
    final String name = '',
    final String description = '',
  }) async {
    return await _db.managers.workspaceTable.replace(WorkspaceTableData(
      id: id,
      name: name,
      description: description,
    ));
  }

  Future<int> deleteWorkspaceEntry({required final int id}) async {
    return await _db.managers.workspaceTable.filter((f) => f.id(id)).delete();
  }
}
