import 'package:indi_tool/services/http/http_method.dart';
import 'package:indi_tool/services/http/http_request.dart';

final List<HttpRequest> kRequestList = [
  HttpRequest(
    id: "0",
    name: "Request 1",
    method: HttpMethod.get,
    url: "https://bored-api.appbrewery.com/random",
    parameters: [
      HttpRequestParameter(
        key: "key1",
        value: "value1",
        enabled: true,
        description: "Some description here",
      ),
      HttpRequestParameter(
        key: "key2",
        value: "value2",
        enabled: true,
        description: "Some other description here",
      ),
    ],
    headers: [
      HttpRequestHeader(
        key: "key1",
        value: "value1",
        enabled: true,
        description: "Some description here",
      ),
      HttpRequestHeader(
        key: "key2",
        value: "value2",
        enabled: true,
        description: "Some other description here",
      ),
    ],
  ),
  HttpRequest(
    id: "1",
    name: "Request 2",
    method: HttpMethod.post,
    url: "https://bored-api.appbrewery.com/post",
    parameters: [],
    headers: [],
    body: "{}",
  ),
  HttpRequest(
    id: "2",
    name: "Request 3",
    method: HttpMethod.put,
    url: "https://bored-api.appbrewery.com/put",
    parameters: [],
    headers: [],
    body: "{}",
  ),
  HttpRequest(
    id: "3",
    name: "Request 4",
    method: HttpMethod.delete,
    url: "https://bored-api.appbrewery.com/delete",
    parameters: [],
    headers: [],
    body: "{}",
  ),
];
