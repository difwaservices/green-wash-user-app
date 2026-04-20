class AppBanner {
  final String id;
  final String title;
  final String imageUrl;
  final String actionType; // 'none', 'shop', 'product', 'url'
  final String actionValue;
  final int priority;

  AppBanner({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.actionType,
    required this.actionValue,
    required this.priority,
  });

  factory AppBanner.fromJson(Map<String, dynamic> json) {
    return AppBanner(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['image'] ?? '',
      actionType: json['actionType'] ?? 'none',
      actionValue: json['actionValue'] ?? '',
      priority: json['priority'] ?? 0,
    );
  }
}
