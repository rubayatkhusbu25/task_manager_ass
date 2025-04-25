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

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {

  bool _getProgressTasksInProgress = false;
  List<TaskModel> _progressTaskList=[];

  @override
  void initState() {

    super.initState();
    _getProgressTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 
      body: Column(
        children: [



          Expanded(
            child: Visibility(
              visible: _getProgressTasksInProgress == false,
              replacement: CenteredCircularproIndicator(),
              child: ListView.separated(
                itemCount: _progressTaskList.length,
                itemBuilder: (context,index){
                   return TaskCard(
                     taskStatus: TaskStatus.Progress,
                     taskModel: _progressTaskList[index],
                     refreshList: _getProgressTaskList,
                   );
              
                }, separatorBuilder: (context, index)=>Divider(height: 8,), ),
            ),
          )



        ],
      ),
    );
  }



  Future<void> _getProgressTaskList() async {

    _getProgressTasksInProgress = true;
    setState(() {

    });
    final NetworkResponse response = await NetworkClient.getRequest(url: Urls.progressTaskListUrl);

    if(response.isSuccess){

      TaskListModel taskListModel = TaskListModel.fromJson( response.data?? {});
      _progressTaskList = taskListModel.taskList;

    }
    else{
      showSnackbarMessage(context, response.errorMessage.toString(), true);
    }
    _getProgressTasksInProgress = false;
    setState(() {

    });

  }
}






