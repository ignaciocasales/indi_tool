import 'package:flutter/material.dart';
import 'package:indi_tool/screens/services/http/http_method.dart';
import 'package:indi_tool/screens/workspace/editor/response_layout.dart';
import 'package:indi_tool/screens/workspace/editor/simple_request_editor_nav.dart';

class SimpleRequestEditorLayout extends StatelessWidget {
  const SimpleRequestEditorLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 8,
      child: Column(
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: HttpMethodDropdown(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: "",
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
      ),
    );
  }
}

class HttpMethodDropdown extends StatefulWidget {
  const HttpMethodDropdown({super.key});

  @override
  State<HttpMethodDropdown> createState() => _HttpMethodDropdownState();
}

class _HttpMethodDropdownState extends State<HttpMethodDropdown> {
  final TextEditingController methodController = TextEditingController();
  HttpMethod dropdownValue = HttpMethod.values.first;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownMenu<HttpMethod>(
        initialSelection: dropdownValue,
        controller: methodController,
        requestFocusOnTap: true,
        onSelected: (HttpMethod? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
        },
        dropdownMenuEntries: HttpMethod.values
            .map<DropdownMenuEntry<HttpMethod>>((HttpMethod type) {
          return DropdownMenuEntry<HttpMethod>(
            value: type,
            label: type.name,
          );
        }).toList(),
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none,
        )
      ),
    );
  }
}
