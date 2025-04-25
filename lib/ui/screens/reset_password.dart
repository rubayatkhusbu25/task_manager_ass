import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/widgets/pop_up_message.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _CpasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _passwordVisibility = true;
  bool _cfmPasswordVisibility = true;

  pswVisibilityControl({required bool isCfmPsw}) {
    if (isCfmPsw == false) {
      setState(() {
        _passwordVisibility = !_passwordVisibility;
      });
    } else if (isCfmPsw == true) {
      setState(() {
        _cfmPasswordVisibility = !_cfmPasswordVisibility;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments;
    receivedEmailAndOtp = arguments as Map<String, dynamic>;
  }

  Map<String, dynamic>? receivedEmailAndOtp;
  bool isLoading = false;


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
                  'Set Password',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Set a password with minimum length of six ',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  obscureText: !_passwordVisibility,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  controller: _passwordController,
                  decoration:  InputDecoration(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () => pswVisibilityControl(isCfmPsw: false),
                      icon:
                      _passwordVisibility
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be min 6 char';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                TextFormField(
                  obscureText: !_cfmPasswordVisibility,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  controller: _passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Password not matched';
                    }
                    return null;
                  },
                  decoration:  InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () => pswVisibilityControl(isCfmPsw: true),
                      icon:
                      _cfmPasswordVisibility
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                    ),
                    hintText: 'Confirm Password',
                  ),
                ),


                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _onTapSubmit,
                  child:  Visibility(
                      visible: isLoading == false,
                      replacement: Padding(
                        padding: EdgeInsets.all(3),
                        child: CircularProgressIndicator(),
                      ),

                      child: Text("Confirm")),
                ),
                const SizedBox(height: 32),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      children: [
                        const TextSpan(text: "Don't have account? "),
                        TextSpan(
                          text: 'Sign In',
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }




  void _onTapSignUpButton() {
    Navigator.pushNamed(context, '/login');
  }
  void _onTapSubmit() {
    if (_formKey.currentState!.validate() == true) {
      resetPassword();
    }
    return;
  }

  Future<void> resetPassword() async {
    isLoading = true;
    setState(() {});

    String newPassword = _passwordController.text;
    Map<String, dynamic> requestBody = {
      "email": receivedEmailAndOtp!['email'],
      "OTP": receivedEmailAndOtp!['OTP'],
      "password": newPassword,
    };
    String url = Urls.resetPasswordRrl;
    NetworkResponse response = await NetworkClient.postRequest(
      url: url,
      body: requestBody,
    );
    if (response.statusCode == 200) {
      if (!mounted) return;
      showPopUp(context, 'Password reset successful');
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
            (predicate) => false,
      );
    }
    isLoading = false;
    setState(() {});
  }



  @override
  void dispose() {
    _passwordController.dispose();
    _CpasswordController.dispose();


    super.dispose();
  }

}