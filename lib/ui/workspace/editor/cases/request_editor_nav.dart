import 'package:flutter/material.dart';
import 'package:indi_tool/ui/workspace/editor/cases/body_pane.dart';
import 'package:indi_tool/ui/workspace/editor/cases/headers_pane.dart';
import 'package:indi_tool/ui/workspace/editor/cases/parameters_pane.dart';

class RequestEditorNav extends StatefulWidget {
  const RequestEditorNav({super.key});

  @override
  State<RequestEditorNav> createState() => _RequestEditorNavState();
}

class _RequestEditorNavState extends State<RequestEditorNav>
    with TickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          TabBar(
            controller: _controller,
            tabs: const [
              Tab(
                text: 'Params',
              ),
              Tab(
                text: 'Headers',
              ),
              Tab(
                text: 'Body',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: const [
                Parameters(),
                Headers(),
                Body(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
