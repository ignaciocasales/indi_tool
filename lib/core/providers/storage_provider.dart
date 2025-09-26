import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/consts.dart';
import 'package:path/path.dart';
import 'package:riverpod_sqflite/riverpod_sqflite.dart';
import 'package:sqflite/sqflite.dart';

final storageProvider = FutureProvider<JsonSqFliteStorage>((ref) async {
  return JsonSqFliteStorage.open(join(await getDatabasesPath(), kDatabaseName));
});
