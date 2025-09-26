import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppPage {
  home,
  details,
}

final navigationProvider = Provider<AppPage>((ref) {
  return AppPage.home;
});

enum TestPage {
  requestBuilder,
  responseViewer,
  metricsExplorer,
}

class SelectedTestPage extends Notifier<TestPage?> {
  @override
  TestPage? build() {
    return null;
  }

  void select(final TestPage page) {
    state = page;
  }

  void clear() {
    state = null;
  }
}

final selectedTestPageProvider =
    NotifierProvider<SelectedTestPage, TestPage?>(SelectedTestPage.new);