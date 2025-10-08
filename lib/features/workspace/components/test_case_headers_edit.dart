import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/domain/models/test_case.dart';
import 'package:indi_tool/core/providers/test_case_provider.dart';
import 'package:uuid/uuid.dart';

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
