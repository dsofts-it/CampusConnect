class UpdateModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final bool isImportant;
  final String createdBy; // ID or Name depending on population
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> likes;
  final DateTime createdAt;

  UpdateModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.isImportant = false,
    required this.createdBy,
    this.startDate,
    this.endDate,
    this.likes = const [],
    required this.createdAt,
  });

  factory UpdateModel.fromJson(Map<String, dynamic> json) {
    return UpdateModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'General',
      isImportant: json['isImportant'] ?? false,
      createdBy: json['createdBy'] is Map
          ? (json['createdBy']['name'] ?? '')
          : (json['createdBy'] ?? ''),
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate:
          json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      likes: List<String>.from(json['likes'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
