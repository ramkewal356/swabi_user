import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/assets.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';

class Customtabbar extends StatefulWidget {
  final List<String> tabs;
  final List<Widget> viewchildren;
  final TabController? controller;
  final bool sortVisiblty;
  final bool isVisible;
  final String? titleHeading;
  final Widget? titleWidget;
  final void Function(int)? onTap;
  final void Function()? onTapSort;
  const Customtabbar(
      {super.key,
      required this.tabs,
      required this.viewchildren,
      this.controller,
      this.titleHeading,
      this.sortVisiblty = false,
      this.isVisible = false,
      this.onTapSort,
      this.titleWidget,
      this.onTap});

  @override
  State<Customtabbar> createState() => _CustomtabbarState();
}

class _CustomtabbarState extends State<Customtabbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.titleHeading ?? '',
          style: appbarTextStyle,
        ),
        backgroundColor: background,
        centerTitle: true,
      ),
      backgroundColor: bgGreyColor,
      body: Column(
        children: [
          Container(
             
              decoration: const BoxDecoration(
               
                color: background,
             
              ),
              child: TabBar(
                // isScrollable: true,
                controller: widget.controller,
                onTap: widget.onTap,
                indicatorSize: TabBarIndicatorSize.tab,
              

                tabAlignment: TabAlignment.fill,
                labelPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                // indicatorPadding: EdgeInsets.zero,
                indicatorWeight: 2.5,
                indicatorColor: btnColor,
                labelColor: blackColor,
                dividerColor: Colors.transparent,
                unselectedLabelColor: blackColor,
                tabs: List.generate(widget.tabs.length, (index) {
                  return Tab(
                    child: Text(
                      widget.tabs[index].toString(),
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  );
                }),
              )),
          const SizedBox(height: 10),
          widget.sortVisiblty
              ? Container(
                  padding: const EdgeInsets.only(bottom: 10, right: 10, top: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SortBy Date :- ',
                        style: titleTextStyle1,
                      ),
                      InkWell(
                        onTap: widget.onTapSort,
                        child: Container(
                          width: 35,
                          height: 24,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(color: Colors.black26),
                              color: background),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Image.asset(
                              widget.isVisible ? ascendingIcon : descendingIcon,
                              height: 20,
                              width: 20,
                              color: blackColor,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : widget.titleWidget ?? Container(),
          Expanded(
              child: TabBarView(
                  controller: widget.controller,
                  children: widget.viewchildren)),
        ],
      ),
    );
  }
}
