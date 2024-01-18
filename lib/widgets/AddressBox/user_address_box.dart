// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:social_media_services/API/endpoint.dart';
import 'package:social_media_services/components/color_manager.dart';
import 'package:social_media_services/components/styles_manager.dart';
import 'package:social_media_services/model/other%20User/show_user_address.dart';

class UserAddressBox extends StatefulWidget {
  UserAddress? userAddress;
  UserAddressBox({super.key, this.userAddress});

  @override
  State<UserAddressBox> createState() => _UserAddressBoxState();
}

class _UserAddressBoxState extends State<UserAddressBox> {
  bool isLoading = false;
  String lang = '';
  @override
  void initState() {
    super.initState();
    lang = Hive.box('LocalLan').get(
      'lang',
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String capitalizeFirstLetter(String text) {
      if (text.isEmpty) {
        return text;
      }
      return text[0].toUpperCase() + text.substring(1);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Stack(
        children: [
          Container(
            width: size.width,
            decoration: BoxDecoration(
              color: ColorManager.whiteColor,
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
                  imageUrl: "$endPoint/${widget.userAddress?.image}",
                  height: 200,
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
                  ),
                  // child: Row(
                  //   children: [
                  //     //   padding: const EdgeInsets.fromLTRB(15, 100, 15, 20),
                  //     Text(
                  //       "${widget.userAddress?.addressName}\n${widget.userAddress?.address}\n${widget.userAddress?.homeNo}\n${widget.userAddress?.region}, ${widget.userAddress?.state}, ${widget.userAddress?.country}",
                  //       style: getRegularStyle(
                  //           color: ColorManager.whiteColor, fontSize: 16),
                  //     ),
                  //   ],
                  // ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
