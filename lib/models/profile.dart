class Profile {
  final String? id; // id nullable
  final String emoji;
  final DateTime? createdAt; // createdAt nullable
  final DateTime? updatedAt; // updatedAt nullable

  Profile({
    this.id,
    required this.emoji,
    this.createdAt,
    this.updatedAt,
  });
}