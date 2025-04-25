
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/screens/update_profile_screen.dart';

class TMAppBar extends StatelessWidget  implements PreferredSizeWidget{
  const TMAppBar({
    super.key, this.fromProfileScreen,

  });

  final bool? fromProfileScreen;


  @override
  Widget build(BuildContext context) {

    TextTheme textTheme= Theme.of(context).textTheme;
    return AppBar(
      backgroundColor: Colors.green,
      title: GestureDetector(
        onTap: (){

          if(fromProfileScreen?? false){
            return;
          }
          _onTapProfileSection(context);

        },
        child: Row(
          children: [
            CircleAvatar(
                radius: 16,
              backgroundImage: _shouldShowImage(AuthController.userModel?.photo)?MemoryImage(base64Decode(AuthController.userModel?.photo?? "")): null,
            ),
            SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AuthController.userModel?.fullName ?? "Unknown",style: textTheme.bodyLarge?.copyWith(color: Colors.white),),
                  Text(AuthController.userModel?.email ?? "Unknown",style: textTheme.bodySmall?.copyWith(color: Colors.white),),
                ],
              ),
            ),
            IconButton(
                onPressed: (){
                  _onTapLogOut(context);
                  },
                icon: Icon(Icons.logout,color: Colors.white))
          ],
        ),
      ),

    );
  }

  bool _shouldShowImage(String? photo){

    return photo != null && photo.isNotEmpty;

  }

  void _onTapProfileSection(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateProfileScreen()));
  }


  Future<void> _onTapLogOut(BuildContext context)async{
    await AuthController.clearUserData();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (predicate)=>false);
  }

  @override

  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}