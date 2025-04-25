import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/centered_circularPro_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snackbar_message.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNController = TextEditingController();
  final TextEditingController _lastNController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();

  bool _registrationInProgress = false;

  bool isShow = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
          child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _fromKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80,
                ),
                Text(
                  "Join With Us",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: "Email",
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
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _firstNController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: "First Name",
                  ),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return "Enter your first name";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _lastNController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: "Last Name",
                  ),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return "Enter your last name";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _numberController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                  ),
                  validator: (String? value) {
                    String phone = value?.trim() ?? "";
                    RegExp regExp = RegExp(r'^(?:\+?88|0088)?01[15-9]\d{8}$');
                    if (regExp.hasMatch(phone) == false) {
                      return "Enter your valid phone number";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  obscureText: isShow,
                  keyboardType: TextInputType.number,
                  controller: _passwordController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: "Password",
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isShow = !isShow;
                          });
                        },
                        icon: isShow
                            ? Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                              )
                            : Icon(
                                Icons.visibility,
                                color: Colors.grey,
                              )),
                  ),
                  validator: (String? value) {
                    if ((value?.isEmpty ?? true) || (value!.length < 4)) {
                      return "Enter your password more then four character";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                Visibility(
                  visible: _registrationInProgress == false,
                  replacement:CenteredCircularproIndicator(),
                  child: ElevatedButton(
                      onPressed: _onTapSubmitButton,
                      child: Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Colors.white,
                      )),
                ),
                SizedBox(
                  height: 32,
                ),
                Center(
                  child: RichText(
                      text: TextSpan(
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(text: "Already have an account? "),
                      TextSpan(
                        text: "Sign In",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _onTapSignUpButton,
                      ),
                    ],
                  )),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }

  void _onTapSubmitButton() {
    if (_fromKey.currentState!.validate()) {
      registerUser();
    }
  }

  Future<void> registerUser() async {
    _registrationInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": _emailController.text.trim(),
      "firstName": _firstNController.text.trim(),
      "lastName": _lastNController.text.trim(),
      "mobile": _numberController.text.trim(),
      "password": _passwordController.text,
    };

    NetworkResponse networkResponse = await NetworkClient.postRequest(
        url: Urls.registerUrl, body: requestBody);

    _registrationInProgress = false;
    setState(() {});

    if (networkResponse.isSuccess) {
      showSnackbarMessage(context, "User registered Successfully!");

    }
    else{
      showSnackbarMessage(context, networkResponse.errorMessage!, true);



      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(networkResponse.errorMessage!)));

    }
  }

  void _onTapSignUpButton() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNController.dispose();
    _lastNController.dispose();
    _numberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
