import 'package:indi_tool/data/source/database.dart';
import 'package:indi_tool/models/workspace/workspace.dart';

class WorkspaceListMapper {
  const WorkspaceListMapper._();

  static Workspace fromEntry(final WorkspaceTableData entry) {
    return Workspace(
      id: entry.id,
      name: entry.name,
      description: entry.description,
    );
  }

  static List<Workspace> fromEntries(final List<WorkspaceTableData> entries) {
    return entries.map(fromEntry).toList();
  }
}
