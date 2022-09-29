import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:weweyou/ui/utils/common_text_style.dart';
import 'package:weweyou/ui/utils/constant.dart';

import '../../../data/networking/shared_pref.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({Key? key}) : super(key: key);
  static const String route = '/previewScreen';

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  final PageController controller = PageController(initialPage: 0);
  final _currentPageNotifier = ValueNotifier<int>(0);

  String previewText = 'on_boarding.book_event_des'.tr();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: WeweyouColors.lightBlackColor,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: size.height * 0.85,
              child: PageView(
                onPageChanged: (int index) {
                  _currentPageNotifier.value = index;
                },
                scrollDirection: Axis.horizontal,
                controller: controller,
                children: <Widget>[
                  _previewContainerNew(
                    imagePath: "assets/images_icons/onboarding/slide3.png",
                    headline: 'on_boarding.book_event'.tr(),
                    description: 'on_boarding.book_event_des'.tr(),
                    context: context,
                  ),
                  _previewContainerNew(
                    imagePath: "assets/images_icons/onboarding/slide2.png",
                    headline: 'on_boarding.create_sub'.tr(),
                    description: 'on_boarding.create_sub_des'.tr(),
                    context: context,
                  ),
                  _previewContainerNew(
                    imagePath: 'assets/images_icons/onboarding/slide1.png',
                    headline: 'on_boarding.share_itinerary'.tr(),
                    description: 'on_boarding.share_itinerary_des'.tr(),
                    context: context,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: size.height * 0.16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CirclePageIndicator(
                    dotColor: Colors.white,
                    selectedDotColor: WeweyouColors.primaryDarkRed,
                    itemCount: 3,
                    currentPageNotifier: _currentPageNotifier,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/signInRoute');
                      previewScreenVisible();
                    },
                    child: Container(
                      height: size.width * 0.15,
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.only(bottom: 20),
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: WeweyouColors.primaryDarkRed,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "on_boarding.get_started".tr(),
                        style: poppinsRegular(
                          fontSize: 18,
                          fontColor: WeweyouColors.customPureWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _previewContainerNew(
      {required String imagePath,
      required String headline,
      required String description,
      required BuildContext context}) {
    final size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: size.height * 0.45,
          width: size.width * 0.85,
          margin: const EdgeInsets.only(top: 70),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                imagePath,
              ),
            ),
            border: Border.all(
                color: WeweyouColors.customPureWhite,
                width: 10,
                style: BorderStyle.solid),
          ),
        ),
        Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              headline,
              style: poppinsBold(),
              textAlign: TextAlign.center,
            ),
            sizedBox(),
            Text(
              description,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: poppinsRegular(),
            ),
            sizedBox(height: 35),
          ],
        )
      ],
    );
  }

  _previewContainer(
      {required String imagePath,
      required String headline,
      required String description}) {
    return Container(
      margin: const EdgeInsets.all(20),
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: Colors.white, width: 10, style: BorderStyle.solid),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            headline,
            style: poppinsBold(),
          ),
          sizedBox(),
          Text(
            description,
            textAlign: TextAlign.center,
            style: poppinsRegular(),
          )
        ],
      ),
    );
  }
}
