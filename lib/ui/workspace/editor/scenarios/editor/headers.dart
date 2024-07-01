import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/models/workspace/indi_http_header.dart';
import 'package:indi_tool/providers/http_headers.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/ui/workspace/editor/scenarios/editor/cell.dart';
import 'package:indi_tool/ui/workspace/editor/scenarios/editor/checkbox.dart';
import 'package:indi_tool/ui/workspace/editor/scenarios/editor/table.dart';

class HeadersWidget extends ConsumerStatefulWidget {
  const HeadersWidget({super.key});

  @override
  ConsumerState<HeadersWidget> createState() => _HeadersWidgetState();
}

class _HeadersWidgetState extends ConsumerState<HeadersWidget> {
  List<IndiHttpHeader> _headers = List.empty(growable: true);
  final List<List<TextEditingController>> _controllers =
      List.empty(growable: true);

  @override
  void dispose() {
    for (final controllers in _controllers) {
      for (final controller in controllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (scenarioId == null) {
      return const SizedBox();
    }

    _headers = ref.watch(httpHeadersProvider(scenarioId: scenarioId)).when(
          data: (headers) => headers,
          error: (err, st) => _headers,
          loading: () => _headers,
        );

    while (_controllers.length < _headers.length + 1) {
      _controllers.add([]);
    }

    while (_controllers.length > _headers.length + 1) {
      for (final controller in _controllers.removeLast()) {
        controller.dispose();
      }
    }

    return Expanded(
      child: BaseTable(values: _buildRows(scenarioId, ref)),
    );
  }

  List<TableRow> _buildRows(
    final int scenarioId,
    final WidgetRef ref,
  ) {
    return List.generate(
      _headers.length + 1,
      (i) {
        final bool isLast = i == _headers.length;

        final List<TextEditingController> controllers = _controllers[i];

        // Ensure each row has enough controllers for all columns
        while (controllers.length < 3) {
          // Assuming 3 editable columns
          controllers.add(TextEditingController());
        }

        return TableRow(
          key: ValueKey(i),
          children: [
            CheckBoxEditingWidget(
              value: _headers.elementAtOrNull(i)?.enabled ?? false,
              onChanged: isLast
                  ? null
                  : (bool? value) {
                      ref
                          .read(httpHeadersProvider(scenarioId: scenarioId)
                              .notifier)
                          .enable(_headers.elementAtOrNull(i)?.id, value!);
                    },
            ),
            CellEditingWidget(
              controller: controllers[0],
              hint: 'Key',
              text: _headers.elementAtOrNull(i)?.key ?? '',
              onChanged: (value) {
                ref
                    .read(httpHeadersProvider(scenarioId: scenarioId).notifier)
                    .updateKey(_headers.elementAtOrNull(i)?.id, value);
              },
            ),
            CellEditingWidget(
              controller: controllers[1],
              hint: 'Value',
              text: _headers.elementAtOrNull(i)?.value ?? '',
              onChanged: (value) {
                ref
                    .read(httpHeadersProvider(scenarioId: scenarioId).notifier)
                    .updateValue(_headers.elementAtOrNull(i)?.id, value);
              },
            ),
            CellEditingWidget(
                controller: controllers[2],
                hint: 'Description',
                text: _headers.elementAtOrNull(i)?.description ?? '',
                onChanged: (value) {
                  ref
                      .read(
                          httpHeadersProvider(scenarioId: scenarioId).notifier)
                      .updateDescription(
                          _headers.elementAtOrNull(i)?.id, value);
                }),
            isLast
                ? const SizedBox()
                : IconButton(
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8.0),
                    icon: const Icon(
                      Icons.delete_outline_sharp,
                      size: 16,
                    ),
                    onPressed: () {
                      ref
                          .read(httpHeadersProvider(scenarioId: scenarioId)
                              .notifier)
                          .delete(_headers[i].id);
                    },
                  )
          ],
        );
      },
    );
  }
}
