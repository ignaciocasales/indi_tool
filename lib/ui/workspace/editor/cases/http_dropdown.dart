import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/exceptions/invalid_work_item_type.dart';
import 'package:indi_tool/models/common/http_method.dart';
import 'package:indi_tool/models/navigation/work_item.dart';
import 'package:indi_tool/providers/data/test_scenarios_prov.dart';
import 'package:indi_tool/providers/navigation/work_item_prov.dart';
import 'package:indi_tool/schema/test_scenario.dart';

class HttpMethodDropdown extends ConsumerWidget {
  HttpMethodDropdown({super.key});

  final TextEditingController methodController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workItem = ref.watch(selectedWorkItemProvider)!;

    if (workItem.type != WorkItemType.testScenario) {
      throw InvalidWorkItemType(workItem.type);
    }

    final TestScenario? testScenario =
        ref.watch(testScenariosProvider.select((value) {
      if (value.value == null || value.value!.isEmpty) {
        return null;
      }

      return value.value?.firstWhere((element) => element.id == workItem.id);
    }));

    if (testScenario == null) {
      return const SizedBox();
    }

    final entries = HttpMethod.values.map<DropdownMenuEntry<HttpMethod>>(
      (HttpMethod type) {
        return DropdownMenuEntry<HttpMethod>(
          value: type,
          label: type.name,
        );
      },
    ).toList();

    var selectedMethod = testScenario.request.method;

    methodController.text = selectedMethod.name;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownMenu<HttpMethod>(
          key: Key('method-${testScenario.id}'),
          initialSelection: selectedMethod,
          controller: methodController,
          enableFilter: false,
          requestFocusOnTap: false,
          dropdownMenuEntries: entries,
          onSelected: (HttpMethod? newValue) {
            final TestScenario updated = testScenario.copyWith(
              request: testScenario.request.copyWith(method: newValue!),
            );

            ref
                .read(testScenariosProvider.notifier)
                .updateTestScenario(updated);
          },
          inputDecorationTheme: const InputDecorationTheme(
            border: InputBorder.none,
          )),
    );
  }
}
