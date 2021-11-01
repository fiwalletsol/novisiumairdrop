
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ionicons/ionicons.dart';
import '../constants.dart';
import '../main.dart';

import '../main_screen.dart';
import '../textFieldWidget.dart';


class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {

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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,//Color(0xFF3C415C),
      appBar: AppBar(
        backgroundColor: Color(0xFF212121),
        title: Text("Tasks", style: kTextStyle.copyWith(
          fontSize: textSize >= 1.2 ? 15 : 20,

        ),),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              AlertDialog dialog = AlertDialog(
                backgroundColor: Color(0xFF3C415C),
                title: Text("Earn NVS", style: kTextStyle,),
                content: Text("If you do one of the tasks, you get to have 2 NVS.", style: kTextStyle.copyWith(
                  fontWeight: FontWeight.normal, fontSize: textSize >= 1.2 ? 15.0 : 20,
                ),
                  overflow: TextOverflow.fade, softWrap: true,
                  textAlign: TextAlign.left,textDirection: TextDirection.ltr,),
                actionsPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                actions: [
                  Text("At the end of the Airdrop, you will get your awards.", style: kTextStyle.copyWith(fontSize: textSize >= 1.2 ? 15.0 : 20,
                  ), textAlign: TextAlign.left,)
                ],

              );
              showDialog(
                context: context,
                builder: (context) {
                  return dialog;
                },
              );
            },
            icon: Icon(Icons.info_outline_rounded),
            splashRadius: 20.0,
          )
        ],

      ),

      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Cards(label: "Telegram Channel", logo: "telegram", url: "https://t.me/novisiumofficial",onTap: (){}),
              Cards(label: "Telegram Group", logo: "telegram", url: "https://t.me/nvscommunityglobal",onTap: (){}),
              Cards(label: "Instagram", logo: "instagram", url: "https://www.instagram.com/novisium_/",onTap: (){}),
              Cards(label: "Twitter", logo: "twitter", url: "https://twitter.com/fiwalletapp/",onTap: (){},),
              //Cards(label: "Facebook", logo: "facebook", url: "https://twitter.com/fiwalletapp/",onTap: (){},),

            ],
          ),
        ),
      ),

    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMail();
    getLang();
  }

  String email = "";

  Future<void> getMail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = await prefs.getString("username")!;
    final response = await http.post(Uri.parse("https://novisium.xyz/settingdata.php"),
      body: <String, String>{
        "username": username,
        "value": "mail"
      },
    );

    setState(() {
      email = response.body;
    });

  }


}

class Cards extends StatefulWidget {

  final String logo;
  final String label;
  final String url;
  final Function onTap;

  const Cards({ required this.logo, required this.label, required this.url, required this.onTap});

  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> {

  TextEditingController controller = TextEditingController();

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
    return Container(
      margin: EdgeInsets.only(left: 15.0, right: 15.0),
      decoration: BoxDecoration(
        color: Color(0xFF212121),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Row(
        children: [
          widget.label!= "Use your email as reference" ?Container(
            child: Image.asset(widget.logo == "instagram" ? "images/${widget.logo}.jpg" : "images/${widget.logo}.png", height: 60, width: 60,),
            padding: EdgeInsets.only(left: 10.0),
          ) :
          Container(
            padding: EdgeInsets.only(left: 15.0),
            child: CircleAvatar(
              child: Icon(Ionicons.link_outline, color: Colors.white, size: 30.0,),
              radius: 25.0,
              backgroundColor: Colors.pink,
            ),
          ),
          SizedBox(width: widget.label!= "Use your email as reference" ? 20.0 :25),
          Expanded(
            child: Text(widget.label!= "Use your email as reference" ? lang == "en" ? "Follow us on ${widget.label}" : "${tr["Follow us on"].toString()} ${widget.label}"//"Follow us on ${widget.label}"
                : widget.label, style: kTextStyle.copyWith(
              fontSize: textSize >= 1.2 ? 13.0 : 18,
            ), maxLines: 3,
              overflow: TextOverflow.fade, softWrap: true,
              textAlign: TextAlign.left,textDirection: TextDirection.ltr,),
          ),
          Transform.scale(
            scale: 0.6,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
              child: MaterialButton(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();

                  if(prefs.containsKey(widget.logo)) {
                    if(widget.label != "Use your email as reference" && taken != "true") {
                      updateData(widget.logo, "true");
                      //updatePoint();

                      _launchURL(widget.url);
                      setState(() {
                        taken="true";
                      });
                    }

                    else if(widget.label != "Use your email as reference" && taken == "true") {
                      _launchURL(widget.url);
                    }
                  }

                  else {


                    if(widget.label!="Use your email as reference"){
                      showDialog(
                        context: context,
                        builder: (dialogContext){
                          return AlertDialog(
                            title: TextFields(
                              label: "Your ${widget.label} Handle",
                              onTap: () {

                              },

                              horizontal: 0,
                              controller: controller,
                            ),
                            content:  Container(
                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),

                              child: ClipRRect(
                                child: MaterialButton(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  color: Colors.indigoAccent,
                                  onPressed: () async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setString(widget.logo, controller.text);

                                    updateData(widget.logo, "true");

                                    _launchURL(widget.url);
                                    setState(() {
                                      taken="true";
                                    });

                                    Navigator.of(dialogContext).pop();
                                  },
                                  child: Text("Save", style: TextStyle(
                                      color: Colors.white,fontSize: textSize >= 1.2 ? 15.0 : 25, fontWeight: FontWeight.bold),),
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),


                            backgroundColor: Colors.black,
                          );
                        },
                      );
                    }
                  }

                  if(widget.logo == "") setRefPoint();

                  /*
                  updateData(widget.logo, "true");
                    if(taken != "true" && widget.label != "") updatePoint();
                    if(widget.label != "Use your email as reference") _launchURL(widget.url);
                   */


                },
                child: widget.logo != "" ? Icon(taken == "true" ? Icons.done : Icons.arrow_forward, color: Colors.white,size: 60.0,)
                : Text(refPoint, style: kTextStyle.copyWith(
                  fontSize: textSize >= 1.2 ? 37.5 : 45, fontWeight: FontWeight.bold
                ),),
                color: taken == "true" ? Colors.greenAccent : Color(0xFF757992),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String _url) async => await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

  String taken = "";

  Future<void> updateData(String valueToBeChanged, String newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = await prefs.getString("username")!;
    final response = await http.post(Uri.parse("https://novisium.xyz/editdata.php"),
      body: <String, String>{
        "username": username,
        "value": valueToBeChanged,
        "input" : newValue
      },
    );
  }



  Future<String> getData(String via, String _value, String input) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = await prefs.getString("username")!;
    final response = await http.post(Uri.parse("https://novisium.xyz/getdata2.php"),
      body: <String, String>{//http://novisium-000webhostapp-com.preview-domain.com/getpoint.php
        "input": input,
        "via" : via,
        "value" : _value
      },
    );


    return response.body.toString();
  }

  String refPoint = "";
  setRefPoint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = await prefs.getString("username")!;
    refPoint = await getData("username", username, "reference_point");
  }

  Future<void> getTask(String task) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = await prefs.getString("username")!;
    final response = await http.post(Uri.parse("https://novisium.xyz/gettask.php"),
      body: <String, String>{//http://novisium-000webhostapp-com.preview-domain.com/getpoint.php
        "username": username,
        "task": task,
      },
    );

    setState(() {
      taken = response.body.toString();
    });

    String value = response.body;
    print(value);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTask(widget.logo);
    setRefPoint();
    getLang();
  }
}
