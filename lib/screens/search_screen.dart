import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Searchscreen extends StatefulWidget {
  UserModel user;
  Searchscreen(this.user, {super.key});

  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  TextEditingController searchController = TextEditingController();
  List<Map> searchResult = [];
  bool isLoading = false;

  void onSearch() async {
    //make search page empty
    setState(
      () {
        searchResult = [];
        isLoading = true;
      },
    );
    //load data from database
    await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: searchController.text)
        .get()
        .then(
      (value) {
        //check if name is there
        if (value.docs.length < 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No user found"),
            ),
          );
          setState(
            () {
              isLoading = false;
            },
          );
          return;
        }
        //else
        value.docs.forEach(
          (user) {
            //check user is not searching itselt
            if (user.data()['email'] != widget.user.email) {
              //add data to list(searchresult) and show search in search page
              searchResult.add(
                user.data(),
              );
            }
          },
        );
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search your friend"),
      ),
      backgroundColor: Colors.green[50],
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "type username....",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  onSearch();
                },
                icon: const Icon(Icons.search,color: Colors.green),
              )
            ],
          ),

          //for search result showing
          if (searchResult.length > 0)
            Expanded(
              child: ListView.builder(
                itemCount: searchResult.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    
                    tileColor: Colors.green[50],
                    leading: CircleAvatar(
                      child: Image.network(
                        searchResult[index]['image'],
                      ),
                    ),
                    title: Text(
                      searchResult[index]['name'],
                    ),
                    subtitle: Text(
                      searchResult[index]['email'],
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              currentUser: widget.user,
                              friendId: searchResult[index]['uid'],
                              friendname: searchResult[index]['name'],
                              friendImage: searchResult[index]['image'],
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.message,color: Colors.green[800],),
                    ),
                  );
                },
              ),
            )
          else if (isLoading == true)
            const Center(
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}
