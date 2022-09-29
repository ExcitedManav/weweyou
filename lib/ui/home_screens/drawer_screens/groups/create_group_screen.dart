import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weweyou/data/networking/api_end_point.dart';
import 'package:weweyou/ui/home_screens/create_event/widgets/customContainer.dart';
import 'package:weweyou/ui/home_screens/drawer_screens/my_events/widgets/secondary_app_bar.dart';
import 'package:weweyou/ui/utils/common_button.dart';
import 'package:weweyou/ui/utils/common_text_style.dart';
import 'package:weweyou/ui/utils/constant.dart';
import 'package:weweyou/ui/utils/input_text_field.dart';

import '../../../../data/models/onboarding_models/categoryModel.dart';
import '../../../../data/networking/api_provider.dart';
import '../../../utils/common_drop_down.dart';
import '../../../utils/common_widgets.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  @override
  initState() {
    getCategories();
    super.initState();
  }

  final ImagePicker _imagePicker = ImagePicker();
  bool loadingCatList = true;

  final ApiEndPoint _apiEndPoint = ApiEndPoint();
  List<CategoryData> _catList = [];
  List<String> _catNameList = [];
  String? selectedCategory;
  int? selectedCategoryId;
  File? pickedImage;

  getCategories() async {
    loadingCatList = true;
    try {
      Dio dio = Dio();
      final response = await dio.get(
        baseUrl + ApiEndPoint.GETCATOGORIES,
        options: Options(
          responseType: ResponseType.json,
          method: 'Get',
          contentType: 'application/json',
          validateStatus: (status) => true,
        ),
      );
      if (response.statusCode == 200 && response.data['status'] == true) {
        CategoryModel categoryModel = CategoryModel.fromJson(response.data);
        _catList = categoryModel.categoryData;
        print('Cat data ${response.data}');
        _catNameList = _catList.map((e) => e.nameEN!).toList();
        loadingCatList = false;
        if (mounted) setState(() {});
      } else {
        loadingCatList = false;
        if (mounted) setState(() {});
        showToast(
          toastMsg: response.data['message'],
          backgroundColor: WeweyouColors.primaryDarkRed,
        );
      }
    } catch (e) {
      loadingCatList = false;
      if (mounted) setState(() {});
      debugPrint(e.toString());
      showToast(
        toastMsg: e.toString(),
        backgroundColor: WeweyouColors.primaryDarkRed,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: WeweyouColors.blackBackground,
      appBar: PreferredSize(
        preferredSize: Size(
          size.width,
          100,
        ),
        child: const SecondaryAppBar(
          appBarName: 'Create Group',
        ),
      ),
      bottomNavigationBar: loadingCatList == false
          ? Container(
              margin: const EdgeInsets.only(top: 130),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: WeweyouColors.blackBackground,
                borderRadius: BorderRadius.circular(15),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 150),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    commonText(
                      text: 'Select Picture',
                      fontSize: 16,
                      fontColor: WeweyouColors.greyPrimary,
                    ),
                    sizedBox(),
                    pickedImage == null
                        ? GestureDetector(
                            onTap: () => _imagePickerBottomSheet(context),
                            child: Container(
                              height: 115,
                              width: size.width,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: WeweyouColors.blackPrimary,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.cloud_upload_sharp,
                                    color: WeweyouColors.primaryDarkRed,
                                    size: 26,
                                  ),
                                  sizedBox(height: 5),
                                  commonText(
                                    text: 'Upload item',
                                    fontColor: WeweyouColors.primaryDarkRed,
                                    fontSize: 14,
                                  )
                                ],
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 230,
                            width: size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Image.file(
                                  height: 170,
                                  width: size.width,
                                  fit: BoxFit.fill,
                                  File(pickedImage!.path),
                                ),
                                TextButton(
                                  onPressed: () {
                                    pickedImage = null;
                                    if(mounted)setState((){});
                                  },
                                  child: Text(
                                    'Try Another Image?',
                                    style: poppinsRegular(
                                      fontSize: 16,
                                      fontColor: WeweyouColors.primaryDarkRed,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    sizedBox(height: 25),
                    commonText(
                      text: 'Enter Information',
                      fontSize: 16,
                      fontColor: WeweyouColors.greyPrimary,
                    ),
                    sizedBox(),
                    CustomFormField(
                      controller: TextEditingController(),
                      hintText: 'Enter Group Name',
                    ),
                    sizedBox(),
                    CustomFormField(
                      controller: TextEditingController(),
                      hintText: 'Enter Member Limit',
                    ),
                    sizedBox(),
                    Container(
                      height: 50,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: WeweyouColors.blackPrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: commonText(
                        text: 'Administrator name',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontColor: WeweyouColors.greyPrimary,
                      ),
                    ),
                    sizedBox(),
                    _catNameList.isNotEmpty
                        ? CommonDropDown(
                            hintText: 'Select Category',
                            selectedValue: selectedCategory ?? _catNameList[0],
                            items: _catNameList.map((String catName) {
                              return DropdownMenuItem(
                                value: catName,
                                child: Text(
                                  catName,
                                  style: poppinsRegular(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontColor: WeweyouColors.customPureWhite,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              selectedCategory = value;
                              final result = _catList.firstWhere(
                                  (element) => element.nameEN == value);
                              selectedCategoryId = result.id;
                              print('Check Result ${result.id.toString()}');
                              print(
                                  'Check Result selectedCatId $selectedCategoryId');
                              if (mounted) setState(() {});
                            },
                          )
                        : const SizedBox.shrink(),
                    sizedBox(),
                    CustomFormField(
                      controller: TextEditingController(),
                      hintText: 'Description',
                      maxLine: 3,
                    ),
                    sizedBox(height: 60),
                    CommonButton(
                      onPressed: () {},
                      buttonName: 'Create Group',
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: CupertinoActivityIndicator(
                color: WeweyouColors.customPureWhite,
                radius: 20,
              ),
            ),
    );
  }

  void _imagePickerBottomSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) {
        return CupertinoActionSheet(
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.pop(context);
                final XFile? file =
                    await _imagePicker.pickImage(source: ImageSource.camera);
                if (file != null) {
                  pickedImage = File(file.path);
                  if (mounted) setState(() {});
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.camera_alt_outlined,
                    size: 22,
                    color: Colors.black,
                  ),
                  sizedBox(width: 5),
                  Text(
                    'Camera',
                    style: poppinsRegular(
                      fontSize: 16,
                      fontColor: WeweyouColors.blackPrimary,
                    ),
                  ),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                final XFile? file = await _imagePicker.pickImage(
                  source: ImageSource.gallery,
                );
                if (file != null) {
                  pickedImage = File(file.path);
                  if (mounted) setState(() {});
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.photo_library_rounded,
                    size: 22,
                    color: Colors.black,
                  ),
                  sizedBox(width: 5),
                  Text(
                    'Gallery',
                    style: poppinsRegular(
                      fontSize: 16,
                      fontColor: WeweyouColors.blackPrimary,
                    ),
                  ),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: poppinsRegular(fontSize: 16, fontColor: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}
