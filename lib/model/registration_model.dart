//model class RegistrationListModel
class SignUpModel {
  Status status;
  Data data;

  SignUpModel({
    required this.status,
    required this.data,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) => SignUpModel(
        status: Status.fromJson(json["status"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  String userId;
  String firstName;
  String lastName;
  String mobile;
  String address;
  String email;
  String password;
  String gender;
  String createdDate;
  String modifiedDate;
  bool status;
  String otp;
  String isOtpVerified;
  String userType;
  // String profileImageUrl;

  Data({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.address,
    required this.email,
    required this.password,
    required this.gender,
    required this.createdDate,
    required this.modifiedDate,
    required this.status,
    required this.otp,
    required this.isOtpVerified,
    required this.userType,
    // required this.profileImageUrl,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["userId"].toString(),
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        mobile: json["mobile"] ?? "",
        address: json["address"] ?? "",
        email: json["email"] ?? "",
        password: json["password"] ?? "",
        gender: json["gender"] ?? "",
        createdDate: json["createdDate"] ?? "",
        modifiedDate: json["modifiedDate"] ?? "",
        status: json["status"],
        otp: json["otp"] ?? "",
        isOtpVerified: json["isOtpVerified"] ?? "",
        userType: json["userType"] ?? "",
        // profileImageUrl: json["profileImageUrl"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": mobile,
        "address": address,
        "email": email,
        "password": password,
        "gender": gender,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "status": status,
        "otp": otp,
        "isOtpVerified": isOtpVerified,
        "userType": userType,
        // "profileImageUrl": profileImageUrl,
      };
}

class Status {
  String httpCode;
  String success;
  String message;

  Status({
    required this.httpCode,
    required this.success,
    required this.message,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        httpCode: json["httpCode"] ?? '',
        success: json["success"].toString(),
        message: json["message"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "httpCode": httpCode,
        "success": success,
        "message": message,
      };
}
