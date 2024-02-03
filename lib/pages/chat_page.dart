import 'package:chat/widgets/text_composer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Olá'),
        elevation: 0,
      ),
      body: TextComposer(sendMessage: _sendMessager),
    );
  }

  void _sendMessager(String text) {
    FirebaseFirestore.instance.collection('messages').add({
      'text' : text
    });
  }
}
