import 'package:flutter/material.dart';
import 'package:indi_tool/core/domain/models/test_case.dart';
import 'package:uuid/uuid.dart';

class TestCaseHeadersEdit extends StatefulWidget {
  const TestCaseHeadersEdit({
    super.key,
    required this.testCase,
    required this.onChanged,
  });

  final TestCase testCase;
  final void Function(TestCase updated) onChanged;

  @override
  State<TestCaseHeadersEdit> createState() => _TestCaseHeadersEditState();
}

class _TestCaseHeadersEditState extends State<TestCaseHeadersEdit> {
  String _draftId = const Uuid().v4();

  void _rotateDraftId() {
    setState(() {
      _draftId = const Uuid().v4();
    });
  }

  @override
  Widget build(BuildContext context) {
    var testCase = widget.testCase;
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
                        testCase: testCase,
                        onChanged: widget.onChanged,
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
                      testCase: testCase,
                      onChanged: widget.onChanged,
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

class TestCaseHeaderEdit extends StatefulWidget {
  final String headerId;
  final bool isDraft; // true for the trailing empty row
  final VoidCallback? onBecameReal; // tell parent to create a new draft

  const TestCaseHeaderEdit(
    this.headerId, {
    super.key,
    required this.testCase,
    required this.onChanged,
    this.isDraft = false,
    this.onBecameReal,
  });

  final TestCase testCase;
  final void Function(TestCase updated) onChanged;

  @override
  State<TestCaseHeaderEdit> createState() => _TestCaseHeaderEditState();
}

class _TestCaseHeaderEditState extends State<TestCaseHeaderEdit> {
  late final TextEditingController _keyController;
  late final TextEditingController _valueController;

  @override
  void initState() {
    super.initState();

    final header = widget.testCase.httpHeaders.firstWhere(
      (h) => h.id == widget.headerId,
      orElse: () => TestCaseHeader(id: widget.headerId, key: '', value: ''),
    );

    _keyController = TextEditingController();
    _keyController.text = header.key;
    _keyController.addListener(_onChanged);

    _valueController = TextEditingController();
    _valueController.text = header.value;
    _valueController.addListener(_onChanged);
  }

  @override
  void didUpdateWidget(covariant TestCaseHeaderEdit oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newTc = widget.testCase;
    final newHeader = newTc.httpHeaders.firstWhere(
      (h) => h.id == widget.headerId,
    );
    final oldTc = oldWidget.testCase;
    final oldHeader = oldTc.httpHeaders.firstWhere(
      (h) => h.id == widget.headerId,
    );
    if (oldHeader.key != newHeader.key) {
      var previousKeyControllerSelection = _keyController.selection;
      _keyController.value = _keyController.value.copyWith(
        text: newHeader.key,
        selection: previousKeyControllerSelection.isValid
            ? previousKeyControllerSelection
            : TextSelection.collapsed(offset: newHeader.key.length),
      );
    }
    if (oldHeader.value != newHeader.value) {
      var previousValueControllerSelection = _valueController.selection;
      _valueController.value = _valueController.value.copyWith(
        text: newHeader.value,
        selection: previousValueControllerSelection.isValid
            ? previousValueControllerSelection
            : TextSelection.collapsed(offset: newHeader.value.length),
      );
    }
  }

  @override
  void dispose() {
    _keyController.removeListener(_onChanged);
    _keyController.dispose();

    _valueController.removeListener(_onChanged);
    _valueController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tc = widget.testCase;
    return Row(
      children: [
        Expanded(
          child: TextField(
            key: Key('header-key-${tc.id}-${widget.headerId}'),
            controller: _keyController,
            decoration: const InputDecoration(hintText: 'Header Name'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            key: Key('header-value-${tc.id}-${widget.headerId}'),
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

  void _onChanged() {
    final keyText = _keyController.text;
    final valueText = _valueController.text;
    final tc = widget.testCase;

    final headers = List<TestCaseHeader>.from(tc.httpHeaders);
    final index = headers.indexWhere((h) => h.id == widget.headerId);

    // If both empty → remove if exists, else do nothing (still a draft)
    if (keyText.isEmpty && valueText.isEmpty) {
      if (index != -1) {
        headers.removeAt(index);
        final updated = tc.copyWith(httpHeaders: headers);
        widget.onChanged(updated);
      }
      return;
    }

    // If any non-empty
    if (index == -1) {
      // Draft becomes real
      headers.add(
        TestCaseHeader(id: widget.headerId, key: keyText, value: valueText),
      );
      final updated = tc.copyWith(httpHeaders: headers);
      widget.onChanged(updated);

      // Ask parent to append a fresh draft row (keeps focus in current field)
      widget.onBecameReal?.call();
    } else {
      // Update existing real header
      headers[index] = headers[index].copyWith(key: keyText, value: valueText);
      final updated = tc.copyWith(httpHeaders: headers);
      widget.onChanged(updated);
    }
  }

  void _removeHeader() {
    final tc = widget.testCase;

    final headers = List<TestCaseHeader>.from(tc.httpHeaders)
      ..removeWhere((h) => h.id == widget.headerId);

    final updated = tc.copyWith(httpHeaders: headers);
    widget.onChanged(updated);

    // Clear the inputs for drafts so they remain as empty placeholders
    if (widget.isDraft) {
      _keyController.clear();
      _valueController.clear();
    }
  }
}
