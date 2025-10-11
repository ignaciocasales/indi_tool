import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indi_tool/core/domain/models/test_case.dart';

class TestCaseBodyEdit extends StatefulWidget {
  const TestCaseBodyEdit({
    super.key,
    required this.testCase,
    required this.onChanged,
  });

  final TestCase testCase;
  final void Function(TestCase updated) onChanged;

  @override
  State<TestCaseBodyEdit> createState() => _TestCaseBodyEditState();
}

class _TestCaseBodyEditState extends State<TestCaseBodyEdit> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = widget.testCase.httpBody;
    _controller.addListener(_updateBody);
  }

  @override
  void didUpdateWidget(covariant TestCaseBodyEdit oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newTc = widget.testCase.httpBody;
    final oldTc = oldWidget.testCase;
    if (oldTc.httpBody != newTc) {
      final previousSelection = _controller.selection;
      _controller.value = TextEditingValue(
        text: newTc,
        selection: previousSelection.isValid
            ? previousSelection
            : TextSelection.collapsed(offset: newTc.length),
        composing: TextRange.empty,
      );
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateBody);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  key: Key('body-${widget.testCase.id}'),
                  enabled: true,
                  controller: _controller,
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: GoogleFonts.firaCode().fontFamily,
                  ),
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
    final tc = widget.testCase;
    final newBody = _controller.text;
    if (newBody == tc.httpBody) return;
    widget.onChanged(tc.copyWith(httpBody: newBody));
  }
}
