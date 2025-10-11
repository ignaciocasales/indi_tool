import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:indi_tool/consts.dart';
import 'package:indi_tool/core/db/tables.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

part 'database.g.dart';

@DriftDatabase(tables: [TestCasesTable, TestCaseResultsTable])
class DriftDb extends _$DriftDb {
  DriftDb({
    required String dbName,
    required bool inMemory,
    required bool logStatements,
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

DatabaseConnection _openConnection(
  String dbName, {
  bool logStatements = false,
  bool inMemory = false,
}) {
  return DatabaseConnection.delayed(
    Future.sync(() async {
      if (inMemory) {
        return DatabaseConnection(
          NativeDatabase.memory(logStatements: logStatements),
        );
      }

      final dbFolder = await getApplicationDocumentsDirectory();
      final fileName = File(
        p.join(dbFolder.path, kRelativeAppStoragePath, kDatabaseFolder, dbName),
      );

      return DatabaseConnection(
        NativeDatabase.createInBackground(
          fileName,
          logStatements: logStatements,
        ),
      );
    }),
  );
}

class UuidValueConverter extends TypeConverter<UuidValue, String> {
  const UuidValueConverter();

  @override
  UuidValue fromSql(String fromDb) {
    return UuidValue.fromString(fromDb);
  }

  @override
  String toSql(UuidValue value) {
    return value.toString();
  }
}

class TimestampConverter extends TypeConverter<DateTime, int> {
  const TimestampConverter();

  @override
  DateTime fromSql(int fromDb) {
    return DateTime.fromMillisecondsSinceEpoch(fromDb);
  }

  @override
  int toSql(DateTime value) {
    return value.millisecondsSinceEpoch;
  }
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
