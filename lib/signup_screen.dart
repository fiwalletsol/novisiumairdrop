import 'main_screen.dart';
import 'textFieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'login_screen.dart';
import 'package:ionicons/ionicons.dart';
import 'package:im_stepper/main.dart';
import 'package:im_stepper/stepper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:core';


class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  int activeStep = 0; // Initial step set to 5.

  int upperBound = 4;

  String email = "";
  String password = "";

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController referenceController = TextEditingController();


  String mail = "";
  String username = "";
  String password2 = "";
  String address = "";
  String reference = "";
  String number = "";
  String name = "";

  bool isValid = true;

  @override
  Widget build(BuildContext context) {
    final textSize = MediaQuery.of(context).textScaleFactor;

    List<Widget> scenes = [ Container(
      padding: EdgeInsets.only(top: 75.0),
      child: Column(
        children: [

          TextFields(controller: usernameController, label: lang == "en" ? "Username" : tr["Username"].toString(),onTap: () {},),

          Column(
            children: [
              TextFields(controller: passwordController, label: lang == "en" ? "Password" : tr["Password"].toString(), obsecured: true,onTap: () {
                 checkUsername(usernameController.text);

              }, suffix: true,),

              usernameCheck != "" ? usernameCheck.substring(0, 5) == "false" ? Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 40.0),//"Username is already used",
                  child: Text(lang == "en" ? "Username is already used" : tr["Username is already used"].toString(), textAlign: TextAlign.left,style: kTextStyle.copyWith(
                    fontSize: textSize >= 1.2 ? 15.0 : 20, color: kErrorColor,
                  ),)) : Container() : Container(),
            ],
          ),

          Container(
            padding: EdgeInsets.only(top: 200.0, bottom: 0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: MaterialButton(

                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                color: Colors.indigoAccent,//Color(0xFF9575CD),
                onPressed: () {
                  if(usernameController.text != "" && passwordController.text != "") {
                    if(usernameCheck == "") {
                      if (activeStep < upperBound) {
                        setState(() {
                          activeStep++;
                        });
                      }
                    }
                  }
                },
                child: Text(lang == "en" ? "Next" : tr["Next"].toString(), style: kTextStyle.copyWith(
                  fontSize: textSize >= 1.2 ? 17.5 : 25,)),
              ),

            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 10.0),

            child: Transform.scale(
              scale: 0.8,
              child: TextButton(
                onPressed: () {

                  Navigator.pushAndRemoveUntil(
                      context, MaterialPageRoute(builder: (context) => LoginScreen()), (
                      route) => false);

                },
                child: Text(lang == "en" ? "I have already an account" : tr["I have already an account"].toString(), style: TextStyle(
                    color: Color(0xFFE0E0E0), fontSize: textSize >= 1.2 ? 17.5 : 22.5,fontWeight: FontWeight.bold
                ),),
              ),
            ),
          ),
        ],
      ),
    ), Container(
      padding: EdgeInsets.only(top: 75.0),
      child: Column(
        children: [
          TextFields(controller: emailController, label: "Email", input: TextInputType.emailAddress,onTap: () {
            if(emailController.text!= "")isValid = EmailValidator.validate(emailController.text);

          }, suffix: false, ),
          Column(
            children: [
              TextFields(controller: nameController, label: lang == "en" ? "Name-Surname" : tr["Name-Surname"].toString(),onTap: () {
                checkMail(emailController.text);
              }),

              mailCheck != "" ? mailCheck.substring(0, 5) == "false" ? Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 40.0),//"Email is already used",
                  child: Text(lang == "en" ? "Email is already used" : tr["Email is already used"].toString(), textAlign: TextAlign.left,style: kTextStyle.copyWith(
                    fontSize: textSize >= 1.2 ? 15.0 : 20, color: kErrorColor,
                  ),)) : Container() : Container(),

              isValid != true ? Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 40.0), //"Email is invalid"
                  child: Text(lang == "en" ? "Email is invalid" : tr["Email is invalid"].toString(), textAlign: TextAlign.left,style: kTextStyle.copyWith(
                    fontSize: textSize >= 1.2 ? 15.0 : 20, color: kErrorColor,
                  ),)) : Container()

            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 200.0, bottom: 0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: MaterialButton(

                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                color: Colors.indigoAccent,//Color(0xFF9575CD),
                onPressed: () {
                  setState(() {
                    isValid = EmailValidator.validate(emailController.text);
                  });
                  print(isValid);

                  if(emailController.text != "" && nameController.text != "" && isValid) {

                    if(mailCheck == "") {
                      if (activeStep < upperBound) {
                        setState(() {
                          activeStep++;
                        });
                      }
                    }
                  }
                },
                child: Text(lang == "en" ? "Next" : tr["Next"].toString(), style: kTextStyle.copyWith(
                  fontSize: textSize >= 1.2 ? 17.5 : 25,)),
              ),

            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 10.0),

            child: Transform.scale(
              scale: 0.8,
              child: TextButton(
                onPressed: () {
                  if (activeStep > 0) {
                    setState(() {
                      activeStep--;
                    });
                  }
                },//"Swipe to Previous Page"
                child: Text(lang == "en" ? "Swipe to Previous Page" : tr["Swipe to Previous Page"].toString(), style: TextStyle(
                    color: Color(0xFFE0E0E0), fontSize: textSize >= 1.2 ? 17.5 : 22.5,fontWeight: FontWeight.bold
                ),),
              ),
            ),
          ),
        ],
      ),
    ), Container()];

    return Container(
      decoration: kBackGround,
      child: Scaffold(
        backgroundColor: Colors.transparent,

        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                IconStepper(

                  activeStepColor: Colors.blueGrey,
                  stepColor: Colors.indigoAccent,
                  enableNextPreviousButtons: false,
                  scrollingDisabled: false,
                  enableStepTapping: false,
                  lineColor: Colors.white,
                  lineDotRadius: 1,
                  icons: [
                    //Icon(Ionicons.color_wand,color: Colors.white,),
                    Icon(Ionicons.person_circle_outline,color: Colors.white,),
                    Icon(Ionicons.mail_open_outline, color: Colors.white),
                    Icon(Ionicons.attach,color: Colors.white),

                  ],
                  activeStep: activeStep,
                  onStepReached: (index) {
                    setState(() {
                      activeStep = index;
                    });
                  },
                ),

                returnScreen(scenes, activeStep),
                activeStep == 2 ? Container(
                  padding: EdgeInsets.only(top: 75.0),
                  child: Column(
                    children: [

                      TextFields(controller: addressController, label: "Solana Address",onTap: () {},),
                      TextFields(controller: referenceController, label: lang == "en" ? "Reference Email Address" : tr["Reference Email Address"].toString(),onTap: () {//"Reference Email Address"
                        getRefUsername("username",referenceController.text);
                        getRefPoint("point", referenceController.text);
                        getRefCount("reference_point", referenceController.text);
                      }, input: TextInputType.emailAddress,),

                      Container(
                        padding: EdgeInsets.only(top: 200.0, bottom: 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: MaterialButton(

                            padding: EdgeInsets.symmetric(horizontal: 85, vertical: 15),
                            color: Colors.indigoAccent,//Color(0xFF9575CD),
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              checkUsername(usernameController.text);
                              checkMail(emailController.text);
                              if(usernameController.text != "" && passwordController.text != "" && emailController.text != "" && nameController.text != "") {
                                if(usernameCheck != "" || mailCheck != ""){
                                  if (usernameCheck.substring(0, 5) != "false" || mailCheck.substring(0, 5) != "false") {
                                    insertData(emailController.text,passwordController.text,addressController.text, nameController.text,usernameController.text,numberController.text, "0",referenceController.text);


                                    prefs.setString("username", usernameController.text);
                                    prefs.setString("password", passwordController.text);

                                    updatePoint();
                                    updateRefCount();


                                    Navigator.pushAndRemoveUntil(
                                        context, MaterialPageRoute(builder: (context) => MainScreen()), (
                                        route) => false);
                                  }
                                  else {
                                    print("This email is already used!");
                                  }
                                }
                                else {
                                  insertData(emailController.text,passwordController.text, addressController.text, nameController.text, usernameController.text, numberController.text, "0", referenceController.text);
                                  prefs.setString("username", usernameController.text);
                                  prefs.setString("password", passwordController.text);

                                  updatePoint();
                                  updateRefCount();


                                  Navigator.pushAndRemoveUntil(
                                      context, MaterialPageRoute(builder: (context) => MainScreen()), (
                                      route) => false);
                                }
                              }

                            },
                            child: Text(lang == "en" ? "Sign Up" : tr["Sign Up"].toString(), style: kTextStyle.copyWith(fontSize: textSize >= 1.2 ? 20.0 : 25,)),
                          ),

                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 10.0),

                        child: Transform.scale(
                          scale: 0.8,
                          child: TextButton(
                            onPressed: () {
                              print("$refAddressUsername");
                              print("$refAddressCount");
                              print("$refAddressPoint");
                              if (activeStep > 0) {
                                setState(() {
                                  activeStep--;
                                });
                              }
                            },//"Swipe to Previous Page"
                            child: Text(lang == "en" ? "Swipe to Previous Page" : tr["Swipe to Previous Page"].toString(), style: TextStyle(
                                color: Color(0xFFE0E0E0), fontSize: textSize >= 1.2 ? 17.5 : 22.5,fontWeight: FontWeight.bold
                            ),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ) : Container(),

              ],
            ),
          ),
        ),
      ),

    );


  }

  Widget returnScreen(List<Widget> scenes, int index) {
    return scenes[index];
  }

  String lang = "";

  getLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lang = prefs.getString("language") ?? "en";
    });
  }



  Future<void> updatePoint() async {
    final response = await http.post(Uri.parse("https://novisium.xyz/updatepoint.php"),
      body: <String, String>{
        "username": refAddressUsername,
        "point": (refAddressPoint + 4).toString(),
      },
    );

  }

  Future<void> updateRefCount() async {
    final response = await http.post(Uri.parse("https://novisium.xyz/editdata.php"),
      body: <String, String>{
        "username": refAddressUsername,
        "value" : "reference_point",
        "input": (refAddressCount + 1).toString(),
      },
    );

  }

  /// Returns the header wrapping the header text.

  Future<List> insertData(String mail,String password, String address, String name, String username,String number, String point, String reference_to) async {
    final response = await http.post(Uri.parse("https://novisium.xyz/insert.php"),

      body: <String, String>{
        "mail": mail,
        "password": password, // value = futurelucas4502
        "address": address, // value = password
        "name": name, // MySql Datetime format
        "username": username, // MySql Datetime format
        "point": point, // MySql Datetime format,
        "reference_to": reference_to, // MySql Datetime format,
        "reference_point": point // MySql Datetime format,

      },
    );

    print(response.body);
    return [];
    //return response.body.toString();
  }



  String usernameCheck = "";
  String mailCheck = "";

  Future<void> checkUsername(String input) async {
    final response = await http.post(Uri.parse("https://novisium.xyz/checkmail.php"),

      body: <String, String>{
        "input": input,
        "value" : "username"
      },
    );

    String value = response.body;
    setState(() {
      try {
        usernameCheck = response.body;
        print(usernameCheck);
      } catch (e) {
        print(e);
      }
      //lenghtOfOneMail = response.body.substring(0, value.indexOf(",")).length;
      //lenghtOfSameMails = response.body.substring(0, value.lastIndexOf(",")).length;
    });
    //print("$lenghtOfOneMail : $lenghtOfSameMails");
    //print("$value2");

  }
  Future<void> checkMail(String input) async {
    final response = await http.post(Uri.parse("https://novisium.xyz/checkmail.php"),

      body: <String, String>{
        "input": input,
        "value" : "mail"
      },
    );

    String value = response.body;
    setState(() {
      try {
        mailCheck = response.body;
      } catch (e) {
        print(e);
      }
      //lenghtOfOneMail = response.body.substring(0, value.indexOf(",")).length;
      //lenghtOfSameMails = response.body.substring(0, value.lastIndexOf(",")).length;
    });
    //print("$lenghtOfOneMail : $lenghtOfSameMails");
    //print("$value2");

  }



  int refAddressCount = 0;
  int refAddressPoint = 0;

  String refAddressUsername = "";

  Future<void> getRefPoint(String input, String mail) async {
    final response = await http.post(Uri.parse("https://novisium.xyz/getdata.php"),

      body: <String, String>{
        "input": "point",
        "mail" : mail
      },
    );

    setState(() {
      refAddressPoint = int.parse(response.body.toString());
    });
  }

  Future<void> getRefUsername(String input, String mail) async {
    final response = await http.post(Uri.parse("https://novisium.xyz/getdata.php"),

      body: <String, String>{
        "input": "username",
        "mail" : mail
      },
    );

    setState(() {
      refAddressUsername = response.body.toString();
    });
  }

  Future<void> getRefCount(String input, String mail) async {
    final response = await http.post(Uri.parse("https://novisium.xyz/getdata.php"),

      body: <String, String>{
        "input": "reference_point",
        "mail" : mail
      },
    );

    setState(() {
      if(response.body.toString() != "") {
        refAddressCount = int.parse(response.body.toString());
      }
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUsername(usernameController.text);
    checkMail(emailController.text);
    getLang();
  }
}

