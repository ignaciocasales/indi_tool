import 'package:drift/drift.dart';
import 'package:indi_tool/core/db/converters.dart';
import 'package:uuid/uuid.dart';

class TestCasesTable extends Table {
  TextColumn get id => text()
      .clientDefault(() => const Uuid().v4())
      .map(const UuidValueConverter())();

  TextColumn get name => text()();

  TextColumn get description => text()();

  TextColumn get httpMethod => text()();

  TextColumn get httpUrl => text()();

  BlobColumn get httpBody => blob()();

  IntColumn get httpTimeoutInMillis => integer()();

  BlobColumn get httpHeaders => blob()();

  BlobColumn get httpParams => blob()();

  IntColumn get numberOfRequests => integer()();

  IntColumn get numberOfConcurrentUsers => integer()();

  IntColumn get createdAt => integer().map(const TimestampConverter())();

  IntColumn get updatedAt => integer().map(const TimestampConverter())();
}

class TestCaseResultsTable extends Table {
  TextColumn get id => text()
      .clientDefault(() => const Uuid().v4())
      .map(const UuidValueConverter())();

  TextColumn get testCaseId => text().map(const UuidValueConverter())();

  TextColumn get requestMethod => text()();

  TextColumn get requestUrl => text()();

  IntColumn get responseStatusCode => integer().nullable()();

  IntColumn get responseDurationInMillis => integer().nullable()();

  IntColumn get responseBodySizeInBytes => integer().nullable()();

  IntColumn get startTimestamp => integer().map(const TimestampConverter())();

  IntColumn get endTimestamp => integer().map(const TimestampConverter())();

  BlobColumn get responseHeaders => blob().nullable()();

  IntColumn get createdAt => integer().map(const TimestampConverter())();

  IntColumn get updatedAt => integer().map(const TimestampConverter())();
}
