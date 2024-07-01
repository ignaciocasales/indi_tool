import 'package:flutter/material.dart';

class BaseTable extends StatelessWidget {
  const BaseTable({super.key, required this.values});

  final List<TableRow> values;

  static const TableRow _headers = TableRow(
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

  @override
  Widget build(BuildContext context) {
    return ListView(
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
            children: [_headers] + values,
          ),
        ),
      ],
    );
  }
}
