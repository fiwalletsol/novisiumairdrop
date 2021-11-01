import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../main_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';

import '../textFieldWidget.dart';


class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController addressController = TextEditingController();


  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newPasswordRepeatController = TextEditingController();


  String passwordErrorText="";
  bool passwordError=false;
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

        title: Text("Account", style: kTextStyle.copyWith(
          fontSize: textSize >= 1.2 ? 15 : 20,

        ),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SettingsTextFields(controller: usernameController, label:"Username",onChanged: () {
              updateData("username", usernameController.text,);
            }, label2: a, enable: false, inputType: '',suffix: true,),
            SettingsTextFields(controller: passwordController, label:"Password", inputType: "password",
              onChanged: () async {
              await getPassword();
            }, label2: password, enable: false,),
            SettingsTextFields(controller: emailController, label: "Email", onChanged: () async {
              await getMail();
            }, label2: email,inputType: "mail",errorMessage: "Email is already used"),
            SettingsTextFields(controller: addressController, label: "Solana Address",
              onChanged: () async {
              await getAddress();
            }, label2: address,inputType: "address",),
            SettingsTextFields(controller: nameController, label: "Name", onChanged: () async {
              await getName();
            }, label2: name, inputType: "name",),
           Container(
              padding: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),

              child: ClipRRect(
                child: MaterialButton(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  color: Colors.indigoAccent,
                  onPressed: () async {

                    updateData("password", passwordController.text);
                    if(SettingsTextFields.mailSaved == true && EmailValidator.validate(emailController.text) == true) updateData("mail", emailController.text);
                    updateData("address", addressController.text);
                    updateData("name", nameController.text);

                    getPassword();
                    getAddress();
                    getName();
                    getMail();
                    print(SettingsTextFields.mailSaved);

                  },
                  child: Text("Save", style: kTextStyle.copyWith(fontSize: textSize >= 1.2 ? 15.0 : 25)),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            /*Transform.scale(
              scale: 0.8,
              child: TextButton(
                onPressed: () {
                },
                child: Text(
                    "Change Password",
                    style: kTextStyle.copyWith(color: Color(0xFFE0E0E0), fontSize: textSize >= 1.2 ? 20.0 : 25,)
                ),
              ),
            ),*/
            Container(
              padding: EdgeInsets.only(left: 30, right: 30, bottom: 30.0),
              child: ClipRRect(
                child: MaterialButton(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  color: Colors.indigoAccent,
                  onPressed: () async {
                    showModalBottomSheet(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15),
                          ),
                        ),
                        useRootNavigator: true,
                        isScrollControlled: true,
                        context: (context),
                        builder: (context) {
                          return SafeArea(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.95,
                              padding: EdgeInsets.only(top: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      TextFields(obsecured: true, suffix: true,controller: currentPasswordController, label: "Current Password", onTap: () {}),
                                      TextFields(obsecured: true, suffix: true,controller: newPasswordController, label: "New Password", onTap: () {}),
                                      TextFields(obsecured: true, suffix: true,controller: newPasswordRepeatController, label:"Repeat New Password", onTap: () {}),
                                      passwordError ? Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(left: 40, top: 10.0),
                                        child: Text(passwordErrorText, style: kTextStyle.copyWith(
                                            fontSize: textSize >= 1.2 ? 15.0 : 20, color: kErrorColor),),
                                      ) : Container()
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),

                                    child: ClipRRect(
                                      child: MaterialButton(
                                        padding: EdgeInsets.symmetric(vertical: 15),
                                        color: Colors.indigoAccent,
                                        onPressed: () async {

                                          setState(() {
                                            if(currentPasswordController.text == password) {
                                              if(newPasswordController.text == newPasswordRepeatController.text){
                                                updateData("password", newPasswordController.text);
                                                passwordError = false;
                                              }
                                              else {
                                                passwordErrorText = "New Password isn't mathced";
                                                passwordError = true;

                                              }
                                            }

                                            else {
                                              passwordErrorText = "Current password isn't correct";
                                              passwordError = true;

                                            }
                                          });



                                          getPassword();

                                          if(passwordError == false) {
                                            currentPasswordController.clear();
                                            newPasswordController.clear();
                                            newPasswordRepeatController.clear();
                                            Navigator.of(context).pop();
                                          }

                                        },
                                        child: Text("Save", style: TextStyle(
                                            color: Colors.white,fontSize: textSize >= 1.2 ? 15.0 : 25, fontWeight: FontWeight.bold),),
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                    );

                  },
                  child: Text("Change Password", style: kTextStyle.copyWith(
                      fontSize: textSize >= 1.2 ? 15.0 : 25
                  ),
                ),),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),

          ],
        )
      ),
    );
  }

  String email = "";
  String password = "";
  String address = "";
  String name = "";
  String number = "";

  Future<void> getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = await prefs.getString("username")!;
    final response = await http.post(Uri.parse("https://novisium.xyz/settingdata.php"),
      body: <String, String>{
        "username": username,
        "value": "password"
      },
    );

    setState(() {
      password = response.body;
    });

  }

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

  Future<void> getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = await prefs.getString("username")!;
    final response = await http.post(Uri.parse("https://novisium.xyz/settingdata.php"),
      body: <String, String>{
        "username": username,
        "value": "address"
      },
    );

    setState(() {
      address = response.body;
    });

  }

  Future<void> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = await prefs.getString("username")!;
    final response = await http.post(Uri.parse("https://novisium.xyz/settingdata.php"),
      body: <String, String>{
        "username": username,
        "value": "name"
      },
    );

    setState(() {
      name = response.body;
    });

  }

  Future<void> getNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = await prefs.getString("username")!;
    final response = await http.post(Uri.parse("https://novisium.xyz/settingdata.php"),
      body: <String, String>{
        "username": username,
        "value": "number"
      },
    );

    setState(() {
      number = response.body;
    });

  }

  getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      a = prefs.getString("username") ?? "";
      num = prefs.getString("number") ?? "";
    });
  }

  String a = "";
  String num = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsername();
    getPassword();
    getAddress();
    getName();
    getNumber();
    getMail();
  }

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

    setState(() {
      number = response.body;
    });

  }


}

class SettingsTextFields extends StatefulWidget {

  final TextEditingController controller;
  final String label;
  final String label2;
  final TextInputType input;
  final bool obsecured;
  final Function onChanged;
  final bool enable;
  final bool suffix;
  final String inputType;
  final String errorMessage;

  static bool mailSaved = false;

  const SettingsTextFields({ required this.controller, required this.label,
    this.input = TextInputType.text, this.obsecured = false,
    required this.onChanged, required this.label2, this.enable = true, required this.inputType, this.errorMessage="", this.suffix=false});


  @override
  _SettingsTextFieldsState createState() => _SettingsTextFieldsState();
}

class _SettingsTextFieldsState extends State<SettingsTextFields> {


  String mailCheck = "";

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
      }
    });


  }


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

    if(valueToBeChanged=="username") {
      prefs.setString("username", newValue);
    } else if(valueToBeChanged=="password") {
      prefs.setString("password", newValue);
    }

  }

  String value2 = "";

  Future<String> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = await prefs.getString("username")!;
    final response = await http.post(Uri.parse("https://novisium.xyz/settingdata.php"),
      body: <String, String>{
        "username": username,
        "value": widget.inputType
      },
    );


    setState(() {
      value2 = response.body;
    });

    return response.body.toString();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    if(widget.inputType=="mail") {
      checkMail(widget.controller.text);
    }

  }

  bool changed = false;
  bool eyeOff = false;

  @override
  Widget build(BuildContext context) {

    final textSize = MediaQuery.of(context).textScaleFactor;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(padding: EdgeInsets.only(left: 10.0),child: Text(widget.label, style: kTextStyle.copyWith(
            fontSize: textSize >= 1.2 ? 15.0 : 20,
          ),)),
          SizedBox(height: 10,),
          Theme(
            data: Theme.of(context).copyWith(splashColor: Colors.transparent),
            child: TextField(
                enabled: widget.enable,


                onChanged: (value) async {
                  changed = true;

                  if(widget.inputType=="mail") {
                    String currentMail = await getData();
                    if(currentMail != widget.controller.text) checkMail(widget.controller.text);

                    if(mailCheck==""){
                      setState(() {
                        SettingsTextFields.mailSaved = true;
                      });
                    } else {
                      setState(() {
                        SettingsTextFields.mailSaved = false;
                      });
                    }
                  }

                  //if(widget.inputType=="mail") if(mailCheck=="") updateData("mail", widget.controller.text);
                  //else updateData(widget.inputType, widget.controller.text);

                  //widget.onChanged();
                },

                onTap: () {
                },


                controller: changed != true ? (widget.controller..text = widget.label2
                  ..selection = TextSelection.collapsed(offset: widget.controller.text.length)) : widget.controller,
                keyboardType: widget.input,
                obscureText: widget.label == "Password" ? true : false,
                cursorColor: Colors.blue,
                inputFormatters: [
                  widget.label != "Name" ? FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s")) : FilteringTextInputFormatter.singleLineFormatter
                ],

                decoration: InputDecoration(

                  suffixIcon: widget.suffix == true ? IconButton(
                    onPressed: () {
                      setState(() {
                        if(widget.label=="Password") {
                          if(eyeOff == false)eyeOff = true;
                          else if(eyeOff == true)eyeOff = false;
                        }
                      });
                    },
                    icon: widget.label != "Username"? Container() : Icon(Ionicons.lock_closed, color: Colors.white),
                    splashRadius: 1.0,
                  ) : null,
                  contentPadding: EdgeInsets.all(20.0),
                  hintText: widget.label,
                  fillColor: Color(0xFF212121),
                  hintStyle: TextStyle(fontSize: textSize >= 1.2 ? 12.0 : 17, color: Color(0xFFCFD8DC)),
                  filled: true,

                  disabledBorder: kTextFieldBorder,
                  border: kTextFieldBorder,
                  enabledBorder: kTextFieldBorder,
                  focusedBorder: kTextFieldFocusBorder,



                ),
                style: kTextStyle.copyWith(fontSize: textSize >= 1.2 ? 15.0 : 20,)

            ),


          ),
          SizedBox(height: 10,),

          widget.inputType=="mail"? mailCheck != "" ? mailCheck.substring(0, 5) == "false" ?
          Container(padding: EdgeInsets.only(left: 10.0),child: Text(widget.errorMessage, style: kTextStyle.copyWith(
            fontSize: textSize >= 1.2 ? 15.0 : 20, color: kErrorColor),),)
              : Container() : Container() : Container(),

          widget.inputType=="mail" ? EmailValidator.validate(widget.controller.text) == false ?
          Container(padding: EdgeInsets.only(left: 10.0),child: Text("Email is invalid", style: kTextStyle.copyWith(
              fontSize: textSize >= 1.2 ? 15.0 : 20, color: kErrorColor),),) : Container() : Container()

        ],
      ),

    );
  }
}


