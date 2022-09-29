import 'package:flutter/material.dart';
import 'package:weweyou/data/networking/api_end_point.dart';
import 'package:weweyou/data/networking/networking.dart';
import 'package:weweyou/ui/home_screens/create_event/widgets/common_widgets_create_event.dart';
import 'package:weweyou/ui/home_screens/drawer_screens/my_events/create_sub_evnet.dart';
import 'package:weweyou/ui/home_screens/drawer_screens/my_events/widgets/secondary_app_bar.dart';
import 'package:weweyou/ui/utils/common_loader.dart';
import 'package:weweyou/ui/utils/common_text_style.dart';
import 'package:weweyou/ui/utils/constant.dart';

import '../../../../data/models/onboarding_models/created_event_detail_model.dart';
import '../../widgets/image_network_function.dart';
import '../accounts/widgets/custom_text.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({Key? key, required this.eventDetailsId})
      : super(key: key);
  final eventDetailsId;

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  CreatedEventDetailRecord? _createdEventDetailRecord;

  bool loader = true;

  getEventCallApi() async {
    final response = await NetworkingFunctions.getApiCall(
      endPoint:
          ApiEndPoint.CREATEDEVENTDETAIL + widget.eventDetailsId.toString(),
    );
    CreatedEventDetailModel createdEventDetailModel =
        CreatedEventDetailModel.fromJson(response.data);
    _createdEventDetailRecord = createdEventDetailModel.record;
    loader = false;
    if (mounted) setState(() {});
    debugPrint("Created Event detail ${_createdEventDetailRecord!.image}");
  }

  @override
  void initState() {
    getEventCallApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: WeweyouColors.lightBlackColor,
      appBar: PreferredSize(
        preferredSize: Size(size.width, 70),
        child: const SecondaryAppBar(
          appBarName: 'Event Details',
        ),
      ),
      body: loader == false ? SingleChildScrollView(
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
                          _createdEventDetailRecord?.image ?? '',
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              WeweyouColors.blackBackground.withOpacity(0.1),
                          child: const Icon(
                            Icons.share,
                            color: WeweyouColors.customPureWhite,
                            size: 22,
                          ),
                        ),
                        sizedBox(width: 10),
                        CircleAvatar(
                          backgroundColor:
                              WeweyouColors.blackBackground.withOpacity(0.1),
                          child: const Icon(
                            Icons.favorite_rounded,
                            color: WeweyouColors.primaryDarkRed,
                            size: 22,
                          ),
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
                        'Itinerary',
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
                      title: _createdEventDetailRecord?.eventTitle ?? "",
                      fontSize: 16,
                    ),
                    sizedBox(height: 5),
                    Text(
                      'January 08 2022 1:54 Am - 3:00 Am',
                      style: poppinsRegular(fontSize: 14),
                    ),
                    sizedBox(),
                    commonText(
                      text:
                          "Event is created by Carbon Almanac, who's motive is to create awareness about the impact about climate change.",
                    ),
                    sizedBox(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            headingText(
                              heading: 'EVENT CODE',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                            sizedBox(height: 5),
                            Image.asset(
                              'assets/images_icons/create_event_card/qr.png',
                              height: 84,
                              width: 83,
                            ),
                          ],
                        ),
                        sizedBox(width: 5),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            headingText(
                              heading: 'SELECT TICKET',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                            sizedBox(height: 5),
                            Container(
                              height: 83,
                              width: 187,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: WeweyouColors.customPureWhite,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(4),
                                            bottomLeft: Radius.circular(4)),
                                        color: WeweyouColors.secondaryOrange,
                                      ),
                                      child: Text(
                                        '1',
                                        style: poppinsMedium(),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              commonText(
                                                text: 'TICKET NAME',
                                                fontColor:
                                                    WeweyouColors.blackPrimary,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              sizedBox(height: 2),
                                              commonText(
                                                text: "\$25.00",
                                                fontColor: WeweyouColors
                                                    .secondaryOrange,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              sizedBox(height: 3),
                                              commonText(
                                                text: "\$25.00 X 1= \$25",
                                                fontColor: WeweyouColors
                                                    .primaryDarkRed,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    sizedBox(),
                    headingText(
                      heading: 'PARTICIPANTS',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    sizedBox(),
                    SizedBox(
                      height: 38,
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
                                _createdEventDetailRecord?.image ?? '',
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
                      heading: 'DETAILS',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    sizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        commonText(
                          text: 'Sub Event',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CreateSubEventScreen(
                                  // eventId: _createdEventDetailRecord.id ?? "",
                                  eventId: 45.toString(),
                                ),
                              ),
                            );
                          },
                          child: const CircleAvatar(
                            radius: 14,
                            backgroundColor: WeweyouColors.primaryDarkRed,
                            child: Icon(
                              Icons.add,
                              size: 20,
                              color: WeweyouColors.customPureWhite,
                            ),
                          ),
                        )
                      ],
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
                                        _createdEventDetailRecord?.image ?? '',
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
                                      title: _createdEventDetailRecord
                                              ?.eventTitle ??
                                          '',
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
                                              _createdEventDetailRecord
                                                      ?.location ??
                                                  '',
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
                                    CustomText(
                                      initialText:
                                          "${_createdEventDetailRecord?.quantity ?? ""} Tickets",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        commonText(
                          text: 'Location',
                          fontSize: 14,
                        ),
                        Text(
                          'How to get there?',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: poppinsMedium(
                            fontSize: 14,
                            fontColor: WeweyouColors.secondaryOrange,
                          ).copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        )
                      ],
                    ),
                    sizedBox(height: 10),
                    commonText(
                      text: _createdEventDetailRecord?.location ?? '',
                      fontColor: WeweyouColors.greyPrimary,
                    ),
                    sizedBox(),
                    commonText(
                      text: 'Organizer',
                      fontSize: 16,
                    ),
                    sizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ImageNetworkFunction(
                                fit: BoxFit.fill,
                                height: 32,
                                width: 32,
                                imagePath: NetworkImage(
                                  _createdEventDetailRecord?.image ?? '',
                                ),
                              ),
                            ),
                            sizedBox(),
                            commonText(
                              text: 'Seth Godins',
                              fontSize: 14,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.mail_outline_outlined,
                              color: WeweyouColors.greyPrimary,
                            ),
                            sizedBox(width: 15),
                            const Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: WeweyouColors.greyPrimary,
                            ),
                            sizedBox(width: 15),
                            const Icon(
                              Icons.call_outlined,
                              color: WeweyouColors.greyPrimary,
                            ),
                          ],
                        )
                      ],
                    ),
                    sizedBox(),
                    commonText(
                      text:
                          " Seth was an internet marketer and essentially invented commercial email. He built Yoyodyne and sold it to Yahoo for ~\$30m and then built Squidoo.",
                    ),
                    sizedBox(height: 20),
                    commonText(
                      text: 'Similar Events',
                      fontSize: 16,
                    ),
                    sizedBox(height: 20),
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
                                        _createdEventDetailRecord?.image ?? '',
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
                                      title: _createdEventDetailRecord?.eventTitle ??
                                          '',
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
                                              _createdEventDetailRecord
                                                      ?.location ??
                                                  '',
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
                                    CustomText(
                                      initialText:
                                          "${_createdEventDetailRecord?.quantity ?? ''} Tickets",
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ) : const CommonLoader(),
    );
  }
}
