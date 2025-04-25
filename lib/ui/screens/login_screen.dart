import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/login_model.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/register_screen.dart';


import 'package:task_manager/ui/widgets/centered_circularPro_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snackbar_message.dart';

import 'forgot_password_screen.dart';
import 'main_bottom_nav.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool isShow=true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _loginInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Text(
                  'Get Started With',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                  validator: (String? value) {
                    String email = value?.trim() ?? "";
                    //  if (value?.trim().isEmpty ?? true) {
                    if (EmailValidator.validate(email) == false) {
                      return "Enter a valid Email";
                    }
                    return null;
                  },

                ),
                const SizedBox(height: 8),
                TextFormField(

                  obscureText: isShow,
                  controller: _passwordController,
                  decoration:  InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            isShow=!isShow;
                          });
                        }, icon:isShow? Icon(Icons.visibility_off,color: Colors.grey,):Icon(Icons.visibility,color: Colors.grey,)),
                    hintText: 'Password',
                  ),
                  validator: (String? value) {
                    if ((value?.isEmpty ?? true) || (value!.length < 4)) {
                      return "Enter your password more then four character";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Visibility(
                  visible: _loginInProgress == false,
                  replacement:CenteredCircularproIndicator(),
                  child: ElevatedButton(
                    onPressed:_onTapBtn,
                    child: const Icon(Icons.arrow_circle_right_outlined),
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed:_forgetPassWordBtn,
                        child: const Text('Forgot Password?',style: TextStyle(color: Colors.grey),),
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          children: [
                            const TextSpan(text: "Don't have account? " ,style: TextStyle(color: Colors.black)),
                            TextSpan(
                              text: 'Sign Up',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = _onTapSignUpButton,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapBtn() {
    if(_formKey.currentState!.validate()){
      _login();
    }

  }

  Future<void> _login() async{

    _loginInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": _emailController.text.trim(),
      "password": _passwordController.text,
    };

    NetworkResponse networkResponse = await NetworkClient.postRequest(
        url: Urls.loginUrl, body: requestBody);

    _loginInProgress = false;
    setState(() {});

    if (networkResponse.isSuccess) {

      LoginModel loginModel= LoginModel.fromJson(networkResponse.data!);
      
      AuthController.saveUserInformation(loginModel.token, loginModel.userModel);


      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MainBottomNav(),
        ),
            (predicate) => false,
      );

    }
    else{
      showSnackbarMessage(context, networkResponse.errorMessage!, true);



      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(networkResponse.errorMessage!)));

    }

  }

  void _forgetPassWordBtn(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordScreen()));
  }


  void _onTapSignUpButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

}