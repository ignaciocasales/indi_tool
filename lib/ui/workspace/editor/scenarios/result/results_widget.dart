import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/providers/services/load_testing_prov.dart';

class ResultsWidget extends ConsumerStatefulWidget {
  const ResultsWidget({super.key});

  @override
  ConsumerState<ResultsWidget> createState() => _ResultsWidgetState();
}

class _ResultsWidgetState extends ConsumerState<ResultsWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LoadTestingState lts = ref.watch(loadTestingProvider);
    return switch (lts) {
      LoadTestingState(:final responses) when responses.isNotEmpty => Expanded(
          child: ListView.builder(
            itemCount: responses.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  title: Row(
                children: [
                  Text(
                    responses[index].startTime,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    responses[index].method.name,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    responses[index].status,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${responses[index].duration} ms',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ));
            },
          ),
        ),
      _ => const Expanded(
          child: Center(
            child: Text('No results yet. Run a test to see results.'),
          ),
        ),
    };
  }
}
