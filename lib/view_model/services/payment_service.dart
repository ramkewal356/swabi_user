import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentService {
  late Razorpay _razorpay;
  final BuildContext context;
  final Function onPaymentSuccess;
  final Function onPaymentError;

  bool islodingpayment = false;
  PaymentService(
      {required this.context,
      required this.onPaymentSuccess,
      required this.onPaymentError}) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout(
      {required String coutryCode,
      required String mobileNo,
      required String email,
      required String razorpayOrderId,
      required double payableAmount}) async {
    try {
      // var paymentOrderId;

      debugPrint('payment..,,......$payableAmount');
      // paymentOrderId = onValue?.data.razorpayOrderId;
      // print('paymentId:....$paymentOrderId');
      var options = {
        'key': 'rzp_test_6RDAELPDeFpXXx',
        'amount': (payableAmount).ceil() * 100,
        'currency': 'AED',
        'name': 'SWABI',
        // 'order_id': widget.orderId,
        'order_id': razorpayOrderId,

        'description': 'Payment for Tours/Service',
        'prefill': {'contact': "$coutryCode $mobileNo", 'email': email},
        'external': {
          'wallets': ['paytm']
        },
        'image':
            'https://shilsha-bckt.s3.ap-south-1.amazonaws.com/Asset_233000_11727343705079.png', // Replace with your logo URL
        // Customize the color theme of the payment interface
        'theme': {
          'color': '#7B1E34' // Replace with your desired color code
        }
      };
      _razorpay.open(options);

      // Extract the Razorpay order ID from the response
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    onPaymentSuccess(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Utils.toastMessage(response.message!);
    onPaymentError(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: ${response.walletName!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void dispose() {
    _razorpay.clear(); // Removes all listeners
  }

}
