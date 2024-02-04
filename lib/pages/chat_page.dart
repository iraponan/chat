import 'dart:io';

import 'package:chat/widgets/text_composer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  void _sendMessager({String? text, File? imgFile}) async {
    Map<String, dynamic> data = Map();

    if (imgFile != null) {
      SettableMetadata metadata = SettableMetadata(
        contentType: "image/jpeg",
      );
      TaskSnapshot task = await FirebaseStorage.instance
          .ref()
          .child(DateTime.now().microsecondsSinceEpoch.toString())
          .putFile(imgFile, metadata);
      String urlImage = await task.ref.getDownloadURL();
      data['imgUrl'] = urlImage;
    }

    if (text != null) {
      data['text'] = text;
    }

    FirebaseFirestore.instance.collection('messages').add(data);
  }
}
