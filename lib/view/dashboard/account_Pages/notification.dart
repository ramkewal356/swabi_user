import 'package:flutter/material.dart';
import 'package:flutter_cab/model/getall_notification_model.dart';
import 'package:flutter_cab/res/Custom%20Page%20Layout/commonPage_Layout.dart';
import 'package:flutter_cab/res/custom_appbar_widget.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view_model/notification_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  final String userId;
  const NotificationPage({super.key, required this.userId});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  GetAllNotificationModel? getAllNotificationList;
  final ScrollController _scrollController = ScrollController();
  int currentPage = 0;
  int pageSize = 10;
  bool isLastPage = false;
  bool isLoadingMore = false;
  List<Content> todayNotification = [];
  List<Content> earlierNotification = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getNotification();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter < 200) {
        // User has reached the end of the list
        if (!isLoadingMore && !isLastPage) {
          debugPrint('testing......');
          getNotification();
        }
      }
    });
  }

  void getNotification() async {
    try {
      var resp =
          await Provider.of<NotificationViewModel>(context, listen: false)
              .getAllNotificationList(
                  context: context,
                  userId: widget.userId,
                  pageNumber: currentPage,
                  pageSize: pageSize,
                  readStatus: 'all');
      var content = resp?.data?.content ?? [];
      List<Content> today = [];
      List<Content> earlier = [];

      DateTime todayStart = DateTime.now();
      for (var notification in content) {
        // Convert notification date
        DateTime notificationDate = DateTime.fromMillisecondsSinceEpoch(
            (notification.createdDate ?? 0),
            isUtc: false);

        if (notificationDate.day == todayStart.day &&
            notificationDate.month == todayStart.month &&
            notificationDate.year == todayStart.year) {
          today.add(notification);
        } else {
          earlier.add(notification);
        }
      }

      setState(() {
        if (content.isNotEmpty) {
          todayNotification.addAll(today);
          earlierNotification.addAll(earlier);
          debugPrint('today.....................///////$todayNotification');
          currentPage++;
          isLastPage = content.length < pageSize; // Set isLastPage correctly
          debugPrint("Current page: $currentPage, Last page: $isLastPage");
        } else {
          isLastPage = true;
        }
      });
    } catch (e) {
      debugPrint('error$e');
    } finally {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        heading: "Notification",
      ),
      body: PageLayout_Page(child:
          Consumer<NotificationViewModel>(builder: (context, value, snapshot) {
        return value.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: greenColor,
                ),
              )
            : SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (todayNotification.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Today', style: titleTextStyle),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: todayNotification.length,
                            itemBuilder: (context, index) {
                              return NotificationContainer(
                                title: todayNotification[index].title ?? '',
                                subTitle:
                                    todayNotification[index].message ?? '',
                                time: todayNotification[index].createdDate ?? 0,
                              );
                            },
                          ),
                        ],
                      ),
                    if (earlierNotification.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Earlier', style: titleTextStyle),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: earlierNotification.length,
                            itemBuilder: (context, index) {
                              return NotificationContainer(
                                title: earlierNotification[index].title ?? '',
                                subTitle:
                                    earlierNotification[index].message ?? '',
                                time:
                                    earlierNotification[index].createdDate ?? 0,
                              );
                            },
                          ),
                        ],
                      ),
                    (todayNotification.isEmpty && earlierNotification.isEmpty)
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'No Notification Available',
                                style: TextStyle(
                                    color: redColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              );
      })),
    );
  }
}

class NotificationContainer extends StatelessWidget {
  final String title;
  final String subTitle;
  final int time;
  const NotificationContainer(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        elevation: 5,
        color: background,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {},
          child: ListTile(
            dense: true,
            minLeadingWidth: 30,
            horizontalTitleGap: 10,
            contentPadding: const EdgeInsets.symmetric(horizontal: 5),
            leading: const Stack(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircleAvatar(
                    child: Icon(
                      Icons.notifications_none_outlined,
                      color: btnColor,
                      size: 30,
                    ),
                  ),
                ),
                Positioned(
                    top: 0,
                    left: 10,
                    child: SizedBox(
                      width: 15,
                      height: 15,
                      child: CircleAvatar(
                        backgroundColor: btnColor,
                      ),
                    ))
              ],
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.lato(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  // overflow: TextOverflow.ellipsis,
                ),
                Text(
                  formatTimeAgo(time),
                  style: GoogleFonts.lato(
                      color: blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            subtitle: Text(
              subTitle,
              style: GoogleFonts.lato(
                  color: greyColor, fontSize: 12, fontWeight: FontWeight.w600),
              // overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  String formatTimeAgo(int dateTime) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(
      dateTime,
    );
    debugPrint('timeeee$date');
    Duration difference = DateTime.now().difference(date);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} sec${difference.inSeconds > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min${difference.inMinutes > 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else {
      return '${(difference.inDays / 7).floor()} week${(difference.inDays / 7).floor() > 1 ? 's' : ''} ago';
    }
  }
}
