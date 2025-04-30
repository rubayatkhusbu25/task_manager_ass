// "_id": "680a9ab832c08ed3a7c6e4e2",
// "title": "Hiii",
// "description": "v",
// "status": "New",
// "email": "sample1@gmail.com",
// "createdDate": "2025-02-22T06:57:26.463Z"

class TaskModel {

  late final String id;
  late final String title;
  late final String description;
  late final String status;
  late final String createdDate;

  TaskModel.fromJson(Map<String, dynamic>jsonData){
    id =jsonData['_id']?? "";
    title = jsonData["title"]?? "";
    description = jsonData['description']?? "";
    status = jsonData['status'];
    createdDate = jsonData['createdDate']??'';

  }

}
