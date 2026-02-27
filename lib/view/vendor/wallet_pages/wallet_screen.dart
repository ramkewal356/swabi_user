// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/core/services/payment_service.dart';
import 'package:flutter_cab/core/utils/utils.dart';
import 'package:flutter_cab/data/response/status.dart';
import 'package:flutter_cab/view/vendor/wallet_pages/wallet_history_screen.dart';
import 'package:flutter_cab/view_model/third_party_view_model.dart';
import 'package:flutter_cab/view_model/wallet_view_model.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/custom_textformfield.dart';
import 'package:go_router/go_router.dart';
import 'package:group_button/group_button.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/widgets/Custom%20Page%20Layout/common_page_layout.dart';
import 'package:flutter_cab/widgets/custom_appbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({
    super.key,
  });
  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  TextEditingController amountcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String result = '';
  bool _obscureBalance = false; // State for show/hide balance
  String selectedCurrency = 'INR';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      getCurrencyListApi();
      getTransactions();
    });
  }

  void _addValues(String item1, String item2) {
    item2 = item2.replaceAll("+", "");
    final int value1 = int.tryParse(item1) ?? 0;
    final int value2 = int.tryParse(item2) ?? 0;
    setState(() {
      result = '${value1 + value2}';
    });
  }

  void getTransactions() {
    context.read<WalletViewModel>().getTransactionApi();
  }

  void getCurrencyListApi() {
    context.read<ThirdPartyViewModel>().getAllCurrency();
  }

  @override
  Widget build(BuildContext context) {
    final currencyList = context
            .watch<ThirdPartyViewModel>()
            .currencyList
            .data
            ?.map((e) => e.code ?? '')
            .toList() ??
        [];
    final transactionData =
        context.watch<WalletViewModel>().getTransactionResponse.data;
    var createOrderStatus =
        context.watch<WalletViewModel>().createPaymentOrderResponse.status;
    var verifyStatus =
        context.watch<WalletViewModel>().verifyPaymentResponse.status;
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: const CustomAppBar(
        heading: "My Wallet",
      ),
      body: PageLayoutPage(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                child: Stack(
                  children: [
                    Container(
                      height: 215,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [
                            btnColor,
                            btnColor.withOpacity(0.88),
                            btnColor.withOpacity(0.76)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: btnColor.withOpacity(0.14),
                          width: 2.3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: btnColor.withOpacity(0.21),
                            blurRadius: 18,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Neon/glass highlight based on btnColor
                          Positioned(
                            left: 18,
                            top: 18,
                            child: Container(
                              width: 125,
                              height: 33,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(26),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.25),
                                    btnColor.withOpacity(0.05)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 35,
                            top: 34,
                            child: Container(
                              width: 40,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: LinearGradient(
                                  colors: [
                                    btnColor.withOpacity(0.13),
                                    Colors.white.withOpacity(0.03)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28.0, vertical: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                            colors: [
                                              btnColor.withOpacity(0.97),
                                              btnColor.withOpacity(0.81)
                                            ],
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: const Offset(0, 4),
                                            blurRadius: 19,
                                            color: btnColor.withOpacity(0.21),
                                          )
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: const Icon(
                                        Icons.account_balance_wallet_rounded,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      'Wallet Balance',
                                      style: titleTextStyle.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20,
                                        letterSpacing: 1.3,
                                        shadows: [
                                          Shadow(
                                            color: btnColor.withOpacity(0.2),
                                            offset: const Offset(0, 2),
                                            blurRadius: 7,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _obscureBalance = !_obscureBalance;
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(50),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Icon(
                                          _obscureBalance
                                              ? Icons.visibility_off_rounded
                                              : Icons.visibility_rounded,
                                          color: Colors.white.withOpacity(0.88),
                                          size: 29,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 13),
                                  child: Text(
                                    _obscureBalance
                                        ? "••••••"
                                        : transactionData?.balance?.amount == 0
                                            ? "USD 0"
                                            : "${transactionData?.balance?.currency ?? ''} ${transactionData?.balance?.amount ?? ''}",
                                    style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 2.5,
                                      shadows: [
                                        Shadow(
                                            color: btnColor.withOpacity(0.45),
                                            offset: const Offset(0, 4),
                                            blurRadius: 14)
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.privacy_tip_rounded,
                                            color: Colors.white, size: 22),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Secure & Protected',
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.92),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 7),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            btnColor.withOpacity(0.47),
                                            btnColor.withOpacity(0.31)
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: btnColor.withOpacity(0.17),
                                          width: 1.1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: btnColor.withOpacity(0.08),
                                            blurRadius: 5,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.verified_rounded,
                                              size: 17, color: Colors.white),
                                          const SizedBox(width: 5),
                                          Text(
                                            'ACTIVE',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 15,
                                              letterSpacing: 0.85,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Add balance modern card
              Form(
                key: _formKey,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                        color: btnColor.withOpacity(0.32), width: 1.8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: btnColor.withOpacity(0.18),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Icon(Icons.add_card_rounded,
                                  color: btnColor, size: 26),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Add Balance",
                              style: titleTextStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                                color: btnColor,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Customtextformfield(
                          prefixIcon: IntrinsicWidth(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(width: 8),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    hint: const Text(
                                      "INR",
                                      style: TextStyle(
                                        color: greyColor1,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    value:
                                        currencyList.contains(selectedCurrency)
                                            ? selectedCurrency
                                            : null,
                                    icon: const Icon(Icons.keyboard_arrow_down,
                                        size: 18),
                                    style: TextStyle(
                                      color: greyColor1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedCurrency = value!;
                                      });
                                    },
                                    items: currencyList.toSet().map((currency) {
                                      return DropdownMenuItem(
                                        value: currency,
                                        child: Text(currency),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Container(
                                  height: 24,
                                  width: 1,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          controller: amountcontroller,
                          hintText: 'Amount (in $selectedCurrency)',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter amount( in $selectedCurrency)';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              result = value;
                            });
                          },
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'Quick Add Amount',
                          style: titleText.copyWith(
                            color: AppColor.cancelTextColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15.2,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          child: GroupButton(
                            buttons: const ['+1000', '+2000', '+5000'],
                            onSelected: (index, int i, isSelected) async {
                              _addValues(result, index);
                              setState(() {
                                amountcontroller.text = result;
                              });
                            },
                            options: GroupButtonOptions(
                              elevation: 0,
                              groupRunAlignment: GroupRunAlignment.start,
                              textAlign: TextAlign.center,
                              buttonHeight: 40,
                              buttonWidth: 100,
                              spacing: 13,
                              runSpacing: 14,
                              selectedTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              selectedColor: btnColor,
                              unselectedColor: Colors.white,
                              unselectedTextStyle: TextStyle(
                                  color: btnColor.withOpacity(0.92),
                                  fontWeight: FontWeight.bold),
                              alignment: Alignment.center,
                              unselectedBorderColor: btnColor.withOpacity(0.25),
                              selectedBorderColor: btnColor,
                              borderRadius: BorderRadius.circular(10),
                              mainGroupAlignment: MainGroupAlignment.start,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: CustomButtonSmall(
                            width: 154,
                            height: 47,
                            btnHeading: 'ADD MONEY',
                            loading: createOrderStatus == Status.loading ||
                                verifyStatus == Status.loading,
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                _payNow();
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Modern navigation cards row (refreshed, no premium look)
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.push('/vendor_dashboard/walletHistory',
                            extra: WalletHistoryScreen(
                                transactionList: transactionData
                                        ?.transactions?.reversed
                                        .toList() ??
                                    []));
                      },
                      child: cardItem(
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                btnColor,
                                btnColor.withOpacity(0.72),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.primaryDark.withOpacity(.11),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                          padding: const EdgeInsets.all(13),
                          child: Icon(
                            Icons.wallet_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        'Wallet History',
                        tagColor: btnColor,
                        glass: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: cardItem(
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [greenColor, greenColor.withOpacity(.75)],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.accent.withOpacity(.13),
                                blurRadius: 9,
                              )
                            ],
                          ),
                          padding: const EdgeInsets.all(11),
                          child: Image.asset(
                            'assets/images/transaction.png',
                            width: 31,
                            height: 31,
                            color: Colors.white,
                          ),
                        ),
                        'Transactions',
                        tagColor: greenColor,
                        glass: true,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }

  // Modern CardItem Widget using app colors, glass effect, neon shadow
  Widget cardItem(Widget icon, String text,
      {Color tagColor = Colors.black87, bool glass = false}) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(22),
      color: Colors.transparent,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: glass
              ? LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.66),
                    tagColor.withOpacity(0.10),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: glass ? null : AppColor.cardColor.withOpacity(0.61),
          border: Border.all(
            color: tagColor.withOpacity(0.19),
            width: 1.3,
          ),
          boxShadow: [
            BoxShadow(
              color: tagColor.withOpacity(0.17),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 11),
            Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: subtitleText.copyWith(
                  color: tagColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.1,
                  shadows: [
                    Shadow(
                        color: tagColor.withOpacity(.13),
                        offset: Offset(0.5, 2.3),
                        blurRadius: 8)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 52,
              height: 7,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    tagColor.withOpacity(0.31),
                    tagColor.withOpacity(0.14)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(99),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _payNow() async {
    debugPrint('amoiuntmmvnv $result');
    double amount = double.tryParse(result) ?? 0;
    var resp = await context
        .read<WalletViewModel>()
        .createWalletPaymentOrderApi(
            query: {"amount": amount, "currency": selectedCurrency});
    if ((resp?.razorpayOrderId ?? '').isNotEmpty) {
      _openPayment(
          amount: resp?.amount ?? 0,
          razorPayId: resp?.razorpayOrderId ?? '',
          currency: selectedCurrency);
    }
  }

  void _openPayment(
      {required double amount,
      required String razorPayId,
      required String currency}) {
    PaymentService(
      onPaymentError: (_) {},
      onPaymentSuccess: (PaymentSuccessResponse res) async {
        Map<String, dynamic> body = {
          "razorpayOrderId": res.orderId,
          "paymentId": res.paymentId,
          "razorpaySignature": res.signature
        };
        final verifyResp =
            await context.read<WalletViewModel>().verifyPaymentApi(body: body);
        if (verifyResp == true) {
          Utils.toastSuccessMessage('Add Wallet Balance Successfully');
          getTransactions();
        }
      },
    ).openCheckout(
        payableAmount: amount,
        razorpayOrderId: razorPayId,
        coutryCode: '',
        mobileNo: '',
        email: '',
        currency: currency);
  }
}
