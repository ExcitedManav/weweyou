import 'dart:io';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weweyou/data/networking/networking.dart';
import 'package:weweyou/ui/home_screens/widgets/image_network_function.dart';

import '../../../../data/models/onboarding_models/categoryModel.dart';
import '../../../../data/models/onboarding_models/itinerary_model.dart';
import '../../../../data/networking/api_end_point.dart';
import '../../../../data/networking/api_provider.dart';
import '../../../utils/common_button.dart';
import '../../../utils/common_drop_down.dart';
import '../../../utils/common_text_style.dart';
import '../../../utils/common_widgets.dart';
import '../../../utils/constant.dart';
import '../../../utils/input_text_field.dart';
import '../my_events/widgets/secondary_app_bar.dart';

class CreateItineraryScreen extends StatefulWidget {
  CreateItineraryScreen({Key? key, this.itineraryRecord}) : super(key: key);

  ItineraryRecordList? itineraryRecord;

  @override
  State<CreateItineraryScreen> createState() => _CreateItineraryScreenState();
}

class _CreateItineraryScreenState extends State<CreateItineraryScreen> {
  @override
  initState() {
    getCategories();
    setItineraryValues();
    super.initState();
  }

  final ImagePicker _imagePicker = ImagePicker();
  bool loadingCatList = true;

  List<CategoryData> _catList = [];
  List<String> _catNameList = [];
  String? selectedCategory;
  int? selectedCategoryId;
  File? pickedImage;
  String? selectedStartDate;
  String? selectedEndDate;
  String? mainDate;

  DateTime dateTime = DateTime.now();
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

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

  final TextEditingController _titleCont = TextEditingController();
  final TextEditingController _desCont = TextEditingController();

  final TextEditingController _selectedStartDateController =
      TextEditingController();
  final TextEditingController _selectedEndDateController =
      TextEditingController();

  final NetworkingFunctions _networkingFunctions = NetworkingFunctions();

  String? setDataDate;

  setItineraryValues() {
    if (widget.itineraryRecord != null) {
      selectedCategoryId = widget.itineraryRecord?.itineraryId;
      mainDate = widget.itineraryRecord?.mainDate;
      _titleCont.text = widget.itineraryRecord!.title!;
      _desCont.text = widget.itineraryRecord!.description!;
      _selectedStartDateController.text = widget.itineraryRecord!.startDate!;
      _selectedEndDateController.text = widget.itineraryRecord!.endDate!;
      final outputDate = DateFormat("dd/mm/yyyy");
      final parsedDate = outputDate.parse(mainDate!);
      final showDate = DateFormat("yyyy-mm-dd");
      final inputDate = showDate.format(parsedDate);
      setDataDate = inputDate;
      debugPrint("Check Date Here --->  $setDataDate");
      if (mounted) setState(() {});
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
        child: SecondaryAppBar(
          appBarName: widget.itineraryRecord== null
              ? 'Create Itinerary'
              : "Update Itinerary",
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
                      text: 'Select Date',
                      fontSize: 16,
                      fontColor: WeweyouColors.greyPrimary,
                    ),
                    sizedBox(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: WeweyouColors.blackPrimary,
                      ),
                      child: DatePicker(
                        DateTime.now(),
                        height: 100,
                        initialSelectedDate:
                            widget.itineraryRecord == null
                                ? DateTime.now()
                                : DateTime.parse(setDataDate!),
                        selectionColor: WeweyouColors.primaryDarkRed,
                        selectedTextColor: Colors.white,
                        deactivatedColor: Colors.white,
                        dateTextStyle: poppinsRegular(fontSize: 14),
                        dayTextStyle: poppinsRegular(fontSize: 14),
                        monthTextStyle: poppinsRegular(fontSize: 14),
                        onDateChange: (date) {
                          setState(() {
                            mainDate = dateFormat.format(date);
                          });
                        },
                      ),
                    ),
                    sizedBox(),
                    commonText(
                      text: 'Select Picture',
                      fontSize: 16,
                      fontColor: WeweyouColors.greyPrimary,
                    ),
                    sizedBox(),
                    widget.itineraryRecord == null
                        ? pickedImage == null
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
                                        text: 'Upload Image',
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
                                        if (mounted) setState(() {});
                                      },
                                      child: Text(
                                        'Try Another Image?',
                                        style: poppinsRegular(
                                          fontSize: 16,
                                          fontColor:
                                              WeweyouColors.primaryDarkRed,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                        : SizedBox(
                            height: 230,
                            width: size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ImageNetworkFunction(
                                  height: 170,
                                  width: size.width,
                                  fit: BoxFit.fill,
                                  imagePath: NetworkImage(
                                      widget.itineraryRecord!.image!),
                                ),
                                TextButton(
                                  onPressed: () {

                                    // final NetworkImage provider = NetworkImage(
                                    //     widget.itineraryRecord!.image!);
                                    // provider.evict().then<void>((bool success) {
                                    //   if (success) debugPrint('removed image!');
                                    // });
                                    if (mounted) setState(() {});
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
                      text: 'Enter Title',
                      fontSize: 16,
                      fontColor: WeweyouColors.greyPrimary,
                    ),
                    sizedBox(),
                    CustomFormField(
                      controller: _titleCont,
                      hintText: 'Enter Title',
                    ),
                    sizedBox(),
                    CustomFormField(
                      controller: _desCont,
                      hintText: 'Enter Brief Description',
                      maxLine: 3,
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
                              if (mounted) setState(() {});
                            },
                          )
                        : const SizedBox.shrink(),
                    sizedBox(),
                    CustomFormField(
                      controller: _selectedStartDateController,
                      hintText: 'Start Date',
                      readOnly: true,
                      onPressed: () async {
                        DateTime? result = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );
                        if (result != null) {
                          _selectedStartDateController.text =
                              dateFormat.format(result);
                        } else {
                          dateFormat.format(DateTime.now());
                        }
                        if (mounted) setState(() {});
                      },
                      suffixIcon: const Icon(
                        Icons.calendar_today,
                        color: WeweyouColors.primaryDarkRed,
                        size: 22,
                      ),
                    ),
                    sizedBox(),
                    CustomFormField(
                      controller: _selectedEndDateController,
                      hintText: 'End Date',
                      readOnly: true,
                      onPressed: () async {
                        DateTime? result = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );
                        if (result != null) {
                          _selectedEndDateController.text =
                              dateFormat.format(result);
                        } else {
                          selectedEndDate = dateFormat.format(DateTime.now());
                        }
                        if (mounted) setState(() {});
                      },
                      suffixIcon: const Icon(
                        Icons.calendar_today,
                        color: WeweyouColors.primaryDarkRed,
                        size: 22,
                      ),
                    ),
                    sizedBox(height: 60),
                    CommonButton(
                      onPressed: () {
                        widget.itineraryRecord == null
                            ? callApiCreateItinerary()
                            : showToast(toastMsg: 'This is on progress....');
                      },
                      buttonName: widget.itineraryRecord == null
                          ? 'Create Itinerary'
                          : 'Update Itinerary',
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

  callApiCreateItinerary() async {
    final navigator = Navigator.of(context);
    final response = await _networkingFunctions.multipartApi(
      apiURL: baseUrl + ApiEndPoint.CREATEININERARY,
      body: {
        "category_id": selectedCategoryId.toString(),
        "date": mainDate.toString(),
        "title": _titleCont.text,
        "description": _desCont.text,
        "start_date": _selectedStartDateController.text,
        "end_date": _selectedEndDateController.text,
        "location": "Indore",
      },
      context: context,
      imagePath: pickedImage!.path,
      keyImagePath: 'image',
      loadingMsg: 'Creating Itinerary',
    );
    debugPrint("Is ti coming here 1======${response.isSuccessFul}");
    if (response.isSuccessFul == true) {
      navigator.pop("result");
      debugPrint("Is ti coming here 2======${response.message}");
    }
    if (mounted) setState(() {});
  }

  // callApiUpdateItinerary() async {
  //   final navigator = Navigator.of(context);
  //   final response = await _networkingFunctions.multipartApi(
  //     apiURL: baseUrl + ApiEndPoint.ITINERARYDETAILSUPDATE,
  //     body: {
  //       "category_id": selectedCategoryId.toString(),
  //       "date": mainDate.toString(),
  //       "title": _titleCont.text,
  //       "description": _desCont.text,
  //       "start_date": _selectedStartDateController.text,
  //       "end_date": _selectedEndDateController.text,
  //       "location": "Indore",
  //     },
  //     context: context,
  //     imagePath: pickedImage == null ? "" : pickedImage!.path,
  //     keyImagePath: 'image',
  //     loadingMsg: 'Creating Itinerary',
  //   );
  //   debugPrint("Is ti coming here 1======${response.isSuccessFul}");
  //   if (response.isSuccessFul == true) {
  //     navigator.pop("result");
  //     debugPrint("Is ti coming here 2======${response.message}");
  //   }
  //   if (mounted) setState(() {});
  // }

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
