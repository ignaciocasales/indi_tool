import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/services/http/http_request.dart';

class ParametersWidget extends ConsumerStatefulWidget {
  const ParametersWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ParametersWidgetState();
}

class _ParametersWidgetState extends ConsumerState<ParametersWidget> {
  Key _key = UniqueKey();

  void _generateNewKey() {
    setState(() {
      _key = UniqueKey();
    });
  }

  void _removeQueryParam(int index) {
    /*ref.read(selectedRequestProvider.notifier).removeQueryParam(index);*/

    _generateNewKey();
  }

  void _onFieldEdited(
    List<IndiHttpParameter> parameters,
    bool isLast,
  ) {
    if (isLast) {
      parameters.add(IndiHttpParameter.newEmpty());
    }

    /*ref
        .read(selectedRequestProvider.notifier)
        .updateQueryParameters(parameters);*/

    _generateNewKey();
  }

  @override
  Widget build(BuildContext context) {
    /*final selectedRequest = ref.watch(selectedRequestProvider);*/
    const selectedRequest = null;

    final List<IndiHttpParameter> parameters = selectedRequest?.parameters ?? [];

    if (parameters.isEmpty) {
      parameters.add(IndiHttpParameter.newEmpty());
      /*ref
          .read(selectedRequestProvider.notifier)
          .updateQueryParameters(parameters);*/
    }

    if (parameters.last.hasValue()) {
      parameters.add(IndiHttpParameter.newEmpty());
    }

    const TableRow headerRow = TableRow(
      children: [
        Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(""),
        ),
        Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(
            "Key",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(
            "Value",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(
            "Description",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(""),
        ),
      ],
    );

    final List<TableRow> valueRows = List.generate(
      parameters.length,
      (i) {
        final bool isLast = i == parameters.length - 1;
        return TableRow(
          children: [
            Checkbox(
              key: Key("enabled-${parameters[i].hashCode}-${_key.toString()}"),
              value: parameters[i].enabled,
              onChanged: isLast
                  ? null
                  : (bool? value) {
                      parameters[i] = parameters[i].copyWith(enabled: value!);

                      _onFieldEdited(parameters, isLast);
                    },
            ),
            TextFormField(
              key: Key("key-${parameters[i].hashCode}-${_key.toString()}"),
              initialValue: parameters[i].key,
              decoration: const InputDecoration(
                hintText: 'Key',
                isDense: true,
                contentPadding: EdgeInsets.all(8.0),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                parameters[i] = parameters[i].copyWith(key: value);

                _onFieldEdited(parameters, isLast);
              },
            ),
            TextFormField(
              key: Key("value-${parameters[i].hashCode}-${_key.toString()}"),
              initialValue: parameters[i].value,
              decoration: const InputDecoration(
                hintText: 'Value',
                isDense: true,
                contentPadding: EdgeInsets.all(8.0),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                parameters[i] = parameters[i].copyWith(value: value);

                _onFieldEdited(parameters, isLast);
              },
            ),
            TextFormField(
              key: Key("desc-${parameters[i].hashCode}-${_key.toString()}"),
              initialValue: parameters[i].description,
              decoration: const InputDecoration(
                hintText: 'Description',
                isDense: true,
                contentPadding: EdgeInsets.all(8.0),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                parameters[i] = parameters[i].copyWith(description: value);

                _onFieldEdited(parameters, isLast);
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
                    onPressed: () => _removeQueryParam(i),
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
