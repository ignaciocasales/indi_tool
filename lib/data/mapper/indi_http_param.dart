import 'package:indi_tool/data/source/database.dart';
import 'package:indi_tool/models/workspace/indi_http_param.dart';

class IndiHttpParamMapper {
  const IndiHttpParamMapper._();

  static IndiHttpParam fromEntry(final IndiHttpParamTableData entry) {
    return IndiHttpParam(
      id: entry.id,
      key: entry.key,
      value: entry.value,
      description: entry.description,
      enabled: entry.enabled,
    );
  }

  static List<IndiHttpParam> fromEntries(
    final List<IndiHttpParamTableData> entries,
  ) {
    return entries.map(fromEntry).toList();
  }
}
