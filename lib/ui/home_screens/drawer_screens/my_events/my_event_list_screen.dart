import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:weweyou/data/networking/networking.dart';
import 'package:weweyou/pagination_test.dart';
import 'package:http/http.dart' as http;
import 'package:weweyou/ui/home_screens/create_event/widgets/common_widgets_create_event.dart';
import 'package:weweyou/ui/home_screens/drawer_screens/accounts/widgets/custom_text.dart';
import 'package:weweyou/ui/home_screens/drawer_screens/my_events/event_detail_page.dart';
import 'package:weweyou/ui/utils/common_text_style.dart';
import 'package:weweyou/ui/utils/constant.dart';

import '../../../../data/models/onboarding_models/popular_events_model.dart';
import '../../../../data/networking/api_end_point.dart';
import '../../../../data/networking/api_provider.dart';
import '../../../../data/networking/shared_pref.dart';
import '../../widgets/image_network_function.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({Key? key}) : super(key: key);

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  int? selectIndex = 1;

  final List<Map<String, String>> _createdList = [
    {
      "image":
          "https://media.istockphoto.com/photos/people-with-raised-hands-silhouettes-of-concert-crowd-in-front-of-picture-id1305092162?b=1&k=20&m=1305092162&s=170667a&w=0&h=boiLTNGUKNNWmJepPA-mjexNcXbcXlLjunqninvMl0w=",
      "event_name": "Created List",
      "location": "Chavvni Murai Mohlla, Indore ",
      "tickets_count": "13 ",
      "created_date": "13 July 2022"
    },
  ];
  final List<Map<String, String>> _joinedList = [
    {
      "image":
          "https://media.istockphoto.com/photos/people-with-raised-hands-silhouettes-of-concert-crowd-in-front-of-picture-id1305092162?b=1&k=20&m=1305092162&s=170667a&w=0&h=boiLTNGUKNNWmJepPA-mjexNcXbcXlLjunqninvMl0w=",
      "event_name": "Joined",
      "location": "Chavvni, Indore ",
      "tickets_count": "14 ",
      "created_date": "14 July 2022"
    },
  ];
  final List<Map<String, String>> _myOrdersList = [
    {
      "image":
          "https://media.istockphoto.com/photos/people-with-raised-hands-silhouettes-of-concert-crowd-in-front-of-picture-id1305092162?b=1&k=20&m=1305092162&s=170667a&w=0&h=boiLTNGUKNNWmJepPA-mjexNcXbcXlLjunqninvMl0w=",
      "event_name": "My Orders",
      "location": "Chavvni Murai Mohlla 9/4, Indore ",
      "tickets_count": "15 ",
      "created_date": "15 July 2022"
    },
  ];
  final List<Map<String, String>> _joiningReqList = [
    {
      "image":
          "https://media.istockphoto.com/photos/people-with-raised-hands-silhouettes-of-concert-crowd-in-front-of-picture-id1305092162?b=1&k=20&m=1305092162&s=170667a&w=0&h=boiLTNGUKNNWmJepPA-mjexNcXbcXlLjunqninvMl0w=",
      "event_name": "Joining Request",
      "location": "Chavvni Murai Mohlla Gupta Garden, Indore ",
      "tickets_count": "16 ",
      "created_date": "16 July 2022"
    },
  ];

  static const _pageSize = 8;
  static int _page = 0;
  final PagingController<int, CreatedAllEvent> _pagingController =
      PagingController(firstPageKey: _page);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  List<CreatedAllEvent> _post = [];

  Future<void> _fetchPage(int pageKey) async {
    try {
      var url = "${baseUrl + ApiEndPoint.CREATEDEVENTLIST}?page=$pageKey";
      debugPrint("Url ----> $url");
      var token = await getAuthToken();
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': "Bearer $token",
        "X-localization": "en",
      });
      var data = jsonDecode(response.body);
      CreatedEventListModel createdEventListModel =
          CreatedEventListModel.fromJson(data);
      _post = createdEventListModel.record!.allEvent!;
      debugPrint("Event list $_post");
      final isLastPage = _post.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(_post);
      } else {
        _page += 1;
        // final nextPageKey = _page + _post.length;
        _pagingController.appendPage(_post, _page);
      }
      if (mounted) setState(() {});
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: WeweyouColors.blackBackground,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _customContainer(
                  title: 'Created',
                  onPressed: () {
                    selectIndex = 1;
                    if (mounted) setState(() {});
                  },
                  index: 1,
                ),
                sizedBox(width: 10),
                _customContainer(
                  title: 'Joined',
                  onPressed: () {
                    selectIndex = 2;
                    if (mounted) setState(() {});
                  },
                  index: 2,
                ),
                sizedBox(width: 10),
                _customContainer(
                  title: 'My Orders',
                  onPressed: () {
                    selectIndex = 3;
                    if (mounted) setState(() {});
                  },
                  index: 3,
                ),
                sizedBox(width: 10),
                _customContainer(
                  title: 'Joining Requests',
                  onPressed: () {
                    selectIndex = 4;
                    if (mounted) setState(() {});
                    print(
                        'Cheek Tejsavi ${checkBannerName(selectIndex).toString()}');
                  },
                  index: 4,
                ),
              ],
            ),
            sizedBox(),
            headingText(
              heading: checkBannerName(selectIndex).toString(),
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
            sizedBox(height: 20),
            Expanded(
              child: PagedListView<int, CreatedAllEvent>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<CreatedAllEvent>(
                  itemBuilder: (context, item, i) {
                    final inputDateFormat = DateFormat("dd/mm/yyyy");
                    final parsedDate = inputDateFormat.parse(item.startDate!);
                    final outputDateFormat = DateFormat("dd MMM yyyy");
                    final outputDate = outputDateFormat.format(parsedDate);
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EventDetailScreen(
                              eventDetailsId: item.eventId,
                            ),
                          ),
                        );
                        print('id check ${item.eventId}');
                      },
                      child: Container(
                        height: 100,
                        margin: const EdgeInsets.symmetric(vertical: 5),
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
                                      item.eventImage ?? '',
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
                                      borderRadius: BorderRadius.circular(4),
                                    ),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Flexible(
                                        child: subHeadingText(
                                          title: item.eventTitle ?? "",
                                          fontSize: 16,
                                        ),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          size: 22,
                                          color: WeweyouColors.secondaryOrange,
                                        ),
                                        Flexible(
                                          child: Text(
                                            item.location ?? "",
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
                                  CustomText(
                                    initialText:
                                        item.ticketCount ?? "No Tickets",
                                  )
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
            ),
          ],
        ),
      ),
    );
  }

  int selectedCategoryEvent(i) {
    if (i == 1) {
      i = _post.length;
    } else if (i == 2) {
      i = _joinedList.length;
    } else if (i == 3) {
      i = _myOrdersList.length;
    } else if (i == 4) {
      i = _joiningReqList.length;
    } else {
      i = _createdList.length;
    }
    return i;
  }

  createdList() {
    return Expanded(
      child: ListView.builder(
        itemCount: selectedCategoryEvent(selectIndex),
        itemBuilder: (ctx, i) {
          debugPrint(selectedCategoryEvent(selectIndex).toString());
          debugPrint("selectedCategoryEvent(selectIndex).toString()");
          final inputDateFormat = DateFormat("dd/mm/yyyy");
          final parsedDate = inputDateFormat.parse(_post[i].startDate!);
          final outputDateFormat = DateFormat("dd MMM yyyy");
          final outputDate = outputDateFormat.format(parsedDate);

          return selectIndex == 1
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventDetailScreen(
                          eventDetailsId: _post[i],
                        ),
                      ),
                    );
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
                                  _post[i].eventImage ?? '',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  subHeadingText(
                                    title: _createdList[i]['event_name']
                                        .toString(),
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
                                        _createdList[i]['location'] ?? '',
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
                              CustomText(
                                initialText:
                                    "${_createdList[i]['tickets_count'] ?? ""} Tickets",
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : selectIndex == 2
                  ? Container(
                      height: 100,
                      // width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: WeweyouColors.blackPrimary,
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: ImageNetworkFunction(
                              height: 80,
                              width: 110,
                              imagePath: NetworkImage(
                                _joinedList[i]['image'] ?? '',
                              ),
                            ),
                          ),
                          sizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    subHeadingText(
                                      title: _joinedList[i]['event_name']
                                          .toString(),
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
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 22,
                                      color: WeweyouColors.secondaryOrange,
                                    ),
                                    Expanded(
                                      child: Text(
                                        _joinedList[i]['location'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        style: poppinsRegular(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                sizedBox(height: 5),
                                CustomText(
                                  initialText:
                                      "${_joinedList[i]['tickets_count'] ?? ""} Tickets",
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : selectIndex == 3
                      ? Container(
                          height: 100,
                          // width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: WeweyouColors.blackPrimary,
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: ImageNetworkFunction(
                                  height: 80,
                                  width: 110,
                                  imagePath: NetworkImage(
                                    _myOrdersList[i]['image'] ?? '',
                                  ),
                                ),
                              ),
                              sizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        subHeadingText(
                                          title: _myOrdersList[i]['event_name']
                                              .toString(),
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
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          size: 22,
                                          color: WeweyouColors.secondaryOrange,
                                        ),
                                        Expanded(
                                          child: Text(
                                            _myOrdersList[i]['location'] ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            style: poppinsRegular(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    sizedBox(height: 5),
                                    CustomText(
                                      initialText:
                                          "${_myOrdersList[i]['tickets_count'] ?? ""} Tickets",
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      : selectIndex == 4
                          ? Container(
                              height: 100,
                              // width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: WeweyouColors.blackPrimary,
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: ImageNetworkFunction(
                                      height: 80,
                                      width: 110,
                                      imagePath: NetworkImage(
                                        _joiningReqList[i]['image'] ?? '',
                                      ),
                                    ),
                                  ),
                                  sizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            subHeadingText(
                                              title: _joiningReqList[i]
                                                      ['event_name']
                                                  .toString(),
                                              fontSize: 16,
                                            ),
                                            sizedBox(),
                                            const Icon(
                                              Icons.favorite_rounded,
                                              size: 20,
                                              color:
                                                  WeweyouColors.customPureWhite,
                                            ),
                                          ],
                                        ),
                                        sizedBox(height: 5),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on_outlined,
                                                size: 22,
                                                color: WeweyouColors
                                                    .secondaryOrange,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  _joiningReqList[i]
                                                          ['location'] ??
                                                      '',
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                        CustomText(
                                          initialText:
                                              "${_joiningReqList[i]['tickets_count'] ?? ""} Tickets",
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          : sizedBox();
        },
      ),
    );
  }

  checkBannerName(i) {
    switch (i) {
      case 1:
        i = 'Created';
        break;
      case 2:
        i = 'Joined';
        break;
      case 3:
        i = 'My Orders';
        break;
      case 4:
        i = 'Joining Requests';
        break;
    }
    return i;
  }

  _customContainer({
    required String title,
    required VoidCallback onPressed,
    int? index,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: index == selectIndex
                ? WeweyouColors.primaryDarkRed
                : WeweyouColors.blackPrimary,
          ),
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: poppinsRegular(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
