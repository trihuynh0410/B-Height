// ignore_for_file: unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:myapp/utils.dart';
import 'package:myapp/Pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/Pages/Add.dart';
import 'package:myapp/Pages/User.dart';
import 'package:myapp/Pages/Login.dart';
import 'package:myapp/Pages/Wifi.dart';
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
	@override
	Widget build(BuildContext context) {
    
	return MaterialApp(
    
		home: Log2(),
    navigatorObservers: [routeObserver],
		);
	}
}
