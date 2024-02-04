import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  const TextComposer({super.key, required this.sendMessage});

  final Function({String text, File imgFile}) sendMessage;

  @override
  State<TextComposer> createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  bool _isComposer = false;

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return BottomSheet(
                    onClosing: () {},
                    builder: (context) {
                      return Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.gallery)
                                          .then((file) {
                                        if (file == null) {
                                          return;
                                        } else {
                                          print(file.path);
                                          widget.sendMessage(
                                              imgFile: File(file.path));
                                        }
                                      });
                                    },
                                    child: const Icon(
                                      Icons.file_open,
                                      color: Colors.blue,
                                      size: 50.0,
                                    ),
                                  ),
                                  const Text(
                                    'Galeria',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await ImagePicker()
                                          .pickImage(source: ImageSource.camera)
                                          .then((file) {
                                        if (file == null) {
                                          return;
                                        } else {
                                          print(file.path);
                                          widget.sendMessage(
                                              imgFile: File(file.path));
                                        }
                                      });
                                    },
                                    child: const Icon(
                                      Icons.camera,
                                      color: Colors.blue,
                                      size: 50.0,
                                    ),
                                  ),
                                  const Text(
                                    'Câmera',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
            icon: const Icon(Icons.photo_camera),
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration.collapsed(
                hintText: 'Enviar uma mensagem...',
              ),
              textCapitalization: TextCapitalization.sentences,
              onChanged: (text) {
                setState(() {
                  _isComposer = text.isNotEmpty;
                });
              },
              onSubmitted: (text) {
                widget.sendMessage(text: text);
                _resert();
              },
            ),
          ),
          IconButton(
            onPressed: _isComposer
                ? () {
                    widget.sendMessage(text: _messageController.text);
                    _resert();
                  }
                : null,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  void _resert() {
    setState(() {
      _messageController.clear();
      _isComposer = false;
    });
  }
}
