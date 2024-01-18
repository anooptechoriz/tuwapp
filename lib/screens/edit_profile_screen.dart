import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_media_services/API/endpoint.dart';
import 'package:social_media_services/API/get_region_info.dart';
import 'package:social_media_services/components/assets_manager.dart';
import 'package:social_media_services/components/color_manager.dart';
import 'package:social_media_services/components/styles_manager.dart';
import 'package:social_media_services/controllers/controllers.dart';
import 'package:social_media_services/model/get_countries.dart';
import 'package:social_media_services/model/region_info_model.dart';
import 'package:social_media_services/model/state_info_model.dart';
import 'package:social_media_services/providers/data_provider.dart';
import 'package:social_media_services/providers/otp_provider.dart';
import 'package:social_media_services/responsive/responsive.dart';
import 'package:social_media_services/responsive/responsive_width.dart';
import 'package:social_media_services/screens/home_page.dart';
import 'package:social_media_services/screens/messagePage.dart';
import 'package:social_media_services/screens/profile_page.dart';
import 'package:social_media_services/screens/serviceHome.dart';
import 'package:social_media_services/utils/get_location.dart';
import 'package:social_media_services/API/viewProfile.dart';
import 'package:social_media_services/utils/animatedSnackBar.dart';
import 'package:social_media_services/widgets/customRadioButton.dart';
import 'package:social_media_services/widgets/custom_drawer.dart';
import 'package:social_media_services/widgets/profile_image.dart';
import 'package:social_media_services/widgets/title_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:social_media_services/widgets/backbutton.dart';

class EditProfileScreen extends StatefulWidget {
  bool isregister;
  EditProfileScreen({Key? key, this.isregister = true}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<EditProfileScreen> {
  DateTime selectedDate = DateTime.now();
  bool value = true;
  bool isPickerSelected = false;
  String? defaultReg;
  String? defRegion;
  String? defState;

  FocusNode nfocus = FocusNode();
  FocusNode dobfocus = FocusNode();

  int _selectedIndex = 2;

  String lang = '';
  int? regi;
  int? countryid;
  String? regid;
  String? stateid;
  String gender = 'male';
  Regions? regs;

  List<Countries> r = [];
  List<Regions> reg = [];

  String? selectedValue;
  List<String> r3 = [];
  final List<Widget> _screens = [const ServiceHomePage(), const MessagePage()];

  bool loading = false;

  @override
  void initState() {
    super.initState();
    lang = Hive.box('LocalLan').get(
      'lang',
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // print(timeStamp);
      final provider = Provider.of<DataProvider>(context, listen: false);
      final otpProvider = Provider.of<OTPProvider>(context, listen: false);
      int? n = provider.countriesModel?.countries?.length;
      print(
          "city=============================${provider.viewProfileModel?.userdetails?.countryId}");
      print(
          "state=============================${provider.viewProfileModel?.userdetails?.statename}");

      int i = 0;
      while (i < n!.toInt()) {
        r3.add(provider.countriesModel!.countries![i].countryName!);
        i++;
      }
      widget.isregister ? emptyFields() : fillFields(provider);
      viewProfile(context);
      print(widget.isregister);
      if (widget.isregister) {
        selectedValue = otpProvider.userCountryName;
        countryid = 165;
        await getRegionData(context, countryid);
        provider.clearStates();
        setState(() {});
      }

      provider.viewProfileModel?.userdetails?.latitude == null
          ? await requestLocationPermission(context)
          : null;
      // if (provider.viewProfileModel?.userdetails?.countryId == 165 &&
      //     provider.viewProfileModel?.userdetails?.region == null) {
      //   countryid = 165;
      //   EditProfileControllers.regionController.text = '';
      //   EditProfileControllers.stateController.text = '';
      //   selectedValue = await getRegionData(context, countryid);
      //   setState(() {});
      // }
      gender = provider.viewProfileModel?.userdetails?.gender ?? 'male';
      provider.clearRegions();
      provider.clearStates();

      await getRegionData(
          context, provider.viewProfileModel?.userdetails?.countryId);
      await getStateData(
          context, provider.viewProfileModel?.userdetails?.region);

      defState = provider.viewProfileModel?.userdetails?.statename;
      setState(() {});
      // getCustomerParent(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = MediaQuery.of(context).size.height;
    final str = AppLocalizations.of(context)!;
    final mob = Responsive.isMobile(context);
    final w = MediaQuery.of(context).size.width;
    final mobWth = ResponsiveWidth.isMobile(context);
    final smobWth = ResponsiveWidth.issMobile(context);
    final provider = Provider.of<DataProvider>(context, listen: true);

    return Scaffold(
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
                  leading: SizedBox(
                      width: 24,
                      height: 24,
                      child: SvgPicture.asset(ImageAssets.homeIconSvg)),
                ),
                GButton(
                  icon: FontAwesomeIcons.message,
                  leading: SizedBox(
                      width: 24,
                      height: 24,
                      child: SvgPicture.asset(ImageAssets.chatIconSvg)),
                ),
              ],
              haptic: true,
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
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

      body: _selectedIndex != 2
          ? _screens[_selectedIndex]
          : SafeArea(
              child: GestureDetector(
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          widget.isregister
                              ? Row(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(builder: (ctx) {
                                            return const HomePage();
                                          }));
                                        },
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          String.fromCharCode(Icons
                                              .arrow_back_ios_rounded
                                              .codePoint),
                                          style: TextStyle(
                                            inherit: false,
                                            color: ColorManager.primary,
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: Icons.search.fontFamily,
                                            package: Icons
                                                .arrow_back_ios_rounded
                                                .fontPackage,
                                          ),
                                        ))
                                  ],
                                )
                              : Row(
                                  children: [
                                    BackButton2(),
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
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: ProfileImage(
                                        // image: provider.viewProfileModel
                                        //         ?.userdetails?.profilePic ??
                                        //     '',
                                        isNavigationActive: false,
                                        iconSize: 12,
                                        profileSize: 40.5,
                                        iconRadius: 12,
                                      ),
                                    ),
                                  ],
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: TitleWidget(name: str.p_first_name),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                                    child: TextField(
                                      // focusNode: nfocus,
                                      style: const TextStyle(),
                                      controller: EditProfileControllers
                                          .firstNameController,
                                      decoration: InputDecoration(
                                          hintText: str.p_first_name_h,
                                          hintStyle: getRegularStyle(
                                              color: const Color.fromARGB(
                                                  255, 173, 173, 173),
                                              fontSize:
                                                  Responsive.isMobile(context)
                                                      ? 15
                                                      : 10)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: TitleWidget(name: str.p_last_name),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                                    child: TextField(
                                      // focusNode: nfocus,
                                      style: const TextStyle(),
                                      controller: EditProfileControllers
                                          .lastNameController,
                                      decoration: InputDecoration(
                                          hintText: str.p_last_name_h,
                                          hintStyle: getRegularStyle(
                                              color: const Color.fromARGB(
                                                  255, 173, 173, 173),
                                              fontSize:
                                                  Responsive.isMobile(context)
                                                      ? 15
                                                      : 10)),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 15, 0, 0),
                                          child: TitleWidget(name: str.e_dob),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 0),
                                          child: Container(
                                            width: mob
                                                ? size.width * 0.5
                                                : size.width * .45,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 10.0,
                                                  color: Colors.grey.shade300,
                                                  // offset: const Offset(5, 8.5),
                                                ),
                                              ],
                                            ),
                                            child: TextField(
                                              style: const TextStyle(),
                                              readOnly: true,
                                              controller: EditProfileControllers
                                                  .dateController,
                                              decoration: InputDecoration(
                                                  suffixIcon: InkWell(
                                                    onTap: () =>
                                                        _selectDate(context),
                                                    child: const Icon(
                                                      Icons.calendar_month,
                                                      color:
                                                          ColorManager.primary,
                                                    ),
                                                  ),
                                                  hintText: str.e_dob_h,
                                                  hintStyle: getRegularStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              173,
                                                              173,
                                                              173),
                                                      fontSize:
                                                          Responsive.isMobile(
                                                                  context)
                                                              ? 14
                                                              : 10)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 0, 0),
                                          child:
                                              TitleWidget(name: str.e_gender),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 15, 0, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    value = true;
                                                    gender = 'male';
                                                  });
                                                },
                                                child: CustomizedRadioButton(
                                                  gender: "MALE",
                                                  isMaleSelected: value,
                                                ),
                                              ),
                                              TitleWidget(name: str.e_male),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    value = false;
                                                    gender = 'female';
                                                  });
                                                },
                                                child: CustomizedRadioButton(
                                                  gender: "FEMALE",
                                                  isMaleSelected: value,
                                                ),
                                              ),
                                              TitleWidget(name: str.p_female),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child: TitleWidget(name: str.e_country),
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                                      width: size.width,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: ColorManager.whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 10),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton2(
                                              isExpanded: true,
                                              focusNode: nfocus,
                                              icon: const Icon(
                                                Icons.keyboard_arrow_down,
                                                size: 35,
                                                color: ColorManager.black,
                                              ),
                                              hint: Text(str.ae_country_h,
                                                  style: getRegularStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              173,
                                                              173,
                                                              173),
                                                      fontSize: 15)),
                                              items: r3
                                                  .map((item) =>
                                                      DropdownMenuItem<String>(
                                                        value: item,
                                                        child: Text(item,
                                                            style: getRegularStyle(
                                                                color:
                                                                    ColorManager
                                                                        .black,
                                                                fontSize: 15)),
                                                      ))
                                                  .toList(),
                                              value: selectedValue,
                                              onChanged: (value) async {
                                                setState(() {
                                                  selectedValue =
                                                      value as String;
                                                });

                                                await s(selectedValue);
                                                regid = null;
                                                stateid = null;

                                                // provider.clearRegions();
                                                provider.clearStates();

                                                await getRegionData(
                                                    context, countryid);
                                                // print(defaultReg);
                                                setState(() {
                                                  defaultReg = null;
                                                  defState = null;
                                                  stateid = null;
                                                });
                                              },
                                              buttonHeight: 40,
                                              dropdownMaxHeight: h * .6,
                                              // buttonWidth: 140,
                                              itemHeight: 40,
                                              buttonPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      12, 0, 8, 0),
                                              // dropdownWidth: size.width,
                                              itemPadding: const EdgeInsets
                                                  .fromLTRB(12, 0, 12, 0),
                                              searchController:
                                                  AddressEditControllers
                                                      .searchController,
                                              searchInnerWidget: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8,
                                                  bottom: 4,
                                                  right: 8,
                                                  left: 8,
                                                ),
                                                child: TextFormField(
                                                  controller:
                                                      AddressEditControllers
                                                          .searchController,
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                      horizontal: 10,
                                                      vertical: 8,
                                                    ),
                                                    hintText:
                                                        str.s_search_country,
                                                    hintStyle: const TextStyle(
                                                        fontSize: 12),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              searchMatchFn:
                                                  (item, searchValue) {
                                                return (item.value
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(searchValue));
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
                                // * Region
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 15, 0, 0),
                                          child:
                                              TitleWidget(name: str.p_region),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 0),
                                          child: Container(
                                            width: size.width * .45,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 10.0,
                                                  color: Colors.grey.shade300,
                                                  // offset: const Offset(5, 8.5),
                                                ),
                                              ],
                                              color: ColorManager.whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),

                                            // child: TextField(
                                            //   style: const TextStyle(),
                                            //   controller: EditProfileControllers
                                            //       .stateController,
                                            //   decoration: InputDecoration(
                                            //       hintText: str.p_region_h,
                                            //       hintStyle: getRegularStyle(
                                            //           color: const Color.fromARGB(
                                            //               255, 173, 173, 173),
                                            //           fontSize:
                                            //               Responsive.isMobile(context)
                                            //                   ? 15
                                            //                   : 10)),
                                            // ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton2<Regions>(
                                                isExpanded: true,
                                                focusNode: nfocus,
                                                icon: const Icon(
                                                  Icons.keyboard_arrow_down,
                                                  size: 35,
                                                  color: ColorManager.black,
                                                ),
                                                hint: provider.regionInfoModel?.result ==
                                                            false ||
                                                        provider.regionInfoModel
                                                                ?.result ==
                                                            null
                                                    ? Text(str.no_ava,
                                                        style: getRegularStyle(
                                                            color: const Color.fromARGB(
                                                                255, 173, 173, 173),
                                                            fontSize: 15))
                                                    : Text(str.p_region_h,
                                                        style: getRegularStyle(
                                                            color: const Color.fromARGB(
                                                                255, 173, 173, 173),
                                                            fontSize: 15)),
                                                items: provider
                                                    .regionInfoModel?.regions!
                                                    .map((item) =>
                                                        DropdownMenuItem<
                                                            Regions>(
                                                          value: item,
                                                          child: Text(
                                                              item.cityName ??
                                                                  '',
                                                              style: getRegularStyle(
                                                                  color:
                                                                      ColorManager
                                                                          .black,
                                                                  fontSize:
                                                                      15)),
                                                        ))
                                                    .toList(),
                                                // value: defaultReg,
                                                onChanged: (value) async {
                                                  setState(() {
                                                    defaultReg = value?.cityName
                                                        .toString();
                                                    regid =
                                                        value?.id.toString();
                                                  });
                                                  EditProfileControllers
                                                      .regionController
                                                      .text = defaultReg ?? '';
                                                  // s(selectedValue);
                                                  provider.clearStates();

                                                  defState = null;
                                                  stateid = null;
                                                  await getStateData(
                                                      context, regid);
                                                  setState(() {});
                                                },
                                                buttonHeight: 50,
                                                dropdownMaxHeight: h * .6,
                                                // buttonWidth: 140,
                                                itemHeight: 40,
                                                buttonPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        12, 0, 8, 0),
                                                // dropdownWidth: size.width,
                                                itemPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        12, 0, 12, 0),
                                                // searchController:
                                                //     AddressEditControllers
                                                //         .searchController,
                                                // searchInnerWidget: Padding(
                                                //   padding:
                                                //       const EdgeInsets.only(
                                                //     top: 8,
                                                //     bottom: 4,
                                                //     right: 8,
                                                //     left: 8,
                                                //   ),
                                                //   child: TextFormField(
                                                //     controller:
                                                //         AddressEditControllers
                                                //             .searchController,
                                                //     decoration: InputDecoration(
                                                //       isDense: true,
                                                //       contentPadding:
                                                //           const EdgeInsets
                                                //               .symmetric(
                                                //         horizontal: 10,
                                                //         vertical: 8,
                                                //       ),
                                                //       // TODO: localisation
                                                //       hintText:
                                                //           str.s_search_country,
                                                //       hintStyle:
                                                //           const TextStyle(
                                                //               fontSize: 12),
                                                //       border:
                                                //           OutlineInputBorder(
                                                //         borderRadius:
                                                //             BorderRadius
                                                //                 .circular(8),
                                                //       ),
                                                //     ),
                                                //   ),
                                                // ),
                                                // searchMatchFn:
                                                //     (item, searchValue) {
                                                //   return (item.value
                                                //       .toString()
                                                //       .toLowerCase()
                                                //       .contains(searchValue));
                                                // },
                                                customButton: defaultReg == null
                                                    ? null
                                                    : Row(
                                                        children: [
                                                          Center(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      10,
                                                                      15,
                                                                      10,
                                                                      15),
                                                              child: Text(
                                                                  defaultReg ??
                                                                      '',
                                                                  style: getRegularStyle(
                                                                      color: ColorManager
                                                                          .black,
                                                                      fontSize:
                                                                          12)),
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
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 15, 0, 0),
                                          child: TitleWidget(name: str.p_city),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 0),
                                          child: Container(
                                            width: size.width * .44,
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
                                              width: size.width * .44,
                                              // height: mob ? 50 : 35,
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 10.0,
                                                      color:
                                                          Colors.grey.shade300,
                                                      // offset: const Offset(5, 8.5),
                                                    ),
                                                  ],
                                                  color:
                                                      ColorManager.whiteColor,
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child:
                                                  // TextField(
                                                  //   // style: const TextStyle(),
                                                  //   controller:
                                                  //       ServiceControllers
                                                  //           .stateController,
                                                  //   decoration: InputDecoration(
                                                  //       hintText:
                                                  //           str.s_state,
                                                  //       hintStyle: getRegularStyle(
                                                  //           color: const Color
                                                  //                   .fromARGB(
                                                  //               255,
                                                  //               173,
                                                  //               173,
                                                  //               173),
                                                  //           fontSize: Responsive
                                                  //                   .isMobile(
                                                  //                       context)
                                                  //               ? 15
                                                  //               : 10)),
                                                  // ),
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton2<States>(
                                                  isExpanded: true,
                                                  // focusNode: nfocus,
                                                  icon: const Icon(
                                                    Icons.keyboard_arrow_down,
                                                    size: 35,
                                                    color: ColorManager.black,
                                                  ),
                                                  hint: provider.stateinfomodel
                                                                  ?.result ==
                                                              false ||
                                                          provider.stateinfomodel
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
                                                      : Text(str.p_state_h,
                                                          style: getRegularStyle(
                                                              color: const Color.fromARGB(255, 173, 173, 173),
                                                              fontSize: 15)),
                                                  items: provider
                                                      .stateinfomodel?.states!
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
                                                      defState = value
                                                          ?.stateName as String;
                                                      stateid =
                                                          value?.id.toString();
                                                    });
                                                    EditProfileControllers
                                                        .stateController
                                                        .text = defState ?? '';
                                                    // s(selectedValue);
                                                  },
                                                  buttonHeight: 50,
                                                  dropdownMaxHeight:
                                                      size.height * .6,
                                                  // buttonWidth: 140,
                                                  itemHeight: 40,
                                                  buttonPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          12, 0, 8, 0),
                                                  // dropdownWidth: size.width,
                                                  itemPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          12, 0, 12, 0),
                                                  // searchController:
                                                  //     AddressEditControllers
                                                  //         .searchController,
                                                  // searchInnerWidget: Padding(
                                                  //   padding:
                                                  //       const EdgeInsets.only(
                                                  //     top: 8,
                                                  //     bottom: 4,
                                                  //     right: 8,
                                                  //     left: 8,
                                                  //   ),
                                                  //   child: TextFormField(
                                                  //     controller:
                                                  //         AddressEditControllers
                                                  //             .searchController,
                                                  //     decoration: InputDecoration(
                                                  //       isDense: true,
                                                  //       contentPadding:
                                                  //           const EdgeInsets
                                                  //               .symmetric(
                                                  //         horizontal: 10,
                                                  //         vertical: 8,
                                                  //       ),
                                                  //       // TODO: localisation
                                                  //       hintText:
                                                  //           str.s_search_country,
                                                  //       hintStyle:
                                                  //           const TextStyle(
                                                  //               fontSize: 12),
                                                  //       border:
                                                  //           OutlineInputBorder(
                                                  //         borderRadius:
                                                  //             BorderRadius
                                                  //                 .circular(8),
                                                  //       ),
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  // searchMatchFn:
                                                  //     (item, searchValue) {
                                                  //   return (item.value
                                                  //       .toString()
                                                  //       .toLowerCase()
                                                  //       .contains(searchValue));
                                                  // },
                                                  customButton: defState == null
                                                      ? null
                                                      : Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      10,
                                                                      15,
                                                                      10,
                                                                      15),
                                                              child: Text(
                                                                  defState ??
                                                                      '',
                                                                  style: getRegularStyle(
                                                                      color: ColorManager
                                                                          .black,
                                                                      fontSize:
                                                                          12)),
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
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child: TitleWidget(name: str.e_about),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 15),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 10.0,
                                          color: Colors.grey.shade300,
                                          offset: const Offset(4, 4.5),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      child: TextField(
                                        minLines: 4,
                                        maxLines: 5,
                                        style: const TextStyle(),
                                        controller: EditProfileControllers
                                            .aboutController,
                                        decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        top: 10),
                                                hintText: str.e_about_h,
                                                hintStyle: getRegularStyle(
                                                    color: const Color.fromARGB(
                                                        255, 173, 173, 173),
                                                    fontSize:
                                                        Responsive.isMobile(context)
                                                            ? 15
                                                            : 10))
                                            .copyWith(
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: const BorderSide(
                                                        color: ColorManager.whiteColor,
                                                        width: .5)),
                                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: ColorManager.whiteColor, width: .5))),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(7, 0, 7, 5),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 35,
                                                vertical: mob ? 16 : 10),
                                          ),
                                          onPressed: updateProfileValidation,
                                          child: Center(
                                            child: loading
                                                ? const SizedBox(
                                                    width: 30,
                                                    height: 30,
                                                    child:
                                                        CircularProgressIndicator(
                                                      backgroundColor:
                                                          ColorManager.primary,
                                                      color: ColorManager
                                                          .whiteColor,
                                                      strokeWidth: 5,
                                                    ),
                                                  )
                                                : Text(
                                                    str.e_save,
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: getRegularStyle(
                                                        color: ColorManager
                                                            .whiteText,
                                                        fontSize:
                                                            Responsive.isMobile(
                                                                    context)
                                                                ? 15
                                                                : 10),
                                                  ),
                                          )),
                                    )
                                  ],
                                )
                              ],
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

  // * Date selection

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
        EditProfileControllers.dateController.text =
            selectedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  // * Update profile

  updateProfileValidation() async {
    final str = AppLocalizations.of(context)!;
    // ! Trim removed
    final firstname = EditProfileControllers.firstNameController.text;
    final lastname = EditProfileControllers.lastNameController.text;
    final dob = EditProfileControllers.dateController.text;
    final country = EditProfileControllers.countryController.text;
    if (firstname.isEmpty) {
      showAnimatedSnackBar(context, str.e_snack_name);
    }
    //  else if (lastname.isEmpty) {
    //   showAnimatedSnackBar(context, "Last Name field is requires");
    // }
    else if (dob.isEmpty) {
      showAnimatedSnackBar(context, str.e_snack_dob);
    }
    // else if (countryid == null) {
    //   showAnimatedSnackBar(context, "Country field can not be empty");
    // }
    else {
      setState(() {
        loading = true;
      });
      await updateProfile(firstname, lastname, dob);
      setState(() {
        loading = false;
      });
    }
  }

  updateProfile(firstname, lastname, dob) async {
    log("regid===================${stateid.toString()}");
    final apiToken = Hive.box("token").get('api_token');
    final provider = Provider.of<DataProvider>(context, listen: false);
    final otpProvider = Provider.of<OTPProvider>(context, listen: false);
    final about = EditProfileControllers.aboutController.text;
    final region = regid;
    final state = stateid;

    final countryId =
        countryid ?? otpProvider.otpVerification?.customerdetails?.countryId;
    final firstName = toBeginningOfSentenceCase(firstname);

    try {
      var response = await http.post(
          Uri.parse(
              "$endPoint/api/update/userprofile?firstname=$firstName&gender=$gender&dob=$dob&about=$about&region=$region&country_id=${countryId.toString()}&state=$state&lastname=$lastname"),
          headers: {
            "device-id": provider.deviceId ?? '',
            "api-token": apiToken
          });
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print(jsonResponse);

        await viewProfile(context);
        setState(() {});
        navigateToNext();
      } else {}
    } on Exception catch (_) {}
  }

  navigateToNext() {
    widget.isregister
        ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) {
            return const HomePage();
          }))
        : Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) {
            return const ProfilePage();
          }));
  }

  s(filter) {
    setState(() {
      r = [];
    });

    final provider = Provider.of<DataProvider>(context, listen: false);
    provider.countriesModel?.countries?.forEach((element) {
      final m = element.countryName?.contains(filter);

      if (m == true) {
        if (selectedValue != element.countryName) {
          return;
        }
        setState(() {
          r.add(element);
        });
        countryid = r[0].countryId;
        provider.selectedCountryId = r[0].countryId;
      }
    });
  }

  // R(filter) {
  //   setState(() {
  //     reg = [];
  //   });

  //   final provider = Provider.of<DataProvider>(context, listen: false);
  //   provider.regionInfoModel?.regions?.forEach((element) {
  //     final m = element.cityName?.contains(filter);

  //     if (m == true) {
  //       if (defaultReg != element.cityName) {
  //         return;
  //       }
  //       setState(() {
  //         reg.add(element);
  //       });
  //       regid = reg[0].id;
  //       provider.selectedRegid = reg[0].id;
  //     }
  //   });
  // }

  fillFields(DataProvider provider) {
    final userDetails = provider.viewProfileModel?.userdetails;

    EditProfileControllers.firstNameController.text =
        provider.viewProfileModel?.userdetails?.firstname ?? '';
    EditProfileControllers.lastNameController.text =
        provider.viewProfileModel?.userdetails?.lastname ?? '';
    EditProfileControllers.dateController.text =
        provider.viewProfileModel?.userdetails?.dob ?? '';
    EditProfileControllers.regionController.text =
        provider.viewProfileModel?.userdetails?.city ?? '';
    EditProfileControllers.stateController.text =
        provider.viewProfileModel?.userdetails?.statename ?? '';
    EditProfileControllers.aboutController.text =
        provider.viewProfileModel?.userdetails?.about ?? '';
    selectedValue = provider.viewProfileModel?.userdetails?.countryName;
    countryid = provider.viewProfileModel?.userdetails?.countryId;
    value = userDetails?.gender == 'female' ? false : true;
    defaultReg = provider.viewProfileModel?.userdetails?.city;
    defState = provider.viewProfileModel?.userdetails?.statename;
    regid = provider.viewProfileModel?.userdetails?.region;
    stateid = provider.viewProfileModel?.userdetails?.state;

    print(provider.viewProfileModel?.userdetails?.gender);
  }

  emptyFields() {
    EditProfileControllers.firstNameController.text = '';
    EditProfileControllers.lastNameController.text = '';
    EditProfileControllers.dateController.text = '';
    EditProfileControllers.regionController.text = '';
    EditProfileControllers.stateController.text = '';
    EditProfileControllers.aboutController.text = '';
  }
}
