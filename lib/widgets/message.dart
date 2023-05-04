import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final String message;
  final bool isMe;

  const Message({super.key, required this.message,required this.isMe});

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 200),
          decoration: BoxDecoration(
            color: isMe ? Colors.white : Colors.green,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          child: Text(
            message,
            style: const TextStyle(color: Colors.black,fontSize: 20),
          ),
        )
      ],
    );
  }
}