import 'package:indi_tool/services/http/http_request.dart';
import 'package:indi_tool/services/http/requests_db.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
List<IndiHttpRequest> requestList(RequestListRef ref) {
  return kRequestList;
}

@riverpod
class SelectedRequest extends _$SelectedRequest {
  @override
  IndiHttpRequest? build() {
    return null;
  }

  void select(IndiHttpRequest request) {
    state = request;
  }

  IndiHttpRequest? get() {
    return state;
  }

  void updateQueryParameters(List<IndiHttpParameter> parameters) {
    if (state == null) {
      return;
    }

    state!.parameters = parameters;
  }

  void removeQueryParam(int index) {
    if (state == null) {
      return;
    }

    if (state!.parameters == null) {
      return;
    }

    state!.parameters!.removeAt(index);
  }
}
