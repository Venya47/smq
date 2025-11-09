class JournalEntry {
  final String id;
  final String title;
  final String content;
  final String mood; // e.g., "happy", "sad"
  final DateTime date;
  final DateTime createdAt;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.mood,
    required this.date,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'mood': mood,
      'date': date.toUtc().toIso8601String(),
      'createdAt': createdAt.toUtc().toIso8601String(),
    };
  }

  factory JournalEntry.fromMap(String id, Map<String, dynamic> m) {
    return JournalEntry(
      id: id,
      title: m['title'] ?? '',
      content: m['content'] ?? '',
      mood: m['mood'] ?? 'neutral',
      date: DateTime.parse(m['date']).toLocal(),
      createdAt: DateTime.parse(m['createdAt']).toLocal(),
    );
  }
}
