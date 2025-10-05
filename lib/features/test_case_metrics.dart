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
          responseTrend =
              results.results
                  .map(
                    (result) => {
                      "timestamp": result.responseStartDateTime,
                      "responseTime": result.responseDurationInMillis,
                    },
                  )
                  .toList()
                ..sort(
                  (a, b) => (a["timestamp"] as String).compareTo(
                    b["timestamp"] as String,
                  ),
                );
          // Ensure at least one data point for the chart
          if (responseTrend.isEmpty) {
            responseTrend = [
              {"timestamp": "", "responseTime": 0},
            ];
          }
          // Log all values
          print('Avg Response Time: $avgResponseTime ms');
          print('Success Rate: $successRate%');
          print('Total Requests: $totalRequests');
          print('Requests per Second: $requestsPerSecond');
          print('Status Distribution: $statusDistribution');
          print('Response Trend: $responseTrend');
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
                                    alignment: BarChartAlignment.spaceAround,
                                    gridData: const FlGridData(show: false),
                                    borderData: FlBorderData(show: false),
                                    titlesData: FlTitlesData(
                                      leftTitles: const AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                        ),
                                      ),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (value, meta) {
                                            final index = value.toInt();
                                            if (index < 0 ||
                                                index >=
                                                    statusDistribution.length) {
                                              return const SizedBox.shrink();
                                            }
                                            return Text(
                                              statusDistribution[index]["status"]
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 10,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    barGroups: statusDistribution
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                          final i = entry.key;
                                          final e = entry.value;
                                          return BarChartGroupData(
                                            x: i,
                                            barRods: [
                                              BarChartRodData(
                                                toY: (e["count"] as num)
                                                    .toDouble(),
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                            ],
                                          );
                                        })
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
                                    gridData: const FlGridData(show: true),
                                    borderData: FlBorderData(show: false),
                                    titlesData: const FlTitlesData(show: false),
                                    lineBarsData: [
                                      LineChartBarData(
                                        isCurved: true,
                                        barWidth: 2,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        dotData: const FlDotData(show: false),
                                        spots: responseTrend.isNotEmpty
                                            ? responseTrend.asMap().entries.map(
                                                (entries) {
                                                  final i = entries.key;
                                                  final e = entries.value;
                                                  return FlSpot(
                                                    i.toDouble(),
                                                    (e["responseTime"] as num)
                                                        .toDouble(),
                                                  );
                                                },
                                              ).toList()
                                            : [const FlSpot(0, 0)],
                                      ),
                                    ],
                                    minY: 0,
                                    maxY: responseTrend.isNotEmpty
                                        ? responseTrend
                                              .map(
                                                (e) =>
                                                    (e["responseTime"] as num)
                                                        .toDouble(),
                                              )
                                              .reduce((a, b) => a > b ? a : b)
                                        : 1, // fallback to 1 if empty
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
