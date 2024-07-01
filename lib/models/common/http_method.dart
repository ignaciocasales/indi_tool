enum HttpMethod {
  get(name: 'GET'),
  post(name: 'POST'),
  put(name: 'PUT'),
  delete(name: 'DELETE'),
  patch(name: 'PATCH'),
  head(name: 'HEAD');

  const HttpMethod({
    required this.name,
  });

  final String name;

  static HttpMethod fromString(final String value) {
    switch (value) {
      case 'GET':
        return HttpMethod.get;
      case 'POST':
        return HttpMethod.post;
      case 'PUT':
        return HttpMethod.put;
      case 'DELETE':
        return HttpMethod.delete;
      case 'PATCH':
        return HttpMethod.patch;
      case 'HEAD':
        return HttpMethod.head;
      default:
        throw ArgumentError('Invalid HTTP method: $value');
    }
  }
}
