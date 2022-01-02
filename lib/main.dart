import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:news_app/views/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      // ThemeData(
      //   primaryColor: Colors.white,
      // ),
      home: AnimatedSplashScreen(
          splash: _header(),
          duration: 2000,
          backgroundColor: Colors.grey[300],
          splashTransition: SplashTransition.fadeTransition,
          nextScreen: const Home()),
    );
  }

  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Image(image: AssetImage("assets/splash_icon.png"), width: 80),
        const SizedBox(width: 5),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text("Flutter",
                    style: TextStyle(color: Colors.blue, fontSize: 24)),
                Text("News", style: TextStyle(color: Colors.red, fontSize: 24)),
              ],
            ),
            const Text(
              "- by Aditya Kanikdaley",
              style:
                  TextStyle(fontStyle: FontStyle.italic, color: Colors.green),
            )
          ],
        )
      ],
    );
  }
}
