import 'package:flutter/material.dart';

import '../../../utils/common_text_style.dart';
import '../../../utils/constant.dart';
import '../../../utils/custom_app_bar.dart';
import '../../create_event/widgets/common_widgets_create_event.dart';
import '../../widgets/image_network_function.dart';
import '../accounts/widgets/custom_text.dart';

class FavoriteListScreen extends StatefulWidget {
  const FavoriteListScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteListScreen> createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends State<FavoriteListScreen> {
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
                  title: 'Events',
                  onPressed: () {
                    selectIndex = 1;
                    if (mounted) setState(() {});
                  },
                  index: 1,
                ),
                sizedBox(width: 10),
                _customContainer(
                  title: 'Subs',
                  onPressed: () {
                    selectIndex = 2;
                    if (mounted) setState(() {});
                  },
                  index: 2,
                ),
                sizedBox(width: 10),
                _customContainer(
                  title: 'Groups',
                  onPressed: () {
                    selectIndex = 3;
                    if (mounted) setState(() {});
                  },
                  index: 3,
                ),
                sizedBox(width: 10),
                _customContainer(
                  title: 'Itinerarie',
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
            createdList()
          ],
        ),
      ),
    );
  }

  int selectedCategoryEvent(i) {
    if (i == 1) {
      i = _createdList.length;
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
          return selectIndex == 1
              ? GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => EventDetailScreen(
                    //       eventDetails: _createdList[i],
                    //     ),
                    //   ),
                    // );
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
                                  _createdList[i]['image'] ?? '',
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
        i = 'Events';
        break;
      case 2:
        i = 'Subs';
        break;
      case 3:
        i = 'Groups';
        break;
      case 4:
        i = 'Itineraries';
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
