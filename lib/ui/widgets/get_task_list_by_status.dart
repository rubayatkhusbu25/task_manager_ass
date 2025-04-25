
import '../../data/models/task_list_model.dart';
import '../../data/models/task_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';

Future<List<TaskModel>> getTaskListByStatus({
  required String status,
}) async {
  List<TaskModel> taskList = [];

  NetworkResponse response = await NetworkClient.getRequest(
    url: Urls.getTaskUrl(status),
  );
  if (response.statusCode == 200) {
    TaskListModel taskListModel = TaskListModel.fromJson(response.data!);
    taskList = taskListModel.taskList;
  } else {
    taskList = [];
  }

  return taskList;
}