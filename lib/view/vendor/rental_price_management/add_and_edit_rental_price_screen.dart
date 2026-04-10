import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/core/utils/utils.dart';
import 'package:flutter_cab/data/models/rental_price_list_model.dart'
    hide Status;
import 'package:flutter_cab/view_model/rental_price_management_view_model.dart';
import 'package:flutter_cab/view_model/third_party_view_model.dart';
import 'package:flutter_cab/view_model/vehicle_view_model.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/customdropdown_button.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/custom_textformfield.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';

class AddAndEditRentalPriceScreen extends StatefulWidget {
  final bool isEdit;
  final RentalPriceContent? rentalPriceItem;

  const AddAndEditRentalPriceScreen({
    super.key,
    this.isEdit = false,
    this.rentalPriceItem,
  });

  @override
  State<AddAndEditRentalPriceScreen> createState() =>
      _AddAndEditRentalPriceScreenState();
}

class _AddAndEditRentalPriceScreenState
    extends State<AddAndEditRentalPriceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _carTypeController = TextEditingController();
  final TextEditingController _pricePerHourController = TextEditingController();
  final TextEditingController _pricePerKmController = TextEditingController();

  // Add a state for selected currency, initialize to 'INR'
  String selectedHrCurrency = 'INR';
  String selectedKmCurrency = 'INR';

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.rentalPriceItem != null) {
      _carTypeController.text = widget.rentalPriceItem?.carType ?? '';
      _pricePerHourController.text =
          widget.rentalPriceItem?.perHourPrice?.toString() ?? '';
      _pricePerKmController.text =
          widget.rentalPriceItem?.perKilometerPrice?.toString() ?? '';
      if (widget.rentalPriceItem?.currencyHour != null &&
          widget.rentalPriceItem!.currencyHour!.isNotEmpty) {
        selectedHrCurrency = widget.rentalPriceItem!.currencyHour!;
      }
      if (widget.rentalPriceItem?.currencyKm != null &&
          widget.rentalPriceItem!.currencyKm!.isNotEmpty) {
        selectedKmCurrency = widget.rentalPriceItem!.currencyKm!;
      }
    }
    getVehicles();
    _loadCurrencies();
  }

  void getVehicles() async {
    context.read<VehicleViewModel>().fetchVehicleTypes();
  }

  void _loadCurrencies() {
    context.read<ThirdPartyViewModel>().getAllCurrency();
  }

  @override
  void dispose() {
    _carTypeController.dispose();
    _pricePerHourController.dispose();
    _pricePerKmController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final data = {
        "carType": _carTypeController.text.trim(),
        "perHourPrice": double.tryParse(_pricePerHourController.text.trim()),
        "perKilometerPrice": double.tryParse(_pricePerKmController.text.trim()),
        "currencyHour": selectedHrCurrency,
        "currencyKM": selectedKmCurrency,
        // If editing, include the rental price ID (use your model's property name)
        if (widget.isEdit && widget.rentalPriceItem != null)
          "id": widget.rentalPriceItem!.id,
      };
      debugPrint('datata $data');
      context.read<RentalPriceManagementViewModel>().addEditRentalPriceApi(
            data: data,
            isEdit: widget.isEdit,
            onComplete: (success, errorMsg) {
              if (success) {
                Navigator.of(context).pop(true); // Optionally pop with result
                // Optionally, show a success message/snackbar
                Utils.toastSuccessMessage(widget.isEdit
                    ? 'Rental price updated successfully'
                    : 'Rental price added successfully');
              }
            },
          );
      // Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var vehicleTypeList =
        context.watch<VehicleViewModel>().getAllVehicleType.data?.data;
    final currencyList = context
            .watch<ThirdPartyViewModel>()
            .currencyList
            .data
            ?.map((e) => e.code ?? '')
            .where((e) => e.isNotEmpty)
            .toList() ??
        [];

    // Listen to the RentalPriceManagementViewModel for the loader
    final rentalPriceVM = context.watch<RentalPriceManagementViewModel>();
    final bool isLoading =
        rentalPriceVM.addEditRentalPrice.status == Status.loading;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEdit ? 'Edit Rental Price' : 'Add Rental Price',
          style: appbarTextStyle,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: const Color(0xFFE8E7E2)),
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 1,
          color: background,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Car Type*',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 8),
                  CustomDropdownButton(
                    itemsList: vehicleTypeList
                            ?.map((toElement) => toElement)
                            .toList() ??
                        [],
                    controller: _carTypeController,
                    isEditable: !widget.isEdit,
                    hintText: 'Select Car Type',
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return 'Please select car type';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  Text('Price Per Hour*',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 8),
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
                              value: currencyList.contains(selectedHrCurrency)
                                  ? selectedHrCurrency
                                  : (currencyList.isNotEmpty
                                      ? currencyList.first
                                      : null),
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  size: 18),
                              style: const TextStyle(
                                color: greyColor1,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    selectedHrCurrency = value;
                                  });
                                }
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
                    controller: _pricePerHourController,
                    hintText: 'Price (in $selectedHrCurrency)',
                    lable: 'Price (in $selectedHrCurrency) *',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter price (in $selectedHrCurrency)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  Text('Price Per K.M.*',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 8),
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
                              value: currencyList.contains(selectedKmCurrency)
                                  ? selectedKmCurrency
                                  : (currencyList.isNotEmpty
                                      ? currencyList.first
                                      : null),
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  size: 18),
                              style: const TextStyle(
                                color: greyColor1,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    selectedKmCurrency = value;
                                  });
                                }
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
                    controller: _pricePerKmController,
                    hintText: 'Price (in $selectedKmCurrency)',
                    lable: 'Price (in $selectedKmCurrency) *',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter price (in $selectedKmCurrency)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  CustomButtonSmall(
                    loading: isLoading,
                    btnHeading:
                        widget.isEdit ? 'Save Changes' : 'Add Rental Price',
                    onTap: isLoading ? null : _onSave,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
