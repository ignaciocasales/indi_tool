import 'dart:convert';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:indi_tool/core/domain/models/test_result.dart';

Future<void> export({required final List<TestCaseResult> results}) async {
  var suggestedName = 'test_results.csv';
  final FileSaveLocation? result = await getSaveLocation(
    suggestedName: suggestedName,
    acceptedTypeGroups: <XTypeGroup>[
      const XTypeGroup(
        label: 'CSV',
        extensions: <String>['csv'],
        mimeTypes: <String>['text/csv'],
      ),
    ],
  );

  if (result == null) {
    // Operation was canceled by the user.
    return;
  }

  final csvString = TestCaseResult.toCsv(results);
  final Uint8List fileData = Uint8List.fromList(utf8.encode(csvString));

  const String mimeType = 'text/csv';
  final XFile textFile = XFile.fromData(
    fileData,
    mimeType: mimeType,
    name: suggestedName,
  );

  await textFile.saveTo(result.path);
}
