import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:social_media_services/components/color_manager.dart';
import 'package:social_media_services/components/styles_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomStepper extends StatelessWidget {
  final int num;
  const CustomStepper({Key? key, required this.num}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = Hive.box('LocalLan').get(
      'lang',
    );
    final str = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                str.cs_profile,
                style: getMediumtStyle(
                    color: ColorManager.paymentPageColor1, fontSize: 10),
              ),
              const SizedBox(
                height: 3,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.0,
                          color: Colors.grey.shade400,
                          offset: const Offset(1, 3.5),
                        ),
                      ],
                      color: num == 1 || num == 2 || num == 3
                          ? ColorManager.primary
                          : ColorManager.whiteColor,
                    ),
                    width: 85,
                    height: 2.2,
                  ),
                  const Positioned(
                    // left: 30,
                    // bottom: 1,
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: ColorManager.primary,
                      child: CircleAvatar(
                        radius: 2,
                        backgroundColor: ColorManager.whiteColor,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          Column(
            children: [
              Text(str.cs_choose_service,
                  style: getMediumtStyle(
                      color: ColorManager.paymentPageColor1, fontSize: 10)),
              lang == 'hi'
                  ? const SizedBox(
                      height: 1.1,
                    )
                  : const SizedBox(
                      height: 3,
                    ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.0,
                          color: Colors.grey.shade400,
                          offset: const Offset(1, 3.5),
                        ),
                      ],
                      color: num == 2 || num == 3
                          ? ColorManager.primary
                          : ColorManager.whiteColor,
                    ),
                    width: 85,
                    height: 2.2,
                  ),
                  const Positioned(
                    // left: 30,
                    // bottom: 1,
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: ColorManager.primary,
                      child: CircleAvatar(
                        radius: 2,
                        backgroundColor: ColorManager.whiteColor,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          Column(
            children: [
              Text(str.cs_pay,
                  style: getMediumtStyle(
                      color: ColorManager.paymentPageColor1, fontSize: 10)),
              const SizedBox(
                height: 3,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 85,
                    height: 2.2,
                    decoration: BoxDecoration(
                      color: num == 3
                          ? ColorManager.primary
                          : ColorManager.whiteColor,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.0,
                          color: Colors.grey.shade400,
                          offset: const Offset(1, 3.5),
                        ),
                      ],
                    ),
                  ),
                  const Positioned(
                    // left: 30,
                    // bottom: 1,
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: ColorManager.primary,
                      child: CircleAvatar(
                        radius: 2,
                        backgroundColor: ColorManager.whiteColor,
                      ),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
