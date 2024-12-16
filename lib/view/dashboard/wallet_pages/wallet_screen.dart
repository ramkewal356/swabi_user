import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20Page%20Layout/commonPage_Layout.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/res/custom_appbar_widget.dart';
import 'package:flutter_cab/utils/assets.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:group_button/group_button.dart';

class WalletScreen extends StatefulWidget {
  final String userId;
  const WalletScreen({super.key, required this.userId});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  TextEditingController amountcontroller = TextEditingController();
  // bool? visibleIcon;
  final _formKey = GlobalKey<FormState>();
  String result = '';
  void _addValues(String item1, String item2) {
    final int value1 = int.tryParse(item1) ?? 0;
    final int value2 = int.tryParse(item2) ?? 0;
    setState(() {
      result = '${value1 + value2}';
      print('result $result');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        heading: "My Wallet",
      ),
      body: PageLayout_Page(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Material(
                elevation: 1,
                color: background,
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Wallet Balance',
                        style: titleTextStyle,
                      ),
                      Text(
                        'AED 00',
                        style: titleTextStyle,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Add Balance",
                          style: titleTextStyle,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Customtextformfield(
                          controller: amountcontroller,
                          hintText: 'Enter Amount',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            setState(() {
                              result = value;

                              debugPrint('object$result');
                            });
                          },
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please enter amount';
                            }
                            return null;
                          },
                        ),
                        // TextField(
                        //   controller: amountcontroller,
                        //   decoration: const InputDecoration(
                        //       contentPadding: EdgeInsets.symmetric(
                        //           vertical: 6, horizontal: 10),
                        //       border: OutlineInputBorder(),
                        //       hintText: 'Enter Amount'),
                        //   keyboardType: TextInputType.number,
                        //   onChanged: (value) {
                        //     setState(() {
                        //       result = value;

                        //       debugPrint('object$result');
                        //     });
                        //   },
                        // ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Recommend',
                          style: titleText,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        GroupButton(
                          buttons: const ['+1000', '+2000', '+5000'],
                          onSelected: (index, int i, isSelected) async {
                            _addValues(result, index);
                            setState(() {
                              amountcontroller.text = result;
                            });
                            debugPrint('$i');
                          },
                          options: GroupButtonOptions(
                              elevation: 2,
                              groupRunAlignment: GroupRunAlignment.start,
                              unselectedTextStyle: const TextStyle(
                                  fontSize: 12, color: Colors.black),
                              textPadding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              textAlign: TextAlign.center,
                              buttonHeight: 35,
                              runSpacing: 25,
                              selectedTextStyle:
                                  const TextStyle(color: btnColor),
                              selectedColor: background,
                              unselectedColor: background,
                              alignment: Alignment.center,
                              unselectedBorderColor: Colors.black54,
                              selectedBorderColor: btnColor,
                              borderRadius: BorderRadius.circular(5),
                              mainGroupAlignment: MainGroupAlignment.start),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                            child: CustomButtonSmall(
                                width: 130,
                                height: 45,
                                btnHeading: 'ADD MONEY',
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {}
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => AddMoneyScreen(
                                  //             getAmount: result)));
                                })),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      context.push('/walletHistory',
                          extra: {'userId': widget.userId});
                    },
                    child: cardItem(
                        const Icon(
                          Icons.wallet_rounded,
                          color: btnColor,
                        ),
                        'WALLET HISTORY'),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      context.push('/myTransaction',
                          extra: {"userId": widget.userId});
                    },
                    child: cardItem(
                        Image.asset(
                          transaction,
                          width: 22,
                          height: 22,
                          color: btnColor,
                        ),
                        'TRANSACTION HISTORY'),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: cardItem(
                          const Icon(
                            Icons.receipt_outlined,
                            color: btnColor,
                          ),
                          'REFUND HISTORY'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  cardItem(Widget icon, String text) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(5),
      color: background,
      child: Container(
        // width: 110,
        height: 110,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        decoration: BoxDecoration(
            color: background, borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Color.fromARGB(252, 242, 199, 161),
              child: icon,
              // child: Icon(
              //   icon,
              //   color: Color(0xFFBF5F0B),
              // ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: subtitleText,
              ),
            )
          ],
        ),
      ),
    );
  }
}
