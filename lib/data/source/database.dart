import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:indi_tool/consts.dart';
import 'package:indi_tool/data/tables/tables.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  WorkspaceTable,
  TestGroupTable,
  TestScenarioTable,
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

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        // In sqlite3 foreign key references aren't enabled by default.
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}

DatabaseConnection _openConnection(
  String dbName, {
  bool logStatements = false,
  bool inMemory = false,
}) {
  return DatabaseConnection.delayed(
    Future.sync(
      () async {
        if (inMemory) {
          return DatabaseConnection(
            NativeDatabase.memory(logStatements: logStatements),
          );
        }

        final dbFolder = await getApplicationDocumentsDirectory();
        final fileName = File(p.join(
          dbFolder.path,
          kRelativeAppStoragePath,
          kDatabaseFolder,
          dbName,
        ));

        return DatabaseConnection(
          NativeDatabase.createInBackground(
            fileName,
            logStatements: logStatements,
          ),
        );
      },
    ),
  );
}

class DriftDbInstance {
  const DriftDbInstance._();

  static DriftDb? _db;

  static void setup({
    required String dbName,
    required bool inMemory,
    required bool logStatements,
  }) {
    _db = DriftDb(
      dbName: dbName,
      inMemory: inMemory,
      logStatements: logStatements,
    );
  }

  static DriftDb get get {
    if (_db == null) {
      throw Exception('Database not initialized');
    }

    return _db!;
  }
}