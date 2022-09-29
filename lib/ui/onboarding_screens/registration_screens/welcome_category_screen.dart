import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weweyou/data/models/onboarding_models/categoryModel.dart';
import 'package:weweyou/ui/utils/common_button.dart';
import 'package:weweyou/ui/utils/common_drop_down.dart';
import 'package:weweyou/ui/utils/constant.dart';

import '../../../data/networking/api_end_point.dart';
import '../../../data/networking/api_provider.dart';
import '../../utils/common_widgets.dart';

class WelcomeCategoryScreen extends StatefulWidget {
  const WelcomeCategoryScreen({Key? key}) : super(key: key);
  static const String route = '/welcomeScreen';

  @override
  State<WelcomeCategoryScreen> createState() => _WelcomeCategoryScreenState();
}

class _WelcomeCategoryScreenState extends State<WelcomeCategoryScreen> {
  String welcomeText =
      'We would like to get to know you better and help find the best events matching with what you love!';

  final List<String> currency = [
    'USD',
    'EUR',
    'CHF',
  ];
  final List<String> langauge = [
    'English',
    'Francais',
  ];

  List<CategoryData> _categoryData = [];
  String? selectedLangauge;
  String? selectedCurrency;

  bool _selectedCat = false;

  List<int> _listIdCat = [];

  @override
  void initState() {
    categoryList();
    debugPrint("list Id cat $_listIdCat");
    super.initState();
  }

  categoryList() async {
    Dio dio = Dio();
    var response = await dio.get(
      baseUrl + ApiEndPoint.GETCATOGORIES,
      options: Options(
          method: 'GET',
          responseType: ResponseType.json,
          validateStatus: (status) => true,
          contentType: 'application/json'),
    );
    print("repsonse ${response.statusCode} ${response.data}");
    if (response.statusCode == 200) {
      try {
        CategoryModel user = CategoryModel.fromJson(response.data);
        _categoryData = user.categoryData;
        if (mounted) setState(() {});
      } catch (e) {
        showToast(
            toastMsg: e.toString(),
            backgroundColor: WeweyouColors.secondaryLightRed);
      }
    } else {
      final snackBar = SnackBar(
        content: Text("${response.data['message']}"),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double buttonMargin = MediaQuery.of(context).size.width * 0.15;
    return Scaffold(
      backgroundColor: WeweyouColors.lightBlackColor,
      bottomNavigationBar: CommonButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => HomeScreen(),
          //   ),
          // );
          debugPrint("_listIdCat.toString()");
          debugPrint(_listIdCat.toString());
        },
        buttonName: 'SAVE PROFILE',
        backgroundColor: WeweyouColors.secondaryLightRed,
        textColor: WeweyouColors.customPureWhite,
        margin: EdgeInsets.only(
            left: buttonMargin, right: buttonMargin, bottom: 10),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/images_icons/onboarding/welcome_lamps.svg',
              color: Colors.white,
            ),
            Image.asset('assets/images_icons/onboarding/Welcome.png'),
            const SizedBox(height: 25),
            Text(
              welcomeText,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              textScaleFactor: 1.1,
              style: const TextStyle(
                color: WeweyouColors.customPureWhite,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Language',
                      style: TextStyle(
                        color: WeweyouColors.customPureWhite,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CommonDropDown(
                      hintText: langauge[0],
                      items: langauge
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      selectedValue: selectedLangauge ?? langauge[0],
                      onChanged: (value) {
                        setState(() {
                          selectedLangauge = value as String;
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Currency',
                      style: TextStyle(
                        color: WeweyouColors.customPureWhite,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CommonDropDown(
                      hintText: currency[0],
                      items: currency
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      selectedValue: selectedCurrency ?? currency[0],
                      onChanged: (value) {
                        setState(() {
                          selectedCurrency = value as String;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Preferred Categories',
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: WeweyouColors.customPureWhite),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (ctx, i) {
                    final url = _categoryData[i].imageAdditional;
                    return ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      shape: _listIdCat.contains(_categoryData[i].id!)
                          ? RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                  color: WeweyouColors.customPureWhite, width: 1),
                            )
                          : null,
                      onTap: () {
                        _selectedCat = _listIdCat.contains(_categoryData[i].id!)
                            ? false
                            : true;
                        print('selected cat check $_selectedCat');
                        if (_selectedCat == true) {
                          _listIdCat.add(_categoryData[i].id!);
                        } else {
                          _listIdCat.removeWhere(
                              (item) => item == _categoryData[i].id);
                        }
                        if (mounted) setState(() {});
                      },
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          "https://$url",
                        ),
                      ),
                      title: Text(
                        _categoryData[i].categoryCardNameEN ?? "",
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  },
                  separatorBuilder: (ctx, i) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: _categoryData.length),
            )
          ],
        ),
      ),
    );
  }
}
