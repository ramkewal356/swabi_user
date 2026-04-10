// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/core/utils/utils.dart';
import 'package:flutter_cab/data/response/status.dart';
import 'package:flutter_cab/view_model/offer_view_model.dart';
import 'package:flutter_cab/view_model/third_party_view_model.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/single_image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../common/styles/app_color.dart';
import '../../../view_model/offer_management_view_model.dart';

class AddAndEditOfferScreen extends StatefulWidget {
  final bool isEdit;
  final String? offerId;

  const AddAndEditOfferScreen({super.key, this.isEdit = false, this.offerId});

  @override
  State<AddAndEditOfferScreen> createState() => _AddAndEditOfferScreenState();
}

class _AddAndEditOfferScreenState extends State<AddAndEditOfferScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _offerNameController = TextEditingController();
  final TextEditingController _offerCodeController = TextEditingController();
  final TextEditingController _discountPercentageController =
      TextEditingController();
  final TextEditingController _minimumBookingAmountController =
      TextEditingController();
  final TextEditingController _maxDiscountAmtController =
      TextEditingController();
  final TextEditingController _usageLimitPerUserController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _termsController = TextEditingController();
  String? initialOfferImage;
  String? selectedOfferImage;

  String _offerType = 'PACKAGE_BOOKING';
  String _offerStatus = 'ACTIVE';
  DateTime? _startDate, _endDate;

  String? _selectedMinBookingCurrency;
  String? _selectedMaxDiscountCurrency;

  // Helper function to format date as dd-MM-yyyy
  String formatDateDMY(DateTime? date) {
    if (date == null) return "";
    return DateFormat("dd-MM-yyyy").format(date);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      _loadCurrencies();
      if (widget.isEdit) {
        // Fetch offer details and update the state after retrieving data.
        _fetchOfferDetails();
      }
    });
  }

  void _loadCurrencies() {
    context.read<ThirdPartyViewModel>().getAllCurrency();
  }

  Future<void> _fetchOfferDetails() async {
    final vm = context.read<OfferViewModel>();
    final offer = await vm.getOfferDetailsApi(offerId: widget.offerId ?? '');
    if (offer?.data != null) {
      setState(() {
        _offerNameController.text = offer?.data?.offerName ?? "";
        _offerCodeController.text = offer?.data?.offerCode ?? "";
        _discountPercentageController.text =
            offer?.data?.discountPercentage?.toString() ?? "";
        _minimumBookingAmountController.text =
            offer?.data?.minimumBookingAmount?.toString() ?? "";
        _maxDiscountAmtController.text =
            offer?.data?.maxDiscountAmount?.toString() ?? "";
        _usageLimitPerUserController.text =
            offer?.data?.usageLimitPerUser?.toString() ?? "";
        _descriptionController.text = offer?.data?.description ?? "";
        _termsController.text = offer?.data?.termsAndConditions ?? "";
        _offerType = offer?.data?.offerType ?? "Flat";
        _offerStatus = offer?.data?.offerStatus ?? "ACTIVE";
        // Parse start and end date from backend string to DateTime and setState
        _startDate = offer?.data?.startDate != null
            ? DateFormat("dd-MM-yyyy").parse(offer?.data?.startDate! ?? '')
            : null;
        _endDate = offer?.data?.endDate != null
            ? DateFormat("dd-MM-yyyy").parse(offer?.data?.endDate! ?? '')
            : null;
        _selectedMinBookingCurrency = offer?.data?.minCurrency ?? "";
        _selectedMaxDiscountCurrency = offer?.data?.maxCurrency ?? "";
        initialOfferImage = offer?.data?.imageUrl;
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    DateTime initialDate = isStart
        ? (_startDate ?? DateTime.now())
        : (_endDate ??
            (_startDate != null
                ? _startDate!.add(const Duration(days: 1))
                : DateTime.now().add(const Duration(days: 1))));
    DateTime firstDate = isStart
        ? DateTime.now().subtract(const Duration(days: 365))
        : (_startDate ?? DateTime.now());
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          // Optionally, reset end date if before new start date
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select offer date range.")));
      return;
    }
    if (_endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("End date must be after start date.")));
      return;
    }
    if (_selectedMinBookingCurrency == null ||
        _selectedMaxDiscountCurrency == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please select currency for amount fields.")));
      return;
    }

    final Map<String, dynamic> offerRequest = {
      "offerName": _offerNameController.text,
      "offerCode": _offerCodeController.text,
      "discountPercentage":
          double.tryParse(_discountPercentageController.text) ?? 0,
      "minimumBookingAmount":
          double.tryParse(_minimumBookingAmountController.text) ?? 0,
      "minCurrency": _selectedMinBookingCurrency,
      "maxDiscountAmount": double.tryParse(_maxDiscountAmtController.text) ?? 0,
      "maxCurrency": _selectedMaxDiscountCurrency,
      "usageLimitPerUser": int.tryParse(_usageLimitPerUserController.text) ?? 0,
      "description": _descriptionController.text,
      "termsAndConditions": _termsController.text,
      "offerType": _offerType,
      "offerStatus": _offerStatus,
      // Keep sending dates as dd-MM-yyyy to backend
      "startDate": formatDateDMY(_startDate),
      "endDate": formatDateDMY(_endDate),
    };
    String? vendorId = await UserViewModel().getUserId();
    if (widget.isEdit) {
      offerRequest["offerId"] = widget.offerId;
      offerRequest["imageUrl"] = initialOfferImage;
    } else {
      offerRequest["vendorId"] = vendorId;
    }
    Map<String, dynamic> offerData = {"offerRequest": jsonEncode(offerRequest)};
    if (selectedOfferImage != null) {
      // offerData["image"] = selectedOfferImage;
      offerData["image"] = await MultipartFile.fromFile(
        selectedOfferImage!,
        filename: selectedOfferImage?.split('/').last,
      );
    }
    final vm = context.read<OfferManagementViewModel>();
    var resp =
        await vm.addOrEditOffer(offerData: offerData, isEdit: widget.isEdit);

    if (resp == true) {
      Utils.toastSuccessMessage(widget.isEdit
          ? "Offer Updated Successfully"
          : "Offer Added Successfully");
      context.pop(true);
    }
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
    var loadingCurrencies =
        context.watch<ThirdPartyViewModel>().currencyList.status ==
            Status.loading;

    var isLoading = context.watch<OfferViewModel>().getOfferDetails.status ==
        Status.loading;
    var actionLoading = context
            .watch<OfferManagementViewModel>()
            .addOrEditOfferResponse
            .status ==
        Status.loading;
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: AppBar(
        title: Text(widget.isEdit ? "Edit Offer" : "Add New Offer",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: background,
      ),
      body: isLoading || loadingCurrencies
          ? const Center(
              child: CircularProgressIndicator(
              color: greenColor,
            ))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Offer Name
                    TextFormField(
                      readOnly: widget.isEdit,
                      ignorePointers: widget.isEdit,
                      controller: _offerNameController,
                      decoration: const InputDecoration(
                          labelText: "Offer Name",
                          border: OutlineInputBorder()),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Please enter offer name'
                              : null,
                    ),
                    const SizedBox(height: 16),

                    // Offer Code
                    TextFormField(
                      readOnly: widget.isEdit,
                      ignorePointers: widget.isEdit,
                      controller: _offerCodeController,
                      decoration: const InputDecoration(
                          labelText: "Offer Code",
                          border: OutlineInputBorder()),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Please enter offer code'
                              : null,
                    ),
                    const SizedBox(height: 16),

                    // Discount Percentage
                    TextFormField(
                      readOnly: widget.isEdit,
                      ignorePointers: widget.isEdit,
                      controller: _discountPercentageController,
                      decoration: const InputDecoration(
                          labelText: "Discount Percentage (%)",
                          border: OutlineInputBorder()),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter percentage';
                        }
                        final d = double.tryParse(value);
                        if (d == null || d < 0) return 'Invalid percentage';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Minimum Booking Amount with Currency
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            value: _selectedMinBookingCurrency,
                            isExpanded: true,
                            items: currencyList
                                .map((c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(c),
                                    ))
                                .toList(),
                            onChanged: widget.isEdit
                                ? null
                                : (val) {
                                    setState(() {
                                      _selectedMinBookingCurrency = val;
                                    });
                                  },
                            decoration: const InputDecoration(
                                labelText: "Currency",
                                border: OutlineInputBorder()),
                            validator: (val) =>
                                val == null || val.trim().isEmpty
                                    ? "Required"
                                    : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            readOnly: widget.isEdit,
                            ignorePointers: widget.isEdit,
                            controller: _minimumBookingAmountController,
                            decoration: const InputDecoration(
                                labelText: "Minimum Booking Amount",
                                border: OutlineInputBorder()),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Please enter minimum booking amount'
                                    : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Max Discount Amount with Currency
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            value: _selectedMaxDiscountCurrency,
                            isExpanded: true,
                            items: currencyList
                                .map((c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(c),
                                    ))
                                .toList(),
                            onChanged: widget.isEdit
                                ? null
                                : (val) {
                                    setState(() {
                                      _selectedMaxDiscountCurrency = val;
                                    });
                                  },
                            decoration: const InputDecoration(
                                labelText: "Currency",
                                border: OutlineInputBorder()),
                            validator: (val) =>
                                val == null || val.trim().isEmpty
                                    ? "Required"
                                    : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            readOnly: widget.isEdit,
                            ignorePointers: widget.isEdit,
                            controller: _maxDiscountAmtController,
                            decoration: const InputDecoration(
                                labelText: "Max Discount Amount",
                                border: OutlineInputBorder()),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Please enter max discount amout'
                                    : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Usage Limit per User
                    TextFormField(
                      readOnly: widget.isEdit,
                      ignorePointers: widget.isEdit,
                      controller: _usageLimitPerUserController,
                      decoration: const InputDecoration(
                          labelText: "Usage Limit Per User",
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Please enter usage limit per user'
                              : null,
                    ),
                    const SizedBox(height: 16),

                    // Offer Type (Dropdown)
                    DropdownButtonFormField<String>(
                      value: _offerType,
                      items: const [
                        DropdownMenuItem(
                            value: 'PACKAGE_BOOKING',
                            child: Text('Package Offer')),
                        DropdownMenuItem(
                            value: 'RENTAL_BOOKING',
                            child: Text('Rental Offer')),
                        DropdownMenuItem(
                            value: 'ACTIVITY', child: Text('Activity Offer')),
                      ],
                      onChanged: widget.isEdit
                          ? null
                          : (val) {
                              setState(() {
                                _offerType = val ?? 'PACKAGE_BOOKING';
                              });
                            },
                      decoration: const InputDecoration(
                          labelText: "Offer Type",
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select Offer type";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Offer Status (Dropdown)
                    DropdownButtonFormField<String>(
                      value: _offerStatus,
                      items: const [
                        DropdownMenuItem(
                            value: 'ACTIVE', child: Text('Active')),
                        DropdownMenuItem(
                            value: 'INACTIVE', child: Text('Inactive')),
                        DropdownMenuItem(
                            value: 'EXPIRED', child: Text('Expired')),
                      ],
                      onChanged: widget.isEdit
                          ? null
                          : (val) {
                              setState(() {
                                _offerStatus = val ?? 'ACTIVE';
                              });
                            },
                      decoration: const InputDecoration(
                          labelText: "Offer Status",
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select offer status";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Date Range
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectDate(context, true),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: "Start Date",
                                border: OutlineInputBorder(),
                              ),
                              child: Text(
                                _startDate != null && _startDate is DateTime
                                    ? formatDateDMY(_startDate)
                                    : "Select",
                                style: TextStyle(
                                  color: _startDate != null &&
                                          _startDate is DateTime
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectDate(context, false),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: "End Date",
                                border: OutlineInputBorder(),
                              ),
                              child: Text(
                                _endDate != null && _endDate is DateTime
                                    ? formatDateDMY(_endDate)
                                    : "Select",
                                style: TextStyle(
                                  color:
                                      _endDate != null && _endDate is DateTime
                                          ? Colors.black
                                          : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    FormField<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      initialValue: initialOfferImage,
                      builder: (field) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SingleImagePicker(
                              isEdit: widget.isEdit,
                              initialImageUrl: initialOfferImage,
                              noteText:
                                  '* File should be less than 1 MB\n* For the best viewing experience, please upload an image with a resolution of 1280x720 pixels.',
                              onImageSelected: (file) {
                                setState(() {
                                  selectedOfferImage = file?.path;
                                });
                                field.didChange(file?.path);
                                debugPrint('Selected image: ${file?.path}');
                              },
                            ),
                            if (field.hasError)
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, left: 10),
                                child: Text(
                                  field.errorText ?? '',
                                  style: TextStyle(
                                      color: Colors.red[700], fontSize: 12),
                                ),
                              ),
                          ],
                        );
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select image';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Description
                    TextFormField(
                      readOnly: widget.isEdit,
                      ignorePointers: widget.isEdit,
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                          labelText: "Description",
                          border: OutlineInputBorder()),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter description";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Terms & Conditions
                    TextFormField(
                      readOnly: widget.isEdit,
                      ignorePointers: widget.isEdit,
                      controller: _termsController,
                      decoration: const InputDecoration(
                          labelText: "Terms & Conditions",
                          border: OutlineInputBorder()),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter term & condition";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    CustomButtonSmall(
                        btnHeading:
                            widget.isEdit ? "Update Offer" : "Add Offer",
                        loading: actionLoading,
                        onTap: _submitForm),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _offerNameController.dispose();
    _offerCodeController.dispose();
    _discountPercentageController.dispose();
    _minimumBookingAmountController.dispose();
    _maxDiscountAmtController.dispose();
    _usageLimitPerUserController.dispose();
    _descriptionController.dispose();
    _termsController.dispose();
    super.dispose();
  }
}
