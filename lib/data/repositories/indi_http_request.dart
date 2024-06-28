import 'package:indi_tool/data/mapper/indi_http_request.dart';
import 'package:indi_tool/data/source/database.dart';
import 'package:indi_tool/models/common/http_method.dart';
import 'package:indi_tool/models/workspace/indi_http_header.dart';
import 'package:indi_tool/models/workspace/indi_http_param.dart';
import 'package:indi_tool/models/workspace/indi_http_request.dart';
import 'package:rxdart/rxdart.dart';

class IndiHttpRequestRepository {
  const IndiHttpRequestRepository(this._db);

  final DriftDb _db;

  Stream<IndiHttpRequest> watchHttpRequest({
    required final int scenarioId,
  }) {
    var requestStream = _db.managers.indiHttpRequestTable
        .filter((f) => f.testScenario.id(scenarioId))
        .watchSingle();
    var paramsStream = _db.managers.indiHttpParamTable
        .filter((f) => f.indiHttpRequest.testScenario.id(scenarioId))
        .watch();
    var headersStream = _db.managers.indiHttpHeaderTable
        .filter((f) => f.indiHttpRequest.testScenario.id(scenarioId))
        .watch();
    return Rx.combineLatest3(
      requestStream,
      paramsStream,
      headersStream,
      (
        IndiHttpRequestTableData request,
        List<IndiHttpParamTableData> params,
        List<IndiHttpHeaderTableData> headers,
      ) {
        return IndiHttpRequestMapper.fromEntry(request, params, headers);
        return IndiHttpRequest(
          id: request.id,
          method: HttpMethod.fromString(request.method),
          url: request.url,
          body: request.body,
          parameters: params.map((e) {
            return IndiHttpParam(
              id: e.id,
              key: e.key,
              value: e.value,
              enabled: e.enabled,
              description: e.description,
            );
          }).toList(),
          headers: headers.map((e) {
            return IndiHttpHeader(
              id: e.id,
              key: e.key,
              value: e.value,
              enabled: e.enabled,
              description: e.description,
            );
          }).toList(),
        );
      },
    );
  }
}
