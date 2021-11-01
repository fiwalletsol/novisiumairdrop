import 'database.dart';
import 'main_screen.dart';
import 'signup_screen.dart';
import 'textFieldWidget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String email = "";
  String password = "";

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController pocketNameController = TextEditingController();

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

        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    "images/logo.png",
                    height: 200,
                    width: 200,
                  ),
                  Column(
                    children: [
                      Text(
                        lang == "en" ? "Welcome" : tr["Welcome"].toString(),
                        style: kTextStyle.copyWith(fontSize: textSize >= 1.2 ? 25.0 : 35,letterSpacing: 1),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "NOVISIUM",
                        style: kTextStyle.copyWith(fontSize: textSize >= 1.2 ? 20.0 : 30),
                      ),
                    ],
                  ),
                ],
              ),
              TextFields(
                onTap: () {
                  if(usernameController.text.contains(" "))checkPassword(usernameController.text.substring(0, usernameController.text.lastIndexOf(" ")));
                  else checkPassword(usernameController.text);
                },
                controller: usernameController,
                label: lang == "en" ? "Username" : tr["Username"].toString(),
                input: TextInputType.text,
              ),
              Column(
                children: [
                  TextFields(
                    suffix: true,
                    onTap: () {
                      if(usernameController.text.contains(" "))checkPassword(usernameController.text.substring(0, usernameController.text.lastIndexOf(" ")));
                      else checkPassword(usernameController.text);
                    },
                    controller: passwordController,
                    label: lang == "en" ? "Password" : tr["Password"].toString(),
                    obsecured: true,
                  ),
                  correct == false ? Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 40.0),//"Password or Username is wrong"
                    child: Text(lang == "en" ? "Password or Username is wrong" : tr["Password or Username is wrong"].toString(), textAlign: TextAlign.left,style: kTextStyle.copyWith(
                      fontSize: textSize >= 1.2 ? 15.0 : 20, color: kErrorColor,
                    ),)): Container(),
                ],
              ),
//            SizedBox(height: 125.0,),
              Container(
                padding: EdgeInsets.only(top: 75.0, bottom: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: MaterialButton(
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 17.5),
                    color: Colors.indigoAccent,//(0xFF9575CD),
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();

                      if(usernameController.text != "" && passwordController.text != ""){
                        if(usernameController.text.contains(" "))checkPassword(usernameController.text.substring(0, usernameController.text.lastIndexOf(" ")));
                        else checkPassword(usernameController.text);
                        //print(passwordController.text.substring(0, passwordController.text.indexOf(" ")));
                        if(passwordController.text.contains(" ")) {
                          String a = passwordController.text.substring(0, passwordController.text.indexOf(" "));
                          if (a == password2) {
                            print("Password is correct");
                            prefs.setString("username", usernameController.text);
                            prefs.setString("password", passwordController.text);
                            prefs.setString("number", await getNumber(usernameController.text));

                            Navigator.pushAndRemoveUntil(
                                context, MaterialPageRoute(builder: (context) => MainScreen()), (
                                route) => false);                          }
                          else print("Password isn't correct");
                        } else {
                          if (passwordController.text == password2) {
                            print("Password is correct");
                            prefs.setString("username", usernameController.text);
                            prefs.setString("password", passwordController.text);

                            Navigator.pushAndRemoveUntil(
                                context, MaterialPageRoute(builder: (context) => MainScreen()), (
                                route) => false);
                          } else {
                            setState(() {
                              correct = false;
                            });
                          }
                        }

                      }
                    },
                    child: Text(
                      lang == "en" ? "Log In" : tr["Log In"].toString(),
                      style: kTextStyle.copyWith(fontSize: textSize >= 1.2 ? 15.0 : 20,),
                    ),
                  ),
                ),
              ),
              Container(
                child: Transform.scale(
                  scale: 0.8,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context, MaterialPageRoute(builder: (context) => SignupScreen()), (
                          route) => false);
                    },
                    child: Text(
                        lang == "en" ? "I don't have an account" : tr["I don't have an account"].toString(),
                      style: kTextStyle.copyWith(color: Color(0xFFE0E0E0), fontSize: textSize >= 1.2 ? 20.0 : 25,)
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String password2 = "";
  bool correct = true;

  Future<List> checkPassword(String username) async {
    final response = await http.post(Uri.parse("https://novisium.xyz/login.php"),

      body: <String, String>{
        "username": username,
      },
    );
    setState(() {
      password2 = response.body;
    });
    print(response.body);
    return [];
    //return response.body.toString();
  }
}
