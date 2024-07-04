import 'package:drift/drift.dart';

class TestScenarioTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get description => text()();

  IntColumn get numberOfRequests => integer()();

  IntColumn get threadPoolSize => integer()();

  TextColumn get url => text()();

  TextColumn get method => text()();

  TextColumn get bodyType => text()();

  BlobColumn get body => blob()();

  IntColumn get timeoutMillis => integer()();

  BlobColumn get httpParams => blob()();

  BlobColumn get httpHeaders => blob()();
}
