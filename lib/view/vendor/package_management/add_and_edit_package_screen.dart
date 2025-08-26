import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/status.dart';
import 'package:flutter_cab/model/get_all_activity_list_model.dart' hide Status;
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20%20Button/customdropdown_button.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/utils/utils.dart';
import 'package:flutter_cab/view_model/package_management_view_model.dart';
import 'package:flutter_cab/view_model/package_view_model.dart';
import 'package:provider/provider.dart';

class AddAndEditPackageScreen extends StatefulWidget {
  final bool isEdit;
  final String? packageId;
  const AddAndEditPackageScreen(
      {super.key, this.isEdit = false, this.packageId});

  @override
  State<AddAndEditPackageScreen> createState() =>
      _AddAndEditPackageScreenState();
}

class _AddAndEditPackageScreenState extends State<AddAndEditPackageScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noOfDayController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String _selectedCountry = 'United Arab Emirates';
  int? packageId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      if (widget.isEdit && widget.packageId != null) {
        viewPackage();
      }
    });
  }

  int calculateTotalPrice(List<ActivityContent> activities) {
    return activities.fold(
        0, (sum, activity) => sum + (activity.activityPrice?.toInt() ?? 0));
  }

  void viewPackage() async {
    final vm = context.read<GetPackageActivityByIdViewModel>();

    await vm.getPackageByIdApi(packageId: widget.packageId ?? '');

    final package = vm.getPackageActivityById.data?.data;

    if (package != null) {
      setState(() {
        // Set text fields
        packageId = package.packageId;
        _nameController.text = package.packageName ?? '';
        _noOfDayController.text = package.noOfDays?.toString() ?? '';
        _selectedCountry = package.country ?? 'United Arab Emirates';

        // Set activities list
        activities.clear();
        activities.addAll(package.packageActivities
                ?.map((e) => ActivityContent(
                      packageActivityId: e.packageActivityId,
                      activityId: e.activity?.activityId,
                      startTime: e.activity?.startTime,
                      activityName: e.activity?.activityName,
                      activityHours: e.activity?.activityHours,
                      activityPrice: e.activity?.activityPrice,
                    ))
                .toList() ??
            []);
      });
    }
  }

  final List<ActivityContent> activities = []; // dynamic list

  void _openAddActivityModal() async {
    final result = await showModalBottomSheet<ActivityContent>(
      context: context,
      isScrollControlled: true,
      backgroundColor: background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const AddActivityModal(),
    );

    if (result != null) {
      setState(() {
        activities.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final addStatus =
        context.watch<PackageManagementViewModel>().addedPackage.status;
    final updateStatus =
        context.watch<PackageManagementViewModel>().updatedPackage.status;

    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: AppBar(
        backgroundColor: background,
        title: Text(widget.isEdit ? "Edit Package" : "Add New Package"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Package Name
                Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text.rich(TextSpan(children: [
                      TextSpan(text: 'Package Name', style: titleTextStyle),
                      const TextSpan(
                          text: ' *', style: TextStyle(color: redColor))
                    ]))),
                Customtextformfield(
                  fillColor: background,
                  controller: _nameController,
                  hintText: 'Package Name',
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Please enter package name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Country Dropdown
                Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text.rich(TextSpan(children: [
                      TextSpan(text: 'Country', style: titleTextStyle),
                      const TextSpan(
                          text: ' *', style: TextStyle(color: redColor))
                    ]))),
                Customtextformfield(
                    readOnly: true,
                    fillColor: background,
                    controller: TextEditingController(text: _selectedCountry),
                    hintText: 'Country name'),

                const SizedBox(height: 10),

                // No. of days

                Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text.rich(TextSpan(children: [
                      TextSpan(text: 'Number of days', style: titleTextStyle),
                      const TextSpan(
                          text: ' *', style: TextStyle(color: redColor))
                    ]))),
                CustomDropdownButton(
                  controller: _noOfDayController,
                  // focusNode: focusNode3,

                  itemsList: List.generate(
                    15,
                    (index) {
                      return (index + 1).toString();
                    },
                  ),

                  // itemsList: [],
                  onChanged: (value) {
                    setState(() {
                      _noOfDayController.text = value ?? '';
                    });
                  },
                  hintText: 'Please Select No. of Days',

                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Please select no. of days';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Add Activity Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btnColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _openAddActivityModal,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Activity"),
                ),

                const SizedBox(height: 16),

                // Activities List or Empty State
                activities.isEmpty
                    ? Center(
                        child: Text(
                          "No activities added yet",
                          style: theme.textTheme.bodyMedium!
                              .copyWith(color: Colors.red),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: activities.length,
                        itemBuilder: (context, index) {
                          final activity = activities[index];
                          return Card(
                            color: background,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              // dense: true,
                              // visualDensity:
                              //     VisualDensity(horizontal: -4, vertical: -4),
                              contentPadding:
                                  const EdgeInsets.only(left: 15, right: 5),
                              title: Text(activity.activityName ?? ''),
                              subtitle: Text("${activity.activityHours} hrs"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "AED ${activity.activityPrice?.toInt()}",
                                    style: activityPrice,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        activities.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                // Total
                if (activities.isNotEmpty)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Total: AED ${(activities.fold<num>(0, (sum, item) => sum + (item.activityPrice?.toInt() ?? 0)) as int)}",
                      style: theme.textTheme.titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                const SizedBox(height: 24),

                // Create/Update Button

                CustomButtonSmall(
                  loading: addStatus == Status.loading ||
                      updateStatus == Status.loading,
                  height: 45,
                  btnHeading:
                      widget.isEdit ? "Update Package" : "Create New Package",
                  onTap: () {
                    int totalPrice = calculateTotalPrice(activities);
                    Map<String, dynamic> packageRequest = {
                      "packageId": widget.isEdit ? packageId : "",
                      "country": _selectedCountry,
                      "state": "",
                      "packageName": _nameController.text,
                      "location": "",
                      "noOfDays": _noOfDayController.text,
                      "totalPrice": totalPrice,
                      "packageActivityDetails":
                          activities.asMap().entries.map((entry) {
                        final index = entry.key;
                        final activity = entry.value;
                        return {
                          "day": index + 1,
                          "startTime": activity.startTime,
                          if (widget.isEdit)
                            "packageActivityId": activity.packageActivityId,
                          "activityId": activity.activityId,
                        };
                      }).toList(),
                      if (widget.isEdit) "packageImageUrl": [],
                      if (widget.isEdit) "deletePackageActivityId": []
                    };
                    if (widget.isEdit) {
                      context
                          .read<PackageManagementViewModel>()
                          .updatePackageApi(
                              packageRequest: packageRequest, context: context);
                    } else {
                      if (_formKey.currentState!.validate()) {
                        if (activities.isEmpty) {
                          Utils.toastMessage('Please add Activity');
                        } else {
                          context
                              .read<PackageManagementViewModel>()
                              .addPackageApi(
                                  packageRequest: packageRequest,
                                  context: context);
                        }
                      }
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddActivityModal extends StatefulWidget {
  const AddActivityModal({super.key});

  @override
  State<AddActivityModal> createState() => _AddActivityModalState();
}

class _AddActivityModalState extends State<AddActivityModal> {
  // final TextEditingController _activityController = TextEditingController();

  String? selectedActivity;

  // final List<Map<String, dynamic>> sampleActivities = [
  //   {"name": "Dubai Desert Safari", "hours": 2, "price": 4999},
  //   {"name": "City Tour", "hours": 4, "price": 2999},
  //   {"name": "Burj Khalifa Visit", "hours": 1, "price": 1999},
  // ];
  @override
  void initState() {
    super.initState();
    getAllActivity();
  }

  void getAllActivity() {
    context.read<PackageManagementViewModel>().getAllActivityApi();
  }

  @override
  Widget build(BuildContext context) {
    final sampleActivities = context
            .watch<PackageManagementViewModel>()
            .getAllActivityList
            .data
            ?.data
            ?.content ??
        [];
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Add Activity", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          // CustomDropdownButton(
          //     itemsList: sampleActivities
          //         .map((act) => act.activityName as String)
          //         .toList(),
          //     hintText: 'Select Activity',
          //     controller: _activityController),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              value: selectedActivity,
              hint: const Text("Select Activity"),
              items: sampleActivities
                  .map((act) => DropdownMenuItem<String>(
                        value: act.activityName as String,
                        child: Text(
                          act.activityName as String,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(),
                        ),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => selectedActivity = val),
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: greyColor1)),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: greyColor1))),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: btnColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: selectedActivity == null
                ? null
                : () {
                    final selected = sampleActivities.firstWhere(
                        (act) => act.activityName == selectedActivity);

                    Navigator.pop(context, selected); // return activity data
                  },
            icon: const Icon(Icons.check),
            label: const Text("Add"),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
