class Task {
  final String id;
  final String title;
  final String content;
  final String url;
  final int rewardAmount;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.content,
    required this.url,
    required this.rewardAmount,
    this.isCompleted = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      url: json['link'],
      rewardAmount: int.parse(json['reward_amount']),
      isCompleted: json['used'] == "1",
    );
  }
}
