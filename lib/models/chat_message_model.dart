class ChatMessageModel {
  final String id;
  final String orderId;
  final String senderRole; // 'user' atau 'cleaner'
  final String text;
  final DateTime timestamp;
  final bool isSystemMessage; // Untuk notifikasi seperti "Cleaner mengajukan Rp 100.000"

  ChatMessageModel({
    required this.id,
    required this.orderId,
    required this.senderRole,
    required this.text,
    required this.timestamp,
    this.isSystemMessage = false,
  });
}
