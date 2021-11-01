import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import '../main_screen.dart';


class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
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

  @override
  Widget build(BuildContext context) {
    final textSize = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      backgroundColor: Colors.black,//Color(0xFF3C415C),
      appBar: AppBar(
        title: Text(lang == "en" ? "Language" : tr["Language"].toString(),style: kTextStyle.copyWith(
          fontSize: textSize >= 1.2 ? 15 : 20,

        ),),
        centerTitle: true,
        backgroundColor: Color(0xFF3C415C),
      ),
      body: Column(
        children: [
          Languages(image: "en",label: lang == "en" ? "English" : tr["English"].toString(), color: Colors.lightBlue, onPressed: () {
          }, size: 65,),
          Languages(image: "tr",label: lang == "en" ? "Turkish" : tr["Turkish"].toString(), color: Colors.redAccent, size: 65, onPressed: () {

          },),

        ],
      ),

    );
  }

  void _launchURL(String _url) async => await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

}


class Languages extends StatefulWidget {
  Languages({required this.image, required this.label, required this.color,
    this.size = 50, required this.onPressed, this.format="png",});

  final String image;
  final String label;
  final Color color;
  final double size;
  final Function onPressed;
  final String format;

  @override
  _LanguagesState createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  @override
  Widget build(BuildContext context) {
    final textSize = MediaQuery.of(context).textScaleFactor;

    return MaterialButton(
      padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 20),
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("language", widget.image);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (route) => false);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset("images/${widget.image}.${widget.format}", height: widget.size, width: widget.size,),
              SizedBox(width: 40.0,),
              Text(widget.label, style: kTextStyle.copyWith(
                  fontSize: textSize >= 1.2 ? 25 : 30
              ), textAlign: TextAlign.left, textDirection: TextDirection.ltr,),
            ],
          ),
          lang == widget.image ? CircleAvatar(
            backgroundColor: Colors.indigoAccent,
            child: Icon(Icons.done),
            radius: 15.0,
          ) : Container()
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLang();

  }

  String lang = "en";

  getLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lang = prefs.getString("language")!;
    });
  }
}
