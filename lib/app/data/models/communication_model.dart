class CommunicationModel {
  final String id;
  final String title;
  final String body;
  final String targetType;
  final DateTime createdAt;

  CommunicationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.targetType,
    required this.createdAt,
  });

  factory CommunicationModel.fromJson(Map<String, dynamic> json) {
    return CommunicationModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      targetType: json['targetType'] ?? 'all',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }
}
