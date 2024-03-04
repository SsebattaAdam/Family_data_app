import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../AuthRepo/Authentications4app/authetication_service_Repo.dart';
import '../homepage.dart';
class BirthdayForm extends StatefulWidget {
  @override
  _BirthdayFormState createState() => _BirthdayFormState();
}

class _BirthdayFormState extends State<BirthdayForm> {

  Authentication_repositry? _authrticatedUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
    var initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> onSelectNotification(String payload) async {
    // Handle notification selection
    print('Notification selected with payload: $payload');
    // Add your logic here, such as navigating to a specific screen
  }

  Future<void> _scheduleNotification(DateTime dateTime) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Birthday Reminder',
      'It\'s time to celebrate!',
      tz.TZDateTime.from(dateTime, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
    await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveBirthday() {
    final birthday = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    firestore.collection('birthdays').add({
      'dateTime': birthday.toUtc().toIso8601String(),
    }).then((docRef) {
      print('Birthday saved with ID: ${docRef.id}');
      _scheduleNotification(birthday);
    }).catchError((error) {
      print('Failed to save birthday: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hide the leading icon
        backgroundColor: Colors.green, // Set the app bar color to green
        title: Text('Birthday Reminder', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
              onPressed: () {
               
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
              },
              icon: const Icon(Icons.home, color: Colors.white)
          ),
        ],
      ),

        body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Select Birthday Date:',
                style: TextStyle(fontSize: 30, color: Colors.green, fontWeight: FontWeight.w700),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // Set the button's background color to green
                  onPrimary: Colors.white, // Set the text color to white
                ),
                onPressed: () => _selectDate(context),
                child: Text('Select Date'),
              ),
              SizedBox(height: 20),
              Text(
                'Select Birthday Time:',
                style: TextStyle(fontSize: 30, color: Colors.green, fontWeight: FontWeight.w700),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // Set the button's background color to green
                  onPrimary: Colors.white, // Set the text color to white

                ),
                onPressed: () => _selectTime(context),
                child: Text('Select Time',),
              ),

              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _formKey.currentState?.validate(); // Validate only if currentState is not null
                    if (_formKey.currentState?.validate() ?? false) {
                      _saveBirthday();
                    }

                    Fluttertoast.showToast(
                      msg: "Bith day set successfully",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // Set the button's background color to green
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 100.0),
                  ),
                  child: Text('Save'),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
