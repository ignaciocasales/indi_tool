import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:indi_tool/providers/dependencies.dart';

import 'package:indi_tool/schema/request_param.dart';
import 'package:indi_tool/schema/test_group.dart';

class ParametersWidget extends ConsumerWidget {
  const ParametersWidget({super.key});

  void _onFieldEdited(
    WorkItem workItem,
    TestGroup testGroup,
    List<IndiHttpParameter> parameters,
    WidgetRef ref,
  ) {
    var original = testGroup.testScenarios[workItem.id];

    var request = original.request;

    testGroup.testScenarios[workItem.id] =
        original.copyWith(request: request.copyWith(parameters: parameters));

    String query = '';
    for (var param in parameters) {
      if (param.enabled == false) {
        continue;
      }

      if (param.key.isEmpty) {
        continue;
      }

      query += param.key;

      if (param.value.isNotEmpty) {
        query += '=${param.value}';
      }

      if (parameters.indexOf(param) < parameters.length - 1) {
        query += '&';
      }
    }

    var updatedUri = Uri.parse(request.url).replace(query: query).toString();

    if (parameters.where((e) => e.enabled).isEmpty) {
      if (updatedUri.endsWith('?')) {
        updatedUri = updatedUri.substring(0, updatedUri.length - 1);
      }
    }

    testGroup.testScenarios[workItem.id] =
        testGroup.testScenarios[workItem.id].copyWith(
      request: testGroup.testScenarios[workItem.id].request
          .copyWith(url: updatedUri),
    );

    ref.read(testGroupsProvider.notifier).updateTestGroup(testGroup);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workItem = ref.watch(selectedWorkItemProvider)!;
    final TestGroup testGroup = ref.watch(testGroupsProvider.select((value) =>
        value.value
            ?.firstWhere((element) => element.id == workItem.parent!.id)))!;

    final List<IndiHttpParameter> parameters =
        testGroup.testScenarios[workItem.id].request.parameters;

    const TableRow headerRow = TableRow(
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

    final List<TableRow> valueRows = List.generate(
      parameters.length + 1,
      (i) {
        final bool isLast = i == parameters.length;
        return TableRow(
          key: ValueKey(i),
          children: [
            CheckBoxEditingWidget(
              value: parameters.elementAtOrNull(i)?.enabled ?? false,
              onChanged: isLast
                  ? null
                  : (bool? value) {
                      final param = parameters.elementAtOrNull(i);

                      if (param == null) {
                        parameters.add(IndiHttpParameter.newWith(
                          enabled: value!,
                        ));
                      } else {
                        parameters[i] = param.copyWith(enabled: value!);
                      }

                      _onFieldEdited(workItem, testGroup, parameters, ref);
                    },
            ),
            CellEditingWidget(
              hint: 'Key',
              text: parameters.elementAtOrNull(i)?.key ?? '',
              onChanged: (value) {
                final param = parameters.elementAtOrNull(i);

                if (param == null) {
                  if (value.isEmpty) {
                    return;
                  }

                  parameters.add(IndiHttpParameter.newWith(
                    key: value,
                  ));
                } else {
                  parameters[i] = param.copyWith(key: value);
                }

                _onFieldEdited(workItem, testGroup, parameters, ref);
              },
            ),
            CellEditingWidget(
              hint: 'Value',
              text: parameters.elementAtOrNull(i)?.value ?? '',
              onChanged: (value) {
                final param = parameters.elementAtOrNull(i);

                if (param == null) {
                  if (value.isEmpty) {
                    return;
                  }

                  parameters.add(IndiHttpParameter.newWith(
                    value: value,
                  ));
                } else {
                  parameters[i] = param.copyWith(value: value);
                }

                _onFieldEdited(workItem, testGroup, parameters, ref);
              },
            ),
            CellEditingWidget(
                hint: 'Description',
                text: parameters.elementAtOrNull(i)?.description ?? '',
                onChanged: (value) {
                  final param = parameters.elementAtOrNull(i);

                  if (param == null) {
                    if (value.isEmpty) {
                      return;
                    }

                    parameters.add(IndiHttpParameter.newWith(
                      description: value,
                    ));
                  } else {
                    parameters[i] = param.copyWith(description: value);
                  }

                  _onFieldEdited(workItem, testGroup, parameters, ref);
                }),
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
                      parameters.removeAt(i);

                      _onFieldEdited(workItem, testGroup, parameters, ref);
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
              children: [headerRow] + valueRows,
            ),
          ),
        ],
      ),
    );
  }
}

class CellEditingWidget extends ConsumerStatefulWidget {
  const CellEditingWidget({
    required this.hint,
    required this.text,
    required this.onChanged,
    super.key,
  });

  final String hint;
  final String text;
  final void Function(String) onChanged;

  @override
  ConsumerState<CellEditingWidget> createState() => _CellEditingWidgetState();
}

class _CellEditingWidgetState extends ConsumerState<CellEditingWidget> {
  final _uniqueKey = UniqueKey();
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.text);
    _controller.addListener(_onCellEdited);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onCellEdited);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CellEditingWidget old) {
    super.didUpdateWidget(old);
    if (old.text != widget.text) {
      _controller.text = widget.text;
    }
  }

  void _onCellEdited() {
    widget.onChanged(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: Key('${widget.hint}-${_uniqueKey.toString()}'),
      controller: _controller,
      decoration: InputDecoration(
        hintText: widget.hint,
        isDense: true,
        contentPadding: const EdgeInsets.all(8.0),
        border: InputBorder.none,
      ),
    );
  }
}

class CheckBoxEditingWidget extends StatelessWidget {
  CheckBoxEditingWidget({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final void Function(bool?)? onChanged;
  final _uniqueKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      key: Key('enabled-${_uniqueKey.toString()}'),
      value: value,
      onChanged: onChanged,
    );
  }
}
