import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/providers/data/test_scenarios_prov.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/schema/indi_http_header.dart';
import 'package:indi_tool/schema/test_scenario.dart';
import 'package:indi_tool/ui/workspace/editor/scenarios/parameters_widget.dart';

class HeadersWidget extends ConsumerWidget {
  const HeadersWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (scenarioId == null) {
      return const SizedBox();
    }

    final AsyncValue<TestScenario> asyncScenario =
        ref.watch(testScenarioProvider(scenarioId));

    final List<IndiHttpHeader> headers = asyncScenario.maybeWhen(
      data: (scenario) => scenario.request.headers,
      orElse: () => [],
    );

    final List<TableRow> valueRows = List.generate(
      headers.length + 1,
      (i) {
        final bool isLast = i == headers.length;
        return TableRow(
          key: ValueKey(i),
          children: [
            CheckBoxEditingWidget(
              value: headers.elementAtOrNull(i)?.enabled ?? false,
              onChanged: isLast
                  ? null
                  : (bool? value) {
                      final header = headers.elementAtOrNull(i);

                      if (header == null) {
                        headers.add(IndiHttpHeader(
                          enabled: value!,
                        ));
                      } else {
                        headers[i] = header.copyWith(enabled: value!);
                      }

                      _onFieldEdited(headers, ref);
                    },
            ),
            CellEditingWidget(
              hint: 'Key',
              text: headers.elementAtOrNull(i)?.key ?? '',
              onChanged: (value) {
                final header = headers.elementAtOrNull(i);

                if (header == null) {
                  if (value.isEmpty) {
                    return;
                  }

                  headers.add(IndiHttpHeader(
                    key: value,
                  ));
                } else {
                  headers[i] = header.copyWith(key: value);
                }

                _onFieldEdited(headers, ref);
              },
            ),
            CellEditingWidget(
              hint: 'Value',
              text: headers.elementAtOrNull(i)?.value ?? '',
              onChanged: (value) {
                final header = headers.elementAtOrNull(i);

                if (header == null) {
                  if (value.isEmpty) {
                    return;
                  }

                  headers.add(IndiHttpHeader(
                    value: value,
                  ));
                } else {
                  headers[i] = header.copyWith(value: value);
                }

                _onFieldEdited(headers, ref);
              },
            ),
            CellEditingWidget(
              hint: 'Description',
              text: headers.elementAtOrNull(i)?.description ?? '',
              onChanged: (value) {
                final header = headers.elementAtOrNull(i);

                if (header == null) {
                  if (value.isEmpty) {
                    return;
                  }

                  headers.add(IndiHttpHeader(
                    description: value,
                  ));
                } else {
                  headers[i] = header.copyWith(description: value);
                }

                _onFieldEdited(headers, ref);
              },
            ),
            isLast
                ? const SizedBox()
                : IconButton(
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8.0),
                    icon: const Icon(
                      Icons.delete_outline_sharp,
                      size: 16,
                    ),
                    onPressed: () {
                      headers.removeAt(i);

                      _onFieldEdited(headers, ref);
                    },
                  )
          ],
        );
      },
    );

    return Expanded(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              columnWidths: const {
                0: FixedColumnWidth(40),
                1: FlexColumnWidth(),
                2: FlexColumnWidth(),
                3: FlexColumnWidth(),
                4: FixedColumnWidth(40),
              },
              border: TableBorder.all(
                color: Theme.of(context).colorScheme.secondary,
              ),
              children: [kHeadersTableRow] + valueRows,
            ),
          ),
        ],
      ),
    );
  }

  void _onFieldEdited(
    List<IndiHttpHeader> headers,
    WidgetRef ref,
  ) async {
    final String? groupId = ref.watch(selectedTestGroupProvider);
    final String? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (groupId == null || scenarioId == null) {
      return;
    }

    final TestScenario scenario =
        await ref.watch(testScenarioProvider(scenarioId).future);

    final TestScenario updated = scenario.copyWith(
      request: scenario.request.copyWith(headers: headers),
    );

    ref.read(testScenariosProvider(groupId).notifier).updateScenario(updated);
  }
}

// TODO: This could be reused in the parameters widget.
var kHeadersTableRow = const TableRow(
  children: [
    Padding(
      padding: EdgeInsets.all(4.0),
      child: Text(''),
    ),
    Padding(
      padding: EdgeInsets.all(4.0),
      child: Text(
        'Key',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    Padding(
      padding: EdgeInsets.all(4.0),
      child: Text(
        'Value',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    Padding(
      padding: EdgeInsets.all(4.0),
      child: Text(
        'Description',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    Padding(
      padding: EdgeInsets.all(4.0),
      child: Text(''),
    ),
  ],
);
