import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TestCasePage { requestBuilder, responseViewer, metricsExplorer }

class SelectedTestPageNotifier extends Notifier<TestCasePage?> {
  @override
  TestCasePage? build() {
    return null;
  }

  void select(final TestCasePage page) {
    state = page;
  }

  void clear() {
    state = null;
  }
}

final selectedTestPageProvider =
    NotifierProvider<SelectedTestPageNotifier, TestCasePage?>(
      SelectedTestPageNotifier.new,
    );
