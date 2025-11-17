import 'package:flutter/material.dart';
import 'package:flutter_cab/core/constants/assets.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatefulWidget {
  final String userName;
  final String emailAddress;
  final String profileUrl;
  final List<Map<String, dynamic>> menuItems;
  final String lastLogin;
  const CustomDrawer(
      {super.key,
      required this.userName,
      required this.emailAddress,
      required this.profileUrl,
      required this.menuItems,
      required this.lastLogin});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: bgGreyColor,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPictureSize: const Size.square(68),
            decoration: const BoxDecoration(color: btnColor),
            otherAccountsPicturesSize: const Size.square(70),
            otherAccountsPictures: [
              Image.asset(
                appLogo1,
                color: Colors.white,
              )
            ],
            accountName: Text(
              widget.userName,
              style: btnTextStyle,
            ),
            accountEmail: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.emailAddress,
                  style: subtitleTextStyle,
                ),
                Text(
                  widget.lastLogin,
                  style: landingTextStyle,
                )
              ],
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                  child: (widget.profileUrl.isNotEmpty)
                      ? Image.network(
                          widget.profileUrl,
                          fit: BoxFit.fill,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : Image.asset(
                          appLogo1,
                          height: double.infinity,
                          width: double.infinity,
                        )),
            ),
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: widget.menuItems.length,
                itemBuilder: (context, index) {
                  final item = widget.menuItems[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: ListTile(
                      horizontalTitleGap: 10,
                      tileColor: background,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      dense: true,
                      minTileHeight: 50,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: greyColor1.shade400),
                          borderRadius: BorderRadius.circular(10)),
                      // selected: widget.selectedIndex == index,
                      selected: widget.menuItems.length - 1 == index,
                      selectedTileColor: btnColor,
                      onTap: () {
                        // widget.onItemSelected(index);
                        if (item['onTap'] != null) {
                          item['onTap']();
                          context.pop();
                        }

                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      leading: Image.asset(
                        item['imgUrl'],
                        height: 20,
                        color: widget.menuItems.length - 1 == index
                            ? Colors.white
                            : btnColor,
                      ),
                      title: Text(
                        item['label'],
                        style: widget.menuItems.length - 1 == index
                            ? landingtitleStyle
                            : customListTileTextStyle,
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: widget.menuItems.length - 1 == index
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
