import 'package:indi_tool/services/db/database.dart';
import 'package:indi_tool/services/http/http_service.dart';
import 'package:indi_tool/services/load_testing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dependency_prov.g.dart';

@Riverpod(keepAlive: true)
DriftDb drift(DriftRef ref) {
  return DriftDb(
    dbName: 'main.db',
    inMemory: false,
    logStatements: false,
  );
}

@riverpod
GenericHttpService httpService(HttpServiceRef ref) {
  return GenericHttpService();
}

@riverpod
LoadTestingService loadTestingPod(LoadTestingPodRef ref) {
  return LoadTestingService(ref.watch(httpServiceProvider));
}
