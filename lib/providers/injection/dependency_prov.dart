import 'package:indi_tool/schema/workspace.dart';
import 'package:indi_tool/services/http/http_service.dart';
import 'package:indi_tool/services/load_testing.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dependency_prov.g.dart';

@riverpod
Future<Isar> isar(IsarRef ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open(
    schemas: [WorkspaceSchema],
    directory: dir.path,
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
