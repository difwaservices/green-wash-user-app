import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderChatPage extends StatefulWidget {
  final String riderName;
  final String riderPhone;
  final String orderId;

  const OrderChatPage({
    super.key,
    required this.riderName,
    required this.riderPhone,
    required this.orderId,
  });

  @override
  State<OrderChatPage> createState() => _OrderChatPageState();
}

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime time;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
  });
}

class _OrderChatPageState extends State<OrderChatPage> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isChatWorking = true;

  @override
  void initState() {
    super.initState();
    // Default initial greeting messages
    _messages.addAll([
      ChatMessage(
        text: "Hello! I am ${widget.riderName}, your delivery partner for your order #${widget.orderId.replaceAll('#', '')}.",
        isMe: false,
        time: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      ChatMessage(
        text: "I have accepted your order and I'm currently picking it up from the retailer. Let me know if you have any instructions.",
        isMe: false,
        time: DateTime.now().subtract(const Duration(minutes: 4)),
      ),
    ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isMe: true,
        time: DateTime.now(),
      ));
      _controller.clear();
    });

    _scrollToBottom();

    // Simulated auto response from rider
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      
      String replyText;
      final query = text.toLowerCase();
      if (query.contains("hello") || query.contains("hi") || query.contains("hey")) {
        replyText = "Hello! Let me know how I can help you with the delivery.";
      } else if (query.contains("where") || query.contains("location") || query.contains("reach") || query.contains("time")) {
        replyText = "I have picked up the items and am heading towards your location. I will reach in about 10 minutes.";
      } else if (query.contains("call") || query.contains("phone") || query.contains("number")) {
        replyText = "Sure, you can call me at ${widget.riderPhone} anytime.";
      } else if (query.contains("gate") || query.contains("door") || query.contains("security")) {
        replyText = "Understood. I will leave it at the gate/door as instructed. Thank you!";
      } else {
        replyText = "Okay, understood. I am currently working on delivering your order. I will keep you updated.";
      }

      setState(() {
        _messages.add(ChatMessage(
          text: replyText,
          isMe: false,
          time: DateTime.now(),
        ));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutQuad,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black12,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF0891B2),
              child: Text(
                widget.riderName.isNotEmpty ? widget.riderName[0].toUpperCase() : 'R',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.riderName,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Delivery Partner',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          if (widget.riderPhone.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.call_outlined, color: Color(0xFF0891B2)),
              onPressed: () async {
                final Uri uri = Uri.parse('tel:${widget.riderPhone}');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // "Chat on Working" option banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFFCFFAFE),
            child: Row(
              children: [
                const Icon(
                  Icons.chat_bubble_rounded,
                  color: Color(0xFF0891B2),
                  size: 18,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    "Chat on Working (Active support)",
                    style: TextStyle(
                      color: Color(0xFF0891B2),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: _isChatWorking,
                    onChanged: (val) {
                      setState(() {
                        _isChatWorking = val;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(val ? "Chat is active." : "Chat is disabled."),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    activeThumbColor: const Color(0xFF0891B2),
                    activeTrackColor: const Color(0xFF0891B2).withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ),
          
          // Message List
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 12),
                        const Text("No messages yet", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return Align(
                        alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: message.isMe ? const Color(0xFF0891B2) : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(message.isMe ? 16 : 4),
                              bottomRight: Radius.circular(message.isMe ? 4 : 16),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                message.text,
                                style: TextStyle(
                                  color: message.isMe ? Colors.white : Colors.black87,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  DateFormat('hh:mm a').format(message.time),
                                  style: TextStyle(
                                    color: message.isMe ? Colors.white60 : Colors.grey,
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Message input bar
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: MediaQuery.of(context).viewInsets.bottom + 8,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _controller,
                      enabled: _isChatWorking,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _isChatWorking ? _sendMessage : null,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: _isChatWorking ? const Color(0xFF0891B2) : Colors.grey[300],
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
