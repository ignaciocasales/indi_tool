import 'package:indi_tool/core/pooled_job.dart';
import 'package:indi_tool/schema/indi_http_request.dart';
import 'package:indi_tool/schema/indi_http_response.dart';
import 'package:indi_tool/services/http/http_service.dart';

class HttpTask extends Task<IndiHttpResponse> {
  final IndiHttpRequest request;
  final GenericHttpService httpService;

  HttpTask(this.request, this.httpService);

  @override
  Future<IndiHttpResponse> execute() async {
    var httpClientResponse = await httpService.sendRequest(request);
    return IndiHttpResponse(httpClientResponse.statusCode.toString());
  }
}
