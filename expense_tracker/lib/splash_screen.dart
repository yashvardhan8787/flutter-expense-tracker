import "dart:async";

import "package:flutter/material.dart";
import "package:loading_indicator/loading_indicator.dart";

import "app_view.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white, // Set your desired splash screen background color
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 20),
              Image.asset(
                "assets/logo.png",
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: const LoadingIndicator(
                    indicatorType: Indicator.ballPulse,

                    /// Required, The loading type of the widget
                    colors: const [Colors.red],

                    /// Optional, The color collections
                    strokeWidth: 2,

                    /// Optional, The stroke of the line, only applicable to widget which contains line
                    backgroundColor: Colors.white,

                    /// Optional, Background of the widget
                    pathBackgroundColor: Colors.yellow

                    /// Optional, the stroke backgroundColor
                    ),
              ) // Optional: A loading spinner
            ],
          ),
        ),
      ),
    );
  }
}
