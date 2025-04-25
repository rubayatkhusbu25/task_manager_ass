/// user friendly way

// class UserModel {
//
//   late final String id;
//   late final String email;
//   late final String firstName;
//   late final String lastName;
//   late final String mobile;
//   late final String createdDate;
//
//   UserModel(); // constructor
//
//   UserModel.fromJson(Map<String, dynamic> jsonData){  //named constructor
//
//     id=jsonData["_id"];
//     email=jsonData["email"];
//     firstName=jsonData["firstName"];
//     lastName=jsonData["lastName"];
//     mobile=jsonData["mobile"];
//     createdDate=jsonData["createdDate"];
//
//   }
//
// }
//
//  UserModel userModel = UserModel.fromJson({});   //instance



/// jodi null hy tahole default value set kora


class UserModel {

  late final String id;
  late final String email;
  late final String firstName;
  late final String lastName;
  late final String mobile;
  late final String createdDate;
  late final String photo;



  UserModel.fromJson(Map<String, dynamic> jsonData){  //named constructor

    id=jsonData["_id"] ?? "";
    email=jsonData["email"] ?? "";
    firstName=jsonData["firstName"]?? "";
    lastName=jsonData["lastName"] ?? "";
    mobile=jsonData["mobile"]?? "";
    createdDate=jsonData["createdDate"]?? "";
    photo=jsonData["photo"]?? "";

  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "createdDate": createdDate,
      "photo":photo
    };
}

// getter for getting full Name

  String get fullName{

    return "$firstName $lastName";
  }

}

/// best way

// class UserModel {
//
//    final String id;
//    final String email;
//    final String firstName;
//    final String lastName;
//    final String mobile;
//    final String createdDate;
//
//   UserModel(
//       { required this.id,
//       required this.email,
//       required this.firstName,
//         required this.lastName,
//         required this.mobile,
//         required this.createdDate}); // constructor
//
//   factory UserModel.fromJson(Map<String, dynamic> jsonData,){  //named constructor
//
//     return UserModel(
//         id: jsonData["_id"] ?? "",
//         email: jsonData["email"] ?? "",
//         firstName: jsonData["firstName"]?? "",
//         lastName: jsonData["lastName"] ?? "",
//         mobile: jsonData["mobile"]?? "",
//         createdDate: jsonData["createdDate"]?? "",
//     );
//
//
//
//   }
//
// }
//  UserModel userModel = UserModel.fromJson({});







