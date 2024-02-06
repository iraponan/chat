import 'dart:io';

import 'package:chat/widgets/text_composer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final String _colletion = 'messages';
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  User? _currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Olá'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection(_colletion).snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    List<DocumentSnapshot>? docs =
                        snapshot.data?.docs.reversed.toList();
                    return ListView.builder(
                      itemCount: docs?.length ?? 0,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(docs?[index].get('text')),
                        );
                      },
                    );
                }
              },
            ),
          ),
          TextComposer(sendMessage: _sendMessager),
        ],
      ),
    );
  }

  void _sendMessager({String? text, File? imgFile}) async {
    final User? user = await _getUsers();
    print('Usuario: $user');
    Map<String, dynamic> data = {};

    if (user == null) {
      _scaffoldKey.currentState?.showSnackBar(const SnackBar(
        content: Text('Não foi possível fazer o login! Tente novamente.'),
        backgroundColor: Colors.red,
      ));
    } else {
      data = {
        'uid' : user.uid,
        'senderName' : user.displayName,
        'senderPhotoUrl' : user.photoURL,
      };
    }

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

    FirebaseFirestore.instance.collection(_colletion).add(data);
  }

  Future<User?> _getUsers() async {
    if (_currentUser != null) {
      return _currentUser;
    }

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication?.idToken,
          accessToken: googleSignInAuthentication?.accessToken);
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      return user;
    } catch (error) {
      print('Erro de Login = $error}');
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().map((user) {
      _currentUser = user!;
    });
  }
}
