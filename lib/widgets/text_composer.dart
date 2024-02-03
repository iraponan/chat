import 'package:flutter/material.dart';

class TextComposer extends StatefulWidget {
  TextComposer({super.key, required this.sendMessage});

  Function(String) sendMessage;

  @override
  State<TextComposer> createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  bool _isComposer = false;

  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
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
                widget.sendMessage(text);
                _resert();
              },
            ),
          ),
          IconButton(
            onPressed: _isComposer ? () {
              widget.sendMessage(_messageController.text);
              _resert();
            } : null,
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
