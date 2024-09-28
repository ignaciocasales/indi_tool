enum BodyType {
  none(name: 'None'),
  raw(name: 'Raw'),
  form(name: 'Form Data');

  const BodyType({
    required this.name,
  });

  final String name;

  static BodyType fromString(final String value) {
    switch (value) {
      case 'None':
        return BodyType.none;
      case 'Raw':
        return BodyType.raw;
      case 'Form Data':
        return BodyType.form;
      default:
        throw ArgumentError('Invalid body type: $value');
    }
  }
}
