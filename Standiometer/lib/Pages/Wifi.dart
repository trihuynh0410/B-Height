// ignore_for_file: file_names, deprecated_member_use, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, prefer_const_constructors, avoid_print



import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
//import 'package:esp_smartconfig/esp_smartconfig.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/utils.dart';
import 'dart:convert';

class WifiIcon extends StatelessWidget {
  final int level;

  WifiIcon({required this.level});

  @override
  Widget build(BuildContext context) {
    Color color;
    if (level >= -50) {
      color = Colors.green;
    } else if (level >= -60) {
      color = Colors.yellow;
    } else if (level >= -70) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }
    return Icon(Icons.wifi, color: color);
  }
}

void showWifiNetworks(BuildContext context) async {
  // Scan for available Wi-Fi networks
  List<WifiNetwork> availableNetworks = await WiFiForIoTPlugin.loadWifiList();
  double baseWidth = 375;
  double fem = MediaQuery.of(context).size.width / baseWidth;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Available Wi-Fi Networks',
          style: SafeGoogleFont (
            'Poppins',
            fontWeight: FontWeight.w500,
            //color: const Color(0xfff0f0f0),
          ),          
        ),
        //backgroundColor: Color(0xff62cdff),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0*fem),
          ),
        ),  
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Show the available Wi-Fi networks
              ...availableNetworks.map((network) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0*fem),
                  ),
                  color: Color(0x4c97deff),
                ),
                child: ListTile(
                  leading: WifiIcon(level: network.level ?? 0),
                  title: Text(
                    network.ssid!,
                    style: SafeGoogleFont (
                      'Poppins',
                      fontWeight: FontWeight.w500,
                      //color: const Color(0xfff0f0f0),
                    ),
                  ),
                  //subtitle: Text(getSignalStrengthIndicator(network.level??0)), // This is a placeholder function
                  onTap: () {
                    // When a network is tapped, open a new dialog for password input
                    showPasswordDialog(context, network);
                  },
                  
                ),
              )),
            ],
          ),
        ),
      );
    },
  );
}

void showPasswordDialog(BuildContext context, WifiNetwork network) {
  // Create a TextEditingController to retrieve the entered password
  final TextEditingController _passwordController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Enter password for ${network.ssid}',
          style: SafeGoogleFont (
            'Poppins',
            fontWeight: FontWeight.w500,
            //color: const Color(0xfff0f0f0),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Add a TextField for the user to enter the Wi-Fi password
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Wi-Fi Password'),
                obscureText: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Transmit the Wi-Fi credentials to the ESP8266 using SmartConfig
                  final ssid = "standio"; // replace with your SoftAP SSID
                  final password = "nhaccu"; // replace with your SoftAP password
                  await WiFiForIoTPlugin.connect(ssid, password: password, security: NetworkSecurity.WPA);

                  // Send the Wi-Fi credentials to the ESP8266 via a HTTP POST request
                  final response = await http.post(
                    Uri.http('192.168.4.1', '/connect'),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(<String, String>{
                      'ssid': network.ssid ?? '',
                      'password': _passwordController.text,
                    }),
                  );

                  if (response.statusCode == 200) {
                    // If the server returns a 200 OK response, then the credentials were successfully received
                        showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Connected to WiFi network $ssid'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
                  } else {
                    // If the server returns an error response, throw an exception
                    throw Exception('Failed to send credentials to the ESP8266');
                  }
                  Navigator.of(context).pop();
                },
                child: Text('Connect'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

String getSignalStrengthIndicator(int level) {
  // This is a placeholder function. Replace this with your actual implementation
  // that maps the 'level' to a string representing signal strength.
  return 'Signal Strength: $level';
}