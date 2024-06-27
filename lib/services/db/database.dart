import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:indi_tool/services/db/tables.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  WorkspaceTable,
  TestGroupTable,
  TestScenarioTable,
  IndiHttpRequestTable,
  IndiHttpParamTable,
  IndiHttpHeaderTable,
])
class DriftDb extends _$DriftDb {
  DriftDb({
    required dbName,
    required inMemory,
    required logStatements,
  }) : super(
          _openConnection(
            dbName,
            inMemory: inMemory,
            logStatements: logStatements,
          ),
        );

  @override
  int get schemaVersion => 1;
}

_openConnection(
  String dbName, {
  bool logStatements = false,
  bool inMemory = false,
}) {
  return DatabaseConnection.delayed(Future.sync(() async {
    if (inMemory) {
      return DatabaseConnection(
        NativeDatabase.memory(logStatements: logStatements),
      );
    }
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, "indi_tool", "databases", dbName));
    return DatabaseConnection(NativeDatabase.createInBackground(
      file,
      logStatements: logStatements,
    ));
  }));
}
