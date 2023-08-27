// ignore_for_file: use_key_in_widget_constructors, camel_case_types, prefer_const_constructors, library_private_types_in_public_api, deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/utils.dart';

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  
  final postController = TextEditingController();
  bool loading = false;
  final dtbref = FirebaseDatabase.instance.ref().child("users");

  @override
  Widget build(BuildContext context) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return AlertDialog(
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30*fem),
        ),
      ),
      title: Text(
        'Add User',
        style: SafeGoogleFont (
          'Poppins',
          fontWeight: FontWeight.w500,
          //color: const Color(0xfff0f0f0),
        ),
      ),
      content: TextFormField(
        controller: postController,
        decoration: InputDecoration(
          //hintText: 'Enter your name',
        ),
      ),
      actions:[
        ElevatedButton(
          onPressed: () {
            dtbref.child(id).set({
              'name' : postController.text.toString(),
              'id': id
            });
            Navigator.pop(context);
          },
          child: Text(
            "Add",
            style: SafeGoogleFont (
              'Poppins',
              fontWeight: FontWeight.w500,
            //color: const Color(0xfff0f0f0),
          ),
          )
        )
      ]
    );
  }
}