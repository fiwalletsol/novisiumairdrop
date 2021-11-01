import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'NotificationApi.dart';
import 'constants.dart';
import 'gradientIcon.dart';
import 'screens/announcement_screen.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'screens/settings_main_screen.dart';
import 'screens/account_screen.dart';
import 'screens/tasks_screen.dart';
import 'welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:scheduled_timer/scheduled_timer.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ionicons/ionicons.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{

  String name = "";
  Future<void> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = await prefs.getString("username")!;
    final response = await http.post(Uri.parse("https://novisium.xyz/settingdata.php"),
      body: <String, String>{
        "username": username,
        "value": "name"
      },
    );

    setState(() {
      name = username;
    });

  }

  int token = 0;
  String money2 = "";
  ScheduledTimer stoptime = ScheduledTimer(id: 'example2',
    onExecute: () {
      print("Executing");
    },);

  Duration differ = Duration();


  @override
  void initState() {
    super.initState();
    getUTC();
    getCurrentTime();
    getScheduledTime();
    setState(() {
      differ = scheduledTime.difference(currentTime);
      bubbleValue = 1 - (differ.inSeconds / 21600);
      earnButtonColor();
    });
    getAlerts();
    getPoint();
    getUsername();

    

    getLang();
  }



  String uid = "";

  StopWatchTimer _stopWatchTimer = StopWatchTimer();
  timer(bool value) {
    _stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      isLapHours: true,
      presetMillisecond: StopWatchTimer.getMilliSecFromSecond(differ.inSeconds), // differ.inSeconds


    );

    _stopWatchTimer.onExecute.add(StopWatchExecute.start);

    return value == false ? _stopWatchTimer.rawTime : _stopWatchTimer.rawTime.value;
  }


  Color? color;

  earnButtonColor() {
    if(!differ.inSeconds.isNegative){
      color = Colors.redAccent;
    }
    else if(differ.inSeconds.isNegative) {
      color = Color(0xFFFFCA28);
    }

    //isTokenAbleToEarn
  }

  getUTC() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey("UTC")){
      prefs.setInt("UTC", DateTime.now().timeZoneOffset.inHours);
    }
  }


  double bubbleValue = 0.0;
  String display = "";

  String lang = "";

  getLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lang = prefs.getString("language") ?? "en";
    });
  }

  bool earnButtonEnable = true;

  @override
  Widget build(BuildContext context) {

    //differ = stoptime.scheduledTime?.difference(DateTime.now()) ?? Duration();
    differ = scheduledTime.difference(currentTime);


    bubbleValue = 1 - (differ.inSeconds / 21600);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textSize = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,

      body: SafeArea(
        child: name != "" ? Container(
          margin: EdgeInsets.symmetric(vertical: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text("@$name", style: kTextStyle.copyWith(
                      fontWeight: FontWeight.normal,fontSize: textSize >= 1.2 ? 20.0 : 25
                  ),),
                  SizedBox(height: 40.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(Ionicons.calendar_clear),//Icon(Icons.assignment_turned_in),
                            color: Colors.white,
                            iconSize: 40.0,
                            tooltip: "Tasks",
                            onPressed: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => TasksScreen()),);

                            },
                            splashRadius: 30.0,
                          ),
                          SizedBox(height: 50.0,),
                          IconBadge(
                            icon: Icon(Ionicons.notifications,color: Colors.white, size: 40.0, ),
                            itemCount: alertBadge > 0 ? alertBadge : 0,
                            badgeColor: Colors.red,

                            itemColor: Colors.white,
                            hideZero: true,
                            onTap: () async {

                              Navigator.push(context, MaterialPageRoute(builder: (context) => AnnouncementScreen()),);
                            },
                          ),
                        ],
                      ),
                      Container(
                        width: 175,
                        height: 175,
                        child: LiquidCircularProgressIndicator(
                          //value: stoptime.scheduledTime.second
                          value: bubbleValue,//1 - (differ.inSeconds / 45), //21600
                          backgroundColor: Color(0xFF2A2A39),

                          valueColor: AlwaysStoppedAnimation(Colors.lightBlueAccent),//Color(0xFF597bb4)
                          //value: double.parse((14400 - differ.inSeconds).toString()),
                          center: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(token2.toString(), style: kTextStyle.copyWith(fontSize: textSize >= 1.2 ? 45.0 : 55,)),
                                Text("NVS", style: kTextStyle.copyWith(fontSize: textSize >= 1.2 ? 40.0 : 50, letterSpacing: 2,)),
                              ]
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(Ionicons.settings_sharp),
                            color: Colors.white,
                            iconSize: 40.0,
                            tooltip: "Settings",
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsMainScreen()),);
                            },
                            splashRadius: 30.0,
                          ),
                          SizedBox(height: 50.0,),
                          IconButton(
                            icon: Icon(Ionicons.earth),
                            tooltip: "Website",
                            color: Colors.white,
                            iconSize: 40.0,
                            onPressed: () {//stoptime!.scheduledTime!.difference(DateTime.now())
                              _launchURL("https://novisium.com/");
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => NewsScreen()),);
                            },
                            splashRadius: 30.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      RotatedBox(quarterTurns: -1, child: Text("NVS Whitepaper",
                        style: kTextStyle.copyWith(fontSize: textSize >= 1.2 ? 15.0 : 20),)),
                      SizedBox(height: 20.0,),
                      GestureDetector(
                        onTap: () async {
                          _launchURL("https://novisium.com/");
                        },
                        child: GradientIcon(Ionicons.document, 40.0, LinearGradient(
                          colors: <Color>[
                            //Color(0xFF3D5AFE),
                            //Color(0xFF3D5AFE),
                            Color(0xFF311B92),
                            Color(0xFFB3E5FC),
                            //Color(0xFFB388FF),
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),),
                      ),
                    ],
                  ),
                  Container(
                    //alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(top: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        StreamBuilder<int>(
                            stream: timer(false),
                            initialData: timer(true),
                            builder: (context, snap) {
                              if(snap.hasData == false) {
                                return CircularProgressIndicator();
                              }
                              final value = snap.data!;
                              final displayTime = StopWatchTimer.getDisplayTime(value, hours: true, second: true, minute: true);

                              if(displayTime.toString()=="00:00:00.00") return Text("06:00:00",
                                style: kTextStyle.copyWith(fontSize: textSize >= 1.2 ? 20.0 : 30),);
                              return Text("${displayTime.toString().substring(0,8)}",
                                  style: kTextStyle.copyWith(fontSize: textSize >= 1.2 ? 20.0 : 30));
                            }

                        ),
                        SizedBox(height: 20.0,),
                        Container(
                          height: 60,
                          width: 175,
                          child: ClipRRect(
                            child: MaterialButton(
                              color: Colors.lightBlue,
                              onPressed: () async {
                                getCurrentTime();
                                setState(() {
                                  differ = scheduledTime.difference(currentTime);
                                });
                                if (differ.inSeconds <= 0 && earnButtonEnable) {//prefs.getBool("isTokenAbleToEarn") == true && color.value != 4294922834
                                  setState(() {
                                    earnButtonEnable = false;
                                  });
                                  await getCurrentTime();
                                  await setScheduledTime(currentTime.add(Duration(hours: 6)).toString());
                                  await getScheduledTime();
                                  await timer(false);

                                  /*stoptime.clearSchedule();
                                  scheduledTimer();
                                  timer(false);*/
                                  await getPoint();
                                  await updatePoint();


                                  NotificationApi.showScheduledNotification(
                                      payload: "@$name",
                                      body: "You get to have 1 NSV!",
                                      title: "Novisium",
                                      scheduledTime: DateTime.now().add(Duration(hours: 6))
                                  );


                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (route) => false);

                                } else {
                                  print("Not in IF State");
                                }


                              },

                              child: Text(lang == "en" ? "Earn NVS" : tr["Earn NVS"].toString(), style: kTextStyle.copyWith(fontSize: textSize >= 1.2 ? 20.0 : 30)),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        SizedBox(height: 40.0,),
                        Column(
                          children: [
                            Text(lang == "en" ? "Powered by" : tr["Powered by"].toString(), style: kTextStyle.copyWith(fontSize: textSize >= 1.2 ? 10 : 15)),
                            SizedBox(height: 5.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset("images/solana.png", height: 20,width: 20,),
                                SizedBox(width: 10.0,),
                                Text("Solana", style: kTextStyle.copyWith(fontSize: textSize >= 1.2 ? 15.0 : 20,fontWeight: FontWeight.normal))
                              ],
                            ),
                          ],
                        ),
                      ],

                    ),
                  ),
                  GestureDetector(
                    onTap: ()  {
                      _launchURL("https://novisium.com/");
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 0),
                      child: Column(
                        children: [
                          RotatedBox(quarterTurns: -1, child: Text(lang == "en" ? "NVS Presale" : tr["NVS Presale"].toString(), style: kTextStyle.copyWith(
                            letterSpacing: 1, fontSize: textSize >= 1.2 ? 20 : 25, wordSpacing: 7.5
                          ),)),
                          SizedBox(height: 20.0,),
                          //Icon(Icons.local_fire_department, size: 65.0, color: Colors.white,),
                          GestureDetector(
                            onTap: () {
                              print(differ.inSeconds.isNegative);
                            },
                            child: GradientIcon(Icons.local_fire_department, 40.0, LinearGradient(
                              colors: <Color>[
                                //Color(0xFF3D5AFE),
                                //Color(0xFF3D5AFE),
                                Color(0xFF311B92),
                                Color(0xFFB3E5FC),
                                //Color(0xFFB388FF),
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ) : Center(child: Column(

          children: [
            Image.asset("images/logo.png", height: 300, width: 300,),
            Container(
              margin: EdgeInsets.all(30.0),
              child: Text("You are about to get in\n \nJust a moment...",style: kTextStyle.copyWith(
                  fontSize: textSize >= 1.2 ? 20.0 : 25
              ), maxLines: 3, textDirection: TextDirection.ltr, textAlign: TextAlign.center,),
            ),
            SizedBox(height: 50.0),
            Container(
              child: CircularProgressIndicator(color: Colors.white,),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.indigoAccent,
                borderRadius: BorderRadius.all(Radius.circular(50.0))
              ),
            )
          ],
        )),
      ),
    );
  }





  void _launchURL(String _url) async => await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

  List alerts = [];
  
  DateTime currentTime = DateTime(0);
  DateTime scheduledTime = DateTime(0);

  Future<String> getCurrentTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.post(Uri.parse("https://novisium.xyz/timer.php"));
    
    setState(() {
      currentTime = DateTime.parse(response.body.toString().replaceAll("/", "-")).add(Duration(hours: prefs.getInt("UTC")!));
    });

    return response.body.toString();

  }

  Future<String> getScheduledTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = await prefs.getString("username")!;

    final response = await http.post(Uri.parse("https://novisium.xyz/getdata2.php",),
      body: <String, String>{//http://novisium-000webhostapp-com.preview-domain.com/getpoint.php
        "input": "scheduled",
        "value" : username,
        "via": "username"
      },);

    setState(() {
      if(response.body.toString() != "") {
        scheduledTime = DateTime.parse(response.body.toString());
      }

      else {
        scheduledTime = DateTime(2021);
      }
    });

    return response.body.toString();

  }

  Future<void> setScheduledTime(String input) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = await prefs.getString("username")!;

    final response = await http.post(Uri.parse("https://novisium.xyz/editdata.php",),
      body: <String, String>{
        "input": input,
        "username" : username,
        "value": "scheduled"
      },);

  }

  Future<void> getAlerts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.post(Uri.parse("https://novisium.xyz/getalerts.php"),
      body: <String, String>{
        //"id": index.toString(),
      },
    );

    setState(() {
      alerts = json.decode(response.body);
      final a = prefs.getInt("alerts") ?? 0;
      alertBadge = alerts.length - a;

    });

    //print(response.body);
  }

  int alertBadge = 0;

  getAlertBadge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      final a = prefs.getInt("alerts") ?? 0;
      alertBadge = alerts.length - a;
    });
  }

  int token2 = 0;
  Future<String> getPoint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = await prefs.getString("username")!;
    final response = await http.post(Uri.parse("https://novisium.xyz/getpoint.php"),
      body: <String, String>{//http://novisium-000webhostapp-com.preview-domain.com/getpoint.php
        "username": username,
      },
    );

    setState(() {
      token2 = int.parse(response.body.toString());
    });

    String value = response.body;
    print(value);
    return response.body.toString();

  }

  Future<void> updatePoint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = await prefs.getString("username")!;
    final response = await http.post(Uri.parse("https://novisium.xyz/updatepoint.php"),
      body: <String, String>{
        "username": username,
        "point": (token2 + 1).toString(),
      },
    );

    String value = response.body;
    print(value);
    getPoint();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _stopWatchTimer.dispose();
  }
}

class MainMenuButtons extends StatefulWidget {
  final String icon;
  final Function onPressed;

  const MainMenuButtons({Key? key, required this.icon, required this.onPressed}) : super(key: key);

  @override
  _MainMenuButtonsState createState() => _MainMenuButtonsState();
}

class _MainMenuButtonsState extends State<MainMenuButtons> {
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.6,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        child: MaterialButton(
          //padding: EdgeInsets.symmetric(vertical: 15.0),
          onPressed: widget.onPressed(),
          child: Image.asset("images/${widget.icon}.png", width: 10.0, height: 10.0,),
          color: Color(0xFF1B1B2F),
        ),
      ),
    );
  }
}

