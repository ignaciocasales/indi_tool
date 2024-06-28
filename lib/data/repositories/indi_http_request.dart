import 'package:indi_tool/data/mapper/indi_http_request.dart';
import 'package:indi_tool/data/source/database.dart';
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
      },
    );
  }
}
