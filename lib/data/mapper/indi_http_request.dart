import 'package:indi_tool/data/mapper/indi_http_header.dart';
import 'package:indi_tool/data/mapper/indi_http_param.dart';
import 'package:indi_tool/data/source/database.dart';
import 'package:indi_tool/models/common/http_method.dart';
import 'package:indi_tool/models/workspace/indi_http_request.dart';

class IndiHttpRequestMapper {
  const IndiHttpRequestMapper._();

  static IndiHttpRequest fromEntry(
    final IndiHttpRequestTableData entry,
    final List<IndiHttpParamTableData> params,
    final List<IndiHttpHeaderTableData> headers,
  ) {
    return IndiHttpRequest(
      id: entry.id,
      method: HttpMethod.fromString(entry.method),
      url: entry.url,
      body: entry.body,
      parameters: IndiHttpParamMapper.fromEntries(params),
      headers: IndiHttpHeaderMapper.fromEntries(headers),
    );
  }
}
