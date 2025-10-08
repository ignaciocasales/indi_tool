import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/app.dart';
import 'package:indi_tool/consts.dart';
import 'package:indi_tool/core/db/database.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup the database
  DriftDbInstance.setup(
    dbName: kDatabaseName,
    inMemory: false,
    logStatements: false,
  );

  runApp(const ProviderScope(child: MyApp()));
}
