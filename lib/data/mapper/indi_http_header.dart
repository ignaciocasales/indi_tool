import 'package:indi_tool/data/source/database.dart';
import 'package:indi_tool/models/workspace/indi_http_header.dart';

class IndiHttpHeaderMapper {
  const IndiHttpHeaderMapper._();

  static IndiHttpHeader fromEntry(final IndiHttpHeaderTableData entry) {
    return IndiHttpHeader(
      id: entry.id,
      key: entry.key,
      value: entry.value,
      description: entry.description,
      enabled: entry.enabled,
    );
  }

  static List<IndiHttpHeader> fromEntries(
    final List<IndiHttpHeaderTableData> entries,
  ) {
    return entries.map(fromEntry).toList();
  }
}
