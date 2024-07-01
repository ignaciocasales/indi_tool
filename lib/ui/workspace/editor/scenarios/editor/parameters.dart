import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/models/workspace/indi_http_param.dart';
import 'package:indi_tool/providers/http_params.dart';
import 'package:indi_tool/providers/navigation/workspace_router_prov.dart';
import 'package:indi_tool/ui/workspace/editor/scenarios/editor/cell.dart';
import 'package:indi_tool/ui/workspace/editor/scenarios/editor/checkbox.dart';
import 'package:indi_tool/ui/workspace/editor/scenarios/editor/table.dart';

class ParametersWidget extends ConsumerStatefulWidget {
  const ParametersWidget({super.key});

  @override
  ConsumerState<ParametersWidget> createState() => _ParametersWidgetState();
}

class _ParametersWidgetState extends ConsumerState<ParametersWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int? scenarioId = ref.watch(selectedTestScenarioProvider);

    if (scenarioId == null) {
      throw StateError('No scenario selected');
    }

    final List<TableRow> valueRows =
        ref.watch(httpParamsProvider(scenarioId: scenarioId)).when(
              data: (params) => _buildRows(params, scenarioId, ref),
              error: (err, st) => List.empty(),
              loading: () => List.empty(),
            );

    return Expanded(child: BaseTable(values: valueRows));
  }

  List<TableRow> _buildRows(
    final List<IndiHttpParam> parameters,
    final int scenarioId,
    final WidgetRef ref,
  ) {
    return List.generate(
      parameters.length + 1,
      (i) {
        final bool isLast = i == parameters.length;
        return TableRow(
          key: ValueKey(i),
          children: [
            CheckBoxEditingWidget(
              value: parameters.elementAtOrNull(i)?.enabled ?? false,
              onChanged: isLast
                  ? null
                  : (bool? value) {
                      ref
                          .read(httpParamsProvider(scenarioId: scenarioId)
                              .notifier)
                          .enable(parameters.elementAtOrNull(i)?.id, value!);
                    },
            ),
            CellEditingWidget(
              hint: 'Key',
              text: parameters.elementAtOrNull(i)?.key ?? '',
              onChanged: (value) {
                ref
                    .read(httpParamsProvider(scenarioId: scenarioId).notifier)
                    .updateKey(parameters.elementAtOrNull(i)?.id, value);
              },
            ),
            CellEditingWidget(
              hint: 'Value',
              text: parameters.elementAtOrNull(i)?.value ?? '',
              onChanged: (value) {
                ref
                    .read(httpParamsProvider(scenarioId: scenarioId).notifier)
                    .updateValue(parameters.elementAtOrNull(i)?.id, value);
              },
            ),
            CellEditingWidget(
                hint: 'Description',
                text: parameters.elementAtOrNull(i)?.description ?? '',
                onChanged: (value) {
                  ref
                      .read(httpParamsProvider(scenarioId: scenarioId).notifier)
                      .updateDescription(
                          parameters.elementAtOrNull(i)?.id, value);
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
                          .read(httpParamsProvider(scenarioId: scenarioId)
                              .notifier)
                          .delete(parameters.elementAtOrNull(i)?.id);
                    },
                  )
          ],
        );
      },
    );
  }
}
