import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/chat/chat_service.dart';
import 'package:intl/intl.dart';
class ChatPage extends StatefulWidget {
  final String recevierUserEmail;
  final String receiverUserUid;
  const ChatPage({super.key, required this.recevierUserEmail, required this.receiverUserUid});
  
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  // для прокрутки вниз
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() async {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverUserUid, message);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5EEF4),
      appBar: AppBar(
        title: Text(
          widget.recevierUserEmail,
          style: const TextStyle(
            fontFamily: "Minecraft",
            color: Color(0xFF373737),
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF8B8B8B),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput()
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        widget.receiverUserUid, 
        _firebaseAuth.currentUser!.uid
      ), 
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return _buildMessageItem(snapshot.data!.docs[index]);
          },
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    
    bool isMe = data['senderId'] == _firebaseAuth.currentUser!.uid;
    String time = DateFormat('HH:mm').format(data['timestamp'].toDate());

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFC8E4CA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                data['senderEmail'][0].toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFF373737),
                  fontFamily: "Minecraft",
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // сообщение
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFFF6FEFF) : const Color(0xFFC8E4CA),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // имя отправителя
                  Text(
                    data['senderEmail'],
                    style: const TextStyle(
                      color: Color(0xFF373737),
                      fontSize: 12,
                      fontFamily: "Minecraft",
                    ),
                  ),
                  const SizedBox(height: 4),
                  // текст сооб
                  Text(
                    data['message'],
                    style: const TextStyle(
                      color: Color(0xFF373737),
                      fontSize: 14,
                      fontFamily: "Minecraft",
                    ),
                  ),
                  const SizedBox(height: 4),
                  // время
                  Text(
                    time,
                    style: const TextStyle(
                      color: Color(0xFF373737),
                      fontSize: 10,
                      fontFamily: "Minecraft",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF8B8B8B),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF373737),
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFF373737),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(
                  fontFamily: "Minecraft",
                  color: Color(0xFF373737),
                ),
                decoration: const InputDecoration(
                  hintText: 'Ввести сообщение',
                  hintStyle: TextStyle(
                    fontFamily: "Minecraft",
                    color: Color(0xFF373737),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFB0E9B4),
              border: Border.all(
                color: const Color(0xFF373737),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: IconButton(
              onPressed: _sendMessage,
              icon: const Icon(
                Icons.send_sharp,
                color: Color(0xff672a43),
                size: 23,
              ),
            ),
          ),
        ],
      ),
    );
  }
}