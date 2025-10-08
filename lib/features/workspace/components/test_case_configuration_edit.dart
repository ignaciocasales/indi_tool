import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indi_tool/core/domain/models/test_case.dart';

class TestCaseConfigurationEdit extends StatefulWidget {
  const TestCaseConfigurationEdit({
    super.key,
    required this.testCase,
    required this.onChanged,
  });

  final TestCase testCase;
  final void Function(TestCase updated) onChanged;

  @override
  State<TestCaseConfigurationEdit> createState() =>
      _TestCaseConfigurationEditState();
}

class _TestCaseConfigurationEditState extends State<TestCaseConfigurationEdit> {
  late final TextEditingController _timeoutController;
  late final TextEditingController _numberOfRequestsController;
  late final TextEditingController _concurrencyController;

  @override
  void initState() {
    super.initState();

    var tc = widget.testCase;

    _timeoutController = TextEditingController();
    _timeoutController.text = tc.httpTimeoutInMillis.toString();
    _timeoutController.addListener(_updateTimeout);

    _numberOfRequestsController = TextEditingController();
    _numberOfRequestsController.text = tc.numberOfRequests.toString();
    _numberOfRequestsController.addListener(_updateNumberOfRequests);

    _concurrencyController = TextEditingController();
    _concurrencyController.text = tc.numberOfConcurrentUsers.toString();
    _concurrencyController.addListener(_updateConcurrency);
  }

  @override
  void didUpdateWidget(covariant TestCaseConfigurationEdit oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newTc = widget.testCase;
    var oldTc = oldWidget.testCase;
    if (oldTc.httpTimeoutInMillis != newTc.httpTimeoutInMillis) {
      _timeoutController.text = newTc.httpTimeoutInMillis.toString();
    }
    if (oldTc.numberOfRequests != newTc.numberOfRequests) {
      _numberOfRequestsController.text = newTc.numberOfRequests.toString();
    }
    if (oldTc.numberOfConcurrentUsers != newTc.numberOfConcurrentUsers) {
      _concurrencyController.text = newTc.numberOfConcurrentUsers.toString();
    }
  }

  @override
  void dispose() {
    _timeoutController.removeListener(_updateTimeout);
    _timeoutController.dispose();

    _numberOfRequestsController.removeListener(_updateNumberOfRequests);
    _numberOfRequestsController.dispose();

    _concurrencyController.removeListener(_updateConcurrency);
    _concurrencyController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
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
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 16),
              _buildNumberInputField(
                label: 'HTTP Timeout (ms)',
                hint: 'e.g., 300',
                controller: _timeoutController,
                testCase: widget.testCase,
                minValue: 0,
                maxValue: 60000,
              ),
              const SizedBox(height: 16),
              _buildNumberInputField(
                label: 'Number of Requests',
                hint: 'e.g., 100',
                controller: _numberOfRequestsController,
                testCase: widget.testCase,
                minValue: 1,
                maxValue: 1000,
              ),
              const SizedBox(height: 16),
              _buildNumberInputField(
                label: 'Number of Concurrent Users',
                hint: 'e.g., 10',
                controller: _concurrencyController,
                testCase: widget.testCase,
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
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        TextField(
          key: Key('$label-${testCase.id}'),
          enabled: true,
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
        ),
      ],
    );
  }

  void _updateTimeout() {
    final tc = widget.testCase;
    final String text = _timeoutController.text;
    final int? timeout = int.tryParse(text);
    if (timeout == null || timeout < 0) return;
    final updated = tc.copyWith(httpTimeoutInMillis: timeout);
    widget.onChanged(updated);
  }

  void _updateNumberOfRequests() {
    final tc = widget.testCase;
    final String text = _numberOfRequestsController.text;
    final int? numberOfRequests = int.tryParse(text);
    if (numberOfRequests == null || numberOfRequests < 1) return;
    final updated = tc.copyWith(numberOfRequests: numberOfRequests);
    widget.onChanged(updated);
  }

  void _updateConcurrency() {
    final tc = widget.testCase;
    final String text = _concurrencyController.text;
    final int? concurrency = int.tryParse(text);
    if (concurrency == null || concurrency < 1) return;
    final updated = tc.copyWith(numberOfConcurrentUsers: concurrency);
    widget.onChanged(updated);
  }
}
