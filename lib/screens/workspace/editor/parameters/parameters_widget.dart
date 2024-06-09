import 'package:flutter/material.dart';
import 'package:indi_tool/screens/workspace/editor/parameters/parameter.dart';

class ParametersWidget extends StatefulWidget {
  const ParametersWidget({super.key});

  @override
  State<ParametersWidget> createState() => _ParametersWidgetState();
}

class _ParametersWidgetState extends State<ParametersWidget> {
  List<Parameter> parameters = [Parameter()];

  void _addQueryParam() {
    setState(() {
      parameters.add(Parameter());
    });
  }

  bool _canBeRemoved(int index) {
    if (parameters.length <= 1) {
      return false;
    }

    if (parameters.length == index + 1) {
      return false;
    }

    return true;
  }

  void _removeQueryParam(int index) {
    setState(() {
      parameters.removeAt(index);
    });
  }

  void _onFieldEdited(int index) {
    if (index == parameters.length - 1) {
      _addQueryParam();
    }
  }

  @override
  Widget build(BuildContext context) {
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
              children: [
                const TableRow(
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
                ),
                for (int i = 0; i < parameters.length; i++)
                  TableRow(
                    children: [
                      Checkbox(
                        value: parameters[i].isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            parameters[i].isChecked = value!;
                          });
                        },
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Key',
                          isDense: true,
                          contentPadding: EdgeInsets.all(8.0),
                          border: InputBorder.none,
                        ),
                        controller: parameters[i].keyController,
                        onChanged: (value) => _onFieldEdited(i),
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Value',
                          isDense: true,
                          contentPadding: EdgeInsets.all(8.0),
                          border: InputBorder.none,
                        ),
                        controller: parameters[i].valueController,
                        onChanged: (value) => _onFieldEdited(i),
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Description',
                          isDense: true,
                          contentPadding: EdgeInsets.all(8.0),
                          border: InputBorder.none,
                        ),
                        controller: parameters[i].descriptionController,
                        onChanged: (value) => _onFieldEdited(i),
                      ),
                      _canBeRemoved(i)
                          ? IconButton(
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(8.0),
                              icon: const Icon(
                                Icons.delete_outline_sharp,
                                size: 16,
                              ),
                              onPressed: () => _removeQueryParam(i),
                            )
                          : const SizedBox(),
                    ],
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
