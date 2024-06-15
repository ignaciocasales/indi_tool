import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/providers/dependencies.dart';
import 'package:indi_tool/schema/request_param.dart';
import 'package:indi_tool/schema/test_scenario.dart';
import 'package:indi_tool/ui/workspace/editor/cases/http_dropdown.dart';
import 'package:indi_tool/ui/workspace/editor/cases/request_editor_nav.dart';
import 'package:indi_tool/ui/workspace/editor/cases/response_layout.dart';

class CaseLayout extends StatelessWidget {
  const CaseLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: HttpMethodDropdown(),
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: UrlEditingWidget(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilledButton(
                onPressed: () {
                  // Do something
                },
                child: const Row(
                  children: [
                    Text('Start'),
                    Icon(Icons.play_arrow),
                  ],
                ),
              ),
            )
          ],
        ),
        const Divider(
          height: 0,
        ),
        const Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RequestEditorNav(),
              VerticalDivider(),
              ResponseLayout(),
            ],
          ),
        ),
      ],
    );
  }
}

class UrlEditingWidget extends ConsumerStatefulWidget {
  const UrlEditingWidget({super.key});

  @override
  ConsumerState<UrlEditingWidget> createState() => _UrlEditingWidgetState();
}

class _UrlEditingWidgetState extends ConsumerState<UrlEditingWidget> {
  late TextEditingController _urlController;

  @override
  void initState() {
    _urlController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workItem = ref.watch(selectedWorkItemProvider)!;

    final TestScenario testScenario = ref.watch(testGroupsProvider.select(
        (value) => value.value
            ?.firstWhere((element) => element.id == workItem.parent!.id)
            .testScenarios[workItem.id]))!;

    _urlController.text = testScenario.request.url;

    return TextFormField(
      key: Key("url-${workItem.id}"),
      controller: _urlController,
      onChanged: (value) {
        final testGroup = ref.read(testGroupsProvider.select((value) => value
            .value
            ?.firstWhere((element) => element.id == workItem.parent!.id)))!;

        testGroup.testScenarios[workItem.id] = testScenario.copyWith(
          request: testScenario.request.copyWith(url: value),
        );

        final parameters = Uri.parse(value)
            .query
            .split('&')
            .where((element) => element.isNotEmpty)
            .map((param) {
          final List<String> keyValue = param.split('=');

          String key = '';
          final maybeKey = keyValue.elementAtOrNull(0);
          if (maybeKey != null) {
            key = Uri.decodeQueryComponent(maybeKey);
          }

          String value = '';
          final maybeValue = keyValue.elementAtOrNull(1);
          if (maybeValue != null) {
            value = Uri.decodeQueryComponent(maybeValue);
          }

          return IndiHttpParameter.newWith(key: key, value: value);
        });

        for (int i = 0; i < parameters.length; i++) {
          if (i < testScenario.request.parameters.length) {
            // If the index exists in both lists, update the original list
            testScenario.request.parameters[i] =
                testScenario.request.parameters[i].copyWith(
              key: parameters.elementAt(i).key,
              value: parameters.elementAt(i).value,
            );
          } else {
            // If the index is only in the new list, add the item to the original list
            testScenario.request.parameters.add(IndiHttpParameter.newWith(
              key: parameters.elementAt(i).key,
              value: parameters.elementAt(i).value,
            ));
          }
        }

        ref.read(testGroupsProvider.notifier).updateTestGroup(testGroup);
      },
      decoration: const InputDecoration(
        hintText: 'Enter URL',
        border: InputBorder.none,
      ),
    );
  }
}
