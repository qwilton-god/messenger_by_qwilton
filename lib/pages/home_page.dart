import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при выходе: $e'),
          backgroundColor: const Color(0xFFC8E4CA),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5EEF4),
      appBar: AppBar(
        title: const Text(
          'Чаты',
          style: TextStyle(
            fontFamily: "Minecraft",
            color: Color(0xFF373737),
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFFE5EEF4),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: signOut,
            icon: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFC8E4CA),
                border: Border.all(
                  color: const Color(0xFF373737),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 0,
                    blurRadius: 0,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  Icons.logout,
                  color: Color(0xFF373737),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("users").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Ошибка: ${snapshot.error}',
              style: const TextStyle(
                fontFamily: "Minecraft",
                color: Color(0xFF373737),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFC8E4CA),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return _buildUserListItem(snapshot.data!.docs[index]);
          },
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    if (_auth.currentUser!.email != data["email"]) {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("chat_rooms")
            .doc("${_auth.currentUser!.uid}_${data["uid"]}")
            .collection("messages")
            .orderBy("timestamp", descending: true)
            .limit(1)
            .snapshots(),
        builder: (context, snapshot) {
          String lastMessage = "Нет сообщений";
          String lastMessageTime = "";
          
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            Map<String, dynamic> chatData = snapshot.data!.docs[0].data() as Map<String, dynamic>;
            lastMessage = chatData["message"] ?? "Нет сообщений";
            if (chatData["timestamp"] != null) {
              DateTime messageTime = (chatData["timestamp"] as Timestamp).toDate();
              lastMessageTime = DateFormat('HH:mm').format(messageTime);
            }
          }

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF6FEFF),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 0,
                  blurRadius: 0,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: ListTile(
              leading: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFC8E4CA),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    data["email"][0].toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF373737),
                      fontFamily: "Minecraft",
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              title: Text(
                data["email"],
                style: const TextStyle(
                  color: Color(0xFF373737),
                  fontFamily: "Minecraft",
                  fontSize: 14,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    lastMessage,
                    style: const TextStyle(
                      fontFamily: "Minecraft",
                      color: Color(0xFF373737),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (lastMessageTime.isNotEmpty)
                    Text(
                      lastMessageTime,
                      style: const TextStyle(
                        fontFamily: "Minecraft",
                        color: Color(0xFF373737),
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      recevierUserEmail: data["email"],
                      receiverUserUid: data["uid"],
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}