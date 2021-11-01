import 'signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';


class WelcomeScreen extends StatefulWidget {

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  void _launchURL(String _url) async => await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

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
    return Container(
      decoration: kBackGround,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => _launchURL("https://novisium.com/"),
                  child: Text(
                    "novisium.com",
                    style: kTextStyle.copyWith(fontSize: textSize >= 1.2 ? 15.0 : 25,letterSpacing: 1),
                  ),
                ),
                Image.asset(
                  "images/logo.png",
                  height: 300,
                  width: 300,
                ),
                Column(
                  children: [
                    Text(
                      lang == "en" ? "Welcome" : tr["Welcome"].toString(),
                      style: kTextStyle.copyWith(fontSize: textSize >= 1.2 ? 25.0 : 35,letterSpacing: 1),
                    ),
                    Text(
                      "NOVISIUM",
                      style: kTextStyle.copyWith(letterSpacing: 1,fontSize: textSize >= 1.2 ? 25.0 : 35,),
                    ),
                  ],
                ),
                SizedBox(height: 0.0,),
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: MaterialButton(
                        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical:15.0),
                        color: Colors.indigoAccent,
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context) => SignupScreen()),  ModalRoute.withName('/'), );

                        },
                        child: Text(lang == "en" ? "Create new account" : tr["Create new account"].toString(), style: kTextStyle.copyWith( fontSize: textSize >= 1.2 ? 15.0 : 22.5,),),
                      ),
                    ),

                    Transform.scale(
                      scale: 0.8,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context) => LoginScreen()),  ModalRoute.withName('/'), );

                        },
                        child: Text(lang == "en" ? "I have already an account" : tr["I have already an account"].toString(), style: kTextStyle.copyWith(color: Color(0xFFE0E0E0),
                            fontSize: textSize >= 1.2 ? 15.0 : 22.5),),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
