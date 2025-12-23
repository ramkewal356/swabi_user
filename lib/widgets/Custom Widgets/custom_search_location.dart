import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/core/utils/utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_maps_webservices/places.dart';


class CustomSearchLocation extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final Color? fillColor;
  final FocusNode? focusNode;
  final String state;
  // final bool stateValidation;
  final bool withoutBorder;
  final bool isEditable;
  const CustomSearchLocation(
      {super.key,
      required this.controller,
      required this.state,
      required this.hintText,
      this.fillColor,
      this.focusNode,
      this.withoutBorder = false,
      this.isEditable = true
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
  }

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
        filled: widget.withoutBorder ? false : true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        border: widget.withoutBorder
            ? const UnderlineInputBorder()
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Colors.black54),
              ),
        focusedBorder: widget.withoutBorder
            ? const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black54),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Color(0xFFCDCDCD)),
              ),
        enabledBorder: widget.withoutBorder
            ? const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black54),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Color(0xFFCDCDCD)),
              ),
        disabledBorder: widget.withoutBorder
            ? const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFCDCDCD)),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Color(0xFFCDCDCD)),
              ),
        focusedErrorBorder: widget.withoutBorder
            ? const UnderlineInputBorder(
                borderSide: BorderSide(color: redColor),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Color(0xFFCDCDCD)),
              ),
        errorBorder: widget.withoutBorder
            ? const UnderlineInputBorder(
                borderSide: BorderSide(color: redColor),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Color(0xFFCDCDCD)),
              ),
        errorStyle: const TextStyle(
          color: redColor, // Change error text color
          fontSize: 13, // Adjust error text size if needed
        ),
      ),
      onTap: widget.isEditable ? _navigateToSearchPage : null,
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
  // String kGoogleApiKey = 'AIzaSyDhKIUQ4QBoDuOsooDfNY_EjCG0MB7Ami8';
  String kGoogleApiKey = dotenv.env['API_KEY'] ?? '';

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
        // components: [Component("country", "ae")],
      );

      if (result.predictions != []) {
        setState(() {
          predictions = result.predictions;
        });
      } else {
        setState(() {
          predictions = [];
        });
      }
    } catch (error) {
      debugPrint("Error occurred while fetching places: $error");
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
        // ignore: deprecated_member_use
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

                        Utils.toastMessage(
                            "Please select a location in ${widget.state}");
                      }
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
