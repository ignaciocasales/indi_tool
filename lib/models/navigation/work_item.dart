class WorkItem {
  WorkItem({
    required this.id,
    required this.type,
    this.parent,
  });

  final String id;
  final WorkItemType type;
  final WorkItem? parent;
}

enum WorkItemType {
  testGroup,
  testScenario,
}
