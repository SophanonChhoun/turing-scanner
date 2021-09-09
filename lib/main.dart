import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_scanner_example/page/login.dart';
import 'package:qr_code_scanner_example/page/qr_scan_page.dart';
import 'package:qr_code_scanner_example/repos/auth.dart';
import 'package:qr_code_scanner_example/widget/button_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final primaryColor = Color(0xFF22223B);
  final backgroundColorDarker = Color(0xFFF5F8FF);
  final primaryTextColor = Color(0xFF4A4E69);
  final captionColor = Color(0xFF8e9aaf);
  final primaryBackgroundColor = Color(0xFFFFFFFF);
  // final accentColor = Colors.red;
  final highlightColor = Color(0xFF02C39A);
  final secondaryColor = Color(0xFF8e9aaf);
  final brandColor = Color(0xFF6A00F4);
  final negativeColor = Color(0xFFef233c);

  final AuthRepo authRepo = new AuthRepo();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flare',
      theme: ThemeData(
          primaryColor: primaryColor,
          backgroundColor: primaryBackgroundColor,
          accentColor: brandColor,
          highlightColor: highlightColor,
          hintColor: captionColor,
          errorColor: negativeColor,
          textTheme: TextTheme(
              headline1: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: primaryColor)),
              headline2: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: primaryColor)),
              headline3: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: primaryColor)),
              headline4: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: primaryColor)),
              headline5: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: 14, color: primaryColor)),
              headline6: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: 14, color: primaryTextColor)),
              subtitle2: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 14, color: captionColor)),
              bodyText1: GoogleFonts.lato(
                  textStyle: TextStyle(
                      color: primaryTextColor, height: 1.6, fontSize: 15)),
              bodyText2: GoogleFonts.lato(
                  textStyle: TextStyle(
                      fontSize: 14, color: primaryTextColor, height: 1.6)),
              caption: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 12, color: captionColor))),
          iconTheme: IconThemeData(color: primaryColor),
          scaffoldBackgroundColor: backgroundColorDarker,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(primary: highlightColor)),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                primary: primaryColor,
                padding:
                    EdgeInsets.only(left: 32, top: 16, right: 32, bottom: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32))),
          ),
          appBarTheme: AppBarTheme(
              elevation: 0, iconTheme: IconThemeData(color: primaryColor))),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: authRepo.verifyExistingCredentials(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error loading app");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return snapshot.data ? QRScanPage() : SignInScreen();
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
