import 'package:flutter/material.dart';
import 'package:indi_tool/ui/workspace/editor/body_pane.dart';
import 'package:indi_tool/ui/workspace/editor/headers_pane.dart';
import 'package:indi_tool/ui/workspace/editor/params_pane.dart';

class SimpleRequestEditorNav extends StatefulWidget {
  const SimpleRequestEditorNav({super.key});

  @override
  State<SimpleRequestEditorNav> createState() => _SimpleRequestEditorNavState();
}

class _SimpleRequestEditorNavState extends State<SimpleRequestEditorNav>
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
                text: "Params",
              ),
              Tab(
                text: "Headers",
              ),
              Tab(
                text: "Body",
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: const [
                Params(),
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
