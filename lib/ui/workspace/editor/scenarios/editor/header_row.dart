import 'package:flutter/material.dart';

const kHeadersTableRow = TableRow(
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
