import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:task_manager/data/models/update_profile_model.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/widgets/centered_circularPro_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snackbar_message.dart';
import 'package:task_manager/ui/widgets/tm_appBar.dart';

class UpdateProfileScreen extends StatefulWidget {
  UpdateProfileScreen({super.key, this.onUpdate});
  final VoidCallback? onUpdate;

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {


  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNController = TextEditingController();
  final TextEditingController _lastNController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _globalKey= GlobalKey<FormState>();

  final ImagePicker _imagePicker =ImagePicker();
  XFile? _pickedImage;

  bool _updateInProgress = false;
  final Logger _logger = Logger();


  @override
  void initState() {
    super.initState();

    UserModel userModel = AuthController.userModel!;

    _emailController.text = userModel.email;
    _firstNController.text = userModel.firstName;
    _lastNController.text = userModel.lastName;
    _numberController.text = userModel.mobile;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: TMAppBar(fromProfileScreen: true,),
      
      body: ScreenBackground(
          child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _globalKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(height: 80),
                      Text(
                        'Update Profile',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),
                      _buildPhotoPicker(),


                      const SizedBox(height: 8),
                      TextFormField(
                        enabled: false,
                        //readOnly: true,
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,

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
                        controller: _firstNController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,

                        decoration: const InputDecoration(
                          hintText: 'First Name',
                        ),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return "Enter your first name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _lastNController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,

                        decoration: const InputDecoration(
                          hintText: 'Last Name',
                        ),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return "Enter your last name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _numberController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'Phone',
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
                      const SizedBox(height: 8),
                      TextFormField(
                        obscureText: true,
                        controller: _passwordController,

                        decoration:  InputDecoration(
                          hintText: 'Password',
                        ),

                      ),
                      const SizedBox(height: 16),
                      Visibility(
                        visible: _updateInProgress==false ,
                        replacement: CenteredCircularproIndicator(),
                        child: ElevatedButton(
                          onPressed:_onTapSubmit,
                          child: const Icon(Icons.arrow_circle_right_outlined),
                        ),
                      ),



                    ],
                  ),
                ),
              ))),

    );
  }

  void _onTapSubmit(){
    if(_globalKey.currentState!.validate()){
      // update profile
      updateUserProfile();

    }



  }

  Future<void> updateUserProfile() async {

    _updateInProgress = true;

    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": _emailController.text.trim(),
      "firstName": _firstNController.text.trim(),
      "lastName": _lastNController.text.trim(),
      "mobile": _numberController.text.trim(),

    };


    if(_passwordController.text.isNotEmpty){
      requestBody["password"]=_passwordController.text;
    }

    if( _pickedImage != null){
      List<int> imageBytes = await _pickedImage!.readAsBytes();
      String encodedImage = base64Encode(imageBytes);
      requestBody["photo"]= encodedImage;

    }




    NetworkResponse networkResponse = await NetworkClient.postRequest(
        url: Urls.updateProfileUrl, body: requestBody);

    if (networkResponse.statusCode == 200) {
      getProfileDetails();
      setState(() {});
    } else {
      _logger.e(networkResponse.errorMessage);
    }



    _updateInProgress = false;
    setState(() {});

    if (networkResponse.isSuccess) {

      _passwordController.clear();
      showSnackbarMessage(context, "User data update Successfully!");

    }
    else{
      showSnackbarMessage(context, networkResponse.errorMessage!, true);

      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(networkResponse.errorMessage!)));

    }
  }

  Future<void> getProfileDetails() async {
    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.profileDetailsUrl,
    );
    if(response.statusCode == 200){

      String token = AuthController.token!;

      Map<String, dynamic> userDetailsMap = response.data!['data'][0];
      _logger.w(userDetailsMap);
      UpdateProfileModel updateProfileModel = UpdateProfileModel.fromJson(response.data!);

      Map<String, dynamic>prepareJsonDataForInitiatingUserModel ={
        "_id": updateProfileModel.data.id,
        "email": updateProfileModel.data.email,
        "firstName": updateProfileModel.data.firstName,
        "lastName": updateProfileModel.data.lastName,
        "mobile": updateProfileModel.data.mobile,
        "createdDate": updateProfileModel.data.createdDate,
        "photo":updateProfileModel.data.photo
      };
      UserModel userModel = UserModel.fromJson(prepareJsonDataForInitiatingUserModel);

      await AuthController.saveUserInformation(token, userModel );
      await AuthController.getUserInformation();

      widget.onUpdate!();
      if(AuthController.token != null){
        _logger.i('State update Successfully ${AuthController.userModel}');

        setState(() {

        });
      }
      else{
        _logger.e('Fail to update the state');
      }
    }
  }


  Widget _buildPhotoPicker(){
    return GestureDetector(
       onTap: _onTapPhotoPicker,

      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8)
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8)
                  )
              ),
              child:   Text("Photo",style: TextStyle(color: Colors.white),),
              alignment: Alignment.center ,
      
            ),
            SizedBox(width: 8,),
      
            Text( _pickedImage?.name ?? "Select your photo")
          ],
        ),
        alignment: Alignment.center ,
      ),
    );
  }


  Future<void> _onTapPhotoPicker() async{

    XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if(image != null){
      _pickedImage = image;
      setState(() {

      });
    }



  }
}
