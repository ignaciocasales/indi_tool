import 'package:indi_tool/schema/request_param.dart';

class ParamsBuilder {
  ParamsBuilder._();

  static List<IndiHttpParameter> syncWithUrl(
    final String url,
    final List<IndiHttpParameter> originalParameters,
  ) {
    final List<IndiHttpParameter> newParameters = Uri.parse(url)
        .query
        .split('&')
        .where((element) => element.isNotEmpty)
        .map((param) {
      final List<String> keyValue = param.split('=');

      String key = '';
      final maybeKey = keyValue.elementAtOrNull(0);
      if (maybeKey != null) {
        key = Uri.decodeQueryComponent(maybeKey);
      }

      String value = '';
      final maybeValue = keyValue.elementAtOrNull(1);
      if (maybeValue != null) {
        value = Uri.decodeQueryComponent(maybeValue);
      }

      return IndiHttpParameter.newWith(key: key, value: value);
    }).toList();

    final List<IndiHttpParameter> updated = List.empty(growable: true);

    for (int i = 0; i < newParameters.length; i++) {
      if (i < originalParameters.length) {
        if (!originalParameters.elementAt(i).enabled) {
          updated.add(originalParameters.elementAt(i));
          continue;
        }

        // If the index exists in both lists, update the original list
        originalParameters[i] = originalParameters[i].copyWith(
          key: newParameters.elementAt(i).key,
          value: newParameters.elementAt(i).value,
        );
      } else {
        // If the index is only in the new list, add the item to the original list
        updated.add(IndiHttpParameter.newWith(
          key: newParameters.elementAt(i).key,
          value: newParameters.elementAt(i).value,
        ));
      }
    }

    return updated;
  }
}
