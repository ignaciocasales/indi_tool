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
}
