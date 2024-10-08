import 'package:indi_tool/models/workspace/indi_http_response.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';
import 'package:indi_tool/providers/di/di_prov.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'load_testing_prov.g.dart';

@riverpod
class LoadTesting extends _$LoadTesting {
  @override
  LoadTestingState build() {
    return LoadTestingState.newWith();
  }

  void startLoadTest(final TestScenario scenario) {
    final service = ref.watch(loadTestingPodProvider);
    if (state.isRunning) {
      return;
    }

    if (state.responses.isNotEmpty) {
      state = state.copyWith(
        responses: List<IndiHttpResponse>.empty(growable: true),
      );
    }

    state = state.copyWith(isRunning: true);
    service.loadTest(scenario).listen((IndiHttpResponse response) {
      state = state.copyWith(responses: [...state.responses, response]);
    }, onDone: () {
      state = state.copyWith(isRunning: false);
    });
  }

  void stopLoadTest() {
    final service = ref.watch(loadTestingPodProvider);
    service.cancelLoadTest();
    state = state.copyWith(isRunning: false);
  }
}

class LoadTestingState {
  LoadTestingState._({
    required this.isRunning,
    required this.responses,
  });

  final bool isRunning;
  final List<IndiHttpResponse> responses;

  factory LoadTestingState.newWith({responses}) {
    return LoadTestingState._(
      isRunning: false,
      responses: responses ?? List<IndiHttpResponse>.empty(growable: true),
    );
  }

  LoadTestingState copyWith({
    bool? isRunning,
    List<IndiHttpResponse>? responses,
  }) {
    return LoadTestingState._(
      isRunning: isRunning ?? this.isRunning,
      responses: responses ?? this.responses,
    );
  }
}
