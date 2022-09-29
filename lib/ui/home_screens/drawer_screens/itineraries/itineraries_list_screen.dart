import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:weweyou/data/models/onboarding_models/itinerary_model.dart';
import 'package:weweyou/data/networking/api_end_point.dart';
import 'package:weweyou/data/networking/networking.dart';
import 'package:weweyou/ui/home_screens/drawer_screens/itineraries/create_itinerary.dart';
import 'package:weweyou/ui/home_screens/drawer_screens/itineraries/itinerary_details.dart';
import 'package:weweyou/ui/utils/common_loader.dart';
import 'package:weweyou/ui/utils/constant.dart';

import '../../../utils/common_text_style.dart';
import '../../create_event/widgets/common_widgets_create_event.dart';
import '../../widgets/image_network_function.dart';

class ItinerariesListScreen extends StatefulWidget {
  const ItinerariesListScreen({Key? key}) : super(key: key);

  @override
  State<ItinerariesListScreen> createState() => _ItinerariesListScreenState();
}

class _ItinerariesListScreenState extends State<ItinerariesListScreen> {
  int? selectIndex = 1;
  final NetworkingFunctions _networkingFunctions = NetworkingFunctions();
  final ApiEndPoint _apiEndPoint = ApiEndPoint();
  bool loader = true;

  @override
  void initState() {
    apiCall();
    super.initState();
  }

  List<ItineraryRecordList>? _itineraryRecordList;

  apiCall() async {
    setState(() {
      loader = true;
    });
    try {
      final response = await NetworkingFunctions.getApiCall(
        endPoint: ApiEndPoint.ITINERARYLIST,
      );
      ItineraryListModel itineraryModel =
          ItineraryListModel.fromJson(response.data);
      _itineraryRecordList = itineraryModel.itineraryRecord;
      loader = false;
    } catch (e) {
      loader = false;
      debugPrint(e.toString());
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WeweyouColors.blackBackground,
      body: loader == false
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sizedBox(),
                  headingText(
                    heading: 'Your Itineraries',
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  sizedBox(),
                  _itineraryRecordList!.isNotEmpty ? createdList() : Text('No Itinerary created yet!')
                ],
              ),
            )
          : const CommonLoader(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>  CreateItineraryScreen(
                 itineraryRecord: null,
              ),
            ),
          );
          if (result != null) {
            apiCall();
            if (mounted) setState(() {});
          }
        },
        backgroundColor: WeweyouColors.primaryDarkRed,
        child: const Icon(
          Icons.add,
          size: 48,
          color: WeweyouColors.blackBackground,
        ),
      ),
    );
  }

  createdList() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () => apiCall(),
        child: ListView.separated(
          itemCount: _itineraryRecordList!.length,
          separatorBuilder: (_, i) => sizedBox(),
          itemBuilder: (ctx, i) {
            final format = DateFormat("dd/mm/yyyy");
            final inputDate = format.parse(_itineraryRecordList![i].mainDate!);
            final showFormat = DateFormat('dd MMM yyyy');
            final outputDate = showFormat.format(inputDate);
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ItineraryDetails(
                      itineraryId: _itineraryRecordList![i].itineraryId ?? '',
                    ),
                  ),
                );
                print('Check id ${_itineraryRecordList![i].itineraryId}');
              },
              child: Container(
                height: 100,
                // width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: WeweyouColors.blackPrimary,
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: ImageNetworkFunction(
                            height: 80,
                            width: 110,
                            imagePath: NetworkImage(
                              _itineraryRecordList![i].image ?? '',
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
                                borderRadius: BorderRadius.circular(4)),
                            child: Text(
                              outputDate,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              subHeadingText(
                                title: _itineraryRecordList![i].title ?? '',
                                fontSize: 16,
                              ),
                              sizedBox(),
                              const Icon(
                                Icons.favorite_rounded,
                                size: 20,
                                color: WeweyouColors.customPureWhite,
                              ),
                            ],
                          ),
                          sizedBox(height: 5),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 22,
                                  color: WeweyouColors.secondaryOrange,
                                ),
                                Flexible(
                                  child: Text(
                                    _itineraryRecordList![i].location ?? '',
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
                          sizedBox(height: 5),
                          // CustomText(
                          //   initialText:
                          //       "${_itineraryList[i]['tickets_count'] ?? ""} Tickets",
                          // )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
