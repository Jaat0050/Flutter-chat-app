import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/widgets/message.dart';
import 'package:chat_app/widgets/message_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final UserModel currentUser;
  final String friendId;
  final String friendname;
  final String friendImage;

  const ChatScreen({
    super.key,
    required this.currentUser,
    required this.friendId,
    required this.friendname,
    required this.friendImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                friendImage,
                height: 50,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              friendname,
              style: const TextStyle(fontSize: 25,color: Colors.white),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green[50],
              ),

              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("users").doc(currentUser.uid).collection('messages').doc(friendId).collection('chats').orderBy("date",descending: true).snapshots(),
                builder: (context,AsyncSnapshot snapshot) {
                  if(snapshot.hasData){
                    if(snapshot.data.docs.length < 1){
                      return const Center(child: Text("Say Hi"));}
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      reverse: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context,index) {
                        bool isMe = snapshot.data.docs[index]['senderId'] == currentUser.uid;
                        return Message(message: snapshot.data.docs[index]['message'],isMe: isMe);});}
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
              
                },
              ),
              
            ),
          ),
          MessageTextField(currentUser.uid, friendId),
        ],
      ),
    );
  }
}
