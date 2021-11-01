import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


Future<String> getNumber(String email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String mail = await prefs.getString("mail")!;
  final response = await http.post(Uri.parse("http://novisium.000webhostapp.com/settingdata.php"),
    body: <String, String>{
      "mail": mail,
      "value": "number"
    },
  );


  return response.body.toString();

}