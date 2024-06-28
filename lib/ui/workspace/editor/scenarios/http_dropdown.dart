import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/models/common/http_method.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';
import 'package:indi_tool/providers/repository/repository_prov.dart';

class HttpMethodDropdown extends ConsumerWidget {
  HttpMethodDropdown({super.key});

  final TextEditingController _controller = TextEditingController();

  final List<DropdownMenuEntry<HttpMethod>> _entries =
      HttpMethod.values.map<DropdownMenuEntry<HttpMethod>>(
    (HttpMethod type) {
      return DropdownMenuEntry<HttpMethod>(
        value: type,
        label: type.name,
      );
    },
  ).toList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int? groupId = ref.watch(selectedTestGroupProvider);

    if (groupId == null) {
      throw StateError('No group selected');
    }

    final int? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (scenarioId == null) {
      throw StateError('No scenario selected');
    }

    final AsyncValue<TestScenario> asyncScenario =
        ref.watch(testScenarioProvider(scenarioId: scenarioId));

    return asyncScenario.when(
      data: (scenario) {
        return _buildMenu(
          method: scenario.request.method.name,
          key: Key('method-${scenario.id}'),
          onSelected: (HttpMethod? newValue) {
            final TestScenario updated = scenario.copyWith(
              request: scenario.request.copyWith(method: newValue!),
            );

            ref.read(testScenarioRepositoryProvider).updateTestScenario(
                  testScenario: updated,
                  testGroupId: groupId,
                );
          },
        );
      },
      error: (err, st) {
        return _buildMenu(method: '', key: UniqueKey(), onSelected: (_) {});
      },
      loading: () {
        return _buildMenu(method: '', key: UniqueKey(), onSelected: (_) {});
      },
    );
  }

  Widget _buildMenu({
    required final String method,
    required final Key key,
    required final Function(HttpMethod?) onSelected,
  }) {
    if (_controller.text != method) {
      _controller.text = method;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownMenu<HttpMethod>(
        key: key,
        controller: _controller,
        enableFilter: false,
        requestFocusOnTap: false,
        dropdownMenuEntries: _entries,
        onSelected: onSelected,
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none,
        ),
      ),
    );
  }
}
