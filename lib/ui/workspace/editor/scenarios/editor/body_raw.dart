import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indi_tool/models/workspace/test_scenario.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/providers/repository/repository_prov.dart';

class RawBodyEditingWidget extends ConsumerStatefulWidget {
  const RawBodyEditingWidget({super.key});

  @override
  ConsumerState<RawBodyEditingWidget> createState() => _TextEditorFieldState();
}

class _TextEditorFieldState extends ConsumerState<RawBodyEditingWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    _controller.text = '';
    _controller.addListener(_updateBody);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateBody);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (scenarioId == null) {
      throw StateError('No scenario selected');
    }

    ref.watch(testScenarioProvider(scenarioId: scenarioId)).whenData((data) {
      if (!_enabled) {
        setState(() {
          _enabled = true;
        });
      }

      final String body = utf8.decode(data.request.body);

      if (_controller.text != body) {
        _controller.text = body;
      }
    });

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          key: Key('body-$scenarioId'),
          enabled: _enabled,
          controller: _controller,
          expands: true,
          maxLines: null,
          style: TextStyle(
            fontFamily: GoogleFonts.sourceCodePro().fontFamily,
          ),
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
            hintText: 'Enter request body here',
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            filled: true,
            hoverColor: Colors.transparent,
            fillColor: Color.alphaBlend(
                (Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.primaryContainer)
                    .withOpacity(0.05),
                Theme.of(context).colorScheme.surface),
          ),
        ),
      ),
    );
  }

  void _updateBody() async {
    final String body = _controller.text;

    if (body.isEmpty) {
      return;
    }

    final int? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (scenarioId == null) {
      return;
    }

    final TestScenario scenario =
        await ref.read(testScenarioProvider(scenarioId: scenarioId).future);

    final TestScenario updated = scenario.copyWith(
      request: scenario.request.copyWith(body: utf8.encode(body)),
    );

    ref
        .read(testScenarioRepositoryProvider)
        .updateTestScenario(testScenario: updated);
  }
}
