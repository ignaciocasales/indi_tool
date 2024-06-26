import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common/sqflite_logger.dart';

class SqliteDb {
  SqliteDb._();

  static late final Database _database;

  static Future<Database> init() async {
    // Initialize the sqflite_ffi database factory
    sqfliteFfiInit();

    // Set the default database factory to use sqflite_ffi
    var databaseFactory = databaseFactoryFfi;

    // Enable logging
    // databaseFactory = SqfliteDatabaseFactoryLogger(
    //   databaseFactory,
    //   options: SqfliteLoggerOptions(
    //     type: SqfliteDatabaseFactoryLoggerType.all,
    //   ),
    // );

    // Get a location using path_provider
    final Directory dir = await getApplicationDocumentsDirectory();

    final String dbPath = p.join(dir.path, "databases", "indi.db");

    _database = await databaseFactory.openDatabase(
      dbPath,
    );

    _createTables();

    return Future.value(_database);
  }

  static void _createTables() async {
    await _database.execute('''
      CREATE TABLE IF NOT EXISTS workspaces (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT
      )
    ''');

    await _database.execute('''
      CREATE TABLE IF NOT EXISTS test_groups (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        workspace_id INTEGER,
        FOREIGN KEY (workspace_id) REFERENCES workspaces(id)
      )
    ''');

    await _database.execute('''
      CREATE TABLE IF NOT EXISTS test_scenarios (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        number_of_requests INTEGER,
        thread_pool_size INTEGER,
        test_group_id INTEGER,
        FOREIGN KEY (test_group_id) REFERENCES test_groups(id)
      )
    ''');

    await _database.execute('''
      CREATE TABLE IF NOT EXISTS indi_http_requests (
        id TEXT PRIMARY KEY,
        name TEXT,
        method TEXT,
        url TEXT,
        body TEXT,
        headers TEXT,
        parameters TEXT,
        test_scenario_id INTEGER,
        FOREIGN KEY (test_scenario_id) REFERENCES test_scenarios(id)
      )
    ''');

    await _database.execute('''
      CREATE TABLE IF NOT EXISTS indi_http_params (
        id TEXT PRIMARY KEY,
        name TEXT,
        value TEXT,
        indi_http_request_id INTEGER,
        FOREIGN KEY (indi_http_request_id) REFERENCES indi_http_requests(id)
      )
    ''');

    await _database.execute('''
      CREATE TABLE IF NOT EXISTS indi_http_headers (
        id TEXT PRIMARY KEY,
        name TEXT,
        value TEXT,
        indi_http_request_id INTEGER,
        FOREIGN KEY (indi_http_request_id) REFERENCES indi_http_requests(id)
      )
    ''');
  }
}
