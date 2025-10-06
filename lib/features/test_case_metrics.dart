import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/providers/test_case_provider.dart';
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
    final isRunning = ref.watch(isTestCaseRunningProvider);

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
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Metrics Section
            Row(
              children: [
                _metricCard(
                  Icons.timer_outlined,
                  "Avg. Response Time",
                  "$avgResponseTime ms",
                  context,
                ),
                _metricCard(
                  Icons.trending_up_outlined,
                  "Success Rate",
                  "$successRate%",
                  context,
                ),
                _metricCard(
                  Icons.list_alt_outlined,
                  "Total Requests",
                  "$totalRequests",
                  context,
                ),
                _metricCard(
                  Icons.bolt_outlined,
                  "Requests/sec",
                  "$requestsPerSecond",
                  context,
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            // Charts Section
            Flexible(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            const SizedBox(height: 8.0),
                            Expanded(
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  gridData: const FlGridData(show: false),
                                  borderData: FlBorderData(show: false),
                                  titlesData: FlTitlesData(
                                    leftTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
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
                                              ).colorScheme.inversePrimary,
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                          ],
                                        );
                                      })
                                      .toList(),
                                  barTouchData: BarTouchData(
                                    enabled: true,
                                    touchTooltipData: BarTouchTooltipData(
                                      getTooltipColor: (group) {
                                        return Theme.of(context)
                                            .colorScheme
                                            .inversePrimary
                                            .withValues(alpha: 0.8);
                                      },
                                      getTooltipItem:
                                          (group, groupIndex, rod, rodIndex) {
                                            final label =
                                                statusDistribution[group.x
                                                    .toInt()]["status"];
                                            return BarTooltipItem(
                                              "Status $label\n${rod.toY.toInt()} hits",
                                              TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer,
                                                fontSize: 11,
                                              ),
                                            );
                                          },
                                    ),
                                  ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.show_chart, size: 16.0),
                                SizedBox(width: 6.0),
                                Text("Response Time Trend"),
                              ],
                            ),
                            const SizedBox(height: 12.0),
                            Expanded(
                              child: LineChart(
                                LineChartData(
                                  gridData: const FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                  ),
                                  borderData: FlBorderData(show: false),
                                  titlesData: FlTitlesData(
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 22,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            value.toInt().toString(),
                                            style: const TextStyle(
                                              fontSize: 10,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: 1,
                                        getTitlesWidget: (value, meta) {
                                          final minY = responseTrend
                                              .map(
                                                (e) =>
                                                    (e["responseTime"] as num)
                                                        .toDouble(),
                                              )
                                              .reduce((a, b) => a < b ? a : b);
                                          final maxY = responseTrend
                                              .map(
                                                (e) =>
                                                    (e["responseTime"] as num)
                                                        .toDouble(),
                                              )
                                              .reduce((a, b) => a > b ? a : b);
                                          if (value == minY || value == maxY) {
                                            return Text(
                                              value.toInt().toString(),
                                              style: const TextStyle(
                                                fontSize: 10,
                                              ),
                                            );
                                          }
                                          return const SizedBox.shrink();
                                        },
                                      ),
                                    ),
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  lineBarsData: [
                                    LineChartBarData(
                                      isCurved: true,
                                      barWidth: 1,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.inversePrimary,
                                      dotData: const FlDotData(show: false),
                                      spots: responseTrend.isNotEmpty
                                          ? responseTrend.asMap().entries.map((
                                              entries,
                                            ) {
                                              final i = entries.key;
                                              final e = entries.value;
                                              return FlSpot(
                                                i.toDouble(),
                                                (e["responseTime"] as num)
                                                    .toDouble(),
                                              );
                                            }).toList()
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
                                                .reduce(
                                                  (a, b) => a > b ? a : b,
                                                ) +
                                            100
                                      : 1, // fallback to 1 if empty
                                  lineTouchData: LineTouchData(
                                    enabled: true,
                                    touchTooltipData: LineTouchTooltipData(
                                      getTooltipColor: (group) {
                                        return Theme.of(context)
                                            .colorScheme
                                            .inversePrimary
                                            .withValues(alpha: 0.8);
                                      },
                                      getTooltipItems: (touchedSpots) {
                                        return touchedSpots.map((touchedSpot) {
                                          final index = touchedSpot.spotIndex;
                                          if (index < 0 ||
                                              index >= responseTrend.length) {
                                            return null;
                                          }
                                          final dataPoint =
                                              responseTrend[index];
                                          final timestamp =
                                              dataPoint["timestamp"];
                                          final responseTime =
                                              dataPoint["responseTime"];
                                          return LineTooltipItem(
                                            "$timestamp\nResponse Time: ${responseTime} ms",
                                            TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onPrimaryContainer,
                                              fontSize: 11,
                                            ),
                                          );
                                        }).toList();
                                      },
                                    ),
                                  ),
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
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isRunning
                        ? Row(
                            key: const ValueKey('running'),
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 25.0,
                                height: 25.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Text(
                                "Running tests...",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        : const Column(
                            key: ValueKey('idle'),
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.rocket_launch_sharp,
                                size: 100,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                "Ready to test",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper
  Widget _metricCard(
    IconData icon,
    String label,
    String value,
    BuildContext context,
  ) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(icon, size: 20, color: Colors.grey),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
