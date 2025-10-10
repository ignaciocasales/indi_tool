import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/application/global_state_provider.dart';
import 'package:indi_tool/core/application/load_runner_provider.dart';
import 'package:indi_tool/core/application/repositories/test_results_repository_provider.dart';
import 'package:indi_tool/core/application/result_buffer_provider.dart';
import 'package:indi_tool/core/application/test_case_metrics.dart';
import 'package:intl/intl.dart';

class TestCaseMetrics extends ConsumerStatefulWidget {
  const TestCaseMetrics({super.key});

  @override
  ConsumerState<TestCaseMetrics> createState() => _TestCaseMetricsState();
}

class _TestCaseMetricsState extends ConsumerState<TestCaseMetrics> {
  var metrics = TestMetrics.empty;

  @override
  Widget build(BuildContext context) {
    final isRunning = ref.watch(isLoadRunnerRunningStateProvider);
    final testCaseId = ref.watch(selectedTestCaseIdProvider);
    if (testCaseId == null) throw StateError('No test case selected');
    final allAsync = isRunning
        ? ref.watch(liveResultsProvider)
        : ref.watch(persistedResultsProvider(testCaseId));

    allAsync.when(
      data: (results) {
        metrics = compute(results);
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
                  "${metrics.avgResponseTimeMs} ms",
                  context,
                ),
                _metricCard(
                  Icons.trending_up_outlined,
                  "Success Rate",
                  "${metrics.successRatePercent}%",
                  context,
                ),
                _metricCard(
                  Icons.list_alt_outlined,
                  "Total Requests",
                  "${metrics.totalRequests}",
                  context,
                ),
                _metricCard(
                  Icons.bolt_outlined,
                  "Requests/sec",
                  "${metrics.requestsPerSecond}",
                  context,
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            // Charts Section
            Flexible(
              flex: 1,
              child: Column(
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
                              child: LayoutBuilder(
                                builder: (context, constrains) {
                                  final totalBars =
                                      metrics.statusDistribution.length;
                                  final availableWidth = constrains.maxWidth;
                                  final barWidth = totalBars > 0
                                      ? ((availableWidth / (totalBars)) * 0.6)
                                            .clamp(8.0, 40.0)
                                      : 10.0;
                                  return BarChart(
                                    BarChartData(
                                      alignment: BarChartAlignment.spaceEvenly,
                                      gridData: const FlGridData(
                                        show: true,
                                        drawVerticalLine: true,
                                        drawHorizontalLine: false,
                                      ),
                                      borderData: FlBorderData(
                                        show: true,
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Theme.of(context)
                                                .dividerColor
                                                .withValues(alpha: 0.4),
                                            width: 1,
                                          ),
                                          left: BorderSide.none,
                                          right: BorderSide.none,
                                          top: BorderSide.none,
                                        ),
                                      ),
                                      titlesData: FlTitlesData(
                                        leftTitles: const AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: false,
                                          ),
                                        ),
                                        rightTitles: const AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: false,
                                          ),
                                        ),
                                        topTitles: const AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: false,
                                          ),
                                        ),
                                        bottomTitles: AxisTitles(
                                          axisNameWidget: const Text(
                                            'HTTP Status Hits',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (value, meta) {
                                              final index = value.toInt();
                                              if (index < 0 ||
                                                  index >=
                                                      metrics
                                                          .statusDistribution
                                                          .length) {
                                                return const SizedBox.shrink();
                                              }
                                              return Text(
                                                metrics
                                                    .statusDistribution[index]["status"]
                                                    .toString(),
                                                maxLines: 1,
                                                softWrap: false,
                                                overflow: TextOverflow.clip,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      barGroups: metrics.statusDistribution
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
                                                      BorderRadius.circular(
                                                        2.0,
                                                      ),
                                                  width: barWidth,
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
                                              (
                                                group,
                                                groupIndex,
                                                rod,
                                                rodIndex,
                                              ) {
                                                final label =
                                                    metrics
                                                        .statusDistribution[group
                                                        .x
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
                                    duration: const Duration(milliseconds: 150),
                                    curve: Curves.easeOutCubic,
                                  );
                                },
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
                              child: ResponseTimeTrendChart(
                                responseTrend: metrics.responseTrend,
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
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    value,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.clip,
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

class ResponseTimeTrendChart extends StatelessWidget {
  final List<Map<String, dynamic>> responseTrend;
  final int windowSize; // how many points to display at once

  const ResponseTimeTrendChart({
    super.key,
    required this.responseTrend,
    this.windowSize = 100,
  });

  @override
  Widget build(BuildContext context) {
    if (responseTrend.isEmpty) {
      return const Center(child: Text("No response data"));
    }

    final visibleData = responseTrend.length > windowSize
        ? responseTrend.sublist(responseTrend.length - windowSize)
        : responseTrend;

    final visibleLen = visibleData.length;

    // X-axis: slide from right to left
    // Map indices so that the last point is at xMax (right edge).
    final int xMax = (visibleLen - 1).clamp(0, windowSize - 1);
    final int xMin = 0;

    final spots = visibleData.asMap().entries.map((entry) {
      final i = entry.key; // 0..visibleLen-1
      final shiftedX = (xMax - (visibleLen - 1 - i))
          .toDouble(); // pushes left as new data comes
      final y = (entry.value["responseTime"] as num).toDouble();
      return FlSpot(shiftedX, y);
    }).toList();

    final values = spots.map((s) => s.y).toList();
    final rawMinY = values.reduce((a, b) => a < b ? a : b);
    final rawMaxY = values.reduce((a, b) => a > b ? a : b);

    double minY = rawMinY;
    double maxY = rawMaxY;
    if (maxY == minY) {
      minY = (minY - 1).clamp(0, double.infinity);
      maxY = maxY + 1;
    }

    // Intervals
    final double bottomInterval = (visibleLen / 6).floorToDouble().clamp(1, 10);
    final bool onlyOne = visibleLen == 1;

    return LineChart(
      LineChartData(
        minX: xMin.toDouble() - (onlyOne ? 1 : 0),
        maxX: xMax.toDouble() + (onlyOne ? 1 : 0),
        minY: (minY - 50).clamp(0, double.infinity),
        maxY: maxY + 100,
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
              width: 1,
            ),
            left: BorderSide.none,
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            axisNameWidget: const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                "Time (HH:mm)",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              ),
            ),
            axisNameSize: 20,
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: bottomInterval,
              getTitlesWidget: (value, meta) {
                // Convert chart X back to visibleData index:
                // value in [xMin..xMax] maps to index = visibleLen - 1 - (xMax - value)
                final idx = (visibleLen - 1 - (xMax - value.toInt()));
                if (idx < 0 || idx >= visibleLen) return const SizedBox.shrink();

                final ts = visibleData[idx]["timestamp"];
                final date = DateTime.tryParse(ts);
                final formatted = date != null
                    ? DateFormat('HH:mm').format(date)
                    : ts.toString();

                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    formatted,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
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
            isCurved: !onlyOne,
            barWidth: 2,
            color: Theme.of(context).colorScheme.inversePrimary,
            dotData: const FlDotData(show: true),
            spots: spots,
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => Theme.of(
              context,
            ).colorScheme.inversePrimary.withValues(alpha: 0.85),
            getTooltipItems: (items) => items.map((spot) {
              // Recover original index
              final idx = (visibleLen - 1 - (xMax - spot.x.toInt()));
              if (idx < 0 || idx >= visibleLen) return null;
              final data = visibleData[idx];
              final time = DateTime.tryParse(data["timestamp"]) != null
                  ? DateFormat(
                      'HH:mm:ss',
                    ).format(DateTime.parse(data["timestamp"]))
                  : data["timestamp"];
              final rt = data["responseTime"];
              return LineTooltipItem(
                "$time\nResponse: $rt ms",
                TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: 11,
                ),
              );
            }).toList(),
          ),
        ),
      ),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutCubic,
    );
  }
}
