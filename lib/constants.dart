import 'package:flutter/material.dart';

const kTextFieldColor = Color(0xFF3D4F66); //0xFF3D4F66 //0xFF7986CB
const kErrorColor = Color(0xFFF44336); //0xFF3D4F66 //0xFF7986CB

TextStyle kTextStyle = TextStyle(fontFamily: "Satoshi",color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0,);

const kTextFieldBorder = OutlineInputBorder(
  borderSide: BorderSide(
      color: kTextFieldColor,
      width: 0.0
  ),
  borderRadius: BorderRadius.all(Radius.circular(10.0)),
);

const kTextFieldFocusBorder = OutlineInputBorder(
  borderSide: BorderSide(
      color: Colors.blue,//Color(0xFF7986CB),
      width: 2.0
  ),
  borderRadius: BorderRadius.all(Radius.circular(10.0)),
);

const kBackGround = BoxDecoration(
    /*gradient: LinearGradient(
      colors: [Color(0xFF000000), Color(0xFF3D4F66), Color(0xFF000000)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    )*/
  color: Colors.black
);


const tr = {
  "Welcome" : "Hoşgeldin",
  "Create new account" : "Yeni hesap yarat",
  "I have already an account" : "Zaten hesabım var",

  "Username" : "Kullanıcı Adı",
  "Password" : "Şifre",
  "Log In" : "Giriş Yap",
  "Password or Username is wrong" : "Kullanıcı adı veya Şifre yanlış",

  "I don't have an account" : "Yeni hesap oluştur",
  "Next" : "Devam",
  "Name-Surname" : "Ad - Soyad",
  "Swipe to Previous Page" : "Önceki Sayfaya Geç",
  "Reference Email Address" : "Referansın Email Adresi",
  "Sign Up" : "Kayıt Ol",
  "Username is already used" : "Kullanıcı adı kullanılıyor",
  "Email is invalid" : "Email geçersiz",
  "Name" : "İsim",

  "Earn NVS" : "NVS AL",
  "Powered by" : "Güçlendirildi",
  "NVS Presale" : "NVS Önsatış",

  "Click to see the details." : "Detaylar için tıklayn",
  "Announcements" : "Duyurular",

  "Follow us on" : "Bizi takip et",
  "Use your email as reference" : "Email adresini referans olarak kullan",
  "Tasks" : "Görevler",

  "Account" : "Hesap",
  "About" : "Hakkımızda",
  "Contact" : "İletişim",
  "Language" : "Dil",
  "Presale" : "Önsatış",
  "Logout" : "Çıkış Yap",
  "Settings" : "Ayarlar",

  "Save" : "Kaydet",
  "Current Password" : "Geçerli Şifre",
  "New Password" : "Yeni Şifre",
  "Repeat New Password" : "Şifre Tekrar",


  "English" : "İngilizce",
  "Turkish" : "Türkçe",

};

const ques = [
  "What is Novisium Airdrop App?",
  "When can I withdraw my NVS balance?",
  "What do I do when I forget my password?",
  "Do I have to pay anything to earn NVS?",
  "What's the total NVS demand?",
  "How do I earn NVS?",
  "What's my Reference Address",
  "Can I change my username, password, email or Solana address?",
  "What are the rewards for Novisium tasks and references?",
  "How do I delete my account?"
];

const answers = [
  "It's an application where you can earn NVS in every 6 hours. You'll earn 1 NVS in every 6 hours.",
  "Your NVS balances will be sent to your Solana address in Airdrop distribution time.",
  "Send an email with the email that you registered with to support@novisum.com about forgetting the password.",
  "No. You don't have to pay anything to join NVS Airdrop or earn NVS",
  "200.000.000 NVS has been created.",
  """There are 3 way to earn NVS. 
  
1. You can earn 1 NVS in every 6 hours.
  
2. You can earn NVS by doing the tasks in Tasks section.
  
3. You can earn NVS by inviting new users with your reference.
  """,
  "Your Reference Address is the email that you registered with.",
  "You can change all of your informations except for your username.",

  "You will earn 2 NVS for each task and every single one who you invited.",
  "If you want to delete your account, send a mail to support@novisum.com with the email that you registered with."
];