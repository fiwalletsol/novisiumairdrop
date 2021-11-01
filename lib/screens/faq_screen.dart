import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import '../constants.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  _FAQScreenState createState() => _FAQScreenState();
}



class _FAQScreenState extends State<FAQScreen> {

  ExpandableThemeData theme = ExpandableThemeData(
    iconColor: Colors.white, 
  );
  ExpandableController controller = ExpandableController();

  List<bool> _isOpened = [true];
  @override
  Widget build(BuildContext context) {
    final textSize = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0xFF212121),
        title: Text("FAQ", style: kTextStyle.copyWith(
          fontSize: textSize >= 1.2 ? 15 : 20,
        ),),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Transform.scale(
            scale: 1.25,
            child: Image.asset(
              "images/logo.png", width: 300, height: 300, fit: BoxFit.contain,
            ),
          ),
          for(int i = 0; i < ques.length; i++) Ques(theme: theme, title: ques[i], body: answers[i])
        ],
      ),
    );
  }
}

class Ques extends StatelessWidget {
  Ques({required this.theme, required this.title, required this.body,});

  final ExpandableThemeData theme;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final textSize = MediaQuery.of(context).textScaleFactor;

    return Container(
      decoration: BoxDecoration(
          color: Color(0xFF212121),
          borderRadius: BorderRadius.all(Radius.circular(10.0))
      ),
      margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      child: ExpandablePanel(
        header: Container(
          child: Text(title, style: kTextStyle.copyWith(
              fontSize: textSize >= 1.2 ? 15 : 20
          ),),
          margin: EdgeInsets.all(20.0),
        ),
        collapsed: Container(),
        expanded: Container(
          margin: EdgeInsets.all(20.0),
          child: Text(body, softWrap: true, style: kTextStyle.copyWith(
              fontSize: textSize >= 1.2 ? 15 : 20, fontWeight: FontWeight.normal
          ),
            textDirection: TextDirection.ltr,textAlign: TextAlign.left,),
        ),
        theme: theme,

      ),
    );
  }
}
