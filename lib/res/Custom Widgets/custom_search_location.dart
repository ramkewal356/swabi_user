import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/utils/utils.dart';
import 'package:google_maps_webservice/places.dart';

class CustomSearchLocation extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final Color? fillColor;
  final FocusNode? focusNode;
  final String state;
  // final bool stateValidation;
  const CustomSearchLocation({
    super.key,
    required this.controller,
    required this.state,
    required this.hintText,
    this.fillColor,
    this.focusNode,
    // required this.stateValidation,
  });

  @override
  State<CustomSearchLocation> createState() => _CustomSearchLocationState();
}

class _CustomSearchLocationState extends State<CustomSearchLocation> {
  void _navigateToSearchPage() async {
    final selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SearchLocationPage(
                state: widget.state,
              )),
    );

    if (selectedLocation != null) {
      // widget.widget = selectedLocation;
      widget.controller?.text = selectedLocation;
    }
    // if (widget.stateValidation) {
    //   if (widget.state.isEmpty) {
    //     Utils.toastMessage('message');
    //   } else {
    //     final selectedLocation = await Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => SearchLocationPage(
    //                 state: widget.state,
    //               )),
    //     );

    //     if (selectedLocation != null) {
    //       // widget.widget = selectedLocation;
    //       widget.controller?.text = selectedLocation;
    //     }
    //   }
    // } else {
    //   final selectedLocation = await Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => SearchLocationPage(
    //               state: widget.state,
    //             )),
    //   );

    //   if (selectedLocation != null) {
    //     // widget.widget = selectedLocation;
    //     widget.controller?.text = selectedLocation;
    //   }
    // }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   widget.controller?.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      readOnly: true,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: textTitleHint,
        fillColor: widget.fillColor ?? background,
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        // border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Color(0xFFCDCDCD),
            // width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Color(0xFFCDCDCD),
            // width: 2.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Color(0xFFCDCDCD),
            // width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Color(0xFFCDCDCD),
            // width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Color(0xFFCDCDCD),
            // color: redColor,
            // width: 2.0,
          ),
        ),

        errorStyle: const TextStyle(
          color: redColor, // Change error text color
          fontSize: 13, // Adjust error text size if needed
        ),
      ),
      onTap: _navigateToSearchPage,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select location';
        }
        return null;
      },
    );
  }
}

class SearchLocationPage extends StatefulWidget {
  final String state;
  const SearchLocationPage({super.key, required this.state});

  @override
  State<SearchLocationPage> createState() => _SearchLocationPageState();
}

class _SearchLocationPageState extends State<SearchLocationPage> {
  String kGoogleApiKey = 'AIzaSyDhKIUQ4QBoDuOsooDfNY_EjCG0MB7Ami8';
  final TextEditingController _searchController = TextEditingController();
  late GoogleMapsPlaces googlePlace;
  List<Prediction> predictions = [];

  @override
  void initState() {
    super.initState();
    googlePlace = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  }

  void _searchPlaces(String input) async {
    try {
      final result = await googlePlace.autocomplete(
        input,
        components: [Component("country", "ae")],
      );

      if (result.predictions != null) {
        setState(() {
          predictions = result.predictions;
        });
      } else {
        setState(() {
          predictions = [];
        });
        print("No predictions found.");
      }
    } catch (error) {
      print("Error occurred while fetching places: $error");
      setState(() {
        predictions = [];
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      predictions = [];
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: background,
        shadowColor: greyColor1.withOpacity(0.5),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
              hintText: "Search location",
              helperStyle: textTitleHint,
              border: InputBorder.none
              // border: OutlineInputBorder(),
              ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              _searchPlaces(value);
            } else {
              setState(() {
                predictions = [];
              });
            }
          },
        ),
        actions: [
          IconButton(onPressed: _clearSearch, icon: const Icon(Icons.close))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  final prediction = predictions[index];
                  return ListTile(
                    splashColor: btnColor,
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(prediction.description ?? ""),
                    onTap: () {
                      if (prediction.description?.contains(widget.state) ??
                          false) {
                        Navigator.pop(context, prediction.description);
                      } else {
                        // Show a validation message or feedback to the user if the location is not valid
                        print("Please select a location in Dubai.");
                        Utils.toastMessage(
                            "Please select a location in ${widget.state}");
                      }
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
