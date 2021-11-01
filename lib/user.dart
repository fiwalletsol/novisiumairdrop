import 'dart:convert';

class Users{
  final String mail;
  final String password;
  final String address;
  final String name;
  final String number;

  Users(this.mail, this.password, this.address, this.name, this.number);


  Users.fromJson(Map<dynamic, dynamic> json) :
        mail = json['mail'] as String,
        password = json['password'] as String,
        address = json["address"] as String,
        name = json["name"] as String,
        number = json["number"] as String;

  Map<dynamic, dynamic> toJson() => <dynamic,dynamic>{
    "mail" : mail,
    "password" : password.toString(),
    "address" : address.toString(),
    "name" : name.toString(),
    "number" : number.toString(),
  };
}



