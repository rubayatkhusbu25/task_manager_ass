import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/add_new_screen.dart';
import 'package:task_manager/ui/screens/forgot_password_screen.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/screens/main_bottom_nav.dart';
import 'package:task_manager/ui/screens/pin_verification.dart';
import 'package:task_manager/ui/screens/register_screen.dart';
import 'package:task_manager/ui/screens/reset_password.dart';
import 'package:task_manager/ui/screens/splash_screen.dart';
import 'package:task_manager/ui/screens/update_profile_screen.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});


  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: TaskManagerApp.navigatorKey,
      title: 'Flutter Demo',
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/resetPassword': (context) => ResetPassword(),
        '/forgetPasswordEmail': (context) => ForgotPasswordScreen(),
        '/forgetPasswordPin':
            (context) => PinVerification(),
        '/MainBottomNavScreen': (context) => MainBottomNav(),
        '/AddNewTaskScreen': (context) => AddNewTaskScreen(),
        '/UpdateProfileScreen': (context) => UpdateProfileScreen(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
          inputDecorationTheme: InputDecorationTheme(
              hintStyle:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),
              fillColor: Colors.white,
              filled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              border: _zeroBorder(),
          focusedBorder: _zeroBorder(),
          errorBorder: _zeroBorder(),
          enabledBorder: _zeroBorder()),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style:  ElevatedButton.styleFrom(
            fixedSize:Size.fromWidth(double.maxFinite),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),),
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),

        )

      ),
      home: SplashScreen(),
    );
  }

  OutlineInputBorder _zeroBorder(){
    return OutlineInputBorder(borderSide: BorderSide.none);
  }
}
