class Task {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String status;
  final String active;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.status,
    required this.active,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        userId: json['userId'],
        title: json['title'],
        description: json['description'],
        status: json['status'],
        active: json['active'],
      );
}
