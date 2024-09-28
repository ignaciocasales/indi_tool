import 'package:indi_tool/core/async/task.dart';
import 'package:indi_tool/models/workspace/indi_http_request.dart';
import 'package:indi_tool/models/workspace/indi_http_response.dart';
import 'package:indi_tool/services/http/http_service.dart';

class HttpTask extends Task<IndiHttpResponse> {
  final IndiHttpRequest request;
  final GenericHttpService httpService;

  HttpTask(this.request, this.httpService);

  @override
  Future<IndiHttpResponse> execute() async {
    return await httpService.sendRequest(request, sslVerify: false);
  }
}
