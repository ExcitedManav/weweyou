import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:weweyou/ui/home_screens/home_screen.dart';
import 'package:weweyou/ui/home_screens/widgets/image_network_function.dart';
import 'package:weweyou/ui/utils/common_button.dart';
import 'package:weweyou/ui/utils/common_text_style.dart';
import 'package:weweyou/ui/utils/constant.dart';

import '../../../data/models/onboarding_models/categoryModel.dart';
import '../../../data/networking/api_end_point.dart';
import '../../../data/networking/api_provider.dart';
import '../../home_screens/drawer_screens/drawer_screen.dart';
import '../../utils/common_widgets.dart';

class SelectCategoryScreen extends StatefulWidget {
  SelectCategoryScreen({Key? key, required this.email}) : super(key: key);
  static const String route = '/categoryScreenRoute';
  final String email;

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  List<CategoryData> _categoryData = [];

  bool _selectedCat = false;
  bool loader = true;

  List<int> _listIdCat = [];

  final ApiProvider _apiProvider = ApiProvider();
  final ApiEndPoint _apiEndPoint = ApiEndPoint();
  final CommonProgress _commonProgress = CommonProgress();

  @override
  void initState() {
    categoryList();
    debugPrint("list Id cat $_listIdCat");
    super.initState();
  }

  categoryList() async {
    loader = true;
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
        loader = false;
        if (mounted) setState(() {});
      } else {
        loader = false;
        showToast(
            toastMsg: "${response.data['message']}",
            backgroundColor: WeweyouColors.secondaryLightRed);
      }
    } catch (e) {
      loader = false;
      showToast(
          toastMsg: e.toString(),
          backgroundColor: WeweyouColors.secondaryLightRed);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: WeweyouColors.primaryDarkRed,
          appBar: AppBar(
            toolbarHeight: 100,
            backgroundColor: WeweyouColors.primaryDarkRed,
            title: headingText(
              heading: 'select_cat.heading'.tr(),
              fontSize: 22,
            ),
            automaticallyImplyLeading: false,
          ),
          bottomNavigationBar: Container(
            color: WeweyouColors.blackBackground,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: CommonButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                if (_listIdCat.isNotEmpty && _listIdCat.length >= 2) {
                  final ProgressDialog pr =
                      _commonProgress.commonProgressIndicator(
                    context: context,
                    loadingMsg: "select_cat.loader_text".tr(),
                  );
                  Dio dio = Dio();
                  Map<String, String> headers = {
                    'Content-Type': "application/json",
                  };
                  final response = await dio.post(
                    baseUrl + ApiEndPoint.SAVECATEGORY,
                    data: jsonEncode(
                      {
                        "email": widget.email,
                        "category_id": _listIdCat,
                      },
                    ),
                    options: Options(
                      responseType: ResponseType.json,
                      method: "POST",
                      headers: headers,
                      validateStatus: (status) => true,
                    ),
                  );
                  if (response.statusCode == 200 &&
                      response.data['status'] == true) {
                    try {
                      SaveCategoryModel categoryModel =
                          SaveCategoryModel.fromJson(response.data);
                      pr.close();
                      navigator.pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const DrawerScreen(),
                        ),
                      );
                      pr.close();
                      showToast(
                        toastMsg: '${response.data['message']}',
                        backgroundColor: Colors.green,
                      );
                    } catch (e) {
                      pr.close();
                      showToast(
                        toastMsg: "${response.data['message']}",
                        backgroundColor: WeweyouColors.secondaryLightRed,
                      );
                      debugPrint(e.toString());
                    }
                  } else {
                    pr.close();
                    showToast(
                      toastMsg: "${response.data['message']}",
                      backgroundColor: WeweyouColors.secondaryLightRed,
                    );
                  }
                } else {
                  showToast(
                    toastMsg: 'select_cat.validator_toast'.tr(),
                  );
                }
              },
              buttonName: 'select_cat.select_btn'.tr(),
              padding: const EdgeInsets.only(left: 20, right: 20),
              width: MediaQuery.of(context).size.width * 0.7,
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: WeweyouColors.blackBackground,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headingText2(
                    heading2: "select_cat.sub_heading".tr(),
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                  sizedBox(),
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      // physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20.0,
                        mainAxisSpacing: 20.0,
                        childAspectRatio: 1 / 1.1,
                      ),
                      itemCount: _categoryData.length,
                      itemBuilder: (ctx, i) {
                        final url = _categoryData[i].imageAdditional!;
                        return InkWell(
                          onTap: () {
                            _selectedCat =
                                _listIdCat.contains(_categoryData[i].id!)
                                    ? false
                                    : true;
                            if (_selectedCat == true) {
                              _listIdCat.add(_categoryData[i].id!);
                            } else {
                              _listIdCat.removeWhere(
                                  (item) => item == _categoryData[i].id);
                            }
                            if (mounted) setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: WeweyouColors.blackPrimary,
                              borderRadius:
                                  _listIdCat.contains(_categoryData[i].id!)
                                      ? BorderRadius.circular(10)
                                      : null,
                              border: _listIdCat.contains(_categoryData[i].id!)
                                  ? Border.all(
                                      color: WeweyouColors.secondaryOrange,
                                      width: 2.0)
                                  : null,
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
                          ),
                        );
                      },
                    ),
                  ),
                  // GridView.builder(
                  //   shrinkWrap: true,
                  //   gridDelegate:
                  //       const SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 2,
                  //     crossAxisSpacing: 15,
                  //     mainAxisSpacing: 15,
                  //     childAspectRatio: 1 / 1.1,
                  //   ),
                  //   itemCount: _categoryData.length,
                  //   itemBuilder: (ctx, i) {
                  //     final url = _categoryData[i].imageAdditional;
                  //     return Container(
                  //       // height: size.height*0.3,
                  //       decoration: BoxDecoration(
                  //         borderRadius:
                  //             _listIdCat.contains(_categoryData[i].id!)
                  //                 ? BorderRadius.circular(10)
                  //                 : null,
                  //         border: _listIdCat.contains(_categoryData[i].id!)
                  //             ? Border.all(
                  //                 color: WeweyouColors.secondaryOrange,
                  //                 width: 2.0)
                  //             : null,
                  //       ),
                  //       child: InkWell(
                  //         onTap: () {
                  //           _selectedCat =
                  //               _listIdCat.contains(_categoryData[i].id!)
                  //                   ? false
                  //                   : true;
                  //           if (_selectedCat == true) {
                  //             _listIdCat.add(_categoryData[i].id!);
                  //           } else {
                  //             _listIdCat.removeWhere(
                  //                 (item) => item == _categoryData[i].id);
                  //           }
                  //           if (mounted) setState(() {});
                  //         },
                  //         child: Container(
                  //           padding: const EdgeInsets.symmetric(
                  //             horizontal: 4,
                  //             vertical: 4,
                  //           ),
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(10),
                  //             color: Colors.black,
                  //           ),
                  //           // height: size.height * 0.25,
                  //           // width: size.width * 0.42,
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Expanded(
                  //                 child: Container(
                  //                   margin: const EdgeInsets.symmetric(
                  //                       horizontal: 2),
                  //                   height: size.height * 0.15,
                  //                   width: size.width * 0.42,
                  //                   child: ClipRRect(
                  //                     borderRadius: BorderRadius.circular(5),
                  //                     child: ImageNetworkFunction(
                  //                       imagePath: NetworkImage(
                  //                         "https://$url",
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //               sizedBox(height: 5),
                  //               Container(
                  //                 margin:
                  //                     const EdgeInsets.symmetric(horizontal: 2),
                  //                 // height: size.height * 0.05,
                  //                 width: size.width * 0.42,
                  //                 child: Expanded(
                  //                   child: Text(
                  //                     _categoryData[i].categoryCardNameEN ?? "",
                  //                     overflow: TextOverflow.ellipsis,
                  //                     style: const TextStyle(
                  //                       color: WeweyouColors.customPureWhite,
                  //                       fontSize: 14,
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // )
                ],
              ),
            ),
          ),
        ),
        if (loader == true)
          const Center(
            child: CupertinoActivityIndicator(
              color: WeweyouColors.customPureWhite,
              radius: 18,
            ),
          )
      ],
    );
  }
}
