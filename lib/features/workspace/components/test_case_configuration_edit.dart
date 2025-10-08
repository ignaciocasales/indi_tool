import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/domain/models/test_case.dart';
import 'package:indi_tool/core/providers/test_case_provider.dart';

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
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
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
        ),
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
