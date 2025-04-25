import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/service/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/centered_circularPro_indicator.dart';
import 'package:task_manager/ui/widgets/snackbar_message.dart';



enum TaskStatus{
  sNew,
  Progress,
  Complete,
  Canceled

}

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key, required this.taskStatus, required this.taskModel, required this.refreshList,
  });

  final TaskStatus taskStatus;
  final TaskModel taskModel;
  final VoidCallback refreshList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {

  bool _inProgress= false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.taskModel.title,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
            Text(widget.taskModel.description),
            Text("Date here: ${widget.taskModel.createdDate}"),
            Row(
              children: [
                Chip(label: Text(widget.taskModel.status,style: TextStyle(color: Colors.white),),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),

                  ),
                  backgroundColor: _getStatusChipColor(),
                  side: BorderSide.none,),
                Spacer(),
                Visibility(
                  visible: _inProgress == false,
                    replacement: CenteredCircularproIndicator(),
                    child: Row(
                      children: [
                        IconButton(onPressed: _deleteTask, icon: Icon(Icons.delete)),

                        IconButton(onPressed: _showUpdateStatusDialog, icon: Icon(Icons.edit)),
                      ],
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  Color _getStatusChipColor(){

    late Color color;
    switch(widget.taskStatus){

      case TaskStatus.sNew:
        color =Colors.blue;
      case TaskStatus.Progress:
        color =Colors.purple;
      case TaskStatus.Complete:
        color =Colors.green;
      case TaskStatus.Canceled:
        color =Colors.red;
    }
    return color;


    // if(taskStatus==TaskStatus.sNew){
    //
    // }
    // else if(status=="Progress"){
    //
    // }
    // else if(status=="Complete"){
    //
    // }
    // else{
    //
    // }
  }

  void _showUpdateStatusDialog(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Update status"),
        content: Column(
          children: [
            ListTile(
              onTap: (){
                _popDialog();
                if(isSelected("New")) return;
                _changeTaskStatus("New");
              },
              title: Text("New"),
              trailing: isSelected( "New")? Icon(Icons.done,color: Colors.green,):null,
            ),
            ListTile(
              onTap: (){
                _popDialog();
                if(isSelected("Progress")) return;
                _changeTaskStatus("Progress");
              },
              title: Text("Progress"),
              trailing: isSelected( "Progress")? Icon(Icons.done,color: Colors.green,):null,

            ),
            ListTile(
              onTap: (){
                _popDialog();
                if(isSelected("Completed")) return;
                _changeTaskStatus("Completed");
              },
              title: Text("Completed"),
              trailing: isSelected( "Completed")? Icon(Icons.done,color: Colors.green,):null,

            ),
            ListTile(
              onTap: (){
                _popDialog();
                if(isSelected("Cancelled")) return;
                _changeTaskStatus("Cancelled");
              },
              title: Text("Cancelled"),
              trailing: isSelected( "Cancelled")? Icon(Icons.done,color: Colors.green,):null,

            ),
          ],
        ),
      );
    });
  }

  void _popDialog(){
    Navigator.pop(context);
  }

  bool isSelected(String status) => widget.taskModel.status == status;

  Future<void> _changeTaskStatus(String status)async{
    _inProgress =true;
    setState(() {

    });

    NetworkResponse response = await NetworkClient.getRequest(url: Urls.updateTaskStatusUrl(widget.taskModel.id, status));
    _inProgress =false;
    if(response.isSuccess){
      widget.refreshList();

    }else{
      setState(() {

      });
      showSnackbarMessage(context, response.errorMessage.toString(),true);
    }

  }

  Future<void> _deleteTask()async{
    _inProgress =true;
    setState(() {

    });

    NetworkResponse response = await NetworkClient.getRequest(url: Urls.deleteTaskUrl(widget.taskModel.id, ));
    _inProgress =false;
    if(response.isSuccess){
      widget.refreshList();

    }else{
      setState(() {

      });
      showSnackbarMessage(context, response.errorMessage.toString(),true);
    }

  }


}