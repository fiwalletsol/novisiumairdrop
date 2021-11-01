
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {

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
        title: Text(lang == "en" ? "Contact" : tr["Contact"].toString(),style: kTextStyle.copyWith(
          fontSize: textSize >= 1.2 ? 15 : 20,

        ),),
        centerTitle: true,
        backgroundColor: Color(0xFF212121),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ContactCards(image: "telegram",label: "Telegram", color: Colors.lightBlue, onPressed: () {
            _launchURL("https://t.me/ficommunityglobal");
          },),
          ContactCards(image: "instagram", format: "jpg",label: "Instagram", color: Colors.deepPurpleAccent, size: 50, onPressed: () {
            _launchURL("https://www.instagram.com/novisium_/");

          },),

          ContactCards(image: "twitter", label: "Twitter", color: Colors.lightGreen, size: 50, onPressed: () {
            _launchURL("https://twitter.com/fiwalletapp/");
          },),

          ContactCards(image: "email", label: "Email", color: Colors.lightGreen, size: 45, onPressed: () {
            _launchURL("https://novisium.com/");
          },),

          ContactCards(image: "web", label: "Website", color: Colors.lightGreen, size: 40, onPressed: () {
            _launchURL("https://novisium.com/");
          },),
          //ContactCards(image: Ionicons.power, label: "Logout",color: Colors.red, size: 45, onPressed: ()async {},),


        ],
      ),

    );
  }

  void _launchURL(String _url) async => await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLang();
  }
}


class ContactCards extends StatefulWidget {
  ContactCards({required this.image, required this.label, required this.color,
    this.size = 50, required this.onPressed, this.format="png",});

  final String image;
  final String label;
  final Color color;
  final double size;
  final Function onPressed;
  final String format;

  @override
  _ContactCardsState createState() => _ContactCardsState();
}

class _ContactCardsState extends State<ContactCards> {
  @override
  Widget build(BuildContext context) {
    final textSize = MediaQuery.of(context).textScaleFactor;

    return MaterialButton(
      padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 20),
      onPressed: () {
        widget.onPressed();
      },
      child: Row(
        children: [
          Image.asset("images/${widget.image}.${widget.format}", height: widget.size, width: widget.size,),
          SizedBox(width: 40.0,),
          Text(widget.label, style: kTextStyle.copyWith(
              fontSize: textSize >= 1.2 ? 17.5 : 25
          ), textAlign: TextAlign.left, textDirection: TextDirection.ltr,),

        ],
      ),
    );
  }
}
