import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/providers/dependencies.dart';
import 'package:indi_tool/schema/http_method.dart';
import 'package:indi_tool/schema/test_group.dart';

class HttpMethodDropdown extends ConsumerWidget {
  HttpMethodDropdown({super.key});

  final TextEditingController methodController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workItem = ref.watch(selectedWorkItemProvider)!;
    final TestGroup testGroup = ref.watch(testGroupsProvider.select((value) =>
        value.value
            ?.firstWhere((element) => element.id == workItem.parent!.id)))!;

    final entries = HttpMethod.values.map<DropdownMenuEntry<HttpMethod>>(
      (HttpMethod type) {
        return DropdownMenuEntry<HttpMethod>(
          value: type,
          label: type.name,
        );
      },
    ).toList();

    var selectedMethod = testGroup.testScenarios[workItem.id].request.method;

    methodController.text = selectedMethod.name;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownMenu<HttpMethod>(
          key: Key('method-${testGroup.id}'),
          initialSelection: selectedMethod,
          controller: methodController,
          enableFilter: false,
          requestFocusOnTap: false,
          dropdownMenuEntries: entries,
          onSelected: (HttpMethod? newValue) {
            var original = testGroup.testScenarios[workItem.id];

            var request = original.request;

            testGroup.testScenarios[workItem.id] =
                original.copyWith(request: request.copyWith(method: newValue!));

            ref.read(testGroupsProvider.notifier).updateTestGroup(testGroup);
          },
          inputDecorationTheme: const InputDecorationTheme(
            border: InputBorder.none,
          )),
    );
  }
}
