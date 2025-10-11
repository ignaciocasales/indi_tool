import 'package:indi_tool/core/domain/models/test_result.dart';

class TestMetrics {
  final int avgResponseTimeMs;
  final int successRatePercent;
  final int totalRequests;
  final int requestsPerSecond;
  final List<Map<String, Object>> statusDistribution; // [{status, count}]
  final List<Map<String, Object>> responseTrend; // [{timestamp, responseTime}]

  const TestMetrics({
    required this.avgResponseTimeMs,
    required this.successRatePercent,
    required this.totalRequests,
    required this.requestsPerSecond,
    required this.statusDistribution,
    required this.responseTrend,
  });

  static const empty = TestMetrics(
    avgResponseTimeMs: 0,
    successRatePercent: 0,
    totalRequests: 0,
    requestsPerSecond: 0,
    statusDistribution: [],
    responseTrend: [],
  );
}

TestMetrics compute(List<TestCaseResult> results) {
  if (results.isEmpty) return TestMetrics.empty;

  final totalResults = results.length;

  var totalResponseTime = 0;
  var successCount = 0;

  DateTime? minTs;
  DateTime? maxTs;

  final statusCountMap = <int, int>{};
  final trend = <Map<String, Object>>[];

  for (final r in results) {
    totalResponseTime += r.responseDurationInMillis;
    if (r.isSuccessStatusCode) successCount += 1;

    statusCountMap.update(
      r.responseStatusCode,
      (v) => v + 1, // if key exists.
      ifAbsent: () => 1, // if key does not exist.
    );

    final ts = DateTime.tryParse(r.responseStartDateTime);
    if (ts != null) {
      if (minTs == null || ts.isBefore(minTs)) minTs = ts;
      if (maxTs == null || ts.isAfter(maxTs)) maxTs = ts;
    }

    trend.add({
      'timestamp': r.responseStartDateTime,
      'responseTime': r.responseDurationInMillis,
    });
  }

  final avg = (totalResponseTime / totalResults).round();
  final successRate = ((successCount / totalResults) * 100).round();

  final durationInSeconds = (minTs != null && maxTs != null)
      ? maxTs.difference(minTs).inSeconds
      : 0;

  final rps = durationInSeconds > 0
      ? (totalResults / durationInSeconds).round()
      : totalResults;

  final statusDistribution =
      statusCountMap.entries
          .map((e) => {'status': e.key, 'count': e.value})
          .toList()
        ..sort((a, b) => (a['status'] as int).compareTo(b['status'] as int));

  trend.sort(
    (a, b) => (a['timestamp'] as String).compareTo(b['timestamp'] as String),
  );

  return TestMetrics(
    avgResponseTimeMs: avg,
    successRatePercent: successRate,
    totalRequests: totalResults,
    requestsPerSecond: rps,
    statusDistribution: statusDistribution,
    responseTrend: trend,
  );
}
