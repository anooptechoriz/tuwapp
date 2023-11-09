import 'package:flutter/material.dart';
import 'package:social_media_services/components/color_manager.dart';
import 'package:social_media_services/components/styles_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MonthlyPlan extends StatelessWidget {
  final String plan;
  final String amount;
  final bool isSelected;
  int? len;
  MonthlyPlan({
    Key? key,
    required this.size,
    required this.plan,
    required this.amount,
    this.len,
    required this.isSelected,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final str = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Container(
        width: len! > 2 ? size.width * .4 : size.width * .44,
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
          decoration: BoxDecoration(
              color: isSelected ? Colors.grey[300] : ColorManager.whiteColor,
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plan,
                    style: getMediumtStyle(
                        color: ColorManager.black, fontSize: 15)),
                Row(
                  children: [
                    Text(amount,
                        style: getSemiBoldtStyle(
                            color: ColorManager.primary, fontSize: 15)),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(str.omr,
                        style: getRegularStyle(
                            color: const Color.fromARGB(255, 173, 173, 173),
                            fontSize: 15))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
