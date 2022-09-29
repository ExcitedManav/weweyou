import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:weweyou/data/models/onboarding_models/itinerary_model.dart';
import 'package:weweyou/data/networking/api_end_point.dart';
import 'package:weweyou/data/networking/networking.dart';
import 'package:weweyou/ui/home_screens/drawer_screens/accounts/widgets/custom_text.dart';
import 'package:weweyou/ui/home_screens/drawer_screens/itineraries/create_itinerary.dart';
import 'package:weweyou/ui/utils/common_loader.dart';

import '../../../utils/common_text_style.dart';
import '../../../utils/constant.dart';
import '../../create_event/widgets/common_widgets_create_event.dart';
import '../../widgets/image_network_function.dart';
import '../my_events/widgets/secondary_app_bar.dart';

class ItineraryDetails extends StatefulWidget {
  ItineraryDetails({Key? key, required this.itineraryId}) : super(key: key);

  final itineraryId;

  @override
  State<ItineraryDetails> createState() => _ItineraryDetailsState();
}

class _ItineraryDetailsState extends State<ItineraryDetails> {
  int? selectedComment;

  final NetworkingFunctions _networkingFunctions = NetworkingFunctions();
  final ApiEndPoint _apiEndPoint = ApiEndPoint();

  ItineraryRecordList? _itineraryRecord;
  bool loader = true;
  String? dateOutput;

  @override
  void initState() {
    callApi();
    super.initState();
  }

  callApi() async {
    setState(() {
      loader = true;
    });
    final response = await NetworkingFunctions.getApiCall(
      endPoint: "${ApiEndPoint.ITINERARYDETAILS}${widget.itineraryId}",
    );

    ItineraryRecordList itineraryRecord =
        ItineraryRecordList.fromJson(response.data['record']);
    _itineraryRecord = itineraryRecord;
    final format = DateFormat("dd/mm/yyyy");
    final inputDate = format.parse(_itineraryRecord!.mainDate!);
    final showFormat = DateFormat("dd MMMM yyyy");
    final outputDate = showFormat.format(inputDate);
    dateOutput = outputDate;
    debugPrint('Date here show ----> $dateOutput');
    debugPrint('Date here coming ----> ${_itineraryRecord!.mainDate}');
    loader = false;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: WeweyouColors.lightBlackColor,
      appBar: PreferredSize(
        preferredSize: Size(size.width, 70),
        child: const SecondaryAppBar(
          appBarName: 'Itinerary Details',
        ),
      ),
      body: loader == false
          ? SingleChildScrollView(
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
                              fit: BoxFit.fill,
                              imagePath: NetworkImage(
                                _itineraryRecord!.image ?? '',
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CreateItineraryScreen(
                                        itineraryRecord: _itineraryRecord,
                                      ),
                                    ),
                                  );
                                  if (result != null) {
                                    callApi();
                                    if (mounted) setState(() {});
                                  }
                                },
                                child: CircleAvatar(
                                  backgroundColor: WeweyouColors.blackPrimary
                                      .withOpacity(0.4),
                                  radius: 16,
                                  child: const Icon(
                                    Icons.edit,
                                    color: WeweyouColors.customPureWhite,
                                    size: 22,
                                  ),
                                ),
                              ),
                              sizedBox(width: 10),
                              CircleAvatar(
                                backgroundColor:
                                    WeweyouColors.blackPrimary.withOpacity(0.4),
                                radius: 16,
                                child: const Icon(
                                  Icons.share,
                                  color: WeweyouColors.customPureWhite,
                                  size: 22,
                                ),
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
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          subHeadingText(
                            title: _itineraryRecord!.title ?? '',
                            fontSize: 16,
                          ),
                          sizedBox(),
                          commonText(
                            text: dateOutput ?? '',
                          ),
                          sizedBox(height: 20),
                          const CustomText(initialText: 'Description'),
                          sizedBox(),
                          commonText(
                            text: _itineraryRecord!.description ?? '',
                          ),
                          sizedBox(),
                          headingText(
                            heading: 'PARTICIPANTS',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                          sizedBox(),
                          commonText(
                              text: 'No Participants Yet!', fontSize: 16),
                          // Container(
                          //   height: 38,
                          //   padding: const EdgeInsets.symmetric(vertical: 2),
                          //   child: ListView.separated(
                          //     scrollDirection: Axis.horizontal,
                          //     itemBuilder: (ctx, i) {
                          //       return ClipRRect(
                          //         borderRadius: BorderRadius.circular(20),
                          //         child: ImageNetworkFunction(
                          //           fit: BoxFit.fill,
                          //           height: 32,
                          //           width: 32,
                          //           imagePath: NetworkImage(
                          //             _itineraryRecord!.image ?? '',
                          //           ),
                          //         ),
                          //       );
                          //     },
                          //     separatorBuilder: (_, i) => sizedBox(),
                          //     itemCount: 6,
                          //   ),
                          // ),
                          sizedBox(),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     commonText(
                          //       text: 'Location',
                          //       fontSize: 14,
                          //     ),
                          //     Text(
                          //       'How to get there?',
                          //       maxLines: 1,
                          //       overflow: TextOverflow.ellipsis,
                          //       style: poppinsMedium(
                          //         fontSize: 14,
                          //         fontColor: WeweyouColors.secondaryOrange,
                          //       ).copyWith(
                          //         decoration: TextDecoration.underline,
                          //       ),
                          //     )
                          //   ],
                          // ),
                          // sizedBox(),
                          // commonText(
                          //   text: 'Indore',
                          //   fontColor: WeweyouColors.greyPrimary,
                          // ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: ImageNetworkFunction(
                                      fit: BoxFit.fill,
                                      height: 32,
                                      width: 32,
                                      imagePath: NetworkImage(
                                          _itineraryRecord!.image ?? ''),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const CommonLoader(),
    );
  }
}
