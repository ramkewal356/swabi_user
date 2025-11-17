////Payment Create OrderID Model
class PaymentCreateOderIdModel {
  Status status;
  Data data;

  PaymentCreateOderIdModel({
    required this.status,
    required this.data,
  });

  factory PaymentCreateOderIdModel.fromJson(Map<String, dynamic> json) => PaymentCreateOderIdModel(
    status: Status.fromJson(json["status"]),
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status.toJson(),
    "data": data.toJson(),
  };
}

class Data {
  String orderId;
  String amount;
  String amountPaid;
  String notes;
  String amountDue;
  String currency;
  String receipt;
  String razorpayOrderId;
  String entity;
  String offerId;
  String status;
  String attempts;
  String userId;
  String createdAt;
  String modifiedDate;

  Data({
   required this.orderId,
    required this.amount,
    required this.amountPaid,
    required this.notes,
    required this.amountDue,
    required this.currency,
    required this.receipt,
    required this.razorpayOrderId,
    required this.entity,
    required this.offerId,
    required this.status,
    required this.attempts,
    required this.userId,
    required this.createdAt,
    required this.modifiedDate,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    orderId: json["orderId"]?.toString() ?? "",
    amount: json["amount"]?.toString() ?? "",
    amountPaid: json["amountPaid"]?.toString() ?? "",
    notes: json["notes"]?.toString() ?? "",
    amountDue: json["amountDue"]?.toString() ?? "",
    currency: json["currency"]?.toString() ?? "",
    receipt: json["receipt"]?.toString() ?? "",
    razorpayOrderId: json["razorpayOrderId"]?.toString() ?? "",
    entity: json["entity"]?.toString() ?? "",
    offerId: json["offerId"]?.toString() ?? "",
    status: json["status"]?.toString() ?? "",
    attempts: json["attempts"]?.toString() ?? "",
    userId: json["userId"]?.toString() ?? "",
    createdAt: json["createdAt"]?.toString() ?? "",
    modifiedDate: json["modifiedDate"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "amount": amount,
    "amountPaid": amountPaid,
    "notes": notes,
    "amountDue": amountDue,
    "currency": currency,
    "receipt": receipt,
    "razorpayOrderId": razorpayOrderId,
    "entity": entity,
    "offerId": offerId,
    "status": status,
    "attempts": attempts,
    "userId": userId,
    "createdAt": createdAt,
    "modifiedDate": modifiedDate,
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

///Payment Verify Model
class PaymentVerifyModel {
  PaymentVerifyStatus status;
  PaymentVerifyData data;

  PaymentVerifyModel({
    required this.status,
    required this.data,
  });

  factory PaymentVerifyModel.fromJson(Map<String, dynamic> json) => PaymentVerifyModel(
    status: PaymentVerifyStatus.fromJson(json["status"]),
    data: PaymentVerifyData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status.toJson(),
    "data": data.toJson(),
  };
}

class PaymentVerifyData {
  String? transactionId;
  String? paymentId;
  String? razorpayOrderId;
  String? razorpaySignature;
  String? orderId;
  String? bookingType;
  String? bookingId;
  String? createdDate;
  String? modifiedDate;
  String? transactionStatus;

  PaymentVerifyData({
    this.transactionId,
    this.paymentId,
    this.razorpayOrderId,
    this.razorpaySignature,
    this.orderId,
    this.bookingType,
    this.bookingId,
    this.createdDate,
    this.modifiedDate,
    this.transactionStatus,
  });

  factory PaymentVerifyData.fromJson(Map<String, dynamic> json) => PaymentVerifyData(
    transactionId: json["transactionId"]?.toString() ?? "",
    paymentId: json["paymentId"]?.toString() ?? "",
    razorpayOrderId: json["razorpayOrderId"]?.toString() ?? "",
    razorpaySignature: json["razorpaySignature"]?.toString() ?? "",
    orderId: json["orderId"]?.toString() ?? "",
    bookingType: json["bookingType"]?.toString() ?? "",
    bookingId: json["bookingId"]?.toString() ?? "",
    createdDate: json["createdDate"]?.toString() ?? "",
    modifiedDate: json["modifiedDate"]?.toString() ?? "",
    transactionStatus: json["transactionStatus"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "transactionId": transactionId,
    "paymentId": paymentId,
    "razorpayOrderId": razorpayOrderId,
    "razorpaySignature": razorpaySignature,
    "orderId": orderId,
    "bookingType": bookingType,
    "bookingId": bookingId,
    "createdDate": createdDate,
    "modifiedDate": modifiedDate,
    "transactionStatus": transactionStatus,
  };
}

class PaymentVerifyStatus {
  String httpCode;
  bool success;
  String message;

  PaymentVerifyStatus({
    required this.httpCode,
    required this.success,
    required this.message,
  });

  factory PaymentVerifyStatus.fromJson(Map<String, dynamic> json) => PaymentVerifyStatus(
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
