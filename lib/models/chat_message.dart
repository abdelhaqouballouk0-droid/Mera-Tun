class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.createdAt,
  });

  final String id;
  final String text;
  final bool isUser;
  final DateTime createdAt;

  Map<String, Object?> toJson() => {
    'id': id,
    'text': text,
    'isUser': isUser,
    'createdAt': createdAt.toIso8601String(),
  };

  factory ChatMessage.fromJson(Map<String, Object?> json) => ChatMessage(
    id: json['id']! as String,
    text: json['text']! as String,
    isUser: json['isUser']! as bool,
    createdAt: DateTime.parse(json['createdAt']! as String),
  );
}
