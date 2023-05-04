import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageTextField extends StatefulWidget {
  final String currentId;
  final String friendId;

  const MessageTextField(this.currentId, this.friendId, {super.key});

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //make message writing box
    return Container(
      color: Colors.white,
      padding: const EdgeInsetsDirectional.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  hintText: "Write your message",
                  fillColor: Colors.green[50],
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 0),
                      gapPadding: 10,
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          //making send button and function of that
          GestureDetector(
            onTap: () async {
              String message = _controller.text;
              _controller.clear();

              //message store by current user 
              await FirebaseFirestore.instance.collection('users').doc(widget.currentId).collection('messages').doc(widget.friendId).collection('chats').add({
                "senderId"   :widget.currentId,
                "recieverId" :widget.friendId,
                "message"    :message,
                "type"       :"text",
                "date"       :DateTime.now(),
              }).then((value) {
                FirebaseFirestore.instance.collection('users').doc(widget.currentId).collection('messages').doc(widget.friendId).set({
                  'last_msg':message,
                });
              });

              //message store by friend 
              await FirebaseFirestore.instance.collection('users').doc(widget.friendId).collection('messages').doc(widget.currentId).collection('chats').add({
                "senderId"   :widget.currentId,
                "recieverId" :widget.friendId,
                "message"    :message,
                "type"       :"text",
                "date"       :DateTime.now(),
              }).then((value) {
                FirebaseFirestore.instance.collection('users').doc(widget.friendId).collection('messages').doc(widget.currentId).set({
                  'last_msg':message,
                });
              });
            },
            
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
