// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, deprecated_member_use, prefer_const_constructors, file_names


import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/Pages/home.dart';
import 'package:myapp/Pages/Add.dart';
import 'package:myapp/utils.dart';

class Log2 extends StatefulWidget {
  const Log2({Key? key}) : super(key: key);


  @override
  _Log2State createState() => _Log2State();
}

class _Log2State extends State<Log2> {

  
  final dtbref = FirebaseDatabase.instance.ref().child("users");
  final editControler = TextEditingController();
  

  @override
  Widget build(BuildContext context) {

    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Scaffold(
      //backgroundColor: Color(0xff62cdff),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Users",
          style: SafeGoogleFont (
            'Poppins',
            fontWeight: FontWeight.w500,
            //color: const Color(0xfff0f0f0),
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff62cdff),
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(             
              query: dtbref,
              itemBuilder: (context, snapshot, animation, index){
                final name = snapshot.child('name').value.toString();
                final id = snapshot.child('id').value.toString();
                return ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.black
                  ),
                  title: Text(
                    snapshot.child('name').value.toString(),
                    style: SafeGoogleFont(
                    'Poppins',
                    fontWeight: FontWeight.w500,
                    //color: const Color(0xfff0f0f0),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder:(context) => Scaffold(
                      body: Homepage(username: name, userid: id)
                    )) 
                    );
                  },
                  trailing: PopupMenuButton(
                    constraints: BoxConstraints(
                      maxWidth: 160*fem,
                      maxHeight: 140*fem
                    ),
                    //color: Color(0xff62cdff),
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(40.0*fem),
                      ),
                    ),

                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.black
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: ListTile(
                          onTap: (){
                            Navigator.pop(context);
                            showMyDialog(name, snapshot.child('id').value.toString());
                          },
                          leading: Icon(Icons.edit),
                          title: Text(
                            'Edit',
                            style: SafeGoogleFont (
                              'Poppins',
                              fontWeight: FontWeight.w500,
                              //color: const Color(0xfff0f0f0),
                            ),
                          )
                        ),
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: ListTile(
                          onTap: (){
                            dtbref.child(snapshot.child('id').value.toString()).remove();
                            Navigator.pop(context);
                          },
                          leading: Icon(Icons.delete_outlined),
                          title: Text(
                            'Delete',
                            style: SafeGoogleFont (
                              'Poppins',
                              fontWeight: FontWeight.w500,
                              //color: const Color(0xfff0f0f0),
                            ),
                          )
                        )
                      ),
                    ]
                  ),
                ); 
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff62cdff),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder:(context) => Add()) 
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
  
  Future<void> showMyDialog(String name, String id)async{
  editControler.text = name;
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Update',
          style: SafeGoogleFont (
            'Poppins',
            fontWeight: FontWeight.w500,
            //color: const Color(0xfff0f0f0),
          ),
        ),
        content: TextField(
          controller: editControler,
          decoration: InputDecoration(
            hintText: "Edit"
          ),
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
              dtbref.child(id).update({
                'name' : editControler.text.toString()
              });
            }, 
            child: Text(
              "Update",
              style: SafeGoogleFont (
                'Poppins',
                fontWeight: FontWeight.w500,
                //color: const Color(0xfff0f0f0),
              ),
            )
          ),
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text(
              "Cancel",
              style: SafeGoogleFont (
                'Poppins',
                fontWeight: FontWeight.w500,
                //color: const Color(0xfff0f0f0),
              ),
            )
          )
        ],
      );
    });
  }
}

