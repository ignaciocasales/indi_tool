import 'package:indi_tool/services/db/sqlite_db.dart';
import 'package:indi_tool/services/http/http_service.dart';
import 'package:indi_tool/services/load_testing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

part 'dependency_prov.g.dart';

@Riverpod(keepAlive: true)
Future<Database> sqlite(SqliteRef ref) async {
  final Database database = await SqliteDb.init();
  return database;
}

@riverpod
GenericHttpService httpService(HttpServiceRef ref) {
  return GenericHttpService();
}

@riverpod
LoadTestingService loadTestingPod(LoadTestingPodRef ref) {
  return LoadTestingService(ref.watch(httpServiceProvider));
}
