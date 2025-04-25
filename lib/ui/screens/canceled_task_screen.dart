import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/centered_circularPro_indicator.dart';
import 'package:task_manager/ui/widgets/snackbar_message.dart';
import 'package:task_manager/ui/widgets/summery_card.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

class CanceledTaskScreen extends StatefulWidget {
  const CanceledTaskScreen({super.key});

  @override
  State<CanceledTaskScreen> createState() => _CanceledTaskScreenState();
}

class _CanceledTaskScreenState extends State<CanceledTaskScreen> {

  bool _getCanceledTasksInProgress = false;
  List<TaskModel> _canceledTaskList=[];


  @override
  void initState() {
    super.initState();

    _getCanceledTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          Visibility(
            visible: _getCanceledTasksInProgress==false,
            replacement: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CenteredCircularproIndicator(),
            ),
            child: Expanded(
              child: ListView.separated(
                itemCount: _canceledTaskList.length,
                itemBuilder: (context,index){
                   return TaskCard(taskStatus: TaskStatus.Canceled,
                   taskModel: _canceledTaskList[index],
                   refreshList: _getCanceledTaskList,);
            
                }, separatorBuilder: (context, index)=>Divider(height: 8,), ),
            ),
          )



        ],
      ),
    );
  }


  Future<void> _getCanceledTaskList() async {

    _getCanceledTasksInProgress = true;
    setState(() {

    });
    final NetworkResponse response = await NetworkClient.getRequest(url: Urls.cancelTaskListUrl);

    if(response.isSuccess){

      TaskListModel taskListModel = TaskListModel.fromJson( response.data?? {});
      _canceledTaskList = taskListModel.taskList;

    }
    else{
      showSnackbarMessage(context, response.errorMessage.toString(), true);
    }
    _getCanceledTasksInProgress = false;
    setState(() {

    });

  }
}






