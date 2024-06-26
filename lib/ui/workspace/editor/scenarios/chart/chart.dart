import 'dart:async';

import 'package:flutter/material.dart';
import 'package:indi_tool/ui/workspace/editor/scenarios/chart/line_chart_view.dart';

class ChartWidget extends StatefulWidget {
  const ChartWidget({super.key});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  final _heightChart = 250.0;
  final _refreshChart$ = StreamController<Key>();

  @override
  void initState() {
    super.initState();
    _refreshChart$.add(UniqueKey());
  }

  @override
  void dispose() {
    _refreshChart$.close();
    super.dispose();
  }

  void _refreshChart() {
    // rebuild to refresh chart
    _refreshChart$.add(UniqueKey());
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _refreshChart,
            icon: const Icon(Icons.refresh),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              clipBehavior: Clip.hardEdge,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xffEBEBEB)),
                color: Colors.black12,
              ),
              child: StreamBuilder<Key>(
                stream: _refreshChart$.stream,
                builder: (context, snapshot) {
                  if (snapshot.data == null) return const SizedBox.shrink();
                  return LineChartView(
                    key: snapshot.data,
                    heightChart: _heightChart,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
