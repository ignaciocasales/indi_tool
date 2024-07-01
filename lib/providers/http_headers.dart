import 'package:indi_tool/models/workspace/indi_http_header.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/providers/repository/repository_prov.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http_headers.g.dart';

@riverpod
class HttpHeaders extends _$HttpHeaders {
  late int _scenarioId;

  @override
  Future<List<IndiHttpHeader>> build({required final int scenarioId}) async {
    _scenarioId = scenarioId;
    final headers = await ref.watch(
        testScenarioProvider(scenarioId: _scenarioId)
            .selectAsync((s) => s.request.headers));
    return List.from(headers, growable: true);
  }

  void enable(final String? id, final bool enabled) async {
    final List<IndiHttpHeader> headers = await ref
        .read(testScenarioProvider(scenarioId: _scenarioId)
            .selectAsync((s) => s.request.headers))
        .then((value) => List.from(value, growable: true));

    final IndiHttpHeader? header =
        headers.where((p) => p.id == id).singleOrNull;

    if (header == null) {
      headers.add(IndiHttpHeader(
        enabled: enabled,
      ));
    } else {
      headers[headers.indexWhere((t) => t.id == id)] =
          header.copyWith(enabled: enabled);
    }

    _onFieldEdited(headers);
  }

  void updateKey(final String? id, final String key) async {
    final List<IndiHttpHeader> headers = await ref
        .read(testScenarioProvider(scenarioId: _scenarioId)
            .selectAsync((s) => s.request.headers))
        .then((value) => List.from(value, growable: true));

    final IndiHttpHeader? header =
        headers.where((p) => p.id == id).singleOrNull;

    if (header == null) {
      if (key.isEmpty) {
        return;
      }

      headers.add(IndiHttpHeader(
        key: key,
      ));
    } else {
      headers[headers.indexWhere((t) => t.id == id)] =
          header.copyWith(key: key);
    }

    _onFieldEdited(headers);
  }

  void updateValue(final String? id, final String value) async {
    final List<IndiHttpHeader> headers = await ref
        .read(testScenarioProvider(scenarioId: _scenarioId)
            .selectAsync((s) => s.request.headers))
        .then((value) => List.from(value, growable: true));

    final IndiHttpHeader? header =
        headers.where((p) => p.id == id).singleOrNull;

    if (header == null) {
      headers.add(IndiHttpHeader(
        value: value,
      ));
    } else {
      headers[headers.indexWhere((t) => t.id == id)] =
          header.copyWith(value: value);
    }

    _onFieldEdited(headers);
  }

  void updateDescription(final String? id, final String description) async {
    final List<IndiHttpHeader> headers = await ref
        .read(testScenarioProvider(scenarioId: _scenarioId)
            .selectAsync((s) => s.request.headers))
        .then((value) => List.from(value, growable: true));

    final IndiHttpHeader? header =
        headers.where((p) => p.id == id).singleOrNull;

    if (header == null) {
      headers.add(IndiHttpHeader(
        description: description,
      ));
    } else {
      headers[headers.indexWhere((t) => t.id == id)] =
          header.copyWith(description: description);
    }

    _onFieldEdited(headers);
  }

  void delete(final String? id) async {
    if (id == null) {
      return;
    }

    final List<IndiHttpHeader> headers = await ref
        .read(testScenarioProvider(scenarioId: _scenarioId)
            .selectAsync((s) => s.request.headers))
        .then((value) => List.from(value, growable: true));

    headers.removeWhere((p) => p.id == id);

    _onFieldEdited(headers);
  }

  void _onFieldEdited(final List<IndiHttpHeader> headers) async {
    final int? groupId = ref.watch(selectedTestGroupProvider);
    final int? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (groupId == null || scenarioId == null) {
      return;
    }

    final TestScenario scenario =
        await ref.watch(testScenarioProvider(scenarioId: scenarioId).future);

    final TestScenario updated = scenario.copyWith(
      request: scenario.request.copyWith(headers: headers),
    );

    ref
        .read(testScenarioRepositoryProvider)
        .updateTestScenario(testScenario: updated, testGroupId: groupId);
  }
}
