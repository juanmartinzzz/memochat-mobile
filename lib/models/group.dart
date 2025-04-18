class Group {
  final String? id; // id nullable
  final String name;
  final String description;
  final String creatorId;
  final DateTime? createdAt; // createdAt nullable
  final DateTime? updatedAt; // updatedAt nullable

  Group({
    this.id,
    required this.name,
    required this.description,
    required this.creatorId,
    this.createdAt,
    this.updatedAt,
  });
}