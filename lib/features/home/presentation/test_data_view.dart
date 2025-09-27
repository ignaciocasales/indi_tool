import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/providers/navigation_provider.dart';
import 'package:indi_tool/core/providers/test_case_provider.dart';
import 'package:indi_tool/models/test_case.dart';
import 'package:uuid/uuid.dart';

class TestDataView extends StatelessWidget {
  const TestDataView({super.key});

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
  ConsumerState<TestCaseNameEdit> createState() => _TestCaseNameEditState();
}

class _TestCaseNameEditState extends ConsumerState<TestCaseNameEdit> {
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
  ConsumerState<TestCaseMethodEdit> createState() => _TestCaseMethodEditState();
}

class _TestCaseMethodEditState extends ConsumerState<TestCaseMethodEdit> {
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
  ConsumerState<TestCaseUrlEdit> createState() => _TestCaseUrlEditState();
}

class _TestCaseUrlEditState extends ConsumerState<TestCaseUrlEdit> {
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

    final testCase = ref.watch(selectedTestCaseProvider);

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
  ConsumerState<TestCaseTrigger> createState() => _TestCaseTriggerState();
}

class _TestCaseTriggerState extends ConsumerState<TestCaseTrigger> {
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
  State<TestCaseTabs> createState() => _TestCaseTabsState();
}

class _TestCaseTabsState extends State<TestCaseTabs>
    with TickerProviderStateMixin {
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
  ConsumerState<TestCaseHeadersEdit> createState() =>
      _TestCaseHeadersEditState();
}

class _TestCaseHeadersEditState extends ConsumerState<TestCaseHeadersEdit> {
  String _draftId = const Uuid().v4();

  void _rotateDraftId() {
    setState(() {
      _draftId = const Uuid().v4();
    });
  }

  @override
  Widget build(BuildContext context) {
    final testCase = ref.watch(selectedTestCaseProvider);
    if (testCase == null) throw StateError('No scenario selected');

    final headers = testCase.httpHeaders;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Existing headers
                  ...headers.map(
                    (header) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: TestCaseHeaderEdit(
                        header.id,
                        key: Key('header-row-${testCase.id}-${header.id}'),
                        isDraft: false,
                        onBecameReal: null,
                      ),
                    ),
                  ),
                  // Always one draft row at the end
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TestCaseHeaderEdit(
                      _draftId,
                      key: Key('header-row-${testCase.id}-$_draftId'),
                      isDraft: true,
                      onBecameReal: _rotateDraftId,
                    ),
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
  final bool isDraft; // true for the trailing empty row
  final VoidCallback? onBecameReal; // tell parent to create a new draft

  const TestCaseHeaderEdit(
    this.headerId, {
    super.key,
    this.isDraft = false,
    this.onBecameReal,
  });

  @override
  ConsumerState<TestCaseHeaderEdit> createState() => _TestCaseHeaderEditState();
}

class _TestCaseHeaderEditState extends ConsumerState<TestCaseHeaderEdit> {
  late final TextEditingController _keyController;
  late final TextEditingController _valueController;

  @override
  void initState() {
    _keyController = TextEditingController();
    _valueController = TextEditingController();
    _keyController.addListener(_onChanged);
    _valueController.addListener(_onChanged);
    super.initState();
  }

  @override
  void dispose() {
    _keyController.removeListener(_onChanged);
    _valueController.removeListener(_onChanged);
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _onChanged() {
    final keyText = _keyController.text;
    final valueText = _valueController.text;

    final testCase = ref.read(selectedTestCaseProvider);
    if (testCase == null) return;

    final headers = List<TestCaseHeader>.from(testCase.httpHeaders);
    final index = headers.indexWhere((h) => h.id == widget.headerId);

    // If both empty → remove if exists, else do nothing (still a draft)
    if (keyText.isEmpty && valueText.isEmpty) {
      if (index != -1) {
        headers.removeAt(index);
        ref
            .read(testCaseListProvider.notifier)
            .updateTestCase(testCase.copyWith(httpHeaders: headers));
      }
      return;
    }

    // If any non-empty
    if (index == -1) {
      // Draft becomes real
      headers.add(
        TestCaseHeader(id: widget.headerId, key: keyText, value: valueText),
      );
      ref
          .read(testCaseListProvider.notifier)
          .updateTestCase(testCase.copyWith(httpHeaders: headers));

      // Ask parent to append a fresh draft row (keeps focus in current field)
      widget.onBecameReal?.call();
    } else {
      // Update existing real header
      headers[index] = headers[index].copyWith(key: keyText, value: valueText);
      ref
          .read(testCaseListProvider.notifier)
          .updateTestCase(testCase.copyWith(httpHeaders: headers));
    }
  }

  void _removeHeader() {
    final testCase = ref.read(selectedTestCaseProvider);
    if (testCase == null) return;

    final headers = List<TestCaseHeader>.from(testCase.httpHeaders)
      ..removeWhere((h) => h.id == widget.headerId);

    ref
        .read(testCaseListProvider.notifier)
        .updateTestCase(testCase.copyWith(httpHeaders: headers));

    // Clear the inputs for drafts so they remain as empty placeholders
    if (widget.isDraft) {
      _keyController.clear();
      _valueController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final testCase = ref.watch(selectedTestCaseProvider);
    if (testCase != null) {
      final header = testCase.httpHeaders.firstWhere(
        (h) => h.id == widget.headerId,
        orElse: () => TestCaseHeader(id: widget.headerId, key: '', value: ''),
      );

      if (_keyController.text != header.key) {
        _keyController.text = header.key;
      }
      if (_valueController.text != header.value) {
        _valueController.text = header.value;
      }
    } else {
      throw StateError('No scenario selected');
    }

    return Row(
      children: [
        Expanded(
          child: TextField(
            key: Key('header-key-${testCase.id}-${widget.headerId}'),
            controller: _keyController,
            decoration: const InputDecoration(hintText: 'Header Name'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            key: Key('header-value-${testCase.id}-${widget.headerId}'),
            controller: _valueController,
            decoration: const InputDecoration(hintText: 'Header Value'),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: _removeHeader,
          tooltip: 'Remove header',
        ),
      ],
    );
  }
}

class TestCaseBodyEdit extends ConsumerStatefulWidget {
  const TestCaseBodyEdit({super.key});

  @override
  ConsumerState<TestCaseBodyEdit> createState() => _TestCaseBodyEditState();
}

class _TestCaseBodyEditState extends ConsumerState<TestCaseBodyEdit> {
  late TextEditingController _controller;
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_updateBody);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateBody);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final testCase = ref.watch(selectedTestCaseProvider);
    if (testCase != null) {
      if (!_enabled) {
        setState(() {
          _enabled = true;
        });
      }

      final body = testCase.httpBody;
      if (_controller.text != body) {
        _controller.text = body;
      }
    } else {
      throw StateError('No scenario selected');
    }

    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Request Body',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: TextField(
                  key: Key('body-${testCase.id}'),
                  enabled: _enabled,
                  controller: _controller,
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontFamily: 'SourceCodePro'),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: "Enter request body (JSON, XML, etc.)",
                    hintStyle: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateBody() {
    final String body = _controller.text;

    final testCase = ref.watch(selectedTestCaseProvider);
    if (testCase == null) {
      return;
    }

    final updated = testCase.copyWith(httpBody: body);

    ref.read(testCaseListProvider.notifier).updateTestCase(updated);
  }
}

class TestCaseConfigurationEdit extends ConsumerStatefulWidget {
  const TestCaseConfigurationEdit({super.key});

  @override
  ConsumerState<TestCaseConfigurationEdit> createState() =>
      _TestCaseConfigurationEditState();
}

class _TestCaseConfigurationEditState
    extends ConsumerState<TestCaseConfigurationEdit> {
  late final TextEditingController _timeoutController;
  late final TextEditingController _numberOfRequestsController;
  late final TextEditingController _concurrencyController;
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    _timeoutController = TextEditingController();
    _numberOfRequestsController = TextEditingController();
    _concurrencyController = TextEditingController();
    _timeoutController.addListener(_updateTimeout);
    _numberOfRequestsController.addListener(_updateNumberOfRequests);
    _concurrencyController.addListener(_updateConcurrency);
  }

  @override
  void dispose() {
    _timeoutController.removeListener(_updateTimeout);
    _numberOfRequestsController.removeListener(_updateNumberOfRequests);
    _concurrencyController.removeListener(_updateConcurrency);
    _timeoutController.dispose();
    _numberOfRequestsController.dispose();
    _concurrencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final testCase = ref.watch(selectedTestCaseProvider);
    if (testCase != null) {
      if (!_enabled) {
        setState(() {
          _enabled = true;
        });
      }

      if (_timeoutController.text != testCase.httpTimeoutInMillis.toString()) {
        _timeoutController.text = testCase.httpTimeoutInMillis.toString();
      }
      if (_numberOfRequestsController.text !=
          testCase.numberOfRequests.toString()) {
        _numberOfRequestsController.text = testCase.numberOfRequests.toString();
      }
      if (_concurrencyController.text !=
          testCase.numberOfConcurrentUsers.toString()) {
        _concurrencyController.text = testCase.numberOfConcurrentUsers
            .toString();
      }
    } else {
      throw StateError('No scenario selected');
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Load Test Configuration",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 16),
              _buildNumberInputField(
                label: 'HTTP Timeout (ms)',
                hint: 'e.g., 300',
                controller: _timeoutController,
                testCase: testCase,
                minValue: 0,
                maxValue: 60000,
              ),
              const SizedBox(height: 16),
              _buildNumberInputField(
                label: 'Number of Requests',
                hint: 'e.g., 100',
                controller: _numberOfRequestsController,
                testCase: testCase,
                minValue: 1,
                maxValue: 1000,
              ),
              const SizedBox(height: 16),
              _buildNumberInputField(
                label: 'Number of Concurrent Users',
                hint: 'e.g., 10',
                controller: _concurrencyController,
                testCase: testCase,
                minValue: 1,
                maxValue: 1000,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required TestCase testCase,
    required int minValue,
    required int maxValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        TextField(
          key: Key('$label-${testCase.id}'),
          enabled: _enabled,
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            // Allow only digits
            FilteringTextInputFormatter.digitsOnly,
            TextInputFormatter.withFunction((o, n) {
              // Prevent leading zeros
              if (n.text.isEmpty) {
                return o;
              }

              // Prevent non-numeric input
              final int? newValueInt = int.tryParse(n.text);
              if (newValueInt == null) {
                return o;
              }

              // Enforce min constraints
              if (newValueInt < minValue) {
                return o;
              }

              // Enforce max constraints
              if (newValueInt > maxValue) {
                return o;
              }

              // Accept the new value
              return n;
            }),
          ],
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onLongPress: () {
                    if (controller.text.isEmpty) {
                      return;
                    }

                    int? intValue = int.tryParse(controller.text);
                    if (intValue == null) {
                      return;
                    }

                    controller.text = maxValue.toString();
                  },
                  onTap: () {
                    if (controller.text.isEmpty) {
                      return;
                    }

                    int? intValue = int.tryParse(controller.text);
                    if (intValue == null) {
                      return;
                    }

                    if (intValue >= maxValue) {
                      return;
                    }

                    controller.text = (intValue + 1).toString();
                  },
                  child: const Icon(Icons.arrow_drop_up),
                ),
                GestureDetector(
                  onLongPress: () {
                    if (controller.text.isEmpty) {
                      return;
                    }

                    int? intValue = int.tryParse(controller.text);
                    if (intValue == null) {
                      return;
                    }

                    controller.text = minValue.toString();
                  },
                  onTap: () {
                    if (controller.text.isEmpty) {
                      return;
                    }

                    int? intValue = int.tryParse(controller.text);
                    if (intValue == null) {
                      return;
                    }

                    if (intValue <= minValue) {
                      return;
                    }

                    controller.text = (intValue - 1).toString();
                  },
                  child: const Icon(Icons.arrow_drop_down),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void _updateTimeout() {
    final String text = _timeoutController.text;
    final int? timeout = int.tryParse(text);

    if (timeout == null || timeout < 0) {
      return;
    }

    final testCase = ref.watch(selectedTestCaseProvider);
    if (testCase == null) {
      return;
    }

    final updated = testCase.copyWith(httpTimeoutInMillis: timeout);

    ref.read(testCaseListProvider.notifier).updateTestCase(updated);
  }

  void _updateNumberOfRequests() {
    final String text = _numberOfRequestsController.text;
    final int? numberOfRequests = int.tryParse(text);

    if (numberOfRequests == null || numberOfRequests < 1) {
      return;
    }

    final testCase = ref.watch(selectedTestCaseProvider);
    if (testCase == null) {
      return;
    }

    final updated = testCase.copyWith(numberOfRequests: numberOfRequests);

    ref.read(testCaseListProvider.notifier).updateTestCase(updated);
  }

  void _updateConcurrency() {
    final String text = _concurrencyController.text;
    final int? concurrency = int.tryParse(text);

    if (concurrency == null || concurrency < 1) {
      return;
    }

    final testCase = ref.watch(selectedTestCaseProvider);
    if (testCase == null) {
      return;
    }

    final updated = testCase.copyWith(numberOfConcurrentUsers: concurrency);

    ref.read(testCaseListProvider.notifier).updateTestCase(updated);
  }
}
