// ignore_for_file: implementation_imports, file_names, unnecessary_import, unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/Pages/Round_button.dart';
import 'package:myapp/Pages/User.dart';
import 'package:myapp/utils.dart';
import 'package:intl/intl.dart';


class Log1 extends StatefulWidget {
  const Log1({Key? key}) : super(key: key);


  @override
  State<Log1> createState() => _Log1State();
}

class _Log1State extends State<Log1> {

  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

    @override
  void dispose(){ 
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double fem = MediaQuery.of(context).size.width / 375;
    

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff537FE7),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24*fem),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height*7/ 10,
            decoration: BoxDecoration (
              color: const Color(0xffffffff),
              borderRadius: BorderRadius.only (
                  topLeft: Radius.circular(20*fem),
                  topRight: Radius.circular(20*fem),
                  bottomLeft: Radius.circular(20*fem),
                  bottomRight: Radius.circular(20*fem)
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24*fem),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 24*fem),
                  Text(
                    'Welcome',
                    style: SafeGoogleFont (
                      'Rubik',
                      fontSize: 24*fem,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff3FA6E1),
                    ),
                  ),
                  SizedBox(height: 24*fem),
                  Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: SafeGoogleFont (
                            'Rubik',
                            fontSize: 14*fem,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff3FA6E1),
                          ),
                        ),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Enter email';
                            }
                            return null;
                          } 
                        ),
                        SizedBox(height: 24*fem),
                        Text(
                          'Password',
                          style: SafeGoogleFont (
                            'Rubik',
                            fontSize: 14*fem,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff3FA6E1),
                          ),
                        ),
                        TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Enter email';
                            }
                            return null;
                          } 
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 24*fem),
                  RoundButton(
                    title: 'Login', 
                    onTap: (){
                      if(_formkey.currentState!.validate()){

                      }
                    }
                  )
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}