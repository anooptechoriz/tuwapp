// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:social_media_services/API/endpoint.dart';
import 'package:social_media_services/components/color_manager.dart';
import 'package:social_media_services/components/styles_manager.dart';
import 'package:social_media_services/loading%20screens/address_card_loading.dart';
import 'package:social_media_services/model/user_address_show.dart';
import 'package:social_media_services/providers/data_provider.dart';

import 'package:social_media_services/screens/Address%20page/address_update.dart';
import 'package:social_media_services/utils/diologue.dart';

class AddressBox extends StatefulWidget {
  UserAddress? userAddress;
  AddressBox({super.key, this.userAddress});

  @override
  State<AddressBox> createState() => _AddressBoxState();
}

class _AddressBoxState extends State<AddressBox> {
  bool isLoading = false;
  String lang = '';
  @override
  void initState() {
    super.initState();
    lang = Hive.box('LocalLan').get(
      'lang',
    );
  }

  void openGoogleMaps(double latitude, double longitude) {
    MapsLauncher.launchCoordinates(latitude, longitude);
  }

  @override
  Widget build(BuildContext context) {
    String capitalizeFirstLetter(String text) {
      if (text.isEmpty) {
        return text;
      }
      return text[0].toUpperCase() + text.substring(1);
    }

    print(
        "city==========================${widget.userAddress?.city.toString()}");
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<DataProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        openGoogleMaps(double.parse(widget.userAddress?.latitude),
            double.parse(widget.userAddress?.longitude));
        //previous
        // Navigator.push(
        //     context,
        //     PageTransition(
        //       type: PageTransitionType.rightToLeft,
        //       child: ViewLocationScreen(
        //           latitude: widget.userAddress?.latitude,
        //           longitude: widget.userAddress?.longitude),
        //     ));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Stack(
          children: [
            Container(
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                // border: Border.all(
                //     color: ColorManager.paymentPageColor1, width: .5),
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10.0,
                    color: Colors.grey.shade300,
                    offset: const Offset(5, 8.5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: "$endPoint${widget.userAddress?.image}",
                    height: 225,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        // width: 25,
                        // height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.5),
                                  BlendMode.srcOver),
                              image: imageProvider,
                              fit: BoxFit.cover),
                        ),
                      );
                    },
                    width: size.width,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                      left: lang != 'ar' ? 15 : null,
                      right: lang == 'ar' ? 15 : null,
                      bottom: 15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            capitalizeFirstLetter(
                                widget.userAddress?.addressName ?? ""),
                            style: getRegularStyle(
                              color: ColorManager.whiteColor,
                              fontSize: 18,
                            ),
                          ),
                          widget.userAddress?.address == null
                              ? Container()
                              : Text(
                                  widget.userAddress?.address ?? "",
                                  style: getRegularStyle(
                                    color: ColorManager.whiteColor,
                                    fontSize: 16,
                                  ),
                                ),
                          widget.userAddress?.homeNo == null
                              ? Container()
                              : Text(
                                  widget.userAddress?.homeNo ?? "",
                                  style: getRegularStyle(
                                    color: ColorManager.whiteColor,
                                    fontSize: 16,
                                  ),
                                ),
                          Container(
                            width: size.width / 1.12,
                            child: RichText(
                              maxLines: 2, // Set the maximum number of lines
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: getRegularStyle(
                                  color: ColorManager.whiteColor,
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        "${widget.userAddress?.city.toString() ?? ''}",
                                  ),
                                  widget.userAddress?.state == null
                                      ? TextSpan()
                                      : TextSpan(
                                          text:
                                              ",${widget.userAddress?.state ?? ''}",
                                          style: getRegularStyle(
                                            fontSize: 16,
                                            color: ColorManager.whiteColor,
                                          ),
                                        ),
                                  TextSpan(
                                    text:
                                        ",${widget.userAddress?.country.toString() ?? ''}",
                                    style: getRegularStyle(
                                      fontSize: 16,
                                      color: ColorManager.whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
            Positioned(
              right: lang == 'ar' ? null : 5,
              left: lang == 'ar' ? 5 : null,
              top: 5,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return UserAddressCardLoading(
                          id: widget.userAddress!.userId.toString(),
                          addressId: widget.userAddress!.id.toString(),
                        );
                      }));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            spreadRadius: 1,
                            blurRadius: 3,
                            // offset: const Offset(2, 2.5),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.remove_red_eye,
                          size: 18,
                          color: ColorManager.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    onTap: () {
                      provider.locality = null;
                      provider.addressLatitude = null;
                      provider.addressLongitude = null;
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return UserAddressUpdate(
                          userAddress: widget.userAddress!,
                        );
                      }));
                      // selectImage();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            spreadRadius: 1,
                            blurRadius: 3,
                            // offset: const Offset(2, 2.5),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.edit,
                          size: 12,
                          color: ColorManager.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    onTap: () async {
                      final addressId = widget.userAddress!.id.toString();
                      // print(addressId);
                      // setState(() {
                      //   isLoading = true;
                      // });
                      // await deleteAddressBox(addressId);
                      // setState(() {
                      //   isLoading = false;
                      // });
                      showDialog(
                          context: context,
                          builder: (context) =>
                              DialogueBox(addressId: addressId),
                          barrierDismissible: false);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            spreadRadius: 1,
                            blurRadius: 3,
                            // offset: const Offset(2, 2.5),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white,
                        child: isLoading
                            ? const SizedBox(
                                height: 8,
                                width: 8,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(
                                Icons.delete,
                                size: 12,
                                color: ColorManager.primary,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Positioned(
            //   top: 130,
            //   right: lang == 'ar' ? null : 5,
            //   left: lang == 'ar' ? 5 : null,
            //   child: const Icon(Icons.navigate_next_sharp,
            //       color: ColorManager.primary, size: 30),
            // )
          ],
        ),
      ),
    );
  }
}
