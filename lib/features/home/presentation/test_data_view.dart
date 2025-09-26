import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/providers/navigation_provider.dart';
import 'package:indi_tool/core/providers/test_case_provider.dart';
import 'package:indi_tool/models/test_case.dart';
import 'package:uuid/uuid.dart';

class TestDataView extends StatelessWidget {
  final TestCase test;

  const TestDataView({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    return Row(children: [TestDataSideBar(), TestDataContentArea()]);
  }
}

class TestDataContentArea extends StatelessWidget {
  const TestDataContentArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TestCaseNameEdit(),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TestCaseMethodEdit(),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TestCaseUrlEdit(),
                ),
              ),
              SizedBox(width: 8),
              TestCaseTrigger(),
            ],
          ),
          Expanded(child: TestCaseTabs()),
        ],
      ),
    );
  }
}

class TestDataSideBar extends StatelessWidget {
  const TestDataSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                  ),
                  child: Text(
                    "Views",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TestNavigationButton(
                        'Request Builder',
                        TestPage.requestBuilder,
                      ),
                      TestNavigationButton(
                        'Response Viewer',
                        TestPage.responseViewer,
                      ),
                      TestNavigationButton(
                        'Performance Metrics',
                        TestPage.metricsExplorer,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TestNavigationButton extends ConsumerStatefulWidget {
  final String label;
  final TestPage testPage;

  const TestNavigationButton(this.label, this.testPage, {super.key});

  @override
  ConsumerState<TestNavigationButton> createState() =>
      _TestNavigationButtonState();
}

class _TestNavigationButtonState extends ConsumerState<TestNavigationButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final testPage = ref.watch(selectedTestPageProvider);

    final isSelected = testPage == widget.testPage;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () => {
            ref
                .watch(selectedTestPageProvider.notifier)
                .select(widget.testPage),
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            alignment: Alignment.centerLeft,
            backgroundColor: isSelected
                ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                : theme.colorScheme.onSurface.withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            widget.label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}

class TestCaseNameEdit extends ConsumerStatefulWidget {
  const TestCaseNameEdit({super.key});

  @override
  ConsumerState<TestCaseNameEdit> createState() => _TestCaseNameEdit();
}

class _TestCaseNameEdit extends ConsumerState<TestCaseNameEdit> {
  late TextEditingController _nameController;
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nameController.addListener(_updateName);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateName);
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TestCase? testCase = ref.watch(selectedTestCaseProvider);
    if (testCase != null) {
      if (!_enabled) {
        setState(() {
          _enabled = true;
        });
      }

      if (_nameController.text != testCase.name) {
        _nameController.text = testCase.name;
      }
    } else {
      throw StateError('No scenario selected');
    }

    return TextField(
      key: Key('name-${testCase.id}'),
      enabled: _enabled,
      controller: _nameController,
      style: Theme.of(context).textTheme.titleLarge,
      decoration: const InputDecoration(
        isDense: true,
        border: InputBorder.none,
      ),
    );
  }

  void _updateName() async {
    final String name = _nameController.text;

    if (name.isEmpty) {
      return;
    }

    final TestCase? testCase = ref.watch(selectedTestCaseProvider);

    if (testCase == null) {
      return;
    }

    final TestCase updated = testCase.copyWith(name: name);

    ref.read(testCaseListProvider.notifier).updateTestCase(updated);
  }
}

class TestCaseMethodEdit extends ConsumerStatefulWidget {
  const TestCaseMethodEdit({super.key});

  @override
  ConsumerState<TestCaseMethodEdit> createState() => _TestCaseMethodEdit();
}

class _TestCaseMethodEdit extends ConsumerState<TestCaseMethodEdit> {
  late final TextEditingController _controller;
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_updateMethod);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateMethod);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TestCase? testCase = ref.watch(selectedTestCaseProvider);

    if (testCase != null) {
      if (!_enabled) {
        setState(() {
          _enabled = true;
        });
      }

      if (_controller.text != testCase.httpMethod) {
        _controller.text = testCase.httpMethod;
      }
    } else {
      throw StateError('No scenario selected');
    }

    return DropdownMenu(
      key: Key('http-method-${testCase.id}'),
      enabled: _enabled,
      controller: _controller,
      enableFilter: false,
      requestFocusOnTap: false,
      dropdownMenuEntries: const [
        DropdownMenuEntry(value: 'GET', label: 'GET'),
        DropdownMenuEntry(value: 'POST', label: 'POST'),
        DropdownMenuEntry(value: 'PUT', label: 'PUT'),
        DropdownMenuEntry(value: 'DELETE', label: 'DELETE'),
        DropdownMenuEntry(value: 'PATCH', label: 'PATCH'),
      ],
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
    );
  }

  void _updateMethod() {
    final String method = _controller.text;

    if (method.isEmpty) {
      return;
    }

    final TestCase? testCase = ref.watch(selectedTestCaseProvider);

    if (testCase == null) {
      return;
    }

    final TestCase updated = testCase.copyWith(httpMethod: method);

    ref.read(testCaseListProvider.notifier).updateTestCase(updated);
  }
}

class TestCaseUrlEdit extends ConsumerStatefulWidget {
  const TestCaseUrlEdit({super.key});

  @override
  ConsumerState<TestCaseUrlEdit> createState() => _TestCaseUrlEdit();
}

class _TestCaseUrlEdit extends ConsumerState<TestCaseUrlEdit> {
  late TextEditingController _urlController;
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController();
    _urlController.addListener(_updateUrl);
  }

  @override
  void dispose() {
    _urlController.removeListener(_updateUrl);
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TestCase? testCase = ref.watch(selectedTestCaseProvider);
    if (testCase != null) {
      if (!_enabled) {
        setState(() {
          _enabled = true;
        });
      }

      if (_urlController.text != testCase.httpUrl) {
        _urlController.text = testCase.httpUrl;
      }
    } else {
      throw StateError('No scenario selected');
    }

    return TextFormField(
      key: Key('url-${testCase.id}'),
      enabled: _enabled,
      controller: _urlController,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: const InputDecoration(
        isDense: true,
        hintText: 'Enter request URL',
      ),
    );
  }

  void _updateUrl() {
    final String url = _urlController.text;

    if (url.isEmpty) {
      return;
    }

    final TestCase? testCase = ref.watch(selectedTestCaseProvider);

    if (testCase == null) {
      return;
    }

    final TestCase updated = testCase.copyWith(httpUrl: url);

    ref.read(testCaseListProvider.notifier).updateTestCase(updated);
  }
}

class TestCaseTrigger extends ConsumerStatefulWidget {
  const TestCaseTrigger({super.key});

  @override
  ConsumerState<TestCaseTrigger> createState() => _TestCaseTrigger();
}

class _TestCaseTrigger extends ConsumerState<TestCaseTrigger> {
  @override
  Widget build(BuildContext context) {
    final bool isRunning = ref.watch(isTestCaseRunningProvider);

    return ElevatedButton.icon(
      onPressed: () => {
        ref.watch(isTestCaseRunningProvider.notifier).setRunning(!isRunning),
      },
      icon: Icon(isRunning ? Icons.stop : Icons.play_arrow, size: 16),
      label: Text(isRunning ? 'Stop' : 'Start'),
    );
  }
}

class TestCaseTabs extends StatefulWidget {
  const TestCaseTabs({super.key});

  @override
  State<TestCaseTabs> createState() => _TestCaseTabs();
}

class _TestCaseTabs extends State<TestCaseTabs> with TickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _controller,
          tabs: const [
            Tab(text: 'Headers'),
            Tab(text: 'Body'),
            Tab(text: 'Configuration'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: [
              TestCaseHeadersEdit(),
              TestCaseBodyEdit(),
              TestCaseConfigurationEdit(),
            ],
          ),
        ),
      ],
    );
  }
}

class TestCaseHeadersEdit extends ConsumerStatefulWidget {
  const TestCaseHeadersEdit({super.key});

  @override
  ConsumerState<TestCaseHeadersEdit> createState() => _TestCaseHeadersEdit();
}

class _TestCaseHeadersEdit extends ConsumerState<TestCaseHeadersEdit> {
  @override
  Widget build(BuildContext context) {
    final TestCase? testCase = ref.watch(selectedTestCaseProvider);

    if (testCase == null) {
      throw StateError('No scenario selected');
    }

    final headers = testCase.httpHeaders;

    final isEmpty = headers.isEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  isEmpty
                      ? TestCaseHeaderEdit(Uuid().v4())
                      : Column(
                          children: headers.map((header) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: TestCaseHeaderEdit(header.id),
                            );
                          }).toList(),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TestCaseHeaderEdit extends ConsumerStatefulWidget {
  final String headerId;

  const TestCaseHeaderEdit(this.headerId, {super.key});

  @override
  ConsumerState<TestCaseHeaderEdit> createState() => _TestCaseHeaderEditState();
}

class _TestCaseHeaderEditState extends ConsumerState<TestCaseHeaderEdit> {
  late final TextEditingController _keyController;
  late final TextEditingController _valueController;

  @override
  void initState() {
    super.initState();
    _keyController = TextEditingController();
    _valueController = TextEditingController();
    _keyController.addListener(_updateHeaderKeyOrValue);
    _valueController.addListener(_updateHeaderKeyOrValue);
  }

  @override
  void dispose() {
    _keyController.removeListener(_updateHeaderKeyOrValue);
    _valueController.removeListener(_updateHeaderKeyOrValue);
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TestCase? testCase = ref.watch(selectedTestCaseProvider);

    if (testCase == null) {
      throw StateError('No scenario selected');
    }

    // final header = testCase.httpHeaders[widget.headerKey];
    //
    // if (header == null) {
    //   throw StateError('Header not found');
    // }

    return Row(
      children: [
        Expanded(
          child: TextField(
            key: Key('header-key-${testCase.id}-${widget.headerId}'),
            controller: _keyController,
            decoration: InputDecoration(hintText: 'Header Name'),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: TextField(
            key: Key('header-value-${testCase.id}-${widget.headerId}'),
            controller: _valueController,
            decoration: InputDecoration(hintText: 'Header Value'),
          ),
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => {_removeHeader()},
        ),
      ],
    );
  }

  void _updateHeaderKeyOrValue() {
    final String key = _keyController.text;
    final String value = _valueController.text;

    final TestCase? testCase = ref.watch(selectedTestCaseProvider);

    if (testCase == null) {
      return;
    }

    final updatedHeaders = List<TestCaseHeader>.from(testCase.httpHeaders)
        .map((header) {
      if (header.id == widget.headerId) {
        return header.copyWith(
          key: key,
          value: value,
        );
      }
      return header;
    }).toList(growable: false);

    final TestCase updated = testCase.copyWith(httpHeaders: updatedHeaders);

    ref.read(testCaseListProvider.notifier).updateTestCase(updated);
  }

  void _removeHeader() {
    final TestCase? testCase = ref.watch(selectedTestCaseProvider);

    if (testCase == null) {
      return;
    }

    final updatedHeaders = List<TestCaseHeader>.from(testCase.httpHeaders)
        .where((header) => header.id != widget.headerId)
        .toList(growable: false);

    final TestCase updated = testCase.copyWith(httpHeaders: updatedHeaders);

    ref.read(testCaseListProvider.notifier).updateTestCase(updated);
  }
}

class TestCaseBodyEdit extends ConsumerStatefulWidget {
  const TestCaseBodyEdit({super.key});

  @override
  ConsumerState<TestCaseBodyEdit> createState() => _TestCaseBodyEdit();
}

class _TestCaseBodyEdit extends ConsumerState<TestCaseBodyEdit> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class TestCaseConfigurationEdit extends ConsumerStatefulWidget {
  const TestCaseConfigurationEdit({super.key});

  @override
  ConsumerState<TestCaseConfigurationEdit> createState() =>
      _TestCaseConfigurationEdit();
}

class _TestCaseConfigurationEdit
    extends ConsumerState<TestCaseConfigurationEdit> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
