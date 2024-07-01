class Workspace {
  Workspace({
    this.id,
    String? name,
    String? description,
  })  : name = name ?? '',
        description = description ?? '';

  final int? id;
  final String name;
  final String description;

  Workspace copyWith({
    String? name,
    String? description,
  }) {
    return Workspace(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
