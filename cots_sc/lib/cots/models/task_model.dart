class Task {
  final int? id; 
  final String title;
  final String course;
  final DateTime deadline;
  final String status; 
  final String note; 
  bool isDone;

  Task({
    this.id,
    required this.title,
    required this.course,
    required this.deadline,
    required this.status,
    this.note = '',
    this.isDone = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      course: json['course'],
      deadline: DateTime.parse(json['deadline']),
      status: json['status'] ?? 'BERJALAN',
      note: json['note'] ?? '',
      isDone: json['is_done'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'course': course,
      'deadline': deadline.toIso8601String().split('T')[0],
      'status': status,
      'note': note,
      'is_done': isDone,
    };
  }
}