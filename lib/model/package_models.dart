
class GetPackageListModel {
  Status status;
  Data data;

  GetPackageListModel({
    required this.status,
    required this.data,
  });

  factory GetPackageListModel.fromJson(Map<String, dynamic> json) =>
      GetPackageListModel(
        status: Status.fromJson(json["status"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  List<Content> content;
  Pageable pageable;
  int totalPages;
  int totalElements;
  bool last;
  int size;
  int number;
  Sort sort;
  int numberOfElements;
  bool first;
  bool empty;

  Data({
    required this.content,
    required this.pageable,
    required this.totalPages,
    required this.totalElements,
    required this.last,
    required this.size,
    required this.number,
    required this.sort,
    required this.numberOfElements,
    required this.first,
    required this.empty,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        content:
            List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
        pageable: Pageable.fromJson(json["pageable"]),
        totalPages: json["totalPages"],
        totalElements: json["totalElements"],
        last: json["last"],
        size: json["size"],
        number: json["number"],
        sort: Sort.fromJson(json["sort"]),
        numberOfElements: json["numberOfElements"],
        first: json["first"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
        "pageable": pageable.toJson(),
        "totalPages": totalPages,
        "totalElements": totalElements,
        "last": last,
        "size": size,
        "number": number,
        "sort": sort.toJson(),
        "numberOfElements": numberOfElements,
        "first": first,
        "empty": empty,
      };
}

class Content {
  String packageId;
  String country;
  String state;
  String packageName;
  String location;
  String noOfDays;
  List<String> packageImageUrl;
  String totalPrice;
  String packageStatus;
  String createdDate;
  String modifiedDate;
  List<PackageActivity> packageActivities;
  double? packageDiscountedAmount;
  Content({
    required this.packageId,
    required this.country,
    required this.state,
    required this.packageName,
    required this.location,
    required this.noOfDays,
    required this.packageImageUrl,
    required this.totalPrice,
    required this.packageStatus,
    required this.createdDate,
    required this.modifiedDate,
    required this.packageActivities,
    this.packageDiscountedAmount,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        packageId: json["packageId"].toString(),
        country: json["country"] ?? "",
        state: json["state"] ?? "",
        packageName: json["packageName"] ?? "",
        location: json["location"] ?? "",
        noOfDays: json["noOfDays"] ?? "",
        packageImageUrl:
            List<String>.from(json["packageImageUrl"].map((x) => x)),
        totalPrice: json["totalPrice"].toString(),
        packageStatus: json["packageStatus"].toString(),
        createdDate: json["createdDate"].toString(),
        modifiedDate: json["modifiedDate"].toString(),
        packageActivities: List<PackageActivity>.from(
            json["packageActivities"].map((x) => PackageActivity.fromJson(x))),
      packageDiscountedAmount: json['packageDiscountedAmount'] ?? 0
      );

  Map<String, dynamic> toJson() => {
        "packageId": packageId,
        "country": country,
        "state": state,
        "packageName": packageName,
        "location": location,
        "noOfDays": noOfDays,
        "packageImageUrl": List<dynamic>.from(packageImageUrl.map((x) => x)),
        "totalPrice": totalPrice,
        "packageStatus": packageStatus,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "packageActivities":
            List<dynamic>.from(packageActivities.map((x) => x.toJson())),
        "packageDiscountedAmount": packageDiscountedAmount
      };
}

class PackageActivity {
  String packageActivityId;
  Activity activity;
  String day;
  String startTime;

  PackageActivity({
    required this.packageActivityId,
    required this.activity,
    required this.day,
    required this.startTime,
  });

  factory PackageActivity.fromJson(Map<String, dynamic> json) =>
      PackageActivity(
        packageActivityId: json["packageActivityId"].toString(),
        activity: Activity.fromJson(json["activity"]),
        day: json["day"].toString(),
        startTime: json["startTime"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "packageActivityId": packageActivityId,
        "activity": activity.toJson(),
        "day": day,
        "startTime": startTime,
      };
}

class Activity {
  String activityId;
  String country;
  String state;
  String city;
  String address;
  String activityName;
  String bestTimeToVisit;
  String activityHours;
  String activityPrice;
  String startTime;
  String endTime;
  String description;
  List<ParticipantType> participantType;
  List<String> weeklyOff;
  List<String> activityImageUrl;
  String activityStatus;
  String createdDate;
  String modifiedDate;
  List<ActivityReligiousOffDate> activityReligiousOffDates;
  AgeGroupDiscountPercent? ageGroupDiscountPercent;
  double discountedAmount;
  Activity(
      {required this.activityId,
      required this.country,
      required this.state,
      required this.city,
      required this.address,
      required this.activityName,
      required this.bestTimeToVisit,
      required this.activityHours,
      required this.activityPrice,
      required this.startTime,
      required this.endTime,
      required this.description,
      required this.participantType,
      required this.weeklyOff,
      required this.activityImageUrl,
      required this.activityStatus,
      required this.createdDate,
      required this.modifiedDate,
      required this.activityReligiousOffDates,
      this.ageGroupDiscountPercent,
      required this.discountedAmount});

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
      activityId: json["activityId"].toString(),
      country: json["country"] ?? "",
      state: json["state"] ?? "",
      city: json["city"] ?? "",
      address: json["address"] ?? "",
      activityName: json["activityName"] ?? "",
      bestTimeToVisit: json["bestTimeToVisit"] ?? "",
      activityHours: json["activityHours"].toString(),
      activityPrice: json["activityPrice"].toString(),
      startTime: json["startTime"] ?? "",
      endTime: json["endTime"] ?? "",
      description: json["description"] ?? "",
      participantType: List<ParticipantType>.from(
          json["participantType"].map((x) => participantTypeValues.map[x]!)),
      weeklyOff: List<String>.from(json["weeklyOff"].map((x) => x)),
      activityImageUrl:
          List<String>.from(json["activityImageUrl"].map((x) => x)),
      activityStatus: json["activityStatus"].toString(),
      createdDate: json["createdDate"].toString(),
      modifiedDate: json["modifiedDate"].toString(),
      activityReligiousOffDates: List<ActivityReligiousOffDate>.from(
          json["activityReligiousOffDates"]
              .map((x) => ActivityReligiousOffDate.fromJson(x))),
      ageGroupDiscountPercent: json["ageGroupDiscountPercent"] == null
          ? null
          : AgeGroupDiscountPercent.fromJson(json["ageGroupDiscountPercent"]),
      discountedAmount: json['discountedAmount'] ?? 0);

  Map<String, dynamic> toJson() => {
        "activityId": activityId,
        "country": country,
        "state": state,
        "city": city,
        "address": address,
        "activityName": activityName,
        "bestTimeToVisit": bestTimeToVisit,
        "activityHours": activityHours,
        "activityPrice": activityPrice,
        "startTime": startTime,
        "endTime": endTime,
        "description": description,
        "participantType": List<dynamic>.from(
            participantType.map((x) => participantTypeValues.reverse[x])),
        "weeklyOff": List<dynamic>.from(weeklyOff.map((x) => x)),
        "activityImageUrl": List<dynamic>.from(activityImageUrl.map((x) => x)),
        "activityStatus": packageStatusEnumValues.reverse[activityStatus],
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "activityReligiousOffDates": List<dynamic>.from(
            activityReligiousOffDates.map((x) => x.toJson())),
        "ageGroupDiscountPercent": ageGroupDiscountPercent?.toJson(),
        "discountedAmount": discountedAmount
      };
}

class ActivityReligiousOffDate {
  String activityReligiousOffId;
  String religiousOffDate;
  String isCancelled;
  String createdDate;
  String modifiedDate;

  ActivityReligiousOffDate({
    required this.activityReligiousOffId,
    required this.religiousOffDate,
    required this.isCancelled,
    required this.createdDate,
    required this.modifiedDate,
  });

  factory ActivityReligiousOffDate.fromJson(Map<String, dynamic> json) =>
      ActivityReligiousOffDate(
        activityReligiousOffId: json["activityReligiousOffId"].toString(),
        religiousOffDate: json["religiousOffDate"] ?? "",
        isCancelled: json["isCancelled"].toString(),
        createdDate: json["createdDate"].toString(),
        modifiedDate: json["modifiedDate"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "activityReligiousOffId": activityReligiousOffId,
        "religiousOffDate": religiousOffDate,
        "isCancelled": isCancelled,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
      };
}

class AgeGroupDiscountPercent {
  double? child;
  double? senior;
  double? infant;

  AgeGroupDiscountPercent({
    this.child,
    this.senior,
    this.infant,
  });

  factory AgeGroupDiscountPercent.fromJson(Map<String, dynamic> json) =>
      AgeGroupDiscountPercent(
        child: json["CHILD"],
        senior: json["SENIOR"],
        infant: json["INFANT"],
      );

  Map<String, dynamic> toJson() => {
        "CHILD": child,
        "SENIOR": senior,
        "INFANT": infant,
      };
}

enum PackageStatusEnum { TRUE }

final packageStatusEnumValues = EnumValues({"TRUE": PackageStatusEnum.TRUE});

enum ParticipantType { ADULT, CHILD, INFANT, SENIOR, TEEN }

final participantTypeValues = EnumValues({
  "ADULT": ParticipantType.ADULT,
  "CHILD": ParticipantType.CHILD,
  "INFANT": ParticipantType.INFANT,
  "SENIOR": ParticipantType.SENIOR,
  "TEEN": ParticipantType.TEEN
});

class Pageable {
  Sort sort;
  int pageNumber;
  int pageSize;
  int offset;
  bool paged;
  bool unpaged;

  Pageable({
    required this.sort,
    required this.pageNumber,
    required this.pageSize,
    required this.offset,
    required this.paged,
    required this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        sort: Sort.fromJson(json["sort"]),
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        offset: json["offset"],
        paged: json["paged"],
        unpaged: json["unpaged"],
      );

  Map<String, dynamic> toJson() => {
        "sort": sort.toJson(),
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "offset": offset,
        "paged": paged,
        "unpaged": unpaged,
      };
}

class Sort {
  bool sorted;
  bool empty;
  bool unsorted;

  Sort({
    required this.sorted,
    required this.empty,
    required this.unsorted,
  });

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
        sorted: json["sorted"],
        empty: json["empty"],
        unsorted: json["unsorted"],
      );

  Map<String, dynamic> toJson() => {
        "sorted": sorted,
        "empty": empty,
        "unsorted": unsorted,
      };
}

class Status {
  String httpCode;
  bool success;
  String message;

  Status({
    required this.httpCode,
    required this.success,
    required this.message,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        httpCode: json["httpCode"],
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "httpCode": httpCode,
        "success": success,
        "message": message,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

///Get Package Detail By ID Model

class GetPackageDetailsByIdModel {
  Status status;
  GetPackageDetailsData data;

  GetPackageDetailsByIdModel({
    required this.status,
    required this.data,
  });

  factory GetPackageDetailsByIdModel.fromJson(Map<String, dynamic> json) =>
      GetPackageDetailsByIdModel(
        status: Status.fromJson(json["status"]),
        data: GetPackageDetailsData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": data.toJson(),
      };
}

class GetPackageDetailsData {
  String packageId;
  String country;
  String state;
  String packageName;
  String location;
  String noOfDays;
  List<String> packageImageUrl;
  String totalPrice;
  String packageStatus;
  String createdDate;
  String modifiedDate;
  List<PackageActivity> packageActivities;
  double packageDiscountedAmount;
  GetPackageDetailsData(
      {required this.packageId,
      required this.country,
      required this.state,
      required this.packageName,
      required this.location,
      required this.noOfDays,
      required this.packageImageUrl,
      required this.totalPrice,
      required this.packageStatus,
      required this.createdDate,
      required this.modifiedDate,
      required this.packageActivities,
      required this.packageDiscountedAmount});

  factory GetPackageDetailsData.fromJson(Map<String, dynamic> json) =>
      GetPackageDetailsData(
          packageId: json["packageId"].toString(),
          country: json["country"] ?? "",
          state: json["state"] ?? "",
          packageName: json["packageName"] ?? "",
          location: json["location"] ?? "",
          noOfDays: json["noOfDays"] ?? "",
          packageImageUrl:
              List<String>.from(json["packageImageUrl"].map((x) => x)),
          totalPrice: json["totalPrice"].toString(),
          packageStatus: json["packageStatus"] ?? "",
          createdDate: json["createdDate"] ?? "",
          modifiedDate: json["modifiedDate"] ?? "",
          packageActivities: List<PackageActivity>.from(
              json["packageActivities"]
                  .map((x) => PackageActivity.fromJson(x))),
          packageDiscountedAmount: json['packageDiscountedAmount'] ?? 0);

  Map<String, dynamic> toJson() => {
        "packageId": packageId,
        "country": country,
        "state": state,
        "packageName": packageName,
        "location": location,
        "noOfDays": noOfDays,
        "packageImageUrl": List<dynamic>.from(packageImageUrl.map((x) => x)),
        "totalPrice": totalPrice,
        "packageStatus": packageStatus,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "packageActivities":
            List<dynamic>.from(packageActivities.map((x) => x.toJson())),
        "packageDiscountedAmount": packageDiscountedAmount
      };
}

class GetPackageDetailsPackageActivity {
  String packageActivityId;
  Activity activity;
  String day;
  String startTime;

  GetPackageDetailsPackageActivity({
    required this.packageActivityId,
    required this.activity,
    required this.day,
    required this.startTime,
  });

  factory GetPackageDetailsPackageActivity.fromJson(
          Map<String, dynamic> json) =>
      GetPackageDetailsPackageActivity(
        packageActivityId: json["packageActivityId"].toString(),
        activity: Activity.fromJson(json["activity"]),
        day: json["day"].toString(),
        startTime: json["startTime"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "packageActivityId": packageActivityId,
        "activity": activity.toJson(),
        "day": day,
        "startTime": startTime,
      };
}

class GetPackageDetailsActivity {
  String activityId;
  String country;
  String state;
  String city;
  String address;
  String activityName;
  String bestTimeToVisit;
  String activityHours;
  String activityPrice;
  String startTime;
  String endTime;
  String description;
  List<String> participantType;
  List<String> weeklyOff;
  List<String> activityImageUrl;
  String activityStatus;
  String religiousOffFrom;
  String religiousOffTo;
  String createdDate;
  String modifiedDate;

  GetPackageDetailsActivity({
    required this.activityId,
    required this.country,
    required this.state,
    required this.city,
    required this.address,
    required this.activityName,
    required this.bestTimeToVisit,
    required this.activityHours,
    required this.activityPrice,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.participantType,
    required this.weeklyOff,
    required this.activityImageUrl,
    required this.activityStatus,
    required this.religiousOffFrom,
    required this.religiousOffTo,
    required this.createdDate,
    required this.modifiedDate,
  });

  factory GetPackageDetailsActivity.fromJson(Map<String, dynamic> json) =>
      GetPackageDetailsActivity(
        activityId: json["activityId"].toString(),
        country: json["country"] ?? "",
        state: json["state"] ?? "",
        city: json["city"] ?? "",
        address: json["address"] ?? "",
        activityName: json["activityName"] ?? "",
        bestTimeToVisit: json["bestTimeToVisit"] ?? "",
        activityHours: json["activityHours"].toString(),
        activityPrice: json["activityPrice"].toString(),
        startTime: json["startTime"] ?? "",
        endTime: json["endTime"] ?? "",
        description: json["description"] ?? "",
        participantType:
            List<String>.from(json["participantType"].map((x) => x)),
        weeklyOff: List<String>.from(json["weeklyOff"].map((x) => x)),
        activityImageUrl:
            List<String>.from(json["activityImageUrl"].map((x) => x)),
        activityStatus: json["activityStatus"] ?? "",
        religiousOffFrom: json["religiousOffFrom"] ?? "",
        religiousOffTo: json["religiousOffTo"] ?? "",
        createdDate: json["createdDate"] ?? "",
        modifiedDate: json["modifiedDate"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "activityId": activityId,
        "country": country,
        "state": state,
        "city": city,
        "address": address,
        "activityName": activityName,
        "bestTimeToVisit": bestTimeToVisit,
        "activityHours": activityHours,
        "activityPrice": activityPrice,
        "startTime": startTime,
        "endTime": endTime,
        "description": description,
        "participantType": List<dynamic>.from(participantType.map((x) => x)),
        "weeklyOff": List<dynamic>.from(weeklyOff.map((x) => x)),
        "activityImageUrl": List<dynamic>.from(activityImageUrl.map((x) => x)),
        "activityStatus": activityStatus,
        "religiousOffFrom": religiousOffFrom,
        "religiousOffTo": religiousOffTo,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
      };
}

class GetPackageDetailsStatus {
  String httpCode;
  String success;
  String message;

  GetPackageDetailsStatus({
    required this.httpCode,
    required this.success,
    required this.message,
  });

  factory GetPackageDetailsStatus.fromJson(Map<String, dynamic> json) =>
      GetPackageDetailsStatus(
        httpCode: json["httpCode"] ?? "",
        success: json["success"].toString(),
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "httpCode": httpCode,
        "success": success,
        "message": message,
      };
}

///Post Booking Package By Member Model
class BookPackageByMemberModel {
  BookPackageByMemberStatus status;
  BookPackageByMemberData data;

  BookPackageByMemberModel({
    required this.status,
    required this.data,
  });

  factory BookPackageByMemberModel.fromJson(Map<String, dynamic> json) =>
      BookPackageByMemberModel(
        status: BookPackageByMemberStatus.fromJson(json["status"]),
        data: BookPackageByMemberData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": data.toJson(),
      };
}

class BookPackageByMemberData {
  String packageBookingId;
  String bookingDate;
  String bookingStatus;
  String cancellationReason;
  String createdDate;
  String modifiedDate;
  User user;
  Pkg pkg;
  String totalAmount;
  String numberOfMembers;
  List<MemberList> memberList;

  BookPackageByMemberData({
    required this.packageBookingId,
    required this.bookingDate,
    required this.bookingStatus,
    required this.cancellationReason,
    required this.createdDate,
    required this.modifiedDate,
    required this.user,
    required this.pkg,
    required this.totalAmount,
    required this.numberOfMembers,
    required this.memberList,
  });

  factory BookPackageByMemberData.fromJson(Map<String, dynamic> json) =>
      BookPackageByMemberData(
        packageBookingId: json["packageBookingId"].toString(),
        bookingDate: json["bookingDate"].toString(),
        bookingStatus: json["bookingStatus"] ?? "",
        cancellationReason: json["cancellationReason"].toString(),
        createdDate: json["createdDate"].toString(),
        modifiedDate: json["modifiedDate"].toString(),
        user: User.fromJson(json["user"] ?? {}),
        pkg: Pkg.fromJson(json["pkg"] ?? {}),
        totalAmount: json["totalAmount"].toString(),
        numberOfMembers: json["numberOfMembers"].toString(),
        memberList: List<MemberList>.from(
            json["memberList"].map((x) => MemberList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "packageBookingId": packageBookingId,
        "bookingDate": bookingDate,
        "bookingStatus": bookingStatus,
        "cancellationReason": cancellationReason,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "user": user,
        "pkg": pkg,
        "totalAmount": totalAmount,
        "numberOfMembers": numberOfMembers,
        "memberList": List<dynamic>.from(memberList.map((x) => x.toJson())),
      };
}

class MemberList {
  String memberId;
  String name;
  String age;
  String gender;

  MemberList({
    required this.memberId,
    required this.name,
    required this.age,
    required this.gender,
  });

  factory MemberList.fromJson(Map<String, dynamic> json) => MemberList(
        memberId: json["memberId"].toString(),
        name: json["name"] ?? "",
        age: json["age"].toString(),
        gender: json["gender"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "memberId": memberId,
        "name": name,
        "age": age,
        "gender": gender,
      };
}

class Pkg {
  String packageId;
  String country;
  String state;
  String packageName;
  String location;
  String noOfDays;
  List<String> packageImageUrl;
  String totalPrice;
  String packageStatus;
  String createdDate;
  String modifiedDate;
  List<BookPackageByMemberPackageActivity> packageActivities;

  Pkg({
    required this.packageId,
    required this.country,
    required this.state,
    required this.packageName,
    required this.location,
    required this.noOfDays,
    required this.packageImageUrl,
    required this.totalPrice,
    required this.packageStatus,
    required this.createdDate,
    required this.modifiedDate,
    required this.packageActivities,
  });

  factory Pkg.fromJson(Map<String, dynamic> json) => Pkg(
        packageId: json["packageId"].toString(),
        country: json["country"] ?? "",
        state: json["state"] ?? "",
        packageName: json["packageName"] ?? "",
        location: json["location"] ?? "",
        noOfDays: json["noOfDays"] ?? "",
        packageImageUrl:
            List<String>.from(json["packageImageUrl"].map((x) => x)),
        totalPrice: json["totalPrice"].toString(),
        packageStatus: json["packageStatus"] ?? "",
        createdDate: json["createdDate"].toString(),
        modifiedDate: json["modifiedDate"].toString(),
        packageActivities: List<BookPackageByMemberPackageActivity>.from(
            json["packageActivities"]
                .map((x) => BookPackageByMemberPackageActivity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "packageId": packageId,
        "country": country,
        "state": state,
        "packageName": packageName,
        "location": location,
        "noOfDays": noOfDays,
        "packageImageUrl": List<dynamic>.from(packageImageUrl.map((x) => x)),
        "totalPrice": totalPrice,
        "packageStatus": packageStatus,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "packageActivities":
            List<dynamic>.from(packageActivities.map((x) => x.toJson())),
      };
}

class BookPackageByMemberPackageActivity {
  String packageActivityId;
  BookPackageByMemberActivity activity;
  String day;
  String startTime;

  BookPackageByMemberPackageActivity({
    required this.packageActivityId,
    required this.activity,
    required this.day,
    required this.startTime,
  });

  factory BookPackageByMemberPackageActivity.fromJson(
          Map<String, dynamic> json) =>
      BookPackageByMemberPackageActivity(
        packageActivityId: json["packageActivityId"].toString(),
        activity: BookPackageByMemberActivity.fromJson(json["activity"]),
        day: json["day"].toString(),
        startTime: json["startTime"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "packageActivityId": packageActivityId,
        "activity": activity.toJson(),
        "day": day,
        "startTime": startTime,
      };
}

class BookPackageByMemberActivity {
  String activityId;
  String country;
  String state;
  String city;
  String address;
  String activityName;
  String bestTimeToVisit;
  String activityHours;
  String activityPrice;
  String startTime;
  String endTime;
  String description;
  List<String> participantType;
  List<String> weeklyOff;
  List<String> activityImageUrl;
  String activityStatus;
  String createdDate;
  String modifiedDate;
  List<dynamic> activityReligiousOffDates;

  BookPackageByMemberActivity({
    required this.activityId,
    required this.country,
    required this.state,
    required this.city,
    required this.address,
    required this.activityName,
    required this.bestTimeToVisit,
    required this.activityHours,
    required this.activityPrice,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.participantType,
    required this.weeklyOff,
    required this.activityImageUrl,
    required this.activityStatus,
    required this.createdDate,
    required this.modifiedDate,
    required this.activityReligiousOffDates,
  });

  factory BookPackageByMemberActivity.fromJson(Map<String, dynamic> json) =>
      BookPackageByMemberActivity(
        activityId: json["activityId"].toString(),
        country: json["country"] ?? "",
        state: json["state"] ?? "",
        city: json["city"] ?? "",
        address: json["address"] ?? "",
        activityName: json["activityName"] ?? "",
        bestTimeToVisit: json["bestTimeToVisit"] ?? "",
        activityHours: json["activityHours"].toString(),
        activityPrice: json["activityPrice"].toString(),
        startTime: json["startTime"] ?? "",
        endTime: json["endTime"] ?? "",
        description: json["description"] ?? "",
        participantType:
            List<String>.from(json["participantType"].map((x) => x)),
        weeklyOff: List<String>.from(json["weeklyOff"].map((x) => x)),
        activityImageUrl:
            List<String>.from(json["activityImageUrl"].map((x) => x)),
        activityStatus: json["activityStatus"],
        createdDate: json["createdDate"].toString(),
        modifiedDate: json["modifiedDate"].toString(),
        activityReligiousOffDates:
            List<dynamic>.from(json["activityReligiousOffDates"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "activityId": activityId,
        "country": country,
        "state": state,
        "city": city,
        "address": address,
        "activityName": activityName,
        "bestTimeToVisit": bestTimeToVisit,
        "activityHours": activityHours,
        "activityPrice": activityPrice,
        "startTime": startTime,
        "endTime": endTime,
        "description": description,
        "participantType": List<dynamic>.from(participantType.map((x) => x)),
        "weeklyOff": List<dynamic>.from(weeklyOff.map((x) => x)),
        "activityImageUrl": List<dynamic>.from(activityImageUrl.map((x) => x)),
        "activityStatus": activityStatus,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "activityReligiousOffDates":
            List<dynamic>.from(activityReligiousOffDates.map((x) => x)),
      };
}

class User {
  int userId;
  String firstName;
  String lastName;
  String mobile;
  String address;
  String email;
  String gender;
  DateTime createdDate;
  DateTime modifiedDate;
  bool status;
  dynamic otp;
  dynamic isOtpVerified;
  String userType;
  dynamic profileImageUrl;

  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.address,
    required this.email,
    required this.gender,
    required this.createdDate,
    required this.modifiedDate,
    required this.status,
    required this.otp,
    required this.isOtpVerified,
    required this.userType,
    required this.profileImageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        mobile: json["mobile"],
        address: json["address"],
        email: json["email"],
        gender: json["gender"],
        createdDate: DateTime.parse(json["createdDate"]),
        modifiedDate: DateTime.parse(json["modifiedDate"]),
        status: json["status"],
        otp: json["otp"],
        isOtpVerified: json["isOtpVerified"],
        userType: json["userType"],
        profileImageUrl: json["profileImageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": mobile,
        "address": address,
        "email": email,
        "gender": gender,
        "createdDate": createdDate.toIso8601String(),
        "modifiedDate": modifiedDate.toIso8601String(),
        "status": status,
        "otp": otp,
        "isOtpVerified": isOtpVerified,
        "userType": userType,
        "profileImageUrl": profileImageUrl,
      };
}

class BookPackageByMemberStatus {
  String httpCode;
  bool success;
  String message;

  BookPackageByMemberStatus({
    required this.httpCode,
    required this.success,
    required this.message,
  });

  factory BookPackageByMemberStatus.fromJson(Map<String, dynamic> json) =>
      BookPackageByMemberStatus(
        httpCode: json["httpCode"],
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "httpCode": httpCode,
        "success": success,
        "message": message,
      };
}

///Package History Model
class GetPackageHistoryModel {
  PackageHistoryStatus status;
  PackageHistoryData data;

  GetPackageHistoryModel({
    required this.status,
    required this.data,
  });

  factory GetPackageHistoryModel.fromJson(Map<String, dynamic> json) =>
      GetPackageHistoryModel(
        status: PackageHistoryStatus.fromJson(json["status"]),
        data: PackageHistoryData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": data.toJson(),
      };
}

class PackageHistoryData {
  List<PackageHistoryContent> content;
  PackageHistoryPageable pageable;
  int totalPages;
  int totalElements;
  bool last;
  int size;
  int number;
  PackageHistorySort sort;
  int numberOfElements;
  bool first;
  bool empty;

  PackageHistoryData({
    required this.content,
    required this.pageable,
    required this.totalPages,
    required this.totalElements,
    required this.last,
    required this.size,
    required this.number,
    required this.sort,
    required this.numberOfElements,
    required this.first,
    required this.empty,
  });

  factory PackageHistoryData.fromJson(Map<String, dynamic> json) =>
      PackageHistoryData(
        content: (json["content"] != null)
            ? List<PackageHistoryContent>.from(
                json["content"].map((x) => PackageHistoryContent.fromJson(x)))
            : [],
        pageable: PackageHistoryPageable.fromJson(json["pageable"]),
        totalPages: json["totalPages"],
        totalElements: json["totalElements"],
        last: json["last"],
        size: json["size"],
        number: json["number"],
        sort: PackageHistorySort.fromJson(json["sort"]),
        numberOfElements: json["numberOfElements"],
        first: json["first"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
        "pageable": pageable.toJson(),
        "totalPages": totalPages,
        "totalElements": totalElements,
        "last": last,
        "size": size,
        "number": number,
        "sort": sort.toJson(),
        "numberOfElements": numberOfElements,
        "first": first,
        "empty": empty,
      };
}

class PackageHistoryContent {
  String packageBookingId;
  String bookingDate;
  String bookingStatus;
  String cancellationReason;
  String createdDate;
  String modifiedDate;
  String user;
  // PackageHistoryUser user;
  // String pkg;
  PackageHistoryPkg pkg;
  String discountAmount;
  String packagePrice;
  String taxAmount;
  String taxPercentage;
  String paymentId;
  String totalPayableAmount;
  String numberOfMembers;
  List<PackageHistoryMemberList> memberList;

  PackageHistoryContent({
    required this.packageBookingId,
    required this.bookingDate,
    required this.bookingStatus,
    required this.cancellationReason,
    required this.createdDate,
    required this.modifiedDate,
    required this.user,
    required this.pkg,
    required this.packagePrice,
    required this.discountAmount,
    required this.taxAmount,
    required this.taxPercentage,
    required this.paymentId,
    required this.totalPayableAmount,
    required this.numberOfMembers,
    required this.memberList,
  });

  factory PackageHistoryContent.fromJson(Map<String, dynamic> json) =>
      PackageHistoryContent(
        packageBookingId: json["packageBookingId"].toString(),
        bookingDate: json["bookingDate"] ?? "",
        bookingStatus: json["bookingStatus"] ?? "",
        cancellationReason: json["cancellationReason"].toString(),
        createdDate: json["createdDate"].toString(),
        modifiedDate: json["modifiedDate"].toString(),
        user: json["user"].toString(),
        // user: PackageHistoryUser.fromJson(json["user"]),
        // pkg: json["pkg"].toString(),
        pkg: PackageHistoryPkg.fromJson(json["pkg"]),
        discountAmount: json["discountAmount"]?.toString() ?? '',
        packagePrice: json["packagePrice"].toString(),
        taxAmount: json["taxAmount"]?.toString() ?? '',
        taxPercentage: json["taxPercentage"]?.toString() ?? '',
        paymentId: json["paymentId"]?.toString() ?? '',
        totalPayableAmount: json["totalPayableAmount"]?.toString() ?? '',
        numberOfMembers: json["numberOfMembers"].toString(),
        memberList: (json["memberList"] != null)
            ? List<PackageHistoryMemberList>.from(json["memberList"]
                .map((x) => PackageHistoryMemberList.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "packageBookingId": packageBookingId,
        "bookingDate": bookingDate,
        "bookingStatus": bookingStatusValues.reverse[bookingStatus],
        "cancellationReason": cancellationReason,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        // "user": user,
        "user": user,
        "pkg": pkg,
        // "pkg": pkg.toJson(),
        "discountAmount": discountAmount,
        "packagePrice": packagePrice,
        "taxAmount": taxAmount,
        "taxPercentage": taxPercentage,
        "paymentId": paymentId,
        "totalPayableAmount": totalPayableAmount,
        "numberOfMembers": numberOfMembers,
        "memberList": List<dynamic>.from(memberList.map((x) => x.toJson())),
      };
}

enum BookingStatus { BOOKED }

final bookingStatusValues = EnumValues({"BOOKED": BookingStatus.BOOKED});

class PackageHistoryMemberList {
  String memberId;
  String name;
  String age;
  String gender;
  // Gender? gender;

  PackageHistoryMemberList({
    required this.memberId,
    required this.name,
    required this.age,
    required this.gender,
  });

  factory PackageHistoryMemberList.fromJson(Map<String, dynamic> json) =>
      PackageHistoryMemberList(
        memberId: json["memberId"].toString(),
        name: json["name"] ?? "",
        age: json["age"].toString(),
        gender: json["gender"] ?? "",
        // gender: genderValues.map[json["gender"]]!,
      );

  Map<String, dynamic> toJson() => {
        "memberId": memberId,
        "name": name,
        "age": age,
        "gender": gender,
      };
}

enum Gender { FEMALE, MALE }

final genderValues = EnumValues({"Female": Gender.FEMALE, "Male": Gender.MALE});

class PackageHistoryPkg {
  String packageId;
  String country;
  String state;
  String packageName;
  String location;
  String noOfDays;
  List<String> packageImageUrl;
  String totalPrice;
  String packageStatus;
  String createdDate;
  String modifiedDate;
  List<PackageHistoryActivity> packageActivities;

  PackageHistoryPkg({
    required this.packageId,
    required this.country,
    required this.state,
    required this.packageName,
    required this.location,
    required this.noOfDays,
    required this.packageImageUrl,
    required this.totalPrice,
    required this.packageStatus,
    required this.createdDate,
    required this.modifiedDate,
    required this.packageActivities,
  });

  factory PackageHistoryPkg.fromJson(Map<String, dynamic> json) =>
      PackageHistoryPkg(
        packageId: json["packageId"].toString(),
        country: json["country"] ?? "",
        state: json["state"] ?? "",
        packageName: json["packageName"] ?? "",
        location: json["location"] ?? "",
        noOfDays: json["noOfDays"] ?? "",
        packageImageUrl:
            List<String>.from(json["packageImageUrl"].map((x) => x)),
        totalPrice: json["totalPrice"].toString(),
        packageStatus: json["packageStatus"] ?? "",
        createdDate: json["createdDate"] ?? "",
        modifiedDate: json["modifiedDate"] ?? "",
        packageActivities: List<PackageHistoryActivity>.from(
            json["packageActivities"]
                .map((x) => PackageHistoryActivity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "packageId": packageId,
        "country": pkgCountryValues.reverse[country],
        "state": pkgStateValues.reverse[state],
        "packageName": packageNameValues.reverse[packageName],
        "location": locationValues.reverse[location],
        "noOfDays": noOfDays,
        "packageImageUrl": List<dynamic>.from(packageImageUrl.map((x) => x)),
        "totalPrice": totalPrice,
        "packageStatus": packageStatusEnumValues.reverse[packageStatus],
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "packageActivities":
            List<dynamic>.from(packageActivities.map((x) => x.toJson())),
      };
}

enum PkgCountry { COUNTRY_DUBAI, DUBAI, INDIA, PURPLE_DUBAI, UAE }

final pkgCountryValues = EnumValues({
  "dubai": PkgCountry.COUNTRY_DUBAI,
  "Dubai ": PkgCountry.DUBAI,
  "India": PkgCountry.INDIA,
  "Dubai": PkgCountry.PURPLE_DUBAI,
  "UAE": PkgCountry.UAE
});

enum Location { BURJ_KHALIFA, DUBAI, LOCATION_DUBAI, NOIDA }

final locationValues = EnumValues({
  "burj khalifa": Location.BURJ_KHALIFA,
  "dubai ": Location.DUBAI,
  "Dubai": Location.LOCATION_DUBAI,
  "Noida": Location.NOIDA
});

class PackageHistoryActivity {
  String packageActivityId;
  HistoryPackageActivity activity;
  String day;
  String startTime;

  PackageHistoryActivity({
    required this.packageActivityId,
    required this.activity,
    required this.day,
    required this.startTime,
  });

  factory PackageHistoryActivity.fromJson(Map<String, dynamic> json) =>
      PackageHistoryActivity(
        packageActivityId: json["packageActivityId"].toString(),
        activity: HistoryPackageActivity.fromJson(json["activity"]),
        day: json["day"].toString(),
        startTime: json["startTime"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "packageActivityId": packageActivityId,
        "activity": activity.toJson(),
        "day": day,
        "startTime": packageActivityStartTimeValues.reverse[startTime],
      };
}

class HistoryPackageActivity {
  String activityId;
  String country;
  String state;
  String city;
  String address;
  String activityName;
  String bestTimeToVisit;
  String activityHours;
  String activityPrice;
  String startTime;
  String endTime;
  String description;
  List<ParticipantType> participantType;
  List<WeeklyOff> weeklyOff;
  List<String> activityImageUrl;
  String activityStatus;
  String createdDate;
  String modifiedDate;
  List<PackageHistoryActivityReligiousOffDate> activityReligiousOffDates;

  HistoryPackageActivity({
    required this.activityId,
    required this.country,
    required this.state,
    required this.city,
    required this.address,
    required this.activityName,
    required this.bestTimeToVisit,
    required this.activityHours,
    required this.activityPrice,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.participantType,
    required this.weeklyOff,
    required this.activityImageUrl,
    required this.activityStatus,
    required this.createdDate,
    required this.modifiedDate,
    required this.activityReligiousOffDates,
  });

  factory HistoryPackageActivity.fromJson(Map<String, dynamic> json) =>
      HistoryPackageActivity(
        activityId: json["activityId"].toString(),
        country: json["country"] ?? "",
        state: json["state"] ?? "",
        city: json["city"] ?? "",
        address: json["address"] ?? "",
        activityName: json["activityName"] ?? "",
        bestTimeToVisit: json["bestTimeToVisit"] ?? "",
        activityHours: json["activityHours"].toString(),
        activityPrice: json["activityPrice"].toString(),
        startTime: json["startTime"] ?? "",
        endTime: json["endTime"] ?? "",
        description: json["description"] ?? "",
        participantType: List<ParticipantType>.from(
            json["participantType"].map((x) => participantTypeValues.map[x])),
        weeklyOff: List<WeeklyOff>.from(json["weeklyOff"]
                ?.map((x) => weeklyOffValues.map[x])
                ?.where((x) => x != null) ??
            []),
        // List<WeeklyOff>.from(
        //     json["weeklyOff"]?.map((x) => weeklyOffValues.map[x])),
        activityImageUrl:
            List<String>.from(json["activityImageUrl"].map((x) => x)),
        activityStatus: json["activityStatus"] ?? "",
        createdDate: json["createdDate"].toString(),
        modifiedDate: json["modifiedDate"].toString(),
        activityReligiousOffDates:
            List<PackageHistoryActivityReligiousOffDate>.from(
                json["activityReligiousOffDates"].map(
                    (x) => PackageHistoryActivityReligiousOffDate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "activityId": activityId,
        "country": activityCountryValues.reverse[country],
        "state": activityStateValues.reverse[state],
        "city": cityValues.reverse[city],
        "address": activityAddressValues.reverse[address],
        "activityName": activityName,
        "bestTimeToVisit": bestTimeToVisitValues.reverse[bestTimeToVisit],
        "activityHours": activityHours,
        "activityPrice": activityPrice,
        "startTime": activityStartTimeValues.reverse[startTime],
        "endTime": endTimeValues.reverse[endTime],
        "description": description,
        "participantType": List<dynamic>.from(
            participantType.map((x) => participantTypeValues.reverse[x])),
        "weeklyOff": List<dynamic>.from(
            weeklyOff.map((x) => weeklyOffValues.reverse[x])),
        "activityImageUrl": List<dynamic>.from(activityImageUrl.map((x) => x)),
        "activityStatus": packageStatusEnumValues.reverse[activityStatus],
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "activityReligiousOffDates": List<dynamic>.from(
            activityReligiousOffDates.map((x) => x.toJson())),
      };
}

class PackageHistoryActivityReligiousOffDate {
  String activityReligiousOffId;
  String religiousOffDate;
  String isCancelled;
  String createdDate;
  String modifiedDate;

  PackageHistoryActivityReligiousOffDate({
    required this.activityReligiousOffId,
    required this.religiousOffDate,
    required this.isCancelled,
    required this.createdDate,
    required this.modifiedDate,
  });

  factory PackageHistoryActivityReligiousOffDate.fromJson(
          Map<String, dynamic> json) =>
      PackageHistoryActivityReligiousOffDate(
        activityReligiousOffId: json["activityReligiousOffId"].toString(),
        religiousOffDate: json["religiousOffDate"].toString(),
        isCancelled: json["isCancelled"].toString(),
        createdDate: json["createdDate"].toString(),
        modifiedDate: json["modifiedDate"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "activityReligiousOffId": activityReligiousOffId,
        "religiousOffDate": religiousOffDate,
        "isCancelled": isCancelled,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
      };
}

enum ReligiousOffDate {
  THE_14062024,
  THE_15072024,
  THE_15082024,
  THE_17062024,
  THE_19062024,
  THE_20062024,
  THE_21062024,
  THE_25062024
}

final religiousOffDateValues = EnumValues({
  "14-06-2024": ReligiousOffDate.THE_14062024,
  "15-07-2024": ReligiousOffDate.THE_15072024,
  "15-08-2024": ReligiousOffDate.THE_15082024,
  "17-06-2024": ReligiousOffDate.THE_17062024,
  "19-06-2024": ReligiousOffDate.THE_19062024,
  "20-06-2024": ReligiousOffDate.THE_20062024,
  "21-06-2024": ReligiousOffDate.THE_21062024,
  "25-06-2024": ReligiousOffDate.THE_25062024
});

enum PackageHistoryStatusEnum { TRUE }

final packageHistoryStatusEnumValues =
    EnumValues({"TRUE": PackageStatusEnum.TRUE});

enum ActivityAddress {
  BURJ,
  BURJ_KHALIFA,
  DOWNTOWN,
  DUBAI,
  NEW_DUBAI,
  OLD_TOWN_DUBAI,
  THE_123_MAIN_STREET
}

final activityAddressValues = EnumValues({
  "Burj": ActivityAddress.BURJ,
  " Burj Khalifa": ActivityAddress.BURJ_KHALIFA,
  "downtown": ActivityAddress.DOWNTOWN,
  "dubai ": ActivityAddress.DUBAI,
  "new dubai": ActivityAddress.NEW_DUBAI,
  "Old town Dubai": ActivityAddress.OLD_TOWN_DUBAI,
  "123 Main Street": ActivityAddress.THE_123_MAIN_STREET
});

enum BestTimeToVisit { AUTUMN, PRE_WINTER, SPRING, SUMMER, WINTER }

final bestTimeToVisitValues = EnumValues({
  "Autumn": BestTimeToVisit.AUTUMN,
  "Pre-Winter": BestTimeToVisit.PRE_WINTER,
  "Spring": BestTimeToVisit.SPRING,
  "Summer": BestTimeToVisit.SUMMER,
  "Winter": BestTimeToVisit.WINTER
});

enum City {
  CITY_DUBAI,
  DUBAI,
  EMIRATE_OF_DUBAI,
  FLUFFY_DUBAI,
  LOS_ANGELES,
  PURPLE_DUBAI,
  TENTACLED_DUBAI
}

final cityValues = EnumValues({
  "dubai": City.CITY_DUBAI,
  "Dubai": City.DUBAI,
  " Emirate of Dubai": City.EMIRATE_OF_DUBAI,
  "Dubai  ": City.FLUFFY_DUBAI,
  "Los Angeles": City.LOS_ANGELES,
  "Dubai ": City.PURPLE_DUBAI,
  "dubai ": City.TENTACLED_DUBAI
});

enum ActivityCountry { DUBAI, UAE, UNITED_STATES }

final activityCountryValues = EnumValues({
  "Dubai": ActivityCountry.DUBAI,
  "UAE": ActivityCountry.UAE,
  "United States": ActivityCountry.UNITED_STATES
});

enum EndTime {
  THE_11_PM,
  THE_1230_PM,
  THE_12_PM,
  THE_1615,
  THE_1930,
  THE_2000,
  THE_2100
}

final endTimeValues = EnumValues({
  "11pm": EndTime.THE_11_PM,
  "12:30 PM": EndTime.THE_1230_PM,
  "12pm": EndTime.THE_12_PM,
  "16:15": EndTime.THE_1615,
  "19:30": EndTime.THE_1930,
  "20:00": EndTime.THE_2000,
  "21:00": EndTime.THE_2100
});

enum PackageHistoryParticipantType { ADULT, CHILD, INFANT, SENIOR, TEEN }

final packageHistoryParticipantTypeValues = EnumValues({
  "ADULT": ParticipantType.ADULT,
  "CHILD": ParticipantType.CHILD,
  "INFANT": ParticipantType.INFANT,
  "SENIOR": ParticipantType.SENIOR,
  "TEEN": ParticipantType.TEEN
});

enum ActivityStartTime {
  THE_0100,
  THE_0515,
  THE_0801,
  THE_0900,
  THE_0900_AM,
  THE_9_AM
}

final activityStartTimeValues = EnumValues({
  "01:00": ActivityStartTime.THE_0100,
  "05:15": ActivityStartTime.THE_0515,
  "08:01": ActivityStartTime.THE_0801,
  "09:00": ActivityStartTime.THE_0900,
  "09:00 AM": ActivityStartTime.THE_0900_AM,
  "9am": ActivityStartTime.THE_9_AM
});

enum ActivityState { ABU_DHABI, CALIFORNIA, DUBAI, STATE_DUBAI, UAE }

final activityStateValues = EnumValues({
  "Abu dhabi ": ActivityState.ABU_DHABI,
  "California": ActivityState.CALIFORNIA,
  "Dubai": ActivityState.DUBAI,
  "dubai": ActivityState.STATE_DUBAI,
  "UAE": ActivityState.UAE
});

enum WeeklyOff { MONDAY, SATURDAY, SUNDAY, THUSDAY, TUESDAY, WEDNESDAY }

final weeklyOffValues = EnumValues({
  "Monday": WeeklyOff.MONDAY,
  "Saturday": WeeklyOff.SATURDAY,
  "Sunday": WeeklyOff.SUNDAY,
  "Thusday": WeeklyOff.THUSDAY,
  "Tuesday": WeeklyOff.TUESDAY,
  "Wednesday": WeeklyOff.WEDNESDAY
});

enum PackageActivityStartTime { THE_1822, THE_1823 }

final packageActivityStartTimeValues = EnumValues({
  "18:22": PackageActivityStartTime.THE_1822,
  "18:23": PackageActivityStartTime.THE_1823
});

enum PackageName {
  BURJ_KHALIFA_TOUR,
  DUBAI_ADVENTURE_PACKAGE,
  DUBAI_SKYCLARK_VIEW,
  DUBAI_VISIT_15,
  GOLDEN_TRIP
}

final packageNameValues = EnumValues({
  "burj khalifa tour": PackageName.BURJ_KHALIFA_TOUR,
  "Dubai Adventure Package": PackageName.DUBAI_ADVENTURE_PACKAGE,
  "dubai skyclark view": PackageName.DUBAI_SKYCLARK_VIEW,
  "Dubai Visit 15": PackageName.DUBAI_VISIT_15,
  "Golden Trip": PackageName.GOLDEN_TRIP
});

enum PkgState { ABU_DHABI, DUBAI, D_UBAI, STATE_DUBAI, UTTAR_PRADESH1 }

final pkgStateValues = EnumValues({
  "abu dhabi": PkgState.ABU_DHABI,
  "dubai ": PkgState.DUBAI,
  "DUbai": PkgState.D_UBAI,
  "Dubai": PkgState.STATE_DUBAI,
  "Uttar Pradesh1": PkgState.UTTAR_PRADESH1
});

class PackageHistoryUser {
  String userId;
  String firstName;
  String lastName;
  String mobile;
  String address;
  String email;
  String gender;
  String createdDate;
  String modifiedDate;
  String status;
  String otp;
  String isOtpVerified;
  String userType;
  String profileImageUrl;

  PackageHistoryUser({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.address,
    required this.email,
    required this.gender,
    required this.createdDate,
    required this.modifiedDate,
    required this.status,
    required this.otp,
    required this.isOtpVerified,
    required this.userType,
    required this.profileImageUrl,
  });

  factory PackageHistoryUser.fromJson(Map<String, dynamic> json) =>
      PackageHistoryUser(
        userId: json["userId"].toString(),
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        mobile: json["mobile"] ?? "",
        address: json["address"] ?? "",
        email: json["email"] ?? "",
        gender: json["gender"] ?? "",
        createdDate: json["createdDate"].toString(),
        modifiedDate: json["modifiedDate"].toString(),
        status: json["status"].toString(),
        otp: json["otp"].toString(),
        isOtpVerified: json["isOtpVerified"].toString(),
        userType: json["userType"].toString(),
        profileImageUrl: json["profileImageUrl"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": mobile,
        "address": address,
        "email": email,
        "gender": gender,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "status": status,
        "otp": otp,
        "isOtpVerified": isOtpVerified,
        "userType": userType,
        "profileImageUrl": profileImageUrl,
      };
}

class PackageHistoryPageable {
  Sort sort;
  int pageSize;
  int pageNumber;
  int offset;
  bool unpaged;
  bool paged;

  PackageHistoryPageable({
    required this.sort,
    required this.pageSize,
    required this.pageNumber,
    required this.offset,
    required this.unpaged,
    required this.paged,
  });

  factory PackageHistoryPageable.fromJson(Map<String, dynamic> json) =>
      PackageHistoryPageable(
        sort: Sort.fromJson(json["sort"]),
        pageSize: json["pageSize"],
        pageNumber: json["pageNumber"],
        offset: json["offset"],
        unpaged: json["unpaged"],
        paged: json["paged"],
      );

  Map<String, dynamic> toJson() => {
        "sort": sort.toJson(),
        "pageSize": pageSize,
        "pageNumber": pageNumber,
        "offset": offset,
        "unpaged": unpaged,
        "paged": paged,
      };
}

class PackageHistorySort {
  bool sorted;
  bool empty;
  bool unsorted;

  PackageHistorySort({
    required this.sorted,
    required this.empty,
    required this.unsorted,
  });

  factory PackageHistorySort.fromJson(Map<String, dynamic> json) =>
      PackageHistorySort(
        sorted: json["sorted"],
        empty: json["empty"],
        unsorted: json["unsorted"],
      );

  Map<String, dynamic> toJson() => {
        "sorted": sorted,
        "empty": empty,
        "unsorted": unsorted,
      };
}

class PackageHistoryStatus {
  String httpCode;
  bool success;
  String message;

  PackageHistoryStatus({
    required this.httpCode,
    required this.success,
    required this.message,
  });

  factory PackageHistoryStatus.fromJson(Map<String, dynamic> json) =>
      PackageHistoryStatus(
        httpCode: json["httpCode"],
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "httpCode": httpCode,
        "success": success,
        "message": message,
      };
}

///Get Package History Detail Model
class GetPackageHIstoryDetailsModel {
  PackageHIstoryDetailsStatus status;
  PackageHIstoryDetailsData data;

  GetPackageHIstoryDetailsModel({
    required this.status,
    required this.data,
  });

  factory GetPackageHIstoryDetailsModel.fromJson(Map<String, dynamic> json) =>
      GetPackageHIstoryDetailsModel(
        status: PackageHIstoryDetailsStatus.fromJson(json["status"]),
        data: PackageHIstoryDetailsData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": data.toJson(),
      };
}

class PackageHIstoryDetailsData {
  String packageBookingId;
  String bookingDate;
  String bookingStatus;
  String cancellationReason;
  String createdDate;
  String modifiedDate;
  String user;
  PackageHIstoryDetailsPkg pkg;
  String packagePrice;
  String numberOfMembers;
  List<PackageHIstoryDetailsMemberList> memberList;
  List<AssignedVehicleOnPackageBooking> assignedVehicleOnPackageBookings;
  List<AssignedDriverOnPackageBooking> assignedDriverOnPackageBookings;
  String pickupLocation;
  String cancelledBy;
  String endDate;
  String paymentId;
  String countryCode;
  String mobile;
  String alternateMobileCountryCode;
  String alternateMobile;
  String discountAmount;
  String taxAmount;
  String taxPercentage;
  String totalPayableAmount;

  PackageHIstoryDetailsData(
      {required this.packageBookingId,
      required this.bookingDate,
      required this.bookingStatus,
      required this.cancellationReason,
      required this.createdDate,
      required this.modifiedDate,
      required this.user,
      required this.pkg,
      required this.packagePrice,
      required this.numberOfMembers,
      required this.memberList,
      required this.assignedVehicleOnPackageBookings,
      required this.assignedDriverOnPackageBookings,
      required this.pickupLocation,
      required this.cancelledBy,
      required this.endDate,
      required this.paymentId,
      required this.countryCode,
      required this.mobile,
      required this.alternateMobileCountryCode,
      required this.alternateMobile,
      required this.discountAmount,
      required this.taxAmount,
      required this.taxPercentage,
      required this.totalPayableAmount});

  factory PackageHIstoryDetailsData.fromJson(Map<String, dynamic> json) =>
      PackageHIstoryDetailsData(
        packageBookingId: json["packageBookingId"].toString(),
        bookingDate: json["bookingDate"] ?? "",
        bookingStatus: json["bookingStatus"] ?? "",
        cancellationReason: json["cancellationReason"] ?? "",
        createdDate: json["createdDate"].toString(),
        modifiedDate: json["modifiedDate"].toString(),
        user: json["user"].toString(),
        // pkg: json["pkg"].toString(),
        // user: PackageHIstoryDetailsUser.fromJson(json["user"]),
        pkg: PackageHIstoryDetailsPkg.fromJson(json["pkg"]),
        packagePrice: json["packagePrice"].toString(),

        numberOfMembers: json["numberOfMembers"].toString(),
        memberList: List<PackageHIstoryDetailsMemberList>.from(
            json["memberList"]
                .map((x) => PackageHIstoryDetailsMemberList.fromJson(x))),
        assignedVehicleOnPackageBookings:
            List<AssignedVehicleOnPackageBooking>.from(
                json["assignedVehicleOnPackageBookings"]
                    .map((x) => AssignedVehicleOnPackageBooking.fromJson(x))),
        assignedDriverOnPackageBookings:
            List<AssignedDriverOnPackageBooking>.from(
                json["assignedDriverOnPackageBookings"]
                    .map((x) => AssignedDriverOnPackageBooking.fromJson(x))),
        pickupLocation: json["pickupLocation"]?.toString() ?? "",
        cancelledBy: json["cancelledBy"]?.toString() ?? "",
        endDate: json["endDate"] ?? "",
        paymentId: json["paymentId"].toString(),
        countryCode: json["countryCode"]?.toString() ?? "",
        mobile: json["mobile"]?.toString() ?? "",
        alternateMobileCountryCode:
            json["alternateMobileCountryCode"]?.toString() ?? "",
        alternateMobile: json["alternateMobile"]?.toString() ?? "",
        discountAmount: json["discountAmount"]?.toString() ?? '',
        taxAmount: json["taxAmount"]?.toString() ?? '',
        taxPercentage: json["taxPercentage"]?.toString() ?? '',
        totalPayableAmount: json["totalPayableAmount"]?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        "packageBookingId": packageBookingId,
        "bookingDate": bookingDate,
        "bookingStatus": bookingStatus,
        "cancellationReason": cancellationReason,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "user": user,
        "pkg": pkg,
        // "user": user.toJson(),
        // "pkg": pkg.toJson(),
        "packagePrice": packagePrice,
        "numberOfMembers": numberOfMembers,
        "memberList": List<dynamic>.from(memberList.map((x) => x.toJson())),
        "assignedVehicleOnPackageBookings": List<dynamic>.from(
            assignedVehicleOnPackageBookings.map((x) => x.toJson())),
        "assignedDriverOnPackageBookings": List<dynamic>.from(
            assignedDriverOnPackageBookings.map((x) => x.toJson())),
        "pickupLocation": pickupLocation,
        "cancelledBy": cancelledBy,
        "endDate": endDate,
        "paymentId": paymentId,
        "countryCode": countryCode,
        "mobile": mobile,
        "alternateMobileCountryCode": alternateMobileCountryCode,
        "alternateMobile": alternateMobile,
        "discountAmount": discountAmount,
        "taxAmount": taxAmount,
        "taxPercentage": taxPercentage,
        "totalPayableAmount": totalPayableAmount,
      };
}

class AssignedDriverOnPackageBooking {
  String driverAssignedId;
  String date;
  Driver driver;
  bool isCancelled;

  AssignedDriverOnPackageBooking({
    required this.driverAssignedId,
    required this.date,
    required this.driver,
    required this.isCancelled,
  });

  factory AssignedDriverOnPackageBooking.fromJson(Map<String, dynamic> json) =>
      AssignedDriverOnPackageBooking(
        driverAssignedId: json["driverAssignedId"].toString(),
        date: json["date"] ?? "",
        driver: Driver.fromJson(json["driver"]),
        isCancelled: json["isCancelled"] ?? true,
      );

  Map<String, dynamic> toJson() => {
        "driverAssignedId": driverAssignedId,
        "date": date,
        "driver": driver.toJson(),
        "isCancelled": isCancelled,
      };
}

class AssignedVehicleOnPackageBooking {
  String assignedId;
  String date;
  Vehicle vehicle;
  bool isCancelled;

  AssignedVehicleOnPackageBooking({
    required this.assignedId,
    required this.date,
    required this.vehicle,
    required this.isCancelled,
  });

  factory AssignedVehicleOnPackageBooking.fromJson(Map<String, dynamic> json) =>
      AssignedVehicleOnPackageBooking(
        assignedId: json["assignedId"].toString(),
        date: json["date"] ?? "",
        vehicle: Vehicle.fromJson(json["vehicle"]),
        isCancelled: json["isCancelled"] ?? true,
      );

  Map<String, dynamic> toJson() => {
        "assignedId": assignedId,
        "date": date,
        "vehicle": vehicle.toJson(),
        "isCancelled": isCancelled,
      };
}

class Driver {
  String driverId;
  String firstName;
  String lastName;
  String driverAddress;
  String emiratesId;
  String mobile;
  String countryCode;
  String email;
  String gender;
  String licenceNumber;
  String createdDate;
  String modifiedDate;
  String profileImageUrl;
  String userType;
  String vendorId;
  // List<DriverUnavailableDate> unavailableDates;
  String driverStatus;

  Driver({
    required this.driverId,
    required this.firstName,
    required this.lastName,
    required this.driverAddress,
    required this.emiratesId,
    required this.mobile,
    required this.countryCode,
    required this.email,
    required this.gender,
    required this.licenceNumber,
    required this.createdDate,
    required this.modifiedDate,
    required this.profileImageUrl,
    required this.userType,
    required this.vendorId,
    // required this.unavailableDates,
    required this.driverStatus,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        driverId: json["driverId"].toString(),
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        driverAddress: json["driverAddress"] ?? "",
        emiratesId: json["emiratesId"] ?? "",
        mobile: json["mobile"] ?? "",
        countryCode: json["countryCode"] ?? "",
        email: json["email"] ?? "",
        gender: json["gender"] ?? "",
        licenceNumber: json["licenceNumber"] ?? "",
        createdDate: json["createdDate"].toString(),
        modifiedDate: json["modifiedDate"].toString(),
        profileImageUrl: json["profileImageUrl"] ?? "",
        userType: json["userType"] ?? "",
        vendorId: json["vendorId"].toString(),
        // unavailableDates: List<DriverUnavailableDate>.from(json["unavailableDates"].map((x) => DriverUnavailableDate.fromJson(x))),
        driverStatus: json["driverStatus"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "driverId": driverId,
        "firstName": firstName,
        "lastName": lastName,
        "driverAddress": driverAddress,
        "emiratesId": emiratesId,
        "mobile": mobile,
        "countryCode": countryCode,
        "email": email,
        "gender": gender,
        "licenceNumber": licenceNumber,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "profileImageUrl": profileImageUrl,
        "userType": userType,
        "vendorId": vendorId,
        // "unavailableDates": List<dynamic>.from(unavailableDates.map((x) => x.toJson())),
        "driverStatus": driverStatus,
      };
}

class Vehicle {
  String vehicleId;
  String carName;
  String year;
  String carType;
  String brandName;
  String fuelType;
  String seats;
  String color;
  String vehicleNumber;
  String modelNo;
  String createdDate;
  String modifiedDate;
  List<String> images;
  String vehicleStatus;
  // List<VehicleUnavailableDate> unavailableDates;

  Vehicle({
    required this.vehicleId,
    required this.carName,
    required this.year,
    required this.carType,
    required this.brandName,
    required this.fuelType,
    required this.seats,
    required this.color,
    required this.vehicleNumber,
    required this.modelNo,
    required this.createdDate,
    required this.modifiedDate,
    required this.images,
    required this.vehicleStatus,
    // required this.unavailableDates,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        vehicleId: json["vehicleId"].toString(),
        carName: json["carName"] ?? "",
        year: json["year"].toString(),
        carType: json["carType"] ?? "",
        brandName: json["brandName"] ?? "",
        fuelType: json["fuelType"] ?? "",
        seats: json["seats"].toString(),
        color: json["color"] ?? "",
        vehicleNumber: json["vehicleNumber"] ?? "",
        modelNo: json["modelNo"] ?? "",
        createdDate: json["createdDate"].toString(),
        modifiedDate: json["modifiedDate"].toString(),
        images: List<String>.from(json["images"].map((x) => x)),
        vehicleStatus: json["vehicleStatus"] ?? "",
        // unavailableDates: List<VehicleUnavailableDate>.from(json["unavailableDates"].map((x) => VehicleUnavailableDate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "vehicleId": vehicleId,
        "carName": carName,
        "year": year,
        "carType": carType,
        "brandName": brandName,
        "fuelType": fuelType,
        "seats": seats,
        "color": color,
        "vehicleNumber": vehicleNumber,
        "modelNo": modelNo,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "images": List<dynamic>.from(images.map((x) => x)),
        "vehicleStatus": vehicleStatus,
        // "unavailableDates": List<dynamic>.from(unavailableDates.map((x) => x.toJson())),
      };
}

class PackageHIstoryDetailsMemberList {
  String memberId;
  String name;
  String age;
  String ageUnit;
  // String type;
  String gender;

  PackageHIstoryDetailsMemberList({
    required this.memberId,
    required this.name,
    required this.age,
    required this.ageUnit,
    // required this.type,
    required this.gender,
  });

  factory PackageHIstoryDetailsMemberList.fromJson(Map<String, dynamic> json) =>
      PackageHIstoryDetailsMemberList(
        memberId: json["memberId"].toString(),
        name: json["name"]?.toString() ?? "",
        age: json["age"].toString(),
        ageUnit: json["ageUnit"].toString(),
        // type: json["type"],
        gender: json["gender"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "memberId": memberId,
        "name": name,
        "age": age,
        "ageUnit": ageUnit,
        // "type": type,
        "gender": gender,
      };
}

class PackageHIstoryDetailsPkg {
  String packageId;
  String country;
  String state;
  String packageName;
  String location;
  String noOfDays;
  List<String> packageImageUrl;
  String totalPrice;
  String packageStatus;
  String createdDate;
  String modifiedDate;
  List<PackageHIstoryDetailsPackageActivity> packageActivities;

  PackageHIstoryDetailsPkg({
    required this.packageId,
    required this.country,
    required this.state,
    required this.packageName,
    required this.location,
    required this.noOfDays,
    required this.packageImageUrl,
    required this.totalPrice,
    required this.packageStatus,
    required this.createdDate,
    required this.modifiedDate,
    required this.packageActivities,
  });

  factory PackageHIstoryDetailsPkg.fromJson(Map<String, dynamic> json) =>
      PackageHIstoryDetailsPkg(
        packageId: json["packageId"].toString(),
        country: json["country"] ?? "",
        state: json["state"] ?? "",
        packageName: json["packageName"] ?? "",
        location: json["location"] ?? "",
        noOfDays: json["noOfDays"] ?? "",
        packageImageUrl:
            List<String>.from(json["packageImageUrl"].map((x) => x)),
        totalPrice: json["totalPrice"].toString(),
        packageStatus: json["packageStatus"] ?? "",
        createdDate: json["createdDate"].toString(),
        modifiedDate: json["modifiedDate"].toString(),
        packageActivities: List<PackageHIstoryDetailsPackageActivity>.from(
            json["packageActivities"]
                .map((x) => PackageHIstoryDetailsPackageActivity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "packageId": packageId,
        "country": country,
        "state": state,
        "packageName": packageName,
        "location": location,
        "noOfDays": noOfDays,
        "packageImageUrl": List<dynamic>.from(packageImageUrl.map((x) => x)),
        "totalPrice": totalPrice,
        "packageStatus": packageStatus,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "packageActivities":
            List<dynamic>.from(packageActivities.map((x) => x.toJson())),
      };
}

class PackageHIstoryDetailsPackageActivity {
  String packageActivityId;
  PackageHIstoryDetailsActivity activity;
  String day;
  String startTime;

  PackageHIstoryDetailsPackageActivity({
    required this.packageActivityId,
    required this.activity,
    required this.day,
    required this.startTime,
  });

  factory PackageHIstoryDetailsPackageActivity.fromJson(
          Map<String, dynamic> json) =>
      PackageHIstoryDetailsPackageActivity(
        packageActivityId: json["packageActivityId"].toString(),
        activity: PackageHIstoryDetailsActivity.fromJson(json["activity"]),
        day: json["day"].toString(),
        startTime: json["startTime"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "packageActivityId": packageActivityId,
        "activity": activity,
        "day": day,
        "startTime": startTime,
      };
}

class PackageHIstoryDetailsActivity {
  String activityId;
  String country;
  String state;
  String city;
  String address;
  String activityName;
  String bestTimeToVisit;
  String activityHours;
  String activityPrice;
  String startTime;
  String endTime;
  String description;
  List<String> participantType;
  List<String> weeklyOff;
  List<String> activityImageUrl;
  String activityStatus;
  String createdDate;
  String modifiedDate;
  List<PackageHIstoryDetailsActivityReligiousOffDate> activityReligiousOffDates;
  double? discountedAmount;
  PackageHIstoryDetailsActivity(
      {required this.activityId,
      required this.country,
      required this.state,
      required this.city,
      required this.address,
      required this.activityName,
      required this.bestTimeToVisit,
      required this.activityHours,
      required this.activityPrice,
      required this.startTime,
      required this.endTime,
      required this.description,
      required this.participantType,
      required this.weeklyOff,
      required this.activityImageUrl,
      required this.activityStatus,
      required this.createdDate,
      required this.modifiedDate,
      required this.activityReligiousOffDates,
      this.discountedAmount});

  factory PackageHIstoryDetailsActivity.fromJson(Map<String, dynamic> json) =>
      PackageHIstoryDetailsActivity(
          activityId: json["activityId"].toString(),
          country: json["country"] ?? "",
          state: json["state"] ?? "",
          city: json["city"] ?? "",
          address: json["address"] ?? "",
          activityName: json["activityName"] ?? "",
          bestTimeToVisit: json["bestTimeToVisit"] ?? "",
          activityHours: json["activityHours"].toString(),
          activityPrice: json["activityPrice"].toString(),
          startTime: json["startTime"] ?? "",
          endTime: json["endTime"] ?? "",
          description: json["description"] ?? "",
          participantType:
              List<String>.from(json["participantType"].map((x) => x)),
          weeklyOff: List<String>.from(json["weeklyOff"].map((x) => x)),
          activityImageUrl:
              List<String>.from(json["activityImageUrl"].map((x) => x)),
          activityStatus: json["activityStatus"] ?? "",
          createdDate: json["createdDate"].toString(),
          modifiedDate: json["modifiedDate"].toString(),
          activityReligiousOffDates:
              List<PackageHIstoryDetailsActivityReligiousOffDate>.from(
                  json["activityReligiousOffDates"].map((x) =>
                      PackageHIstoryDetailsActivityReligiousOffDate.fromJson(
                          x))),
          discountedAmount: json["discountedAmount"] ?? 0);

  Map<String, dynamic> toJson() => {
        "activityId": activityId,
        "country": country,
        "state": state,
        "city": city,
        "address": address,
        "activityName": activityName,
        "bestTimeToVisit": bestTimeToVisit,
        "activityHours": activityHours,
        "activityPrice": activityPrice,
        "startTime": startTime,
        "endTime": endTime,
        "description": description,
        "participantType": List<dynamic>.from(participantType.map((x) => x)),
        "weeklyOff": List<dynamic>.from(weeklyOff.map((x) => x)),
        "activityImageUrl": List<dynamic>.from(activityImageUrl.map((x) => x)),
        "activityStatus": activityStatus,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "activityReligiousOffDates": List<dynamic>.from(
            activityReligiousOffDates.map((x) => x.toJson())),
        "discountedAmount": discountedAmount
      };
}

class PackageHIstoryDetailsActivityReligiousOffDate {
  String activityReligiousOffId;
  String religiousOffDate;
  String isCancelled;
  String createdDate;
  String modifiedDate;

  PackageHIstoryDetailsActivityReligiousOffDate({
    required this.activityReligiousOffId,
    required this.religiousOffDate,
    required this.isCancelled,
    required this.createdDate,
    required this.modifiedDate,
  });

  factory PackageHIstoryDetailsActivityReligiousOffDate.fromJson(
          Map<String, dynamic> json) =>
      PackageHIstoryDetailsActivityReligiousOffDate(
        activityReligiousOffId: json["activityReligiousOffId"].toString(),
        religiousOffDate: json["religiousOffDate"] ?? "",
        isCancelled: json["isCancelled"].toString(),
        createdDate: json["createdDate"].toString(),
        modifiedDate: json["modifiedDate"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "activityReligiousOffId": activityReligiousOffId,
        "religiousOffDate": religiousOffDate,
        "isCancelled": isCancelled,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
      };
}

class PackageHIstoryDetailsUser {
  String userId;
  String firstName;
  String lastName;
  String mobile;
  String address;
  String email;
  String gender;
  String createdDate;
  String modifiedDate;
  String status;
  String otp;
  String isOtpVerified;
  String userType;
  String profileImageUrl;

  PackageHIstoryDetailsUser({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.address,
    required this.email,
    required this.gender,
    required this.createdDate,
    required this.modifiedDate,
    required this.status,
    required this.otp,
    required this.isOtpVerified,
    required this.userType,
    required this.profileImageUrl,
  });

  factory PackageHIstoryDetailsUser.fromJson(Map<String, dynamic> json) =>
      PackageHIstoryDetailsUser(
        userId: json["userId"].toString(),
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        mobile: json["mobile"] ?? "",
        address: json["address"] ?? "",
        email: json["email"] ?? "",
        gender: json["gender"] ?? "",
        createdDate: json["createdDate"].toString(),
        modifiedDate: json["modifiedDate"].toString(),
        status: json["status"].toString(),
        otp: json["otp"].toString(),
        isOtpVerified: json["isOtpVerified"].toString(),
        userType: json["userType"] ?? "",
        profileImageUrl: json["profileImageUrl"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": mobile,
        "address": address,
        "email": email,
        "gender": gender,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "status": status,
        "otp": otp,
        "isOtpVerified": isOtpVerified,
        "userType": userType,
        "profileImageUrl": profileImageUrl,
      };
}

class PackageHIstoryDetailsStatus {
  String httpCode;
  String success;
  String message;

  PackageHIstoryDetailsStatus({
    required this.httpCode,
    required this.success,
    required this.message,
  });

  factory PackageHIstoryDetailsStatus.fromJson(Map<String, dynamic> json) =>
      PackageHIstoryDetailsStatus(
        httpCode: json["httpCode"] ?? "",
        success: json["success"].toString(),
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "httpCode": httpCode,
        "success": success,
        "message": message,
      };
}

///Package Delete Model
class PackageCancelModel {
  PackageCancelStatus status;
  PackageCancelData data;

  PackageCancelModel({
    required this.status,
    required this.data,
  });

  factory PackageCancelModel.fromJson(Map<String, dynamic> json) =>
      PackageCancelModel(
        status: PackageCancelStatus.fromJson(json["status"]),
        data: PackageCancelData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": data.toJson(),
      };
}

class PackageCancelData {
  Headers headers;
  String body;
  String statusCode;
  String statusCodeValue;

  PackageCancelData({
    required this.headers,
    required this.body,
    required this.statusCode,
    required this.statusCodeValue,
  });

  factory PackageCancelData.fromJson(Map<String, dynamic> json) =>
      PackageCancelData(
        headers: Headers.fromJson(json["headers"]),
        body: json["body"] ?? "",
        statusCode: json["statusCode"] ?? "",
        statusCodeValue: json["statusCodeValue"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "headers": headers.toJson(),
        "body": body,
        "statusCode": statusCode,
        "statusCodeValue": statusCodeValue,
      };
}

class Headers {
  Headers();

  factory Headers.fromJson(Map<String, dynamic> json) => Headers();

  Map<String, dynamic> toJson() => {};
}

class PackageCancelStatus {
  String httpCode;
  String success;
  String message;

  PackageCancelStatus({
    required this.httpCode,
    required this.success,
    required this.message,
  });

  factory PackageCancelStatus.fromJson(Map<String, dynamic> json) =>
      PackageCancelStatus(
        httpCode: json["httpCode"] ?? "",
        success: json["success"].toString(),
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "httpCode": httpCode,
        "success": success,
        "message": message,
      };
}

///Add PickUpLocation Model
class AddPickUpLocationModel {
  AddPickUpLocationStatus status;
  AddPickUpLocationData data;

  AddPickUpLocationModel({
    required this.status,
    required this.data,
  });

  factory AddPickUpLocationModel.fromJson(Map<String, dynamic> json) =>
      AddPickUpLocationModel(
        status: AddPickUpLocationStatus.fromJson(json["status"]),
        data: AddPickUpLocationData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": data.toJson(),
      };
}

class AddPickUpLocationData {
  String packageBookingId;
  String bookingDate;
  String bookingStatus;
  String cancellationReason;
  String createdDate;
  String modifiedDate;
  AddPickUpLocationUser user;
  AddPickUpLocationPkg pkg;
  String totalAmount;
  String numberOfMembers;
  List<AddPickUpLocationMemberList> memberList;
  List<dynamic> assignedVehicleOnPackageBooking;
  List<dynamic> assignedDriverOnPackageBooking;
  PickupLocation pickupLocation;

  AddPickUpLocationData({
    required this.packageBookingId,
    required this.bookingDate,
    required this.bookingStatus,
    required this.cancellationReason,
    required this.createdDate,
    required this.modifiedDate,
    required this.user,
    required this.pkg,
    required this.totalAmount,
    required this.numberOfMembers,
    required this.memberList,
    required this.assignedVehicleOnPackageBooking,
    required this.assignedDriverOnPackageBooking,
    required this.pickupLocation,
  });

  factory AddPickUpLocationData.fromJson(Map<String, dynamic> json) =>
      AddPickUpLocationData(
        packageBookingId: json["packageBookingId"].toString(),
        bookingDate: json["bookingDate"] ?? "",
        bookingStatus: json["bookingStatus"] ?? "",
        cancellationReason: json["cancellationReason"] ?? "",
        createdDate: json["createdDate"] ?? "",
        modifiedDate: json["modifiedDate"] ?? "",
        user: AddPickUpLocationUser.fromJson(json["user"]),
        pkg: AddPickUpLocationPkg.fromJson(json["pkg"]),
        totalAmount: json["totalAmount"].toString(),
        numberOfMembers: json["numberOfMembers"].toString(),
        memberList: List<AddPickUpLocationMemberList>.from(json["memberList"]
            .map((x) => AddPickUpLocationMemberList.fromJson(x))),
        assignedVehicleOnPackageBooking: List<dynamic>.from(
            json["assignedVehicleOnPackageBooking"].map((x) => x)),
        assignedDriverOnPackageBooking: List<dynamic>.from(
            json["assignedDriverOnPackageBooking"].map((x) => x)),
        pickupLocation: PickupLocation.fromJson(json["pickupLocation"]),
      );

  Map<String, dynamic> toJson() => {
        "packageBookingId": packageBookingId,
        "bookingDate": bookingDate,
        "bookingStatus": bookingStatus,
        "cancellationReason": cancellationReason,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "user": user.toJson(),
        "pkg": pkg.toJson(),
        "totalAmount": totalAmount,
        "numberOfMembers": numberOfMembers,
        "memberList": List<dynamic>.from(memberList.map((x) => x.toJson())),
        "assignedVehicleOnPackageBooking":
            List<dynamic>.from(assignedVehicleOnPackageBooking.map((x) => x)),
        "assignedDriverOnPackageBooking":
            List<dynamic>.from(assignedDriverOnPackageBooking.map((x) => x)),
        "pickupLocation": pickupLocation.toJson(),
      };
}

class AddPickUpLocationMemberList {
  String memberId;
  String name;
  String age;
  String gender;

  AddPickUpLocationMemberList({
    required this.memberId,
    required this.name,
    required this.age,
    required this.gender,
  });

  factory AddPickUpLocationMemberList.fromJson(Map<String, dynamic> json) =>
      AddPickUpLocationMemberList(
        memberId: json["memberId"].toString(),
        name: json["name"] ?? "",
        age: json["age"].toString(),
        gender: json["gender"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "memberId": memberId,
        "name": name,
        "age": age,
        "gender": gender,
      };
}

class PickupLocation {
  String the05072024;
  String the02072024;
  String the04072024;
  String the03072024;

  PickupLocation({
    required this.the05072024,
    required this.the02072024,
    required this.the04072024,
    required this.the03072024,
  });

  factory PickupLocation.fromJson(Map<String, dynamic> json) => PickupLocation(
        the05072024: json["05-07-2024"],
        the02072024: json["02-07-2024"],
        the04072024: json["04-07-2024"],
        the03072024: json["03-07-2024"],
      );

  Map<String, dynamic> toJson() => {
        "05-07-2024": the05072024,
        "02-07-2024": the02072024,
        "04-07-2024": the04072024,
        "03-07-2024": the03072024,
      };
}

class AddPickUpLocationPkg {
  String packageId;
  String country;
  String state;
  String packageName;
  String location;
  String noOfDays;
  List<String> packageImageUrl;
  String totalPrice;
  String packageStatus;
  String createdDate;
  String modifiedDate;
  List<AddPickUpLocationPackageActivity> packageActivities;

  AddPickUpLocationPkg({
    required this.packageId,
    required this.country,
    required this.state,
    required this.packageName,
    required this.location,
    required this.noOfDays,
    required this.packageImageUrl,
    required this.totalPrice,
    required this.packageStatus,
    required this.createdDate,
    required this.modifiedDate,
    required this.packageActivities,
  });

  factory AddPickUpLocationPkg.fromJson(Map<String, dynamic> json) =>
      AddPickUpLocationPkg(
        packageId: json["packageId"].toString(),
        country: json["country"] ?? "",
        state: json["state"] ?? "",
        packageName: json["packageName"] ?? "",
        location: json["location"] ?? "",
        noOfDays: json["noOfDays"] ?? "",
        packageImageUrl:
            List<String>.from(json["packageImageUrl"].map((x) => x)),
        totalPrice: json["totalPrice"].toString(),
        packageStatus: json["packageStatus"] ?? "",
        createdDate: json["createdDate"].toString(),
        modifiedDate: json["modifiedDate"].toString(),
        packageActivities: List<AddPickUpLocationPackageActivity>.from(
            json["packageActivities"]
                .map((x) => AddPickUpLocationPackageActivity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "packageId": packageId,
        "country": country,
        "state": state,
        "packageName": packageName,
        "location": location,
        "noOfDays": noOfDays,
        "packageImageUrl": List<dynamic>.from(packageImageUrl.map((x) => x)),
        "totalPrice": totalPrice,
        "packageStatus": packageStatus,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "packageActivities":
            List<dynamic>.from(packageActivities.map((x) => x.toJson())),
      };
}

class AddPickUpLocationPackageActivity {
  String packageActivityId;
  AddPickUpLocationActivity activity;
  String day;
  String startTime;

  AddPickUpLocationPackageActivity({
    required this.packageActivityId,
    required this.activity,
    required this.day,
    required this.startTime,
  });

  factory AddPickUpLocationPackageActivity.fromJson(
          Map<String, dynamic> json) =>
      AddPickUpLocationPackageActivity(
        packageActivityId: json["packageActivityId"].toString(),
        activity: AddPickUpLocationActivity.fromJson(json["activity"]),
        day: json["day"].toString(),
        startTime: json["startTime"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "packageActivityId": packageActivityId,
        "activity": activity.toJson(),
        "day": day,
        "startTime": startTime,
      };
}

class AddPickUpLocationActivity {
  String activityId;
  String country;
  String state;
  String city;
  String address;
  String activityName;
  String bestTimeToVisit;
  String activityHours;
  String activityPrice;
  String startTime;
  String endTime;
  String description;
  List<String> participantType;
  List<String> weeklyOff;
  List<String> activityImageUrl;
  String activityStatus;
  String createdDate;
  String modifiedDate;
  List<AddPickUpLocationActivityReligiousOffDate> activityReligiousOffDates;

  AddPickUpLocationActivity({
    required this.activityId,
    required this.country,
    required this.state,
    required this.city,
    required this.address,
    required this.activityName,
    required this.bestTimeToVisit,
    required this.activityHours,
    required this.activityPrice,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.participantType,
    required this.weeklyOff,
    required this.activityImageUrl,
    required this.activityStatus,
    required this.createdDate,
    required this.modifiedDate,
    required this.activityReligiousOffDates,
  });

  factory AddPickUpLocationActivity.fromJson(Map<String, dynamic> json) =>
      AddPickUpLocationActivity(
        activityId: json["activityId"].toString(),
        country: json["country"] ?? "",
        state: json["state"] ?? "",
        city: json["city"] ?? "",
        address: json["address"] ?? "",
        activityName: json["activityName"] ?? "",
        bestTimeToVisit: json["bestTimeToVisit"] ?? "",
        activityHours: json["activityHours"].toString(),
        activityPrice: json["activityPrice"].toString(),
        startTime: json["startTime"] ?? "",
        endTime: json["endTime"] ?? "",
        description: json["description"] ?? "",
        participantType:
            List<String>.from(json["participantType"].map((x) => x)),
        weeklyOff: List<String>.from(json["weeklyOff"].map((x) => x)),
        activityImageUrl:
            List<String>.from(json["activityImageUrl"].map((x) => x)),
        activityStatus: json["activityStatus"] ?? "",
        createdDate: json["createdDate"].toString(),
        modifiedDate: json["modifiedDate"].toString(),
        activityReligiousOffDates:
            List<AddPickUpLocationActivityReligiousOffDate>.from(
                json["activityReligiousOffDates"].map((x) =>
                    AddPickUpLocationActivityReligiousOffDate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "activityId": activityId,
        "country": country,
        "state": state,
        "city": city,
        "address": address,
        "activityName": activityName,
        "bestTimeToVisit": bestTimeToVisit,
        "activityHours": activityHours,
        "activityPrice": activityPrice,
        "startTime": startTime,
        "endTime": endTime,
        "description": description,
        "participantType": List<dynamic>.from(participantType.map((x) => x)),
        "weeklyOff": List<dynamic>.from(weeklyOff.map((x) => x)),
        "activityImageUrl": List<dynamic>.from(activityImageUrl.map((x) => x)),
        "activityStatus": activityStatus,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "activityReligiousOffDates": List<dynamic>.from(
            activityReligiousOffDates.map((x) => x.toJson())),
      };
}

class AddPickUpLocationActivityReligiousOffDate {
  String activityReligiousOffId;
  String religiousOffDate;
  bool isCancelled;
  String createdDate;
  String modifiedDate;

  AddPickUpLocationActivityReligiousOffDate({
    required this.activityReligiousOffId,
    required this.religiousOffDate,
    required this.isCancelled,
    required this.createdDate,
    required this.modifiedDate,
  });

  factory AddPickUpLocationActivityReligiousOffDate.fromJson(
          Map<String, dynamic> json) =>
      AddPickUpLocationActivityReligiousOffDate(
        activityReligiousOffId: json["activityReligiousOffId"].toString(),
        religiousOffDate: json["religiousOffDate"] ?? "",
        isCancelled: json["isCancelled"] ?? false,
        createdDate: json["createdDate"].toString(),
        modifiedDate: json["modifiedDate"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "activityReligiousOffId": activityReligiousOffId,
        "religiousOffDate": religiousOffDate,
        "isCancelled": isCancelled,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
      };
}

class AddPickUpLocationUser {
  String userId;
  String firstName;
  String lastName;
  String mobile;
  String address;
  String email;
  String gender;
  String createdDate;
  String modifiedDate;
  String status;
  String otp;
  String isOtpVerified;
  String userType;
  String profileImageUrl;

  AddPickUpLocationUser({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.address,
    required this.email,
    required this.gender,
    required this.createdDate,
    required this.modifiedDate,
    required this.status,
    required this.otp,
    required this.isOtpVerified,
    required this.userType,
    required this.profileImageUrl,
  });

  factory AddPickUpLocationUser.fromJson(Map<String, dynamic> json) =>
      AddPickUpLocationUser(
        userId: json["userId"].toString(),
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        mobile: json["mobile"] ?? "",
        address: json["address"] ?? "",
        email: json["email"] ?? "",
        gender: json["gender"] ?? "",
        createdDate: json["createdDate"].toString(),
        modifiedDate: json["modifiedDate"].toString(),
        status: json["status"].toString(),
        otp: json["otp"].toString(),
        isOtpVerified: json["isOtpVerified"].toString(),
        userType: json["userType"] ?? "",
        profileImageUrl: json["profileImageUrl"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": mobile,
        "address": address,
        "email": email,
        "gender": gender,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "status": status,
        "otp": otp,
        "isOtpVerified": isOtpVerified,
        "userType": userType,
        "profileImageUrl": profileImageUrl,
      };
}

class AddPickUpLocationStatus {
  String httpCode;
  bool success;
  String message;

  AddPickUpLocationStatus({
    required this.httpCode,
    required this.success,
    required this.message,
  });

  factory AddPickUpLocationStatus.fromJson(Map<String, dynamic> json) =>
      AddPickUpLocationStatus(
        httpCode: json["httpCode"],
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "httpCode": httpCode,
        "success": success,
        "message": message,
      };
}

///Get Package Itinerary Model
class GetPackageItineraryModel {
  GetPackageItineraryStatus status;
  GetPackageItineraryData? data;

  GetPackageItineraryModel({
    required this.status,
    required this.data,
  });

  factory GetPackageItineraryModel.fromJson(Map<String, dynamic> json) =>
      GetPackageItineraryModel(
        status: GetPackageItineraryStatus.fromJson(json["status"]),
        data: json["data"] != null
            ? GetPackageItineraryData.fromJson(json["data"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": data?.toJson(),
      };
}

class GetPackageItineraryData {
  String itineraryId;
  List<ItineraryDetail> itineraryDetails;
  String packageBookingId;
  String createdDate;
  String modifiedDate;
  bool isMailSend;

  GetPackageItineraryData({
    required this.itineraryId,
    required this.itineraryDetails,
    required this.packageBookingId,
    required this.createdDate,
    required this.modifiedDate,
    required this.isMailSend,
  });

  factory GetPackageItineraryData.fromJson(Map<String, dynamic> json) =>
      GetPackageItineraryData(
        itineraryId: json["itineraryId"].toString(),
        itineraryDetails: List<ItineraryDetail>.from(
            json["itineraryDetails"].map((x) => ItineraryDetail.fromJson(x))),
        packageBookingId: json["packageBookingId"].toString(),
        createdDate: json["createdDate"].toString(),
        modifiedDate: json["modifiedDate"].toString(),
        isMailSend: json["isMailSend"] ?? true,
      );

  Map<String, dynamic> toJson() => {
        "itineraryId": itineraryId,
        "itineraryDetails":
            List<dynamic>.from(itineraryDetails.map((x) => x.toJson())),
        "packageBookingId": packageBookingId,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "isMailSend": isMailSend,
      };
}

class ItineraryDetail {
  String itineraryDetailsId;
  String day;
  String date;
  GetPackageItineraryActivity activity;
  String createdDate;
  String modifiedDate;
  String dayStatus;
  String startTimestamp;
  String endTimestamp;
  String pickupTime;
  String completedBy;

  ItineraryDetail({
    required this.itineraryDetailsId,
    required this.day,
    required this.date,
    required this.activity,
    required this.createdDate,
    required this.modifiedDate,
    required this.dayStatus,
    required this.startTimestamp,
    required this.endTimestamp,
    required this.pickupTime,
    required this.completedBy,
  });

  factory ItineraryDetail.fromJson(Map<String, dynamic> json) =>
      ItineraryDetail(
        itineraryDetailsId: json["itineraryDetailsId"].toString(),
        day: json["day"].toString(),
        date: json["date"] ?? "",
        activity: GetPackageItineraryActivity.fromJson(json["activity"]),
        createdDate: json["createdDate"].toString(),
        modifiedDate: json["modifiedDate"].toString(),
        dayStatus: json["dayStatus"] ?? "",
        startTimestamp: json["startTimestamp"] ?? "",
        endTimestamp: json["endTimestamp"] ?? "",
        pickupTime: json["pickupTime"] ?? '',
        completedBy: json["completedBy"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "itineraryDetailsId": itineraryDetailsId,
        "day": day,
        "date": date,
        "activity": activity.toJson(),
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "dayStatus": dayStatus,
        "startTimestamp": startTimestamp,
        "endTimestamp": endTimestamp,
        "pickupTime": pickupTime,
        "completedBy": completedBy,
      };
}

class GetPackageItineraryActivity {
  String activityId;
  String country;
  String state;
  String city;
  String address;
  String activityName;
  String bestTimeToVisit;
  String activityHours;
  String activityPrice;
  String startTime;
  String endTime;
  String description;
  List<String> participantType;
  List<String> weeklyOff;
  List<String> activityImageUrl;
  String activityStatus;
  String createdDate;
  String modifiedDate;
  // List<dynamic> activityReligiousOffDates;
  double? discountedAmount;
  GetPackageItineraryActivity(
      {required this.activityId,
      required this.country,
      required this.state,
      required this.city,
      required this.address,
      required this.activityName,
      required this.bestTimeToVisit,
      required this.activityHours,
      required this.activityPrice,
      required this.startTime,
      required this.endTime,
      required this.description,
      required this.participantType,
      required this.weeklyOff,
      required this.activityImageUrl,
      required this.activityStatus,
      required this.createdDate,
      required this.modifiedDate,
      // required this.activityReligiousOffDates,
      this.discountedAmount});

  factory GetPackageItineraryActivity.fromJson(Map<String, dynamic> json) =>
      GetPackageItineraryActivity(
          activityId: json["activityId"].toString(),
          country: json["country"] ?? "",
          state: json["state"] ?? "",
          city: json["city"] ?? "",
          address: json["address"] ?? "",
          activityName: json["activityName"] ?? "",
          bestTimeToVisit: json["bestTimeToVisit"] ?? "",
          activityHours: json["activityHours"].toString(),
          activityPrice: json["activityPrice"].toString(),
          startTime: json["startTime"] ?? "",
          endTime: json["endTime"] ?? "",
          description: json["description"] ?? "",
          participantType:
              List<String>.from(json["participantType"].map((x) => x)),
          weeklyOff: List<String>.from(json["weeklyOff"].map((x) => x)),
          activityImageUrl:
              List<String>.from(json["activityImageUrl"].map((x) => x)),
          activityStatus: json["activityStatus"] ?? "",
          createdDate: json["createdDate"] ?? "",
          modifiedDate: json["modifiedDate"] ?? "",
          // activityReligiousOffDates: List<dynamic>.from(json["activityReligiousOffDates"].map((x) => x)),
          discountedAmount: json["discountedAmount"] ?? 0);

  Map<String, dynamic> toJson() => {
        "activityId": activityId,
        "country": country,
        "state": state,
        "city": city,
        "address": address,
        "activityName": activityName,
        "bestTimeToVisit": bestTimeToVisit,
        "activityHours": activityHours,
        "activityPrice": activityPrice,
        "startTime": startTime,
        "endTime": endTime,
        "description": description,
        "participantType": List<dynamic>.from(participantType.map((x) => x)),
        "weeklyOff": List<dynamic>.from(weeklyOff.map((x) => x)),
        "activityImageUrl": List<dynamic>.from(activityImageUrl.map((x) => x)),
        "activityStatus": activityStatus,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        // "activityReligiousOffDates": List<dynamic>.from(activityReligiousOffDates.map((x) => x)),
        "discountedAmount": discountedAmount
      };
}

class GetPackageItineraryStatus {
  String httpCode;
  bool success;
  String message;

  GetPackageItineraryStatus({
    required this.httpCode,
    required this.success,
    required this.message,
  });

  factory GetPackageItineraryStatus.fromJson(Map<String, dynamic> json) =>
      GetPackageItineraryStatus(
        httpCode: json["httpCode"],
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "httpCode": httpCode,
        "success": success,
        "message": message,
      };
}
