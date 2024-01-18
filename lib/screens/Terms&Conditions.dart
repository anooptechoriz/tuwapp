import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:social_media_services/components/assets_manager.dart';
import 'package:social_media_services/components/color_manager.dart';
import 'package:social_media_services/components/styles_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:social_media_services/widgets/backbutton.dart';

class TermsAndConditionPage extends StatefulWidget {
  const TermsAndConditionPage({super.key});

  @override
  State<TermsAndConditionPage> createState() => _TermsAndConditionPageState();
}

class _TermsAndConditionPageState extends State<TermsAndConditionPage> {
  String? text;
  String? lan;
  Future<void> readTextFile() async {
    print(lan);
    if (lan == 'en') {
      text = await rootBundle.loadString('assets/txt/termsEnglish.txt');
    } else if (lan == 'ar') {
      text = await rootBundle.loadString('assets/txt/arabicTerms.txt');
    } else {
      text = await rootBundle.loadString('assets/txt/termsHindi.txt');
    }
  }

  @override
  void initState() {
    super.initState();
    lan = Hive.box("LocalLan").get('lang');

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await readTextFile();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final str = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: PreferredSize(
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
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
          ),
          preferredSize: Size(100, 150)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                    child: Row(
                      children: [
                        Container(
                            width: 38,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: ColorManager.primary,
                            ),
                            child: Center(
                                child: Image.asset(ImageAssets.privacy))),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          str.t_2,
                          style: getRegularStyle(
                              color: ColorManager.black, fontSize: 17),
                        )
                      ],
                    ),
                  ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  const Divider(
                      color: ColorManager.engineWorkerColor, height: 5),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
                    child: Text(
                      text ?? '',
                      textAlign: TextAlign.justify,
                      style: getRegularStyle(
                          color: ColorManager.engineWorkerColor, fontSize: 16),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
