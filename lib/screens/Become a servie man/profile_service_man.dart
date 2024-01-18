import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media_services/API/becomeServiceMan/customerParent.dart';
import 'package:social_media_services/API/endpoint.dart';
import 'package:social_media_services/API/get_region_info.dart';
import 'package:social_media_services/API/viewProfile.dart';
import 'package:social_media_services/animations/animtions.dart';
import 'package:social_media_services/components/assets_manager.dart';
import 'package:social_media_services/components/color_manager.dart';
import 'package:social_media_services/components/styles_manager.dart';
import 'package:social_media_services/controllers/controllers.dart';
import 'package:social_media_services/model/get_countries.dart';
import 'package:social_media_services/model/region_info_model.dart';
import 'package:social_media_services/model/state_info_model.dart';
import 'package:social_media_services/model/updateProfile.dart';
import 'package:social_media_services/providers/data_provider.dart';
import 'package:social_media_services/responsive/responsive.dart';
import 'package:social_media_services/responsive/responsive_width.dart';
import 'package:social_media_services/screens/Become%20a%20servie%20man/choose_service_page.dart';
import 'package:social_media_services/screens/home_page.dart';
import 'package:social_media_services/screens/messagePage.dart';
import 'package:social_media_services/screens/my_services.dart';
import 'package:social_media_services/screens/serviceHome.dart';
import 'package:social_media_services/utils/animatedSnackBar.dart';
import 'package:social_media_services/widgets/backbutton.dart';
import 'package:social_media_services/widgets/customRadioButton.dart';
import 'package:social_media_services/widgets/custom_drawer.dart';
import 'package:social_media_services/widgets/custom_stepper.dart';
import 'package:social_media_services/widgets/custom_text_field.dart';
import 'package:social_media_services/widgets/mandatory_widget.dart';
import 'package:social_media_services/widgets/title_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:social_media_services/widgets/top_logo.dart';

import 'choose_more_services_page.dart';

class ProfileServicePage extends StatefulWidget {
  final Userdetails? userAddress;
  bool? isservicepage;
  var index;
  ProfileServicePage(
      {Key? key, this.userAddress, this.isservicepage, this.index})
      : super(key: key);

  @override
  State<ProfileServicePage> createState() => _ProfileServicePageState();
}

class _ProfileServicePageState extends State<ProfileServicePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? defvalue;
  String? selectedValue;
  String? defaultReg;
  int? Regid;
  int? countryid;
  String? defRegion;
  bool isTickSelected = false;
  bool isregister = false;
  DateTime selectedDate = DateTime.now();
  bool value = true;
  final int _selectedIndex = 2;
  final List<Widget> _screens = [const ServiceHomePage(), const MessagePage()];
  String lang = '';
  List<Countries> r2 = [];
  FocusNode nfocus = FocusNode();
  List<Countries> r = [];
  List<Regions> reg = [];
  Future<bool> handleBackButton() async {
    if (_scaffoldKey.currentState!.isEndDrawerOpen) {
      // If the drawer is open, close it
      _scaffoldKey.currentState!.closeEndDrawer();
      return false; // Do not exit the app
    } else {
      widget.isservicepage == true
          ? Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (ctx) {
              return const MyServicesPage();
            }))
          : Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (ctx) {
              return const HomePage(
                selectedIndex: 0,
              );
            }));
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    lang = Hive.box('LocalLan').get(
      'lang',
    );
    countryid = 165;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // print(timeStamp);
      final provider = Provider.of<DataProvider>(context, listen: false);
      viewProfile(context);
      fillFields(provider);
      print(
          "city=============================${provider.viewProfileModel?.userdetails?.city}");
      print(
          "state=============================${provider.viewProfileModel?.userdetails?.statename}");

      int? n = provider.countriesModel?.countries?.length;
      int i = 0;

      while (i < n!.toInt()) {
        r2.add(provider.countriesModel!.countries![i]);
        i++;
      }

      provider.clearRegions();
      provider.clearStates();

      await getRegionData(
          context, provider.viewProfileModel?.userdetails?.countryId);
      await getStateData(
          context, provider.viewProfileModel?.userdetails?.region);

      setState(() {});

      getCustomerParent(context);
    });
  }

  // Future<bool> _willPopCallback() async {

  //   return true; // return true if the route to be popped
  // }

  @override
  Widget build(BuildContext context) {
    final str = AppLocalizations.of(context)!;
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final mob = Responsive.isMobile(context);
    final provider = Provider.of<DataProvider>(context, listen: true);
    final homeData = provider.homeModel?.services;
    final mobWth = ResponsiveWidth.isMobile(context);
    final smobWth = ResponsiveWidth.issMobile(context);
    return WillPopScope(
      onWillPop: handleBackButton,
      child: Scaffold(
        key: _scaffoldKey,
        drawerEnableOpenDragGesture: false,
        endDrawer: SizedBox(
          height: h * 0.825,
          width: mobWth
              ? w * 0.6
              : smobWth
                  ? w * .7
                  : w * .75,
          child: const CustomDrawer(),
        ),
        // * Custom bottom Nav
        bottomNavigationBar: Stack(
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
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: ColorManager.primary.withOpacity(0.4),
                color: ColorManager.black,
                tabs: [
                  GButton(
                    icon: FontAwesomeIcons.message,
                    leading: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: const HomePage(
                                selectedIndex: 0,
                              ),
                            ));
                      },
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: SvgPicture.asset(ImageAssets.homeIconSvg),
                      ),
                    ),
                  ),
                  GButton(
                    icon: FontAwesomeIcons.message,
                    leading: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: const HomePage(
                                selectedIndex: 1,
                              ),
                            ));
                      },
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: SvgPicture.asset(ImageAssets.chatIconSvg),
                      ),
                    ),
                  ),
                ],
                haptic: true,
                selectedIndex: _selectedIndex,
                // onTabChange: (index) {
                //   Navigator.pushNamedAndRemoveUntil(
                //       context, Routes.homePage, (route) => false);
                //   // setState(() {
                //   //   _selectedIndex = index;
                //   // });
                // },
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
        body: _selectedIndex != 2
            ? _screens[_selectedIndex]
            : WillPopScope(
                onWillPop: () async {
                  return handleBackButton();
                },
                child: SafeArea(
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          BackButton2(),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TopLogo(),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          const FadeCustomAnimation(
                              delay: .1, child: CustomStepper(num: 1)),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FadeSlideCustomAnimation(
                                        delay: .1,
                                        child: MandatoryHeader(
                                            heading: str.p_first_name)),
                                    FadeSlideCustomAnimation(
                                      delay: .15,
                                      child: CustomTextField(
                                          hintText: str.p_first_name_h,
                                          controller: ProfileServiceControllers
                                              .firstNameController),
                                    ),
                                    FadeSlideCustomAnimation(
                                      delay: .2,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 0),
                                        child:
                                            TitleWidget(name: str.p_last_name),
                                      ),
                                    ),
                                    FadeSlideCustomAnimation(
                                      delay: .25,
                                      child: CustomTextField(
                                          hintText: str.p_last_name_h,
                                          controller: ProfileServiceControllers
                                              .lastNameController),
                                    ),
                                    FadeSlideCustomAnimation(
                                        delay: .3,
                                        child: MandatoryHeader(
                                            heading: str.p_civil)),
                                    FadeSlideCustomAnimation(
                                      delay: .35,
                                      child: CustomTextField(
                                          hintText: str.p_civil_h,
                                          controller: ProfileServiceControllers
                                              .civilCardController,
                                          type: TextInputType.number),
                                    ),
                                    FadeSlideCustomAnimation(
                                      delay: .4,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 10, 0, 0),
                                                child: TitleWidget(
                                                    name: str.p_dob),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 10, 0, 0),
                                                child: Container(
                                                  width:
                                                      mob ? w * 0.5 : w * .45,
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 10.0,
                                                        color: Colors
                                                            .grey.shade300,
                                                        // offset: const Offset(5, 8.5),
                                                      ),
                                                    ],
                                                  ),
                                                  child: TextField(
                                                    style: const TextStyle(),
                                                    readOnly: true,
                                                    controller:
                                                        ProfileServiceControllers
                                                            .dateController,
                                                    decoration: InputDecoration(
                                                        suffixIcon: InkWell(
                                                          onTap: () =>
                                                              _selectDate(
                                                                  context),
                                                          child: const Icon(
                                                            Icons
                                                                .calendar_month,
                                                            color: ColorManager
                                                                .primary,
                                                          ),
                                                        ),
                                                        hintText: str.p_dob_h,
                                                        hintStyle: getRegularStyle(
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                173,
                                                                173,
                                                                173),
                                                            fontSize: 14)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            // mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 10, 0, 0),
                                                child: TitleWidget(
                                                    name: str.p_gender),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 15, 0, 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        provider.gender =
                                                            'male';
                                                        setState(() {
                                                          value = true;
                                                        });
                                                      },
                                                      child:
                                                          CustomizedRadioButton(
                                                        gender: "MALE",
                                                        isMaleSelected: value,
                                                      ),
                                                    ),
                                                    TitleWidget(
                                                        name: str.p_male),
                                                    InkWell(
                                                      onTap: () {
                                                        provider.gender =
                                                            'female';
                                                        print(provider.gender);
                                                        setState(() {
                                                          value = false;
                                                        });
                                                      },
                                                      child:
                                                          CustomizedRadioButton(
                                                        gender: "FEMALE",
                                                        isMaleSelected: value,
                                                      ),
                                                    ),
                                                    TitleWidget(
                                                        name: str.p_female),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    FadeSlideCustomAnimation(
                                      delay: .5,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 0),
                                        child: Row(
                                          children: [
                                            TitleWidget(name: str.p_country),
                                            const Icon(
                                              Icons.star_outlined,
                                              size: 10,
                                              color: ColorManager.errorRed,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    FadeSlideCustomAnimation(
                                      delay: .55,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 10.0,
                                                color: Colors.grey.shade300,
                                                // offset: const Offset(5, 8.5),
                                              ),
                                            ],
                                          ),
                                          child: Container(
                                            width: w,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: ColorManager.whiteColor,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 10, 0, 10),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton2<
                                                        Countries>(
                                                    isExpanded: true,
                                                    icon: const Icon(
                                                      Icons.keyboard_arrow_down,
                                                      size: 35,
                                                      color: ColorManager.black,
                                                    ),
                                                    hint: Text(str.ae_country_h,
                                                        style: getRegularStyle(
                                                            color: const Color.fromARGB(
                                                                255, 173, 173, 173),
                                                            fontSize: 15)),
                                                    items: r2
                                                        .map(
                                                            (item) => DropdownMenuItem<
                                                                    Countries>(
                                                                  value: item,
                                                                  child: Row(
                                                                    children: [
                                                                      CachedNetworkImage(
                                                                          errorWidget: (context, url, error) =>
                                                                              Container(
                                                                                width: 25,
                                                                                height: 20,
                                                                                color: ColorManager.whiteColor,
                                                                              ),
                                                                          imageBuilder: (context, imageProvider) =>
                                                                              Container(
                                                                                width: 25,
                                                                                height: 20,
                                                                                decoration: BoxDecoration(
                                                                                  // shape: BoxShape.circle,
                                                                                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                                                ),
                                                                              ),
                                                                          // width: 90,
                                                                          progressIndicatorBuilder: (context,
                                                                              url,
                                                                              progress) {
                                                                            return Container(
                                                                              color: ColorManager.black,
                                                                            );
                                                                          },
                                                                          imageUrl:
                                                                              '$endPoint${item.countryflag}'),
                                                                      const SizedBox(
                                                                        width:
                                                                            4,
                                                                      ),
                                                                      Text(
                                                                          item.countryName ??
                                                                              '',
                                                                          style: getRegularStyle(
                                                                              color: ColorManager.black,
                                                                              fontSize: 15)),
                                                                    ],
                                                                  ),
                                                                ))
                                                        .toList(),
                                                    // value: selectedValue,
                                                    onChanged: (value) async {
                                                      setState(() {
                                                        selectedValue = value
                                                                ?.countryName ??
                                                            '';
                                                      });
                                                      defaultReg = null;
                                                      await getRegionData(
                                                        context,
                                                        value?.countryId,
                                                      );
                                                      provider.clearStates();
                                                      defRegion = null;

                                                      setState(() {});
                                                      // provider.selectedAddressCountry =
                                                      //     value as Countries;
                                                    },
                                                    buttonHeight: 40,
                                                    dropdownMaxHeight: h * .6,
                                                    // buttonWidth: 140,
                                                    itemHeight: 40,
                                                    buttonPadding:
                                                        const EdgeInsets.fromLTRB(
                                                            12, 0, 8, 0),
                                                    // dropdownWidth: size.width,
                                                    itemPadding: const EdgeInsets.fromLTRB(
                                                        12, 0, 12, 0),
                                                    searchController:
                                                        AddressEditControllers
                                                            .searchController,
                                                    searchInnerWidget: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 8,
                                                        bottom: 4,
                                                        right: 8,
                                                        left: 8,
                                                      ),
                                                      child: TextFormField(
                                                        controller:
                                                            AddressEditControllers
                                                                .searchController,
                                                        decoration:
                                                            InputDecoration(
                                                          isDense: true,
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 10,
                                                            vertical: 8,
                                                          ),
                                                          hintText: str
                                                              .s_search_country,
                                                          hintStyle:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    customButton:
                                                        selectedValue == null
                                                            ? null
                                                            : Row(
                                                                children: [
                                                                  Center(
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.fromLTRB(
                                                                              10,
                                                                              0,
                                                                              10,
                                                                              0),
                                                                      child: Text(
                                                                          selectedValue ??
                                                                              ''),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                    searchMatchFn:
                                                        (item, searchValue) {
                                                      return (item
                                                          .value.countryName
                                                          .toString()
                                                          .toLowerCase()
                                                          .contains(
                                                              searchValue));
                                                    },
                                                    //This to clear the search value when you close the menu
                                                    onMenuStateChange: (isOpen) {
                                                      if (!isOpen) {
                                                        AddressEditControllers
                                                            .searchController
                                                            .clear();
                                                      }
                                                    }),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // * Region
                                    FadeSlideCustomAnimation(
                                      delay: .6,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              MandatoryHeader(
                                                  heading: str.p_region),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 10, 0, 0),
                                                child: Container(
                                                  width: w * .44,
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 10.0,
                                                        color: Colors
                                                            .grey.shade300,
                                                        // offset: const Offset(5, 8.5),
                                                      ),
                                                    ],
                                                    color:
                                                        ColorManager.whiteColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child: DropdownButton2<
                                                        Regions>(
                                                      isExpanded: true,
                                                      focusNode: nfocus,
                                                      icon: const Icon(
                                                        Icons
                                                            .keyboard_arrow_down,
                                                        size: 35,
                                                        color:
                                                            ColorManager.black,
                                                      ),
                                                      hint: provider.regionInfoModel
                                                                      ?.result ==
                                                                  false ||
                                                              provider.regionInfoModel
                                                                      ?.result ==
                                                                  null
                                                          ? Text(str.no_ava,
                                                              style: getRegularStyle(
                                                                  color:
                                                                      const Color.fromARGB(
                                                                          255,
                                                                          173,
                                                                          173,
                                                                          173),
                                                                  fontSize: 15))
                                                          : Text(str.p_region_h,
                                                              style: getRegularStyle(
                                                                  color: const Color.fromARGB(255, 173, 173, 173),
                                                                  fontSize: 15)),
                                                      items: provider
                                                          .regionInfoModel
                                                          ?.regions!
                                                          .map((item) =>
                                                              DropdownMenuItem<
                                                                  Regions>(
                                                                value: item,
                                                                child: Text(
                                                                    item.cityName ??
                                                                        '',
                                                                    style: getRegularStyle(
                                                                        color: ColorManager
                                                                            .black,
                                                                        fontSize:
                                                                            15)),
                                                              ))
                                                          .toList(),
                                                      // value: defaultReg,
                                                      onChanged: (value) async {
                                                        setState(() {
                                                          defaultReg =
                                                              value?.cityName;
                                                          Regid = value?.id;
                                                        });
                                                        ProfileServiceControllers
                                                                .regionController
                                                                .text =
                                                            defaultReg ?? '';
                                                        // s(selectedValue);
                                                        provider.clearStates();

                                                        defRegion = null;

                                                        await getStateData(
                                                            context, Regid);
                                                        setState(() {});
                                                      },
                                                      buttonHeight: 50,
                                                      dropdownMaxHeight: h * .6,
                                                      // buttonWidth: 140,
                                                      itemHeight: 40,
                                                      buttonPadding:
                                                          const EdgeInsets
                                                                  .fromLTRB(
                                                              12, 0, 8, 0),
                                                      // dropdownWidth: size.width,
                                                      itemPadding:
                                                          const EdgeInsets
                                                                  .fromLTRB(
                                                              12, 0, 12, 0),

                                                      customButton:
                                                          defaultReg == null
                                                              ? null
                                                              : Row(
                                                                  children: [
                                                                    Center(
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets.fromLTRB(
                                                                            10,
                                                                            15,
                                                                            10,
                                                                            15),
                                                                        child: Text(defaultReg ??
                                                                            ''),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                      //This to clear the search value when you close the menu
                                                      // onMenuStateChange: (isOpen) {
                                                      //   if (!isOpen) {
                                                      //     AddressEditControllers
                                                      //         .searchController
                                                      //         .clear();
                                                      //   }
                                                      // }
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              MandatoryHeader(
                                                  heading: str.p_city),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 10, 0, 0),
                                                child: Container(
                                                  width: w * .44,
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 10.0,
                                                        color: Colors
                                                            .grey.shade300,
                                                        // offset: const Offset(5, 8.5),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Container(
                                                    width: w * .44,
                                                    // height: mob ? 50 : 35,
                                                    decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 10.0,
                                                            color: Colors
                                                                .grey.shade300,
                                                            // offset: const Offset(5, 8.5),
                                                          ),
                                                        ],
                                                        color: ColorManager
                                                            .whiteColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    child:
                                                        DropdownButtonHideUnderline(
                                                      child: DropdownButton2<
                                                          States>(
                                                        isExpanded: true,
                                                        focusNode: nfocus,
                                                        icon: const Icon(
                                                          Icons
                                                              .keyboard_arrow_down,
                                                          size: 35,
                                                          color: ColorManager
                                                              .black,
                                                        ),
                                                        hint: provider.stateinfomodel
                                                                        ?.result ==
                                                                    false ||
                                                                provider.stateinfomodel
                                                                        ?.result ==
                                                                    null
                                                            ? Text(str.no_ava,
                                                                style: getRegularStyle(
                                                                    color: const Color.fromARGB(
                                                                        255,
                                                                        173,
                                                                        173,
                                                                        173),
                                                                    fontSize:
                                                                        15))
                                                            : Text(str.p_state_h,
                                                                style: getRegularStyle(
                                                                    color: const Color.fromARGB(255, 173, 173, 173),
                                                                    fontSize: 15)),
                                                        items: provider
                                                            .stateinfomodel
                                                            ?.states!
                                                            .map((item) =>
                                                                DropdownMenuItem<
                                                                    States>(
                                                                  value: item,
                                                                  child: Text(
                                                                      item.stateName ??
                                                                          '',
                                                                      style: getRegularStyle(
                                                                          color: ColorManager
                                                                              .black,
                                                                          fontSize:
                                                                              15)),
                                                                ))
                                                            .toList(),
                                                        // value: defRegion,
                                                        onChanged: (value) {
                                                          print(provider
                                                              .stateinfomodel
                                                              ?.result);
                                                          setState(() {
                                                            defRegion =
                                                                value?.stateName
                                                                    as String;
                                                          });
                                                          ProfileServiceControllers
                                                                  .stateController
                                                                  .text =
                                                              defRegion ?? '';
                                                          // s(selectedValue);
                                                        },
                                                        buttonHeight: 50,
                                                        dropdownMaxHeight:
                                                            h * .6,
                                                        // buttonWidth: 140,
                                                        itemHeight: 40,
                                                        buttonPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                12, 0, 8, 0),
                                                        // dropdownWidth: size.width,
                                                        itemPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                12, 0, 12, 0),

                                                        customButton:
                                                            defRegion == null
                                                                ? null
                                                                : Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.fromLTRB(
                                                                            10,
                                                                            15,
                                                                            10,
                                                                            15),
                                                                        child: Text(defRegion ??
                                                                            ''),
                                                                      ),
                                                                    ],
                                                                  ),
                                                        //This to clear the search value when you close the menu
                                                        // onMenuStateChange: (isOpen) {
                                                        //   if (!isOpen) {
                                                        //     AddressEditControllers
                                                        //         .searchController
                                                        //         .clear();
                                                        //   }
                                                        // }
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    FadeSlideCustomAnimation(
                                      delay: .7,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 0),
                                        child: TitleWidget(name: str.p_address),
                                      ),
                                    ),
                                    FadeSlideCustomAnimation(
                                      delay: .75,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 15),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 10.0,
                                                color: Colors.grey.shade300,
                                                // offset: const Offset(5, 8.5),
                                              ),
                                            ],
                                          ),
                                          child: SizedBox(
                                            child: TextField(
                                              minLines: 4,
                                              maxLines: 5,
                                              style: const TextStyle(),
                                              controller:
                                                  ProfileServiceControllers
                                                      .addressController,
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          top: 10),
                                                  hintText: str.p_address_h,
                                                  hintStyle: getRegularStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              173,
                                                              173,
                                                              173),
                                                      fontSize: 15)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        28, 0, 28, 0)),
                                            onPressed: onContinue,
                                            child: Text(str.p_continue,
                                                style: getRegularStyle(
                                                    color:
                                                        ColorManager.whiteText,
                                                    fontSize: 16))),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
                colorScheme:
                    const ColorScheme.light(primary: ColorManager.primary)),
            child: child!,
          );
        },
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        ProfileServiceControllers.dateController.text =
            selectedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  onContinue() {
    final provider = Provider.of<DataProvider>(context, listen: false);
    final homeData = provider.homeModel?.services;
    final str = AppLocalizations.of(context)!;
    print(ProfileServiceControllers.regionController.text);
    // FocusManager.instance.primaryFocus?.unfocus();
    if (ProfileServiceControllers.firstNameController.text.isEmpty) {
      showAnimatedSnackBar(context, str.e_snack_name);
    }
    //  else if (ProfileServiceControllers.lastNameController.text.isEmpty) {
    //   showAnimatedSnackBar(context, "Please Enter Your Last Name");
    // }
    else if (ProfileServiceControllers.civilCardController.text.isEmpty) {
      showAnimatedSnackBar(context, str.ps_snack_cvv);
    } else if (selectedValue == null) {
      showAnimatedSnackBar(context, str.a_country);
    } else if (ProfileServiceControllers.regionController.text.isEmpty) {
      showAnimatedSnackBar(context, str.a_region);
    } else if (ProfileServiceControllers.stateController.text.isEmpty) {
      showAnimatedSnackBar(context, str.a_state);
    }
    // else if (ProfileServiceControllers.addressController.text.isEmpty) {
    //   showAnimatedSnackBar(context, "Please Enter Your Address");
    // }
    else {
      widget.isservicepage == true
          ? Navigator.push(context, MaterialPageRoute(builder: (ctx) {
              return ChooseMoreServicePage(
                services: homeData?[widget.index],
              );
            }))
          : Navigator.push(context, MaterialPageRoute(builder: (ctx) {
              return ChooseServicePage(
                scaffoldKey: _scaffoldKey,
              );
            }));
    }
  }

  fillFields(DataProvider provider) {
    final fieldData = provider.viewProfileModel?.userdetails;
    ProfileServiceControllers.firstNameController.text =
        fieldData?.firstname ?? '';

    ProfileServiceControllers.lastNameController.text =
        fieldData?.lastname ?? '';
    ProfileServiceControllers.civilCardController.text =
        fieldData?.civilCardNo ?? '';

    ProfileServiceControllers.dateController.text = fieldData?.dob ?? '';
    selectedValue = fieldData?.countryName ?? 'oman';

    ProfileServiceControllers.stateController.text = fieldData?.statename ?? '';

    ProfileServiceControllers.regionController.text = fieldData?.city ?? '';
    countryid = 165;
    value = fieldData?.gender == 'female' ? false : true;
    defaultReg = fieldData?.city;
    defRegion = fieldData?.statename;
  }

  s(filter) {
    setState(() {
      r = [];
    });
    // print(filter);
    final provider = Provider.of<DataProvider>(context, listen: false);
    provider.countriesModel?.countries?.forEach((element) {
      final m = element.countryName?.contains(filter);

      if (m == true) {
        if (selectedValue != element.countryName) {
          return;
        }
        setState(() {
          // r = [];
          r.add(element);
        });
        print(r[0].countryId);
        print(r[0].countryName);
        provider.selectedCountryId = r[0].countryId;
      }
    });
  }
}
