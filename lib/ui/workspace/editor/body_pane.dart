import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indi_tool/providers/providers.dart';
import 'package:indi_tool/services/http/body_type.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            BodyTypeDropdown(),
          ],
        ),
        TextEditorField(),
      ],
    );
  }
}

class BodyTypeDropdown extends StatefulWidget {
  const BodyTypeDropdown({super.key});

  @override
  State<BodyTypeDropdown> createState() => _BodyTypeDropdownState();
}

class _BodyTypeDropdownState extends State<BodyTypeDropdown> {
  final TextEditingController bodyTypeController = TextEditingController();
  BodyType dropdownValue = BodyType.values.first;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownMenu<BodyType>(
        initialSelection: dropdownValue,
        controller: bodyTypeController,
        requestFocusOnTap: true,
        label: const Text('Type'),
        onSelected: (BodyType? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
        },
        dropdownMenuEntries:
            BodyType.values.map<DropdownMenuEntry<BodyType>>((BodyType type) {
          return DropdownMenuEntry<BodyType>(
            value: type,
            label: type.name,
          );
        }).toList(),
      ),
    );
  }
}

class TextEditorField extends ConsumerWidget {
  const TextEditorField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedProvider = ref.watch(selectedRequestProvider);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          key: Key("body-${selectedProvider?.id}"),
          initialValue: selectedProvider?.body ?? '',
          expands: true,
          maxLines: null,
          style: TextStyle(
            fontFamily: GoogleFonts.sourceCodePro().fontFamily,
          ),
          textAlignVertical: TextAlignVertical.top,
          onChanged: (String value) {
            // Do something?
          },
          decoration: InputDecoration(
            hintText: 'Enter request body here',
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary.withOpacity(
                      0.6,
                    ),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
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
}
