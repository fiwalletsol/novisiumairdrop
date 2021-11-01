import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TextFields extends StatefulWidget {

  final TextEditingController controller;
  final String label;
  final TextInputType input;
  final bool obsecured;
  final Function onTap;
  final double horizontal;
  final bool suffix;


  const TextFields({ required this.controller, required this.label,
    this.input = TextInputType.text, this.obsecured = false, required this.onTap, this.horizontal = 30, this.suffix = false,});


  @override
  _TextFieldsState createState() => _TextFieldsState();
}

class _TextFieldsState extends State<TextFields> {


  bool eyeOff = false;
  @override
  Widget build(BuildContext context) {
    final textSize = MediaQuery.of(context).textScaleFactor;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: widget.horizontal, vertical: 10),
      child: Theme(
        data: Theme.of(context).copyWith(splashColor: Colors.transparent),
        child: TextField(
          inputFormatters: [
            widget.label != "Name-Surname"? FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s")) : FilteringTextInputFormatter.singleLineFormatter
          ],
          onTap: widget.onTap(),
          controller: widget.controller,
          keyboardType: widget.input,
          obscureText: widget.label == "Password" || widget.label == "Current Password" || widget.label=="Repeat Current Password"
              ? !eyeOff : false,
          cursorColor: Colors.indigoAccent,
          decoration: InputDecoration(
            suffixIcon: widget.suffix == true ? IconButton(
              onPressed: () {
                setState(() {
                  if(widget.label == "Password" || widget.label == "Current Password" || widget.label=="Repeat Current Password") {
                    if(eyeOff == false)eyeOff = true;
                    else if(eyeOff == true)eyeOff = false;
                  }
                });
              },
              icon: widget.label != "Reference Email Address" ? Icon(eyeOff==false ? Ionicons.eye_off : Ionicons.eye, color: Colors.white,) : Icon(Ionicons.help_circle, color: Colors.white),
              splashRadius: 1.0,
            ) : null,
            contentPadding: EdgeInsets.all(20.0),
            hintText: widget.label,
            fillColor: Color(0xFF212121),
            hintStyle: kTextStyle.copyWith(fontSize: textSize >= 1.2 ? 12 : 17, color: Color(0xFFCFD8DC)),
            filled: true,

            disabledBorder: kTextFieldBorder,
            border: kTextFieldBorder,
            enabledBorder: kTextFieldBorder,
            focusedBorder: kTextFieldFocusBorder,



          ),

          style: kTextStyle.copyWith(fontSize: textSize >= 1.2 ? 15.0 : 20,)



        ),
      ),

    );
  }
}
