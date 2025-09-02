class Task {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String status;
  final String active;
  final String createdAt;
  final String updatedAt;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.status,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      active: json['active'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
