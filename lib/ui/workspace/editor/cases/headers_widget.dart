import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/providers/dependencies.dart';
import 'package:indi_tool/schema/request_header.dart';
import 'package:indi_tool/schema/test_group.dart';
import 'package:indi_tool/ui/workspace/editor/cases/parameters_widget.dart';

class HeadersWidget extends ConsumerWidget {
  const HeadersWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workItem = ref.watch(selectedWorkItemProvider)!;

    if (workItem.type != WorkItemType.testScenario) {
      // It should not be possible to reach this widget without a test scenario.
      throw Exception('No test scenario selected');
    }

    final TestGroup testGroup = ref.watch(testGroupsProvider.select((value) =>
        value.value
            ?.firstWhere((element) => element.id == workItem.parent!.id)))!;

    final List<IndiHttpHeader> headers =
        testGroup.testScenarios[workItem.id].request.headers;

    final List<TableRow> valueRows = List.generate(
      headers.length + 1,
      (i) {
        final bool isLast = i == headers.length;
        return TableRow(
          children: [
            CheckBoxEditingWidget(
              value: headers.elementAtOrNull(i)?.enabled ?? false,
              onChanged: isLast
                  ? null
                  : (bool? value) {
                      final header = headers.elementAtOrNull(i);

                      if (header == null) {
                        headers.add(IndiHttpHeader.newWith(
                          enabled: value!,
                        ));
                      } else {
                        headers[i] = header.copyWith(enabled: value!);
                      }

                      _onFieldEdited(workItem, testGroup, headers, ref);
                    },
            ),
            CellEditingWidget(
              hint: 'Key',
              text: headers.elementAtOrNull(i)?.key ?? '',
              onChanged: (value) {
                final header = headers.elementAtOrNull(i);

                if (header == null) {
                  headers.add(IndiHttpHeader.newWith(
                    key: value,
                  ));
                } else {
                  headers[i] = header.copyWith(key: value);
                }

                _onFieldEdited(workItem, testGroup, headers, ref);
              },
            ),
            CellEditingWidget(
              hint: 'Value',
              text: headers.elementAtOrNull(i)?.value ?? '',
              onChanged: (value) {
                final header = headers.elementAtOrNull(i);

                if (header == null) {
                  headers.add(IndiHttpHeader.newWith(
                    value: value,
                  ));
                } else {
                  headers[i] = header.copyWith(value: value);
                }

                _onFieldEdited(workItem, testGroup, headers, ref);
              },
            ),
            CellEditingWidget(
              hint: 'Description',
              text: headers.elementAtOrNull(i)?.description ?? '',
              onChanged: (value) {
                final header = headers.elementAtOrNull(i);

                if (header == null) {
                  headers.add(IndiHttpHeader.newWith(
                    description: value,
                  ));
                } else {
                  headers[i] = header.copyWith(description: value);
                }

                _onFieldEdited(workItem, testGroup, headers, ref);
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
                    onPressed: () => {
                      headers.removeAt(i),
                      _onFieldEdited(workItem, testGroup, headers, ref),
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
    WorkItem workItem,
    TestGroup testGroup,
    List<IndiHttpHeader> headers,
    WidgetRef ref,
  ) {
    var original = testGroup.testScenarios[workItem.id];

    var request = original.request;

    testGroup.testScenarios[workItem.id] =
        original.copyWith(request: request.copyWith(headers: headers));

    ref.read(testGroupsProvider.notifier).updateTestGroup(testGroup);
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
