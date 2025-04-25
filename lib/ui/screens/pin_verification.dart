import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/screens/reset_password.dart';
import 'package:task_manager/ui/widgets/pop_up_message.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

class PinVerification extends StatefulWidget {
  const PinVerification({super.key});

  @override
  State<PinVerification> createState() => _PinVerificationState();
}

class _PinVerificationState extends State<PinVerification> {
  final TextEditingController _pinVerController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final argument = ModalRoute.of(context)!.settings.arguments;
    receivedEmail = argument as String;
  }

  String? receivedEmail;

  bool isLoading = false;
  bool _isDisposed = false;

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
                  'Pin Verification',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'A 6 digit verification pin will be sent to your email',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey
                  ),
                ),
                const SizedBox(height: 24),
                PinCodeTextField(
                  length: 6,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    inactiveColor: Colors.green,
                    inactiveFillColor: Colors.white,
                    selectedFillColor: Colors.green
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,

                  // errorAnimationController: errorController,
                  controller: _pinVerController,
                  onCompleted: (v) {
                    print("Completed");
                  },
                 appContext: context,
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                  validator: (String? value) {
                    if (value!.trim().isEmpty == true) {
                      return 'Please Provide your OTP';
                    } else if (value.trim().length < 6) {
                      return 'Provide valid OTP';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _onSubmit,
                  child: Visibility(
                    visible: isLoading == false,
                      replacement: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CircularProgressIndicator(),
                      ),

                      child: const Text("Verify")),
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
                        const TextSpan(text: "Have account? "),
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
  
  void _onSubmit(){

    if (_formKey.currentState!.validate() == true) {
      forgetPasswordOTPVerify();
    }
   // Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetPassword()));
  }

  Future<void> forgetPasswordOTPVerify() async {
    final String otp = _pinVerController.text;
    if (_isDisposed) return;

    Map<String,dynamic> authDataForSetPassword= {'email': receivedEmail, 'OTP': otp};


    isLoading = true;
    setState(() {});

    String url = Urls.forgetPasswordEmailAndOPTVerifyUrl(
      email: receivedEmail,
      otp: otp,
    );
    NetworkResponse response = await NetworkClient.getRequest(url: url);
    if (_isDisposed) return;
    _pinVerController.clear();
    if (!mounted) return;
    if (response.statusCode == 200) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/resetPassword',
            (route) => false,
        arguments: authDataForSetPassword,
      );
      return;
    } else {
      showPopUp(context, 'Invalid OTP !!!', true);
    }
    isLoading = false;
    setState(() {});
  }




  void _onTapSignUpButton() {
    if (_isDisposed) return;
    Navigator.pushNamed(context, '/login');


  }



}