import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/progress_task_screen.dart';
import 'package:task_manager/ui/widgets/tm_appBar.dart';

import 'canceled_task_screen.dart';
import 'completed_task_screen.dart';
import 'new_task_screen.dart';

class MainBottomNav extends StatefulWidget {
  const MainBottomNav({super.key});

  @override
  State<MainBottomNav> createState() => _MainBottomNavState();
}

class _MainBottomNavState extends State<MainBottomNav> {



  int _selectedIndex = 0;

  List<Widget> _screen=[
    NewTaskScreen(),
    ProgressTaskScreen(),
    CompletedTaskScreen(),
    CanceledTaskScreen(),

  ];

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: TMAppBar(),
      body: _screen[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index){
          _selectedIndex=index;
          setState(() {

          });
        },
          destinations: const[
        NavigationDestination(icon: Icon(Icons.new_label), label: "New"),
        NavigationDestination(icon: Icon(Icons.public_rounded), label: "Progress"),
        NavigationDestination(icon: Icon(Icons.done), label: "Complete"),
        NavigationDestination(icon: Icon(Icons.cancel_outlined), label: "Canceled"),
      ]),
    );
  }
}

