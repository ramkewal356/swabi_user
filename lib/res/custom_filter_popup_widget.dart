import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/color.dart';

class CustomFilterPopupWidget extends StatefulWidget {
  final Map<String, String> filterOptions; // UI label to return value
  final ValueChanged<String> onFilterChanged;
  final String title;

  const CustomFilterPopupWidget({
    super.key,
    required this.filterOptions,
    required this.onFilterChanged,
    this.title = "Filter",
  });

  @override
  State<CustomFilterPopupWidget> createState() =>
      _CustomFilterPopupWidgetState();
}

class _CustomFilterPopupWidgetState extends State<CustomFilterPopupWidget> {
  late Map<String, bool> filters;
  late String _filterTitle;

  @override
  void initState() {
    super.initState();
    // Initialize all options to false, first one (default) to true
    filters = {
      for (var key in widget.filterOptions.keys) key: false,
    };
    final firstKey = widget.filterOptions.keys.first;
    filters[firstKey] = true;
    _filterTitle = firstKey;
  }

  void _updateSelection(String filter, bool? value, StateSetter setStatePopup) {
    // Reset all
    filters.updateAll((key, _) => false);
    filters[filter] = value ?? false;

    setStatePopup(() {});
    setState(() {
      _filterTitle = filter;
    });

    _applyFilters();
    Navigator.pop(context);
  }

  void _applyFilters() {
    final selectedKey = filters.entries
        .firstWhere((e) => e.value, orElse: () => filters.entries.first)
        .key;
    final selectedValue = widget.filterOptions[selectedKey] ?? '';
    widget.onFilterChanged(selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      position: PopupMenuPosition.under,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      constraints: const BoxConstraints(minWidth: 150, maxWidth: 160),
      offset: const Offset(0, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Text(
              _filterTitle == widget.filterOptions.keys.first
                  ? widget.title
                  : _filterTitle,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
            const SizedBox(width: 5),
            const Icon(Icons.filter_list_rounded),
          ],
        ),
      ),
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          PopupMenuItem(
            padding: EdgeInsets.zero,
            enabled: false,
            child: StatefulBuilder(
              builder: (context, setStatePopup) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: filters.keys.map((filter) {
                    return _buildCheckListTile(
                      context,
                      filter,
                      filters[filter] ?? false,
                      (value) => _updateSelection(filter, value, setStatePopup),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ];
      },
      onSelected: (_) {},
    );
  }

  Widget _buildCheckListTile(BuildContext context, String title, bool? value,
      void Function(bool?)? onChanged) {
    return CheckboxListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      activeColor: btnColor,
      controlAffinity: ListTileControlAffinity.leading,
      visualDensity: const VisualDensity(horizontal: -4),
      value: value,
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, color: Colors.black),
      ),
      onChanged: onChanged,
    );
  }
}
