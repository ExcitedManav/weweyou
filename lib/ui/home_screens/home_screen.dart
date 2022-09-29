import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:weweyou/data/models/onboarding_models/popular_events_model.dart';
import 'package:weweyou/data/networking/api_end_point.dart';
import 'package:weweyou/data/networking/api_provider.dart';
import 'package:weweyou/data/networking/shared_pref.dart';

import 'package:weweyou/ui/home_screens/widgets/image_network_function.dart';
import 'package:weweyou/ui/utils/common_loader.dart';
import 'package:weweyou/ui/utils/common_text_style.dart';
import 'package:weweyou/ui/utils/constant.dart';

import '../../data/models/onboarding_models/categoryModel.dart';
import '../utils/common_widgets.dart';
import 'create_event/widgets/location_access_popup.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.email}) : super(key: key);
  static const String route = '/homeRoute';
  final String email;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String networkUrl =
      'https://media.istockphoto.com/photos/party-people-enjoy-concert-at-festival-summer-music-festival-picture-id1324561072?b=1&k=20&m=1324561072&s=170667a&w=0&h=LwWrgpVzxoznttv_6qXMVtZHer1QSLNbfHmORZCFhN0=';

  List<CategoryData> _categoryData = [];
  List<Record> _popularEventData = [];
  final TextEditingController _locationController = TextEditingController();
  bool loader = true;
  bool emptyData = false;
  String? finalLocation;

  @override
  void initState() {
    locationChecker();
    categoryList();
    super.initState();
  }

  locationChecker() async {
    finalLocation = await getLocation();
    if (finalLocation == null) {
      Future.delayed(
        const Duration(seconds: 1),
        () => userLocationPermission(context, () async {
          loader = false;
          Navigator.pop(context);
          LocationResult? result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PlacePicker(
                mapApiKey,
              ),
            ),
          );
          if (result != null) {
            _locationController.text = result.formattedAddress.toString();
            setLocation(_locationController.text);
            sendLocation(_locationController.text);
          } else {
            sendLocation('');
          }
        }, () async {
          loader = false;
          Navigator.pop(context);
          sendLocation('');
        }),
      );
    } else {
      setLocation(finalLocation!);
      sendLocation(finalLocation!);
    }
  }

  sendLocation(String location) async {
    loader = true;
    try {
      Dio dio = Dio();
      var response = await dio.post(
        baseUrl + ApiEndPoint.POPULAREVENTSURL,
        data: jsonEncode({"location": location}),
        options: Options(
          method: 'POST',
          responseType: ResponseType.json,
          validateStatus: (status) => true,
          contentType: 'application/json',
        ),
      );
      debugPrint(
          "Error this side ${response.statusCode} ${response.data['status']}");
      if (response.statusCode == 200 && response.data['status'] == true) {
        PopularEventModel popularEventModel =
            PopularEventModel.fromJson(response.data);
        _popularEventData = popularEventModel.record!;
        debugPrint('Success popular events ${response.data['message']}');
        loader = false;
        if (mounted) setState(() {});
      } else {
        loader = false;
        debugPrint('Error popular events ${response.data['message']}');
        showToast(
          toastMsg: "${response.data['message']}",
          backgroundColor: WeweyouColors.secondaryLightRed,
        );
      }
    } catch (e) {
      loader = false;
      showToast(
        toastMsg: e.toString(),
        backgroundColor: WeweyouColors.secondaryLightRed,
      );
      debugPrint("Error this side $e");
    }
    if (mounted) setState(() {});
  }

  categoryList() async {
    try {
      Dio dio = Dio();
      var response = await dio.get(
        baseUrl + ApiEndPoint.GETCATOGORIES,
        options: Options(
            method: 'GET',
            responseType: ResponseType.json,
            validateStatus: (status) => true,
            contentType: 'application/json'),
      );
      debugPrint("Response ${response.statusCode} ${response.data}");
      if (response.statusCode == 200 && response.data['status'] == true) {
        CategoryModel user = CategoryModel.fromJson(response.data);
        _categoryData = user.categoryData;
        if (mounted) setState(() {});
      } else {
        showToast(
          toastMsg: "${response.data['message']}",
          backgroundColor: WeweyouColors.secondaryLightRed,
        );
      }
    } catch (e) {
      showToast(
        toastMsg: e.toString(),
        backgroundColor: WeweyouColors.secondaryLightRed,
      );
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: WeweyouColors.lightBlackColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DO NOT MISS THEM',
              style: poppinsBold(
                fontSize: 17,
              ),
            ),
            sizedBox(),
            SizedBox(
              height: 230,
              width: size.width,
              child: ListView.separated(
                itemBuilder: (ctx, i) {
                  return ImageNetworkFunction(
                    imagePath: NetworkImage(networkUrl),
                    width: size.width * 0.8,
                  );
                },
                separatorBuilder: (ctx, i) => sizedBox(),
                itemCount: 4,
                scrollDirection: Axis.horizontal,
              ),
            ),
            sizedBox(height: 20),
            loader == false
                ? _popularEventData.isNotEmpty
                    ? Column(
                        children: [
                          eventsCat(
                            title1: 'POPULAR EVENTS',
                            title2: 'See All',
                            onPressed: () {},
                          ),
                          customListView(itemCount: _popularEventData.length),
                          sizedBox(height: 25),
                          eventsCat(
                            title1: 'ITINERARY OF THE WEEK',
                            title2: 'See All',
                            onPressed: () {},
                          ),
                          Text(
                            'November 21-27',
                            style: poppinsRegular(
                              fontSize: 16,
                            ),
                          ),
                          sizedBox(height: 10),
                          customListView(itemCount: 5),
                          eventsCat(
                            title1: 'EVENTS BY CATEGORY',
                            onPressed: () {},
                          ),
                        ],
                      )
                    : Text(
                        'No popular Events to your nearest location',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: poppinsSemiBold(fontSize: 18),
                      )
                : const CommonLoader(),
            sizedBox(),
            GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                childAspectRatio: 1 / 1.1,
              ),
              itemCount: _categoryData.length,
              itemBuilder: (ctx, i) {
                final url = _categoryData[i].imageAdditional!;
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: WeweyouColors.blackPrimary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: size.height * 0.15,
                          width: size.width * 0.42,
                          child: ImageNetworkFunction(
                            imagePath: NetworkImage(
                              "http://$url",
                            ),
                          ),
                        ),
                      ),
                      sizedBox(),
                      Expanded(
                        flex: 1,
                        child: Text(
                          _categoryData[i].categoryCardNameEN!,
                          // maxLines: ,
                          overflow: TextOverflow.ellipsis,
                          style: poppinsRegular(
                            fontColor: WeweyouColors.customPureWhite,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  eventsCat({
    required String title1,
    String? title2,
    required VoidCallback onPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title1,
          style: poppinsBold(
            fontSize: 17,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            title2 ?? '',
            style: poppinsRegular(
              fontSize: 17,
              fontColor: WeweyouColors.secondaryOrange,
              fontWeight: FontWeight.w500,
            ).copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
        )
      ],
    );
  }

  customListView({required int itemCount}) {
    return SizedBox(
      height: 260,
      width: MediaQuery.of(context).size.width,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, i) {
          final inputDateFormat = DateFormat('dd/mm/yyyy');
          final parsed =
              inputDateFormat.parse(_popularEventData[i].startDate ?? '');
          final outputDateFormat = DateFormat('dd MMM yyyy');
          final formattedDate = outputDateFormat.format(parsed);
          debugPrint(_popularEventData[i].eventImage);
          return Container(
            // height: 190,
            width: MediaQuery.of(context).size.width * 0.55,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 15, bottom: 10),
            decoration: BoxDecoration(
              color: WeweyouColors.blackPrimary,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 130,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.55,
                  // margin: const EdgeInsets.all(7),
                  child: Stack(
                    children: [
                      ImageNetworkFunction(
                        width: 250,
                        imagePath: NetworkImage(
                          // "http://${_popularEventData[i].eventImage}",
                          "${_popularEventData[i].eventImage}",
                        ),
                      ),
                      Positioned(
                        top: 10,
                        child: Container(
                          height: 22,
                          alignment: Alignment.center,
                          color: WeweyouColors.secondaryOrange,
                          width: 80,
                          child: Text(
                            formattedDate,
                            style: poppinsRegular(
                              fontSize: 10,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                sizedBox(height: 5),
                Text(
                  _popularEventData[i].eventTitle ?? '',
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: poppinsBold(fontSize: 16),
                ),
                sizedBox(height: 5),
                Expanded(
                  child: Row(
                    children: [
                      Image.asset(
                        AppIcons.location,
                        height: 22,
                        width: 22,
                      ),
                      sizedBox(width: 5),
                      Flexible(
                        child: Text(
                          _popularEventData[i].location ?? "",
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: poppinsRegular(
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                sizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '13 Tickets',
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: poppinsRegular(
                          fontSize: 14, fontColor: WeweyouColors.greyPrimary),
                    ),
                    sizedBox(width: 5),
                    Text(
                      '3 Subs',
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: poppinsRegular(
                        fontSize: 14,
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
        separatorBuilder: (ctx, i) => sizedBox(),
        itemCount: itemCount,
      ),
    );
  }
}
