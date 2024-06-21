import 'package:indi_tool/schema/request_param.dart';

class UrlBuilder {
  UrlBuilder._();

  static String syncWithParameters(final String url, final List<IndiHttpParameter> parameters) {
    String query = '';
    for (var param in parameters) {
      if (param.enabled == false) {
        continue;
      }

      if (param.key.isEmpty) {
        continue;
      }

      query += param.key;

      if (param.value.isNotEmpty) {
        query += '=${param.value}';
      }

      if (parameters.indexOf(param) < parameters.length - 1) {
        query += '&';
      }
    }

    var updatedUri = Uri.parse(url).replace(query: query).toString();

    if (parameters.where((e) => e.enabled).isEmpty) {
      if (updatedUri.endsWith('?')) {
        updatedUri = updatedUri.substring(0, updatedUri.length - 1);
      }
    }

    return updatedUri;
  }
}
