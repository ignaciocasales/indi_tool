import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/core/application/global_state_provider.dart';
import 'package:intl/intl.dart';

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
        if (results != null && results.isNotEmpty) {
          final totalResults = results.length;
          final totalResponseTime = results
              .map((result) => result.responseDurationInMillis)
              .reduce((a, b) => a + b);
          avgResponseTime = (totalResponseTime / totalResults).round();
          final successCount = results
              .where((result) => result.isSuccessStatusCode)
              .length;
          successRate = ((successCount / totalResults) * 100).round();
          totalRequests = totalResults;
          final firstTimestamp = results
              .map((result) => DateTime.parse(result.responseStartDateTime))
              .reduce((a, b) => a.isBefore(b) ? a : b);
          final lastTimestamp = results
              .map((result) => DateTime.parse(result.responseStartDateTime))
              .reduce((a, b) => a.isAfter(b) ? a : b);
          final durationInSeconds = lastTimestamp
              .difference(firstTimestamp)
              .inSeconds;
          requestsPerSecond = durationInSeconds > 0
              ? (totalResults / durationInSeconds).round()
              : totalResults;
          final statusCountMap = <int, int>{};
          for (var result in results) {
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
              results
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
                                  final totalBars = statusDistribution.length;
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
                                                      statusDistribution
                                                          .length) {
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
                                responseTrend: responseTrend,
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

    // --- Sliding window ---
    final visibleData = responseTrend.length > windowSize
        ? responseTrend.sublist(responseTrend.length - windowSize)
        : responseTrend;

    // --- Convert to chart data ---
    final spots = visibleData.asMap().entries.map((entry) {
      final i = entry.key;
      final e = entry.value;
      return FlSpot(i.toDouble(), (e["responseTime"] as num).toDouble());
    }).toList();

    final values = spots.map((s) => s.y).toList();
    final minY = values.reduce((a, b) => a < b ? a : b);
    final maxY = values.reduce((a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
              width: 1,
            ),
            left: BorderSide(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
              width: 1,
            ),
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
              interval: (visibleData.length / 6).floorToDouble().clamp(1, 10),
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= visibleData.length) {
                  return const SizedBox.shrink();
                }

                final ts = visibleData[index]["timestamp"];
                final date = DateTime.tryParse(ts);
                final formatted = date != null
                    ? DateFormat('HH:mm').format(date)
                    : ts.toString();

                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(formatted, style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              interval: (maxY - minY) / 3,
              getTitlesWidget: (value, meta) => Text(
                "${value.toInt()} ms",
                style: const TextStyle(fontSize: 10),
              ),
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
            barWidth: 2,
            color: Theme.of(context).colorScheme.inversePrimary,
            dotData: const FlDotData(show: true),
            spots: spots,
          ),
        ],
        minY: (minY - 50).clamp(0, double.infinity),
        maxY: maxY + 100,
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => Theme.of(
              context,
            ).colorScheme.inversePrimary.withValues(alpha: 0.85),
            getTooltipItems: (spots) => spots.map((spot) {
              final index = spot.spotIndex;
              if (index < 0 || index >= visibleData.length) return null;
              final data = visibleData[index];
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
      duration: const Duration(milliseconds: 400), // smooth animation
      curve: Curves.easeInOut,
    );
  }
}
