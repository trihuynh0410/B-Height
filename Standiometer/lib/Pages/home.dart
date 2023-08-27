// ignore_for_file: unused_field, no_leading_underscores_for_local_identifiers, prefer_const_constructors, deprecated_member_use, non_constant_identifier_names, prefer_const_declarations, avoid_print, prefer_final_fields, unused_import

import 'dart:async';
import 'dart:math';
//import 'package:myapp/Pages/Login.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Pages/User.dart';
import 'package:myapp/utils.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:esp_smartconfig/esp_smartconfig.dart';
import 'package:myapp/Pages/Wifi.dart';



class Homepage extends StatefulWidget {
  //final String usernames;
  final String username;
  final String userid;
  const Homepage({Key? key, required this.username, required this.userid}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final Future<FirebaseApp> _fApp = Firebase.initializeApp();
  String realTimeValue = '0';
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime currentDay = DateTime.now();
  DateTime? _selectedDate;
  final waitRef = FirebaseDatabase.instance.reference().child('wait');
  final editControler = TextEditingController();
  final dtbref = FirebaseDatabase.instance.ref().child("users");
  final databaseReference = FirebaseDatabase.instance.reference();
  List<ChartData> chartData = [];
  String _height = "0";
  String _heighttime = "0";
  final dateFormat = DateFormat("HH:mm, dd-MM-yyyy");
  Timer? _timer;
  List<WifiNetwork>? _wifiNetworks;

  @override
  void initState() {
    super.initState();
    getData(widget.userid);
    _selectedDate = _focusedDay;
    dtbref.child(widget.userid).child('heightinfo').orderByChild('time').limitToLast(1).onValue.listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
      // Update the _height state variable with the retrieved value
        setState(() {
          _height = (snapshot.value as Map).values.toList()[0]['height'].toString();
          _heighttime = (snapshot.value as Map).values.toList()[0]['time'].toString();          
          _heighttime = dateFormat.format(DateTime.parse(_heighttime));
        });
      } else {
        setState(() {
          _height = "0";
          _heighttime = "unknown day";
        });
      }
    });
    _timer = Timer.periodic(Duration(seconds: 10), (timer) async {
      var wifiNetworks = await WiFiForIoTPlugin.loadWifiList();
      setState(() {
        _wifiNetworks = wifiNetworks;
      });
    });
  }

  void getData(String userid) {
  databaseReference.child('users/$userid/heightinfo').onValue.listen((event) {
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
      List<MapEntry<dynamic, dynamic>> sortedData = data.entries.toList()
        ..sort((a, b) => b.value['time'].compareTo(a.value['time']));
      List<ChartData> newData = [];
      final dateFormat = DateFormat('dd/MM\nHH:mm');
      final int numDataPoints = 6;
      for (int i = 0; i < min(sortedData.length, numDataPoints); i++) {
        MapEntry<dynamic, dynamic> entry = sortedData[i];
        String xValue = dateFormat.format(DateTime.parse(entry.value['time']));
        newData.add(ChartData(
          x: xValue,
          y: int.parse(entry.value['height']),
        ));
      }
      setState(() {
        chartData = newData;
      });
    }
  });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context){
    

    String formattedDate = DateFormat('EEEE, MMMM d').format(currentDay);
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    List<ChartData> reversedChartData = chartData.reversed.toList();

    return Container(
      color: Color(0xff62cdff),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Color(0xff62cdff),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox()
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 27*ffem),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    // fridayjuly15XmS (74:959)
                                    formattedDate,
                                    style: SafeGoogleFont (
                                      'Poppins',
                                      fontSize: 17*ffem,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5*ffem/fem,
                                      color: const Color(0xfff0f0f0),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Expanded(
                                  child: Text(
                                    'Hi, ${widget.username}',
                                    style: SafeGoogleFont (
                                      'Poppins',
                                      fontSize: 28*ffem,
                                      fontWeight: FontWeight.w500,
                                      height: 1.2000000817*ffem/fem,
                                      color: const Color(0xfff0f0f0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: SizedBox()
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder:(context) => Log2())
                                );
                              },
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Image.asset(
                                        'assets/fitness-app/images/friends.png',
                                        width: 30*fem,
                                        height: 30*fem,
                                        color: const Color(0xfff0f0f0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              color: Color(0xff62cdff),
              // calendaraSC (116:28)
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18*ffem),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    TableCalendar(
                      firstDay: DateTime(2023),
                      lastDay: DateTime(2024),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      //availableCalendarFormats: const { CalendarFormat.twoWeeks : '2 Weeks' },
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDate, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDate = selectedDay;
                          _focusedDay = focusedDay; // update `_focusedDay` here as well
                        });
                      },
                      
                      //headercalendar
                      headerStyle: const HeaderStyle(
                        titleTextStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          //fontSize: 20*ffem
                        ),
                        formatButtonTextStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      
                      //bodycalendar
                      calendarStyle: CalendarStyle(
                        defaultTextStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                        weekendTextStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Colors.blue[500],
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle: const TextStyle(
                          color: Colors.white
                        ), 
                      ),
                      
                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                        weekendStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 15,
            child: Container(
              // heightandplotSdN (108:102)
              padding: EdgeInsets.fromLTRB(20*fem, 20*fem, 20*fem, 10*fem),
              width: double.infinity,
              decoration: BoxDecoration (
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.only (
                  topLeft: Radius.circular(30*fem),
                  topRight: Radius.circular(30*fem),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      // heightUa4 (116:27)
                      decoration: BoxDecoration (
                        color: const Color(0x4c97deff),
                        borderRadius: BorderRadius.circular(20*fem),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,                              
                                    children: [ 
                                      Text(
                                        'Your current height',
                                        style: SafeGoogleFont (
                                          'Poppins',
                                          fontSize: 15*ffem,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5*ffem/fem,
                                          color: const Color(0xff000000),
                                        ),
                                      ),
                                      Text(
                                        _heighttime,
                                        style: SafeGoogleFont (
                                          'Poppins',
                                          fontSize: 15*ffem,
                                          fontWeight: FontWeight.w400,
                                          height: 1.5*ffem/fem,
                                          color: const Color(0x7f343a40),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5*fem),
                                      SizedBox(
                                        child: Image.asset(
                                          width: 34 * fem,
                                          height: 34 * fem,
                                          'assets/fitness-app/images/iconheight.png'
                                        )
                                      ),
                                      SizedBox(height: 5*fem),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              "${_height}cm",
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont (
                                'Poppins',
                                fontSize: 48*ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.5*ffem/fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height:10),
                  Expanded(
                    flex: 3,
                    child: Container(
                      // heightUa4 (116:27)
                      decoration: BoxDecoration (
                        color: const Color(0x4c97deff),
                        borderRadius: BorderRadius.circular(20*fem),
                      ),                    
                      child: Stack(
                        children: [
                          SfCartesianChart(
                            series: <LineSeries>[
                              LineSeries<ChartData, String>(
                                dataSource: reversedChartData,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                              )
                            ],
                            primaryXAxis: CategoryAxis(
                              edgeLabelPlacement: EdgeLabelPlacement.shift,
                              labelStyle: TextStyle(color: Colors.black),
                              //title: AxisTitle(text: 'Time'),
                              majorGridLines: MajorGridLines(width: 0),
                              minorGridLines: MinorGridLines(width: 0),
                              axisLine: AxisLine(color: Colors.black),
                            ),
                            primaryYAxis: NumericAxis(
                              edgeLabelPlacement: EdgeLabelPlacement.shift,
                              labelStyle: TextStyle(color: Colors.black),
                              //title: AxisTitle(text: 'Height'),
                              majorGridLines: MajorGridLines(width: 0),
                              minorGridLines: MinorGridLines(width: 0),
                              axisLine: AxisLine(color: Colors.black),
                            ), 
                          ),
                        ]
                      )        
                    ),
                  ),
                  SizedBox(height:10),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 45 * fem,
                          height: 45 * fem,
                          child: FutureBuilder<DatabaseEvent>(
                            future: FirebaseDatabase.instance.reference().child('wait').orderByKey().limitToLast(1).once(),
                            builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final wait = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
                                  final String height = wait.values.first.toString();
                                  final time = DateTime.now().toString();
                                  return ClipOval(
                                    child: Container(
                                      color: Color(0xff62cdff),
                                      width: 45 * fem,
                                      height: 45 * fem,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.black
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text(
                                                "Update height",
                                                style: SafeGoogleFont(
                                                  'Poppins',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              content: Text(
                                                "Do you accept $height cm as your new height?",
                                                style: SafeGoogleFont(
                                                  'Poppins',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  dtbref.child(widget.userid).child('heightinfo').push().set({'height': height, 'time': time});
                                                  FirebaseDatabase.instance.reference().child('wait').orderByValue().equalTo(int.parse(height)).once().then((DatabaseEvent event) {
                                                    if (event.snapshot.value != null) {
                                                      Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
                                                      String heightKey = data.keys.first;
                                                      FirebaseDatabase.instance.reference().child('wait').child(heightKey).remove();
                                                    }
                                                  });
                                                  setState(() {
                                                  _height = height.toString();
                                                  _heighttime = time.toString();
                                                  _heighttime = dateFormat.format(DateTime.parse(_heighttime));
                                                  });
                                                },
                                                child: Text(
                                                  "Yes",
                                                  style: SafeGoogleFont(
                                                    'Poppins',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  FirebaseDatabase.instance.reference().child('wait').orderByValue().equalTo(int.parse(height)).once().then((DatabaseEvent event) {
                                                    if (event.snapshot.value != null) {
                                                      Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
                                                      String heightKey = data.keys.first;
                                                      FirebaseDatabase.instance.reference().child('wait').child(heightKey).remove();
                                                    }
                                                  });
                                                },                      
                                                child: Text(
                                                  "No",
                                                  style: SafeGoogleFont(
                                                    'Poppins',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );      
                                      }
                                    ),
                                  )
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),                
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget SetHeight(String height, double ffem, double fem) {
  return Text(
    height,
    textAlign: TextAlign.center,
    style: SafeGoogleFont(
      'Poppins',
      fontSize: 48 * ffem,
      fontWeight: FontWeight.w500,
      height: 1.5 * ffem / fem,
      color: const Color(0xff000000),
    ),
  );
  }
  
}

class ChartData {
  final String x;
  final int y;
  ChartData({required this.x, required this.y});
}