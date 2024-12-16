
import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/assets.dart';
import 'package:flutter_cab/view_model/services/splash_services.dart';

class SplashSreen extends StatefulWidget {
  const SplashSreen({super.key});

  @override
  State<SplashSreen> createState() => _SplashSreenState();
}

class _SplashSreenState extends State<SplashSreen> {

  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    super.initState();
    // Timer(Duration(seconds: 4), ()=> context.pushReplacement("/login"));
   splashServices.login(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(234, 233, 226, 1),
      body: Container(
        child: Center(
            child:
            Image.asset(appLogo1,
          // 'assets/images/Asset 233000 1.png',
          width: 297,
          height: 78,
        )
        ),
      ),
    );
  }
}
