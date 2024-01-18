import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_media_services/API/endpoint.dart';
import 'package:social_media_services/API/get_chat_list.dart';
import 'package:social_media_services/components/assets_manager.dart';
import 'package:social_media_services/components/color_manager.dart';
import 'package:social_media_services/components/routes_manager.dart';
import 'package:social_media_services/components/styles_manager.dart';
import 'package:social_media_services/loading%20screens/chat_loading_screen.dart';
import 'package:social_media_services/providers/data_provider.dart';
import 'package:social_media_services/providers/servicer_provider.dart';
import 'package:social_media_services/responsive/responsive_width.dart';
import 'package:social_media_services/screens/home_page.dart';
import 'package:social_media_services/widgets/chat/chat_list_tile.dart';
import 'package:social_media_services/widgets/custom_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/backbutton.dart';

class MessagePage extends StatefulWidget {
  final bool isHome;
  final bool isOther;
  //  isother making true in initial case may cause some errors want to test it
  const MessagePage({Key? key, this.isHome = true, this.isOther = false})
      : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  String lang = '';
  late Timer timer;
  String? time;
  String? apiToken;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    apiToken = Hive.box("token").get('api_token');

    lang = Hive.box('LocalLan').get(
      'lang',
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (apiToken == null) {
        Navigator.pushReplacementNamed(context, Routes.phoneNumber);
        return;
      }
      getChatList(
        context,
      );
      timer = Timer.periodic(const Duration(seconds: 30), (timer) {
        if (mounted) {
          getChatList(
            context,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    log("Dispose");
  }

  Future<bool> handleBackButton() async {
    if (_scaffoldKey.currentState!.isEndDrawerOpen) {
      // If the drawer is open, close it
      _scaffoldKey.currentState!.closeEndDrawer();
      return false; // Do not exit the app
    } else {
      // If the drawer is not open, exit the app
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) {
        return const HomePage(
          selectedIndex: 0,
        );
      }));

      return true;
    }
  }

  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<DataProvider>(context, listen: true);
    final servicerProvider =
        Provider.of<ServicerProvider>(context, listen: true);
    final w = MediaQuery.of(context).size.width;
    final mobWth = ResponsiveWidth.isMobile(context);
    final smobWth = ResponsiveWidth.issMobile(context);
    final str = AppLocalizations.of(context)!;

    return WillPopScope(
      onWillPop: () async {
        return handleBackButton();
      },
      child: apiToken == null
          ? Scaffold()
          : Scaffold(
              key: _scaffoldKey,
              appBar: PreferredSize(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      children: [
                        BackButton1(),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                              backgroundColor: Color(0xff08dc2c),
                              child: Image.asset(
                                'assets/logo/app-logo-T.jpg',
                                height: 30,
                                width: 30,
                              )),
                        )
                      ],
                    ),
                  ),
                  preferredSize: Size(100, 150)),
              drawerEnableOpenDragGesture: false,
              endDrawer: SizedBox(
                height: size.height * 0.825,
                width: mobWth
                    ? size.width * 0.6
                    : smobWth
                        ? w * .7
                        : w * .75,
                child: const CustomDrawer(),
              ),
              bottomNavigationBar: widget.isHome
                  ? null
                  : Stack(
                      children: [
                        Container(
                          height: 45,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              blurRadius: 5.0,
                              color: Colors.grey.shade400,
                              offset: const Offset(6, 1),
                            ),
                          ]),
                        ),
                        SizedBox(
                          height: 44,
                          child: GNav(
                            tabMargin: const EdgeInsets.symmetric(
                              vertical: 0,
                            ),
                            gap: 0,
                            backgroundColor: ColorManager.whiteColor,
                            mainAxisAlignment: MainAxisAlignment.center,
                            activeColor: ColorManager.grayDark,
                            iconSize: 24,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            duration: const Duration(milliseconds: 400),
                            tabBackgroundColor:
                                ColorManager.primary.withOpacity(0.4),
                            color: ColorManager.black,
                            tabs: [
                              GButton(
                                icon: FontAwesomeIcons.message,
                                leading: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      SvgPicture.asset(ImageAssets.homeIconSvg),
                                ),
                              ),
                              GButton(
                                icon: FontAwesomeIcons.message,
                                leading: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      SvgPicture.asset(ImageAssets.chatIconSvg),
                                ),
                              ),
                            ],
                            haptic: true,
                            selectedIndex: _selectedIndex,
                            onTabChange: (index) {
                              widget.isOther
                                  ? Navigator.push(context,
                                      MaterialPageRoute(builder: (ctx) {
                                      return HomePage(
                                        selectedIndex: index,
                                      );
                                    }))
                                  : null;

                              // if (mounted) {
                              //   Navigator.pushNamedAndRemoveUntil(
                              //       context, Routes.homePage, (route) => false);
                              // }

                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                          ),
                        ),
                        Positioned(
                            left: lang == 'ar' ? 5 : null,
                            right: lang != 'ar' ? 5 : null,
                            bottom: 0,
                            child: Builder(
                              builder: (context) => InkWell(
                                onTap: () {
                                  Scaffold.of(context).openEndDrawer();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.menu,
                                    size: 25,
                                    color: ColorManager.black,
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              str.mh_message,
                              style: getBoldtStyle(
                                  color: ColorManager.black, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                        child: Text(
                          str.mh_recents,
                          style: getSemiBoldtStyle(
                              color: ColorManager.black, fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                            itemCount: provider
                                .chatListDetails?.chatMessage?.data?.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final profileDetails = provider
                                  .chatListDetails?.chatMessage?.data?[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.shade300,
                                                spreadRadius: 1,
                                                blurRadius: 3,
                                                offset: const Offset(4, 4.5),
                                              ),
                                            ],
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              navToChatLoadingScreen(index);
                                            },
                                            child: CircleAvatar(
                                              backgroundColor: ColorManager
                                                  .whiteColor
                                                  .withOpacity(0.8),
                                              radius: 25,
                                              backgroundImage: profileDetails
                                                          ?.profilePic ==
                                                      null
                                                  ? const AssetImage(
                                                          'assets/user.png')
                                                      as ImageProvider
                                                  : CachedNetworkImageProvider(
                                                      '$endPoint${profileDetails?.profilePic}'),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 5,
                                          left: 1,
                                          // left: size.width * .0,
                                          child: CircleAvatar(
                                            radius: 5,
                                            backgroundColor: profileDetails
                                                        ?.onlineStatus ==
                                                    'online'
                                                ? ColorManager.primary
                                                : profileDetails
                                                            ?.onlineStatus ==
                                                        'offline'
                                                    ? ColorManager.grayLight
                                                    : ColorManager.errorRed,
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(profileDetails?.firstname ??
                                        profileDetails?.phone ??
                                        ''),
                                  ],
                                ),
                              );
                            }),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: ((context, index) {
                          final profileDetails = provider
                              .chatListDetails?.chatMessage?.data?[index];

                          // var dtime = DateFormat("HH:mm").parse(
                          //     profileDetails?.createdAt?.substring(11, 16) ??
                          //         '',
                          //     true);

                          // var date = DateFormat("yyyy-MM-dd").parse(
                          //     profileDetails?.createdAt?.substring(0, 10) ?? '',
                          //     true);
                          // String localDate =
                          //     DateFormat.yMd('es').format(date.toLocal());

                          // var hour = dtime.toLocal().hour;
                          // var minute = dtime.toLocal().minute;

                          // var day = date.toLocal().weekday;
                          // if (DateTime.now().weekday == day) {
                          //   String time24 = "$hour:$minute";
                          //   time = DateFormat.jm('en_US')
                          //       .format(DateFormat("hh:mm").parse(time24));
                          // } else if (day == DateTime.now().weekday - 1) {
                          //   time = "Yesterday";
                          // } else {
                          //   time = DateFormat.jm('en_US')
                          //       .format(DateTime.parse(localDate.toString()));
                          // }

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: InkWell(
                              onTap: () {
                                navToChatLoadingScreen(index);
                              },
                              child: ChatListTile(
                                  profileData: profileDetails,
                                  time: _formatTime(profileDetails?.createdAt)),
                            ),
                          );
                        }),
                        itemCount:
                            provider.chatListDetails?.chatMessage?.data?.length,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  navToChatLoadingScreen(index) {
    final servicerProvider =
        Provider.of<ServicerProvider>(context, listen: false);
    final provider = Provider.of<DataProvider>(context, listen: false);
    final serviceManId =
        provider.chatListDetails?.chatMessage?.data?[index].servicemanId;
    servicerProvider.servicerId = serviceManId;
    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
      return ChatLoadingScreen(
        serviceManId: serviceManId.toString(),
      );
    }));
  }

  String _formatTime(String? createdAt) {
    if (createdAt == null) return '';
    final str = AppLocalizations.of(context)!;
    var dtime = DateFormat("HH:mm").parse(createdAt.substring(11, 16), true);
    var date = DateFormat("yyyy-MM-dd").parse(createdAt.substring(0, 10), true);

    // Assuming the server provides time in UTC, convert it to local time
    var utc =
        DateTime.utc(date.year, date.month, date.day, dtime.hour, dtime.minute);
    var localTime = utc.toLocal();

    var hour = localTime.hour;
    var minute = localTime.minute;
    var locale = lang == 'ar'
        ? 'ar'
        : lang == 'hi'
            ? 'hi'
            : 'en_us';
    var day = localTime.weekday;

    String formattedTime = '';
    if (DateTime.now().weekday == day) {
      formattedTime = DateFormat.jm(locale).format(localTime);
    } else if (day == DateTime.now().weekday - 1) {
      formattedTime = str.yesterday;
    } else {
      formattedTime = DateFormat.jm(locale).format(localTime);
    }

    // Check for Arabic language
    // if (lang == 'ar') {
    //   // Use the intl package for Arabic localization
    //   var format = DateFormat.jm('ar');
    //   formattedTime = format.format(localTime);
    // } else if (lang == 'hi') {
    //   var format = DateFormat.jm('hi');
    //   formattedTime = format.format(localTime);
    // }

    return formattedTime;
  }
}
