import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/main_bottom_nav.dart';
import 'package:task_manager/ui/utils/assets_path.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
    moveToNextScreen();
  }

  Future<void>moveToNextScreen()async{
    await Future.delayed(Duration(seconds: 5));


    final bool isLoggedIn = await AuthController.checkedIfUseLoggedIn();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>isLoggedIn? const MainBottomNav(): const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
          child:  Center(
              child: SvgPicture.asset(AssetsPath.logoTwo, width: 120,)))
    );
  }
}
