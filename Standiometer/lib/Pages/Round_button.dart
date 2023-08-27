// ignore_for_file: file_names, unnecessary_import, implementation_imports, unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/Pages/User.dart';
import 'package:myapp/utils.dart';
import 'package:intl/intl.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const RoundButton({Key? key, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fem = MediaQuery.of(context).size.width / 375;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50*fem,
        decoration: BoxDecoration(
          color: Color(0xff537FE7),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Center(child: Text(title, style: TextStyle(color: Colors.white)))
      ),
    );
  }
}