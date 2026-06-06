import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../../models/chat_message_model.dart';
import '../../models/order_model.dart';

class ChatPage extends StatefulWidget {
  final OrderModel order;
  final bool isCleaner;

  const ChatPage({super.key, required this.order, required this.isCleaner});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool get isOrderParticipant {
    if (widget.isCleaner) {
      return widget.order.cleanerId != null &&
          widget.order.cleanerId == currentCleaner?.id;
    }
    return widget.order.customerName == currentUser?.name;
  }

  bool get canChat {
    return isOrderParticipant &&
        (widget.order.status == 'Negosiasi' ||
            widget.order.status == 'Diterima');
  }

  List<ChatMessageModel> get messages =>
      allMessages.where((m) => m.orderId == widget.order.id).toList();

  @override
  void initState() {
    super.initState();
    // Tambahkan pesan sistem hanya saat sedang dalam proses negosiasi
    if (widget.order.status == 'Negosiasi' && messages.isEmpty) {
      allMessages.add(
        ChatMessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          orderId: widget.order.id,
          senderRole: 'system',
          text:
              'Negosiasi harga dimulai. Harga awal: Rp ${widget.order.totalPrice}',
          timestamp: DateTime.now(),
          isSystemMessage: true,
        ),
      );
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage(String text) {
    if (!canChat || text.trim().isEmpty) return;
    setState(() {
      allMessages.add(
        ChatMessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          orderId: widget.order.id,
          senderRole: widget.isCleaner ? 'cleaner' : 'user',
          text: text.trim(),
          timestamp: DateTime.now(),
        ),
      );
    });
    _textController.clear();
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  void _showChangePriceDialog() {
    final controller = TextEditingController(
      text: widget.order.totalPrice.toString(),
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajukan Harga Baru'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Harga (Rp)',
              prefixText: 'Rp ',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                final newPrice = int.tryParse(controller.text) ?? 0;
                if (newPrice > 0) {
                  setState(() {
                    widget.order.totalPrice = newPrice;
                    allMessages.add(
                      ChatMessageModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        orderId: widget.order.id,
                        senderRole: 'system',
                        text:
                            '${widget.isCleaner ? 'Cleaner' : 'Pelanggan'} mengajukan harga baru: Rp $newPrice',
                        timestamp: DateTime.now(),
                        isSystemMessage: true,
                      ),
                    );
                  });
                }
                Navigator.pop(context);
                Future.delayed(
                  const Duration(milliseconds: 100),
                  _scrollToBottom,
                );
              },
              child: const Text('Ajukan'),
            ),
          ],
        );
      },
    );
  }

  void _acceptOrder() {
    setState(() {
      widget.order.status = 'Diterima';
      allMessages.add(
        ChatMessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          orderId: widget.order.id,
          senderRole: 'system',
          text: 'Pelanggan menyetujui harga Rp ${widget.order.totalPrice}',
          timestamp: DateTime.now(),
          isSystemMessage: true,
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Harga disepakati dan pesanan diterima!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final chatMessages = messages;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isCleaner ? 'Chat Pelanggan' : 'Chat Cleaner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Harga saat ini: Rp ${widget.order.totalPrice}',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner Status
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFFFFD54F).withValues(alpha: 0.2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Harga Penawaran:',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  'Rp ${widget.order.totalPrice}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0B4FA8),
                  ),
                ),
              ],
            ),
          ),

          // Area Chat
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                final msg = chatMessages[index];

                if (msg.isSystemMessage) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          msg.text,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                final isMe = widget.isCleaner
                    ? msg.senderRole == 'cleaner'
                    : msg.senderRole == 'user';

                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF0B4FA8) : Colors.white,
                      borderRadius: BorderRadius.circular(16).copyWith(
                        bottomRight: isMe ? const Radius.circular(0) : null,
                        bottomLeft: !isMe ? const Radius.circular(0) : null,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Aksi Tambahan (Ajukan Harga / Sepakat)
          if (widget.order.status == 'Negosiasi')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _showChangePriceDialog,
                      child: const Text('Ubah Harga'),
                    ),
                  ),
                  if (widget.isCleaner) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: _acceptOrder,
                        child: const Text('Sepakat & Terima'),
                      ),
                    ),
                  ] else ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF0B4FA8),
                        ),
                        onPressed: _acceptOrder,
                        child: const Text('Setujui Harga'),
                      ),
                    ),
                  ],
                ],
              ),
            ),

          // Input Area
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                if (!isOrderParticipant)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Anda tidak dapat mengirim pesan pada pesanan ini.',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 12,
                      ),
                    ),
                  )
                else if (!canChat)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Chat hanya aktif selama negosiasi atau setelah pesanan diterima.',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        enabled: canChat,
                        decoration: InputDecoration(
                          hintText: canChat ? 'Tulis pesan...' : 'Chat ditutup',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: canChat
                          ? const Color(0xFF0B4FA8)
                          : Colors.grey.shade400,
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: canChat
                            ? () => _sendMessage(_textController.text)
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
