class AppUrl {
  // static var baseUrl = "http://swabi.ap-south-1.elasticbeanstalk.com";
  // static var baseUrlForImage = "http://swabi.ap-south-1.elasticbeanstalk.com";
  static var baseUrl = 'https://dev-api.swabitours.com';
  static var baseUrlForImage = "https://dev-api.swabitours.com";
  static var locationBaseUrl = 'https://www.universal-tutorial.com';

  ///registration URL
  static var login = "$baseUrl/login";
  static var loginUrl = "/login";
  static var signUp = "$baseUrl/user/register_user";
  static var signupUrl = '/user/register_user';
  static var rental = "$baseUrl/rental";
  static var rentalBooking = "$baseUrl/rental/booking";
  static var rentalBookingCancel = "$baseUrl/rental/cancel_rental_booking";
  static var rentalBookingList = "$baseUrl/rental/get_rental_booking_by_userId";
  static var rentalViewDetails = "$baseUrl/rental/get_rental_booking_by_id";
  static var userProfile = "$baseUrl/user/get_user_by_userId";
  static var userProfileUpdate = "$baseUrl/user/update_user";
  static var userProfileimg = "$baseUrl/user/upload_profile";
  static var rentalRangeList = "$baseUrl/rental/get_rental_metrics_list";
  static var getPackageList = "$baseUrl/package/get_package_list";
  static var getAllPackageListUrl = "/package/get_package_list_by_date";
  static var getPackageByIdUrl = '/package/get_package_by_id';
  static var getCalculatePriceUrl = '/package_booking/calculate_package_price';
  static var packageBookingUrl = '/package_booking/book_package';
  static var confirmpackageBookingUrl =
      '/package_booking/confirm_package_booking';
  static var confirmRentalBookingUrl = '/rental/confirm_rental_booking';
  static var getpackageBookingByIdUrl =
      '/package_booking/get_package_booking_by_id';
  static var getItenerypackageBookingIdUrl =
      '/package_booking/get_itinerary_by_package_booking_id';
  static var createPaymentOrder = "/payment/create_order";
  static var verifyPayment = "/payment/verify_payment";
  static var changepasswordUrl = "/user/change_user_password";
  static var updateProfileUrl = '/user/update_user';
  static var getProfileUrl = '/user/get_user_by_userId';
  static var rentalCarBookingUrl = "/rental/booking_v2";
  static var rentalCarSearchUrl = '/rental/rental_car_price';
  static var paymentDetailUrl = "/payment/get_payment_by_payment_id";
  static var changeMobileUrl = "/package_booking/change_mobile_number";
  static var raiseIssueUrl = "/booking_issue/raise_issue";
  static var getIssueUrl = "/booking_issue/get_issue_raised_by";
  static var getIssueDetailsUrl = "/booking_issue/get_issue_detail";
  static var getIssueBybbokingId = "/booking_issue/get_issue_by_booking_id";
  static var sendOtpsUrl = "/otp_send";
  static var verifyOtpUrl = "/otp_verify";
  static var resetPassordUrl = "/password_update";
  static var getOfferListUrl = "/offer/get_available_offer";
  static var getOfferDetailUrl = "/offer/get_offer_by_id";
  static var validateOfferUrl = "/offer/validate_offer";
  static var getTransactionByIdUrl = "/payment/get_transaction_by_userId";
  static var getRefundTransactionByIdUrl = '/payment/get_refund_by_userId';
  static var getRefundPaymentUrl = "/payment/get_refund_by_payment_id";
  static var packageCancellUrl = "/package_booking/cancel_package_booking";
  static var addPickupLocation = '/package_booking/add_pickup_location';
  static var rentalCancellUrl = "/rental/cancel_rental_booking";
  static var getRentalByUserIdUrl = "/rental/get_rental_booking_by_userId";
  static var getRentalByIdUrl = "/rental/get_rental_booking_by_id";
  static var checkRentalBookingByDateUrl =
      "/rental/check_rental_booking_by_date";
  static var getRentalmatricsListUrl = "/rental/get_rental_metrics_list";
  static var getPackagelistUrl =
      "/package_booking/get_package_booking_by_userId";
  static var getLatestNotificationUrl =
      '/notification/get_latest_notification_by_receiverId';
  static var updateNotificationStatusUrl =
      '/notification/update_notification_status';
  static var getAllNotificationUrl =
      '/notification/get_notification_by_receiverId';
  static var getCountryList = '/api/countries/';
  static var getStateList = '/api/states/';
  static var getAccessTokenUrl = '/api/getaccesstoken';

}
