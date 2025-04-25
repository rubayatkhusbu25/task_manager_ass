import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/pin_verification.dart';
import 'package:task_manager/ui/screens/register_screen.dart';
import 'package:task_manager/ui/widgets/pop_up_message.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/validator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                  'Your Email Address',
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
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailTEController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      return validator(
                        value!,
                        isEmptyTitle: 'Enter your mail address',
                        alertTitle: 'Enter a valid mail',
                        regExp: RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        ),
                      );
                    }
                ),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _onTapSubmit,
                  child: Visibility(
                      visible: isLoading == false,
                      replacement: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CircularProgressIndicator(),
                      ),

                      child: const Icon(Icons.arrow_circle_right_outlined)),
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

  void _onTapSubmit(){

    if (_formKey.currentState!.validate() == true) {
      forgetPasswordEmailVerify();
    }
  }

  Future<void> forgetPasswordEmailVerify() async {
    isLoading = true;
    setState(() {});
    String email = _emailTEController.text.trim();

    String url = Urls.forgetPasswordEmailVerifyUrl(email);

    NetworkResponse response = await NetworkClient.getRequest(url: url);
    if (response.statusCode == 200) {
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/forgetPasswordPin',
            (route) => false,
        arguments: email,
      );
    } else {
      isLoading = false;
      setState(() {});
      if (!mounted) return;
      showPopUp(context, 'Email not found', true);
    }
    isLoading = false;
    setState(() {});
  }

  void _onTapSignUpButton() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailTEController.dispose();

    super.dispose();
  }

}