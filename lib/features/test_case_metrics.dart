import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/providers/test_result_provider.dart';

class TestCaseMetrics extends ConsumerStatefulWidget {
  const TestCaseMetrics({super.key});

  @override
  ConsumerState<TestCaseMetrics> createState() => _TestCaseMetricsState();
}

class _TestCaseMetricsState extends ConsumerState<TestCaseMetrics> {
  var avgResponseTime = 0;
  var successRate = 100;
  var totalRequests = 0;
  var requestsPerSecond = 0;
  var statusDistribution = <Map<String, Object>>[];
  var responseTrend = <Map<String, Object>>[];

  @override
  Widget build(BuildContext context) {
    final asyncResults = ref.watch(selectedTestResultsProvider);

    asyncResults.when(
      data: (results) {
        if (results != null && results.results.isNotEmpty) {
          final totalResults = results.results.length;
          final totalResponseTime = results.results
              .map((result) => result.responseDurationInMillis)
              .reduce((a, b) => a + b);
          avgResponseTime = (totalResponseTime / totalResults).round();
          final successCount = results.results
              .where((result) => result.isSuccessStatusCode)
              .length;
          successRate = ((successCount / totalResults) * 100).round();
          totalRequests = totalResults;
          final firstTimestamp = results.results
              .map((result) => DateTime.parse(result.responseStartDateTime))
              .reduce((a, b) => a.isBefore(b) ? a : b);
          final lastTimestamp = results.results
              .map((result) => DateTime.parse(result.responseStartDateTime))
              .reduce((a, b) => a.isAfter(b) ? a : b);
          final durationInSeconds = lastTimestamp
              .difference(firstTimestamp)
              .inSeconds;
          requestsPerSecond = durationInSeconds > 0
              ? (totalResults / durationInSeconds).round()
              : totalResults;
          final statusCountMap = <int, int>{};
          for (var result in results.results) {
            statusCountMap.update(
              result.responseStatusCode,
              (value) => value + 1,
              ifAbsent: () => 1,
            );
          }
          statusDistribution =
              statusCountMap.entries
                  .map((entry) => {"status": entry.key, "count": entry.value})
                  .toList()
                ..sort(
                  (a, b) => (a["status"] as int).compareTo(b["status"] as int),
                );
        }
      },
      error: (_, _) {},
      loading: () {},
    );

    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Metric Cards
                Row(
                  children: [
                    // Avg. Response Time Card
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.timer_outlined,
                                size: 20.0,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 8.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Avg. Response Time',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '$avgResponseTime ms',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Success Rate Card
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.trending_up_outlined,
                                size: 20,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 8.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Success Rate',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '$successRate%',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Total Requests Card
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.list_alt_outlined,
                                size: 20,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 8.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total Requests',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '$totalRequests',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Requests per second Card
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.bolt_outlined,
                                size: 20,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 8.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Requests/sec',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '$requestsPerSecond',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                // Charts
                Row(
                  children: [
                    // Status Code Distribution Chart
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.bar_chart, size: 16),
                                  SizedBox(width: 6),
                                  Text("Status Code Distribution"),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 150,
                                child: BarChart(
                                  BarChartData(
                                    minY: 0,
                                    maxY: (statusDistribution.isNotEmpty
                                        ? statusDistribution
                                              .map(
                                                (e) => (e["count"] as num)
                                                    .toDouble(),
                                              )
                                              .reduce((a, b) => a > b ? a : b)
                                        : 1), // fallback to 1 if empty
                                    gridData: const FlGridData(
                                      show: true,
                                      drawVerticalLine: false,
                                    ),
                                    borderData: FlBorderData(show: false),
                                    titlesData: const FlTitlesData(show: true),
                                    barGroups: statusDistribution
                                        .map(
                                          (e) => BarChartGroupData(
                                            x: (e["status"] as num).toInt(),
                                            barRods: [
                                              BarChartRodData(
                                                toY: (e["count"] as num)
                                                    .toDouble(),
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Response Time Trend Chart
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.show_chart, size: 16),
                                  SizedBox(width: 6),
                                  Text("Response Time Trend"),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 150,
                                child: LineChart(
                                  LineChartData(
                                    gridData: const FlGridData(
                                      show: true,
                                      drawVerticalLine: false,
                                    ),
                                    titlesData: const FlTitlesData(show: true),
                                    borderData: FlBorderData(show: false),
                                    lineBarsData: [
                                      LineChartBarData(
                                        isCurved: true,
                                        spots: responseTrend
                                            .map(
                                              (e) => FlSpot(
                                                (e["index"] as num).toDouble(),
                                                (e["responseTime"] as num)
                                                    .toDouble(),
                                              ),
                                            )
                                            .toList(),
                                        dotData: const FlDotData(show: false),
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        barWidth: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
