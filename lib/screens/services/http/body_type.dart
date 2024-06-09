enum BodyType {
  none(name: "None"),
  raw(name: "Raw"),
  form(name: "Form Data");

  const BodyType({
    required this.name,
  });

  final String name;
}
