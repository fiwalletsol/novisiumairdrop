import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ionicons/ionicons.dart';
import '../constants.dart';
import '../main_screen.dart';
import '../welcome_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'account_screen.dart';
import 'contact_screen.dart';
import 'faq_screen.dart';



class SettingsMainScreen extends StatefulWidget {
  @override
  _SettingsMainScreenState createState() => _SettingsMainScreenState();
}

class _SettingsMainScreenState extends State<SettingsMainScreen> {

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
        backgroundColor: Color(0xFF212121),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();

            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (route) => false);
            },
          splashRadius: 20.0,
        ),
        title: Text("Settings", style: kTextStyle.copyWith(
            fontSize: textSize >= 1.2 ? 15 : 20,
        ),),
        centerTitle: true,
      ),

      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SettingsButton(icon: Ionicons.person_circle_outline,
              label: lang == "en" ? "Account" : tr["Account"].toString(), color: Colors.lightBlue, onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AccountScreen()),);
              },),
            SettingsButton(icon: Ionicons.help_circle, label: lang == "en" ? "FAQ" : tr["About"].toString(), color: Colors.deepPurpleAccent, size: 45, onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FAQScreen()),);

            },),
            SettingsButton( icon: Ionicons.information_circle, label: lang == "en" ? "Contact" : tr["Contact"].toString(), color: Colors.orange, size: 45, onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ContactScreen()),);

            },),
            /*SettingsButton(icon: Icons.translate, label: lang == "en" ? "Language" : tr["Language"].toString(), color: Colors.pinkAccent, size: 35, onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LanguageScreen()),);},),*/
            SettingsButton(icon: Ionicons.cash, label: lang == "en" ? "Presale" : tr["Presale"].toString(), color: Colors.lightGreen, size: 40, onPressed: () {
              _launchURL("https://novisium.com/");
            },),
            SettingsButton(icon: Ionicons.power, label: lang == "en" ? "Logout" : tr["Logout"].toString(), color: Colors.red, size: 40, onPressed: ()async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove("username");
              prefs.remove("password");

              Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (context) => WelcomeScreen()), (
              route) => false);
    },),
          ],
        ),
      ),

    );
  }

  void _launchURL(String _url) async => await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

}

class SettingsButton extends StatefulWidget {
  SettingsButton({required this.icon, required this.label, required this.color, this.size = 50, required this.onPressed,});

  final IconData icon;
  final String label;
  final Color color;
  final double size;
  final Function onPressed;

  @override
  _SettingsButtonState createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton> {
  @override
  Widget build(BuildContext context) {
    final textSize = MediaQuery.of(context).textScaleFactor;

    return MaterialButton(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
      onPressed: () {
        widget.onPressed();
      },
      child: Row(
        children: [
          CircleAvatar(
            child: Icon(widget.icon, color: Colors.white, size: widget.size,),
            backgroundColor: widget.color,
            radius: 35,
          ),
          SizedBox(width: 40.0,),
          Text(widget.label, style: kTextStyle.copyWith(
              fontSize: textSize >= 1.2 ? 22.5 : 30
          ), textAlign: TextAlign.left, textDirection: TextDirection.ltr,),

        ],
      ),
    );
  }
}
