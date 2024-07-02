import 'package:flutter/material.dart';
import 'package:indi_tool/consts.dart';

class ScaffoldWrapper extends StatelessWidget {
  ScaffoldWrapper({super.key, required this.appBar, required this.body});

  final PreferredSizeWidget appBar;
  final Widget body;

  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth < kMinScreenWidth
              ? kMinScreenWidth
              : constraints.maxWidth;

          final height = constraints.maxHeight < kMinScreenHeight
              ? kMinScreenHeight
              : constraints.maxHeight;

          return ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: Scrollbar(
              controller: _horizontalScrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _horizontalScrollController,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: width,
                    maxWidth: width,
                    minHeight: height,
                    maxHeight: height,
                  ),
                  child: Scrollbar(
                    controller: _verticalScrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      controller: _verticalScrollController,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: width,
                          maxWidth: width,
                          minHeight: height,
                          maxHeight: height,
                        ),
                        child: body,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
