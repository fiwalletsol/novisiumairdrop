import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../main_screen.dart';


class AnnouncementScreen extends StatefulWidget {


  @override
  _AnnouncementScreenState createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {

  String lang = "";

  getLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lang = prefs.getString("language") ?? "en";
    });
  }


  @override
  Widget build(BuildContext context) {
    final textSize = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      backgroundColor: Colors.black,//Color(0xFF3C415C),
      appBar: AppBar(
        backgroundColor: Color(0xFF212121),
        title: Text(lang == "en" ? "Announcements" : tr["Announcements"].toString(),style: kTextStyle.copyWith(
          fontSize: textSize >= 1.2 ? 15 : 20,

        ),),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (route) => false);
          },
          icon: Icon(Icons.arrow_back),
          splashRadius: 25.0,
        ),
      ),
      body: SafeArea(

        child: alerts.length != 0 ? ListView.builder(
          padding: EdgeInsets.only(bottom: 20.0),

          itemCount: alerts.length,
          itemBuilder: (context, index) {
            return Notifications(title: alerts[index]["title"], url: alerts[index]["url"]);
          },

        ) : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  List alerts = [];

  Future<void> getAlerts(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse("https://novisium.xyz/getalerts.php"),
      body: <String, String>{
        //"id": index.toString(),
      },
    );

    setState(() {
      alerts = json.decode(response.body);
      prefs.setInt("alerts", alerts.length);
    });

    print(alerts[0]["title"]);
    print(alerts[1]["title"]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAlerts(0);
    getLang();
  }


}

class Notifications extends StatefulWidget {

  final String title;
  final String url;

  Notifications({ required this.title, required this.url});

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    final textSize = MediaQuery.of(context).textScaleFactor;
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 30),
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 5),
      decoration: BoxDecoration(
        color: Color(0xFF212121), //0xFFFFAB91 0xFF3C415C
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10.0),
            child: CircleAvatar(
              child: Icon(Icons.notifications, color: Color(0xFFFFB300), size: 40.0,),
              backgroundColor: Color(0xFFFFFDE7),
              radius: 30.0,
            ),
          ),
          SizedBox(width: 20.0,),
          Expanded(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,

                  child: Text(widget.title,
                    style: kTextStyle.copyWith(fontSize: textSize >= 1.2 ? 13.0 : 17.5,), overflow: TextOverflow.fade, softWrap: true,
                    textAlign: TextAlign.left,textDirection: TextDirection.ltr,),
                ),
                SizedBox(height: 10.0,),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(lang == "en" ? "Click to see the details." : tr["Click to see the details."].toString(), textAlign: TextAlign.left,
                    textDirection: TextDirection.ltr,overflow: TextOverflow.fade, softWrap: true,style: kTextStyle.copyWith(
                      fontWeight: FontWeight.normal, color: Color(0xFFE0E0E0), fontSize: textSize >= 1.2 ? 12.0 : 15
                  ),),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.6,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
              child: MaterialButton(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                onPressed: () {
                  _launchURL("https://novisium.com/");
                },
                child: Icon(Icons.arrow_forward, color: Colors.white,size: 60.0,),
                color: Color(0xFF757992),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String _url) async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

  String lang = "";

  getLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lang = prefs.getString("language") ?? "en";
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLang();
  }
}
