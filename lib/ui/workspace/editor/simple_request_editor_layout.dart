import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indi_tool/providers/providers.dart';
import 'package:indi_tool/ui/workspace/editor/response_layout.dart';
import 'package:indi_tool/ui/workspace/editor/simple_request_editor_nav.dart';
import 'package:indi_tool/services/http/http_method.dart';

class SimpleRequestEditorLayout extends ConsumerWidget {
  const SimpleRequestEditorLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedRequest = ref.watch(selectedRequestProvider);

    return Expanded(
      flex: 8,
      child: selectedRequest != null
          ? Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: HttpMethodDropdown(),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          key: Key("url-${selectedRequest.id}"),
                          initialValue: selectedRequest.url,
                          decoration: const InputDecoration(
                            hintText: "Enter URL",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilledButton(
                        onPressed: () {
                          // Do something
                        },
                        child: const Row(
                          children: [
                            Text('Start'),
                            Icon(Icons.play_arrow),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const Divider(
                  height: 0,
                ),
                const Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SimpleRequestEditorNav(),
                      VerticalDivider(),
                      ResponseLayout(),
                    ],
                  ),
                ),
              ],
            )
          : const Center(
              child: Text('Select a request to view details'),
            ),
    );
  }
}

class HttpMethodDropdown extends ConsumerWidget {
  HttpMethodDropdown({super.key});

  final TextEditingController methodController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRequest = ref.watch(selectedRequestProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownMenu<HttpMethod>(
          key: Key("method-${selectedRequest?.id}"),
          initialSelection: selectedRequest?.method ?? HttpMethod.get,
          controller: methodController,
          requestFocusOnTap: true,
          onSelected: (HttpMethod? newValue) {},
          dropdownMenuEntries: HttpMethod.values
              .map<DropdownMenuEntry<HttpMethod>>((HttpMethod type) {
            return DropdownMenuEntry<HttpMethod>(
              value: type,
              label: type.name,
            );
          }).toList(),
          inputDecorationTheme: const InputDecorationTheme(
            border: InputBorder.none,
          )),
    );
  }
}
