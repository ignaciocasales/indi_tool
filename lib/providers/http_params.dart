import 'package:indi_tool/models/workspace/indi_http_param.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/providers/repository/repository_prov.dart';
import 'package:indi_tool/services/url_builder.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http_params.g.dart';

@riverpod
class HttpParams extends _$HttpParams {
  late int _scenarioId;

  @override
  Future<List<IndiHttpParam>> build({required final int scenarioId}) async {
    _scenarioId = scenarioId;
    final parameters = await ref.watch(
        testScenarioProvider(scenarioId: _scenarioId)
            .selectAsync((s) => s.request.parameters));
    return List.from(parameters, growable: true);
  }

  void enable(final String? id, final bool enabled) async {
    final List<IndiHttpParam> parameters = await ref
        .read(testScenarioProvider(scenarioId: _scenarioId)
            .selectAsync((s) => s.request.parameters))
        .then((value) => List.from(value, growable: true));

    final IndiHttpParam? param =
        parameters.where((p) => p.id == id).singleOrNull;

    if (param == null) {
      parameters.add(IndiHttpParam(
        enabled: enabled,
      ));
    } else {
      parameters[parameters.indexWhere((t) => t.id == id)] =
          param.copyWith(enabled: enabled);
    }

    _onFieldEdited(parameters);
  }

  void updateKey(final String? id, final String key) async {
    final List<IndiHttpParam> parameters = await ref
        .read(testScenarioProvider(scenarioId: _scenarioId)
            .selectAsync((s) => s.request.parameters))
        .then((value) => List.from(value, growable: true));

    final IndiHttpParam? param =
        parameters.where((p) => p.id == id).singleOrNull;

    if (param == null) {
      if (key.isEmpty) {
        return;
      }

      parameters.add(IndiHttpParam(
        key: key,
      ));
    } else {
      parameters[parameters.indexWhere((t) => t.id == id)] =
          param.copyWith(key: key);
    }

    _onFieldEdited(parameters);
  }

  void updateValue(final String? id, final String value) async {
    final List<IndiHttpParam> parameters = await ref
        .read(testScenarioProvider(scenarioId: _scenarioId)
            .selectAsync((s) => s.request.parameters))
        .then((value) => List.from(value, growable: true));

    final IndiHttpParam? param =
        parameters.where((p) => p.id == id).singleOrNull;

    if (param == null) {
      if (value.isEmpty) {
        return;
      }

      parameters.add(IndiHttpParam(
        value: value,
      ));
    } else {
      parameters[parameters.indexWhere((t) => t.id == id)] =
          param.copyWith(value: value);
    }

    _onFieldEdited(parameters);
  }

  void updateDescription(final String? id, final String description) async {
    final List<IndiHttpParam> parameters = await ref
        .read(testScenarioProvider(scenarioId: _scenarioId)
            .selectAsync((s) => s.request.parameters))
        .then((value) => List.from(value, growable: true));

    final IndiHttpParam? param =
        parameters.where((p) => p.id == id).singleOrNull;

    if (param == null) {
      if (description.isEmpty) {
        return;
      }

      parameters.add(IndiHttpParam(
        description: description,
      ));
    } else {
      parameters[parameters.indexWhere((t) => t.id == id)] =
          param.copyWith(description: description);
    }

    _onFieldEdited(parameters);
  }

  void delete(final String? id) async {
    if (id == null) {
      return;
    }

    final List<IndiHttpParam> parameters = await ref
        .read(testScenarioProvider(scenarioId: _scenarioId)
            .selectAsync((s) => s.request.parameters))
        .then((value) => List.from(value, growable: true));

    parameters.removeWhere((p) => p.id == id);

    _onFieldEdited(parameters);
  }

  void _onFieldEdited(final List<IndiHttpParam> parameters) async {
    final int? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (scenarioId == null) {
      return;
    }

    final TestScenario testScenario =
        await ref.read(testScenarioProvider(scenarioId: scenarioId).future);

    final String updatedUri = UrlBuilder.syncWithParameters(
      testScenario.request.url,
      parameters,
    );

    final TestScenario updated = testScenario.copyWith(
      request: testScenario.request.copyWith(
        url: updatedUri,
        parameters: parameters,
      ),
    );

    ref
        .read(testScenarioRepositoryProvider)
        .updateTestScenario(testScenario: updated);
  }
}
