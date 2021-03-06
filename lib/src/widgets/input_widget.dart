
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swiper_app/src/models/chat_message_model.dart';

class InputWidget extends StatefulWidget {
  final String? current;
  final ChatMessage chat;

  const InputWidget({this.current, required this.chat, Key? key})
      : super(key: key);

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final TextEditingController _tCon = TextEditingController();
  String? get current => widget.current;
  ChatMessage get chat => widget.chat;

  @override
  void initState() {
    if (current != null) _tCon.text = current as String;
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        onChanged: () {
          _formKey.currentState?.validate();
          setState(() {});
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Edit Message'),
            const SizedBox(height: 15,),
            TextFormField(
              controller: _tCon,
              validator: (value) {
                if (value == null || value.isEmpty || value.trim().isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: const InputDecoration(
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: (_formKey.currentState?.validate() ?? false)
                  ? () {
                      if (_formKey.currentState?.validate() ?? false) {
                        chat.updateDetails(_tCon.text);
                        Navigator.of(context).pop();
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  primary: (_formKey.currentState?.validate() ?? false)
                      ? const Color(0xFF303030)
                      : Colors.grey),
              child: const Text('Edit'),
            )
          ],
        ),
      ),
    );
  }
}
