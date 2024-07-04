import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/providers/services/load_testing_prov.dart';

class ResultsWidget extends ConsumerStatefulWidget {
  const ResultsWidget({super.key});

  @override
  ConsumerState<ResultsWidget> createState() => _ResultsWidgetState();
}

class _ResultsWidgetState extends ConsumerState<ResultsWidget> {
  final ScrollController _scrollController = ScrollController();

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
          child: Scrollbar(
            controller: _scrollController,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: responses.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        responses[index].startTime,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        responses[index].method.name,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        responses[index].status,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${responses[index].duration} ms',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      _ => Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.rocket_launch_rounded,
                size: 80,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const Text('Hit Start to begin'),
            ],
          ),
        ),
    };
  }
}
