class AppUrl {
  static var baseUrl = "https://live.swabi.xyz/api";
  static var baseUrlForImage = "https://live.swabi.xyz/api";
  // static var baseUrl = 'https://dev-api.swabitours.com';
  // static var baseUrlForImage = "https://dev-api.swabitours.com";
  static var locationBaseUrl = 'https://www.universal-tutorial.com';
  static var countryStateBaseUrl = 'https://countriesnow.space';

  ///registration URL

  static var loginUrl = "/login";
  static var signupUrl = '/user/register_user';
  static var getPackageList = "/package/get_package_list";
  static var getAllPackageList = "/package/get_All_package_list";

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
  static var updateProfilePicUrl = '/user/upload_profile';
  // static var updateVendorProfilecUrl = '/vendor/update_vendor';
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
  static var getActivityCategoryList =
      '/activity_category/list_activity_categories';

  static var getAllActivityList = '/activity/get_all_activity';
  static var getAllAcitivityListUrl = '/activity/get_all_activities';
  static var getStateWithImageList = '/state_image/get_list_state_with_image';
  static var getCountryListUrl = '/api/v0.1/countries';
  static var getStateNameUrl = '/api/v0.1/countries/states';

  /// vendor url
  static var getVendorByIdUrl = '/vendor/get_vendor_by_vendorId';
  static var updateVendorProfilePicUrl = '/vendor/upload_vendor_profile';
  static var getAllVehicleUrl = '/vehicle/get_count_of_vehicle';
  static var getAllDriverUrl = '/driver/get_count_of_driver';
  static var getAllRentalBookingUrl = '/rental/get_count_of_rental_booking';
  static var getAllPackageBookingUrl =
      '/package_booking/get_count_of_package_booking';
  static var vendorChangePasswordUrl = '/vendor/change_vendor_password';
  static var vendorUpdateProfileUrl = '/vendor/update_vendor';
  // bid management
  static var sendEnquiryUrl = '/travel/sendInquiry';
  static var getAllEnquiryUrl = '/travel/inquiries';
  static var getAllMyEnquiryUrl = '/bids/user/bids';
  static var getEnquiryById = '/travel/get_inquiry';
  static var createBidUrl = '/bids/create';
  static var getAllBidUrl = '/bids/vendor/1/submitted';
  static var updateBidUrl = '/bids/vendor/update';
  static var bidBookUrl = '/bids/book';
  static var bidAcceptUrl = '/bids/accept';
  static var bidRejectUrl = '/bids/reject';
  //package mangement
  static var addPackageUrl = '/package/create_package';
  static var updatePackageUrl = '/package/update_package';
  static var activePackageUrl = '/package/activate_package';
  static var deactivepackageUrl = '/package/deactivate_package';
  static var activateAcitivityUrl = '/activity/activate_activity';
  static var deActivateAcitivityUrl = '/activity/deactivate_activity';
  //acivity offer
  static var activityOfferUrl = '/offer/get_activity_offer';
  static var getActivityByIdUrl = '/activity/get_activity_by_id';
  static var addActivityUrl = '/activity/add_activity';
  static var updateActivityUrl = '/activity/update_activity';
  static var getOfferByVendorIdUrl = '/offer/get_available_offer_by_vendor';
  // rental management
  static var getAllRentalListUrl = '/rental/get_all_rental_booking';
  //package booking management
  static var getAllpackageBookingListUrl =
      '/package_booking/get_package_booking_list';
  static var updateItineraryUrl = '/package_booking/update_itinerary';
  static var addItineraryUrl = '/package_booking/create_itinerary';

  /// vehicle management
  static var getAllVehicleListUrl = '/vehicle/get_vehicle_list';
  static var getAvailableVehicleListUrl =
      '/vehicle/get_available_vehicle_by_package_booking_id';
  static var assignVehicleUrl =
      '/package_booking/assign_vehicle_to_package_booking';
  static var addVehicleUrl = '/vehicle/add_vehicle';
  static var updateVehicleUrl = '/vehicle/update_vehicle';
  static var getVehicleByIdUrl = '/vehicle/get_vehicle_by_vehicleId';
  static var activateVehicleUrl = '/vehicle/activate_vehicle';
  static var deactiveVehicleUrl = '/vehicle/deactivate_vehicle';
  static var getVehicleBrandName = '/vehicle/get_vehicle_brand_name';
  static var getAllVehicleType = '/vehicle/get_all_vehicle_type';
  static var getVehicleOwnerListUrl = '/vehicle/get_vehicle_owner_list';
  static var addVehicleOwnerUrl = '/vehicle/add_vehicle_owner';
  static var getVehicleOwnerByIdUrl = '/vehicle/get_vehicle_owner_by_id';
  static var activateVehicleOwnerUrl = '/vehicle/activate_vehicle_owner';
  static var deactiveVehicleOwnerUrl = '/vehicle/delete_vehicle_owner';
  static var updateVehicleOwnerDetails = '/vehicle/update_vehicle_owner_detail';
  // driver management
  static var getAllDriverListUrl = '/driver/get_driver_list';
  static var getAvailableDriverListUrl =
      '/driver/get_available_driver_by_package_booking_id';
  static var assignDriverUrl =
      '/package_booking/assign_driver_to_package_booking';
  static var getDriverByIdUrl = '/driver/get_driver_by_driverId';
  static var addDriverUrl = '/driver/add_driver';
  static var updateDriverUrl = '/driver/update_driver_details';
  static var activateDriverUrl = '/driver/activate_driver';
  static var deactivateDriverUrl = '/driver/deactivate_driver';
  // currency URL
  static var currencyUrl = '/swabi/get_all_currencies';
  // color url
  static var colorbaseUrl = 'https://www.csscolorsapi.com';
  static var colorUrl = '/api/colors';
}
