import 'package:indi_tool/data/source/database.dart';
import 'package:indi_tool/services/http/http_service.dart';
import 'package:indi_tool/services/load_testing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'di_prov.g.dart';

@Riverpod(keepAlive: true)
DriftDb drift(DriftRef ref) {
  return DriftDbInstance.get;
}

@riverpod
GenericHttpService httpService(HttpServiceRef ref) {
  return GenericHttpService();
}

@riverpod
LoadTestingService loadTestingPod(LoadTestingPodRef ref) {
  return LoadTestingService(ref.watch(httpServiceProvider));
}
