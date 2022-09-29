import 'package:flutter/material.dart';
import 'package:weweyou/ui/utils/common_button.dart';
import 'package:weweyou/ui/utils/input_text_field.dart';

import '../../../utils/common_text_style.dart';
import '../../../utils/constant.dart';
import '../../create_event/widgets/common_widgets_create_event.dart';
import '../../widgets/image_network_function.dart';
import '../accounts/widgets/custom_text.dart';
import '../my_events/widgets/secondary_app_bar.dart';

class GroupDetailScreen extends StatefulWidget {
  const GroupDetailScreen({Key? key, required this.imagePath})
      : super(key: key);
  final String imagePath;

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  int? selectedComment;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: WeweyouColors.lightBlackColor,
      appBar: PreferredSize(
        preferredSize: Size(size.width, 70),
        child: const SecondaryAppBar(
          appBarName: 'Group Details',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Container(
          color: WeweyouColors.blackPrimary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 243,
                    width: size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: ImageNetworkFunction(
                        height: 80,
                        width: 110,
                        imagePath: NetworkImage(
                          widget.imagePath,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.share,
                          color: WeweyouColors.customPureWhite,
                          size: 22,
                        ),
                        sizedBox(width: 10),
                        const Icon(
                          Icons.favorite_rounded,
                          color: WeweyouColors.primaryDarkRed,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    child: Container(
                      height: 38,
                      width: 121,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: WeweyouColors.primaryDarkRed),
                      child: Text(
                        'Join Group',
                        style: poppinsBold(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subHeadingText(
                      title: "Group Name",
                      fontSize: 16,
                    ),
                    sizedBox(height: 5),
                    Text(
                      'Category Name',
                      style: poppinsRegular(fontSize: 14),
                    ),
                    sizedBox(),
                    commonText(
                      text:
                          "Event is created by Carbon Almanac, who's motive is to create awareness about the impact about climate change.",
                    ),
                    sizedBox(),
                    headingText(
                      heading: 'MEMBER',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    sizedBox(),
                    Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, i) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: ImageNetworkFunction(
                              fit: BoxFit.fill,
                              height: 32,
                              width: 32,
                              imagePath: NetworkImage(
                                widget.imagePath,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, i) => sizedBox(),
                        itemCount: 6,
                      ),
                    ),
                    sizedBox(),
                    headingText(
                      heading: 'ADMINISTRATOR',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    sizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: ImageNetworkFunction(
                                height: 32,
                                width: 32,
                                imagePath: NetworkImage(
                                  widget.imagePath,
                                ),
                              ),
                            ),
                            sizedBox(),
                            commonText(
                              text: 'Administrator Name',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        Text(
                          'Follow',
                          style: poppinsSemiBold(
                            fontColor: WeweyouColors.primaryDarkRed,
                            fontSize: 14,
                          ).copyWith(decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                    sizedBox(height: 20),
                    CommonButton(onPressed: () {}, buttonName: 'Contact'),
                    sizedBox(height: 30),
                    headingText(
                      heading: 'DETAILS',
                      fontSize: 16,
                    ),
                    sizedBox(),
                    commonText(
                      text: 'Shared Events',
                      fontSize: 14,
                    ),
                    sizedBox(),
                    ListView.separated(
                      itemCount: 2,
                      separatorBuilder: (_, i) => sizedBox(),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (ctx, i) {
                        return Container(
                          height: 90,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: WeweyouColors.blackBackground,
                          ),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: ImageNetworkFunction(
                                      height: 80,
                                      width: 102,
                                      imagePath: NetworkImage(
                                        widget.imagePath,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: Container(
                                      height: 17,
                                      width: 110,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: WeweyouColors.secondaryOrange
                                            .withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(
                                          4,
                                        ),
                                      ),
                                      child: Text(
                                        '13 July 2022',
                                        style: poppinsRegular(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              sizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    subHeadingText(
                                      title: 'Group Name',
                                      fontSize: 16,
                                    ),
                                    sizedBox(height: 5),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                            size: 22,
                                            color:
                                                WeweyouColors.secondaryOrange,
                                          ),
                                          Flexible(
                                            child: Text(
                                              'South Delhi, India',
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                              textAlign: TextAlign.start,
                                              style: poppinsRegular(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    sizedBox(height: 8),
                                    const CustomText(
                                      initialText: "13 Tickets",
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    sizedBox(height: 20),
                    commonText(
                      text: 'Similar Events',
                      fontSize: 16,
                    ),
                    sizedBox(height: 20),
                    commonText(
                      text: 'Comments',
                      fontSize: 14,
                    ),
                    sizedBox(),
                    CustomFormField(
                      controller: TextEditingController(),
                      hintText: 'Type here...',
                      fillColor: WeweyouColors.blackBackground,
                      maxLine: 3,
                    ),
                    sizedBox(height: 20),
                    CommonButton(
                      onPressed: () {},
                      buttonName: 'Submit',
                    ),
                    sizedBox(height: 30),
                    SizedBox(
                      height: 150,
                      width: size.width,
                      child: ListView.builder(
                        itemCount: 3,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, i) {
                          selectedComment = i;
                          return SizedBox(
                            width: size.width * 0.8,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: ImageNetworkFunction(
                                        height: 32,
                                        width: 32,
                                        imagePath: NetworkImage(
                                          widget.imagePath,
                                        ),
                                      ),
                                    ),
                                    sizedBox(),
                                    commonText(
                                      text: 'Commentator Name',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    sizedBox(),
                                  ],
                                ),
                                sizedBox(),
                                commonText(
                                  text:
                                      'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.',
                                ),
                                sizedBox(),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Wrap(children: [
                        for (var index = 0; index < 3; index++)
                          Container(
                            height: 8,
                            width: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: index == selectedComment
                                    ? WeweyouColors.primaryDarkRed
                                    : WeweyouColors.primaryDarkRed
                                        .withOpacity(0.52)),
                          ),
                      ]),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
