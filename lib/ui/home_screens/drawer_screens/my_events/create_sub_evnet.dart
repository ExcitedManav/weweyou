import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:http/http.dart' as http;
import 'package:weweyou/data/models/onboarding_models/create_sub_event_model.dart';
import 'package:weweyou/ui/home_screens/drawer_screens/my_events/widgets/secondary_app_bar.dart';

import '../../../../data/models/onboarding_models/categoryModel.dart';
import '../../../../data/models/onboarding_models/createEventModel.dart';
import '../../../../data/networking/api_end_point.dart';
import '../../../../data/networking/api_provider.dart';
import '../../../../data/networking/networking.dart';
import '../../../utils/common_button.dart';
import '../../../utils/common_drop_down.dart';
import '../../../utils/common_loader.dart';
import '../../../utils/common_text_style.dart';
import '../../../utils/common_widgets.dart';
import '../../../utils/constant.dart';
import '../../../utils/input_text_field.dart';
import '../../../utils/validator.dart';
import '../../create_event/widgets/common_text.dart';
import '../../create_event/widgets/common_widgets_create_event.dart';
import '../../create_event/widgets/customContainer.dart';
import '../drawer_screen.dart';

class CreateSubEventScreen extends StatefulWidget {
  const CreateSubEventScreen({Key? key, required this.eventId})
      : super(key: key);
  final String eventId;

  @override
  State<CreateSubEventScreen> createState() => _CreateSubEventScreenState();
}

class _CreateSubEventScreenState extends State<CreateSubEventScreen> {
  final TextEditingController _eventTitleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _eventDesController = TextEditingController();
  final TextEditingController _ticketQuantityController =
      TextEditingController();

  final ScrollController scrollController = ScrollController();

  final FocusNode _eventFocus = FocusNode();
  final FocusNode _eventDesFocus = FocusNode();

  int? selectedCategoryId;
  String? selectedCategory;
  String? selectedStartDate;
  String? selectedEndDate;
  String? selectedStartTime;
  String? selectedEndTime;

  DateTime dateTime = DateTime.now();
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  int selectedProcess = 1;
  int? nextProcess;

  final ApiEndPoint _apiEndPoint = ApiEndPoint();

  List<CategoryData> _catList = [];
  List<String> _catNameList = [];

  bool loadingCatList = true;
  bool loadingTicketType = true;
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey4 = GlobalKey<FormState>();

  @override
  void initState() {
    getCoverImages();
    getCategories();
    super.initState();
  }

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
        debugPrint('Cat data ${response.data}');
        _catNameList = _catList.map((e) => e.nameEN!).toList();
        loadingCatList = false;
        if (mounted) setState(() {});
      } else {
        loadingCatList = false;
        if (mounted) setState(() {});
        showToast(
            toastMsg: response.data['message'],
            backgroundColor: WeweyouColors.primaryDarkRed);
      }
    } catch (e) {
      loadingCatList = false;
      if (mounted) setState(() {});
      debugPrint(e.toString());
      showToast(
          toastMsg: e.toString(),
          backgroundColor: WeweyouColors.primaryDarkRed);
    }
  }

  List<CoverImageData> _coverImageData = [];

  // Cover Images API Call Function //
  getCoverImages() async {
    loadingCatList = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_Token');
    try {
      var headers = {
        "Authorization": "Bearer $token",
        "X-localization": 'en',
      };
      Dio dio = Dio();
      final response = await dio.get(baseUrl + ApiEndPoint.GETCOVERIMAGE,
          options: Options(
              headers: headers,
              method: 'Get',
              responseType: ResponseType.json));
      debugPrint(
          "${response.statusCode} ${response.data['success']} ${response.statusMessage} ${response.data}");
      if (response.statusCode == 200 && response.data['success'] == true) {
        CoverImageModel coverImage = CoverImageModel.fromJson(response.data);
        _coverImageData = coverImage.coverImageData!;
        for (var items in _coverImageData) {
          debugPrint("Cover Image data ${items.imageUrl}");
        }
        loadingCatList = false;
      }
    } catch (e) {
      loadingCatList = false;
      debugPrint("Cover image error ${e.toString()}");
      showToast(
          toastMsg: e.toString(),
          backgroundColor: WeweyouColors.primaryDarkRed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: WeweyouColors.blackBackground,
      appBar: PreferredSize(
        preferredSize: Size(size.width, 80),
        child: const SecondaryAppBar(appBarName: 'Create Sub Event'),
      ),
      bottomNavigationBar: Container(
        color: WeweyouColors.blackBackground,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            if (selectedProcess != 1)
              Expanded(
                child: CommonButton(
                  onPressed: () async {
                    selectedProcess = 1;
                    if (mounted) setState(() {});
                  },
                  buttonName: 'Back',
                  backgroundColor: WeweyouColors.blackBackground,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  // width: MediaQuery.of(context).size.width * 0.35,
                ),
              ),
            sizedBox(),
            Expanded(
              child: CommonButton(
                onPressed: () async {
                  if (selectedProcess == 1) {
                    if (_formKey1.currentState!.validate()) {
                      _formKey1.currentState!.save();
                      if (selectedStartDate != null &&
                          selectedEndDate != null &&
                          selectedStartTime != null &&
                          selectedEndTime != null) {
                        subEventApiCall();
                        if (mounted) setState(() {});
                      } else {
                        showToast(
                          toastMsg:
                              "Please selected Date and Time Correctly..!",
                          backgroundColor: Colors.blue,
                        );
                      }
                    }
                  } else {
                    if (_formKey4.currentState!.validate()) {
                      _formKey4.currentState!.save();
                      uploadImageVideoApi(context);
                      if (mounted) setState(() {});
                    }
                  }
                },
                buttonName: createLoader == false
                    ? 'Next' : 'Please Wait...',
                padding: const EdgeInsets.only(left: 20, right: 20),
                // width: MediaQuery.of(context).size.width * 0.35,
              ),
            ),
          ],
        ),
      ),
      body: loadingCatList == false
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                color: WeweyouColors.blackBackground,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        processStep(
                            text: '1',
                            backgroundColor: WeweyouColors.secondaryOrange),
                        line(
                          backgroundColor: selectedProcess >= 2
                              ? WeweyouColors.secondaryOrange
                              : WeweyouColors.blackPrimary,
                        ),
                        processStep(
                          text: '2',
                          backgroundColor: selectedProcess >= 2
                              ? WeweyouColors.secondaryOrange
                              : WeweyouColors.blackPrimary,
                        ),
                      ],
                    ),
                    sizedBox(height: 25),
                    selectedProcess == 1
                        ? createEventFirstStep()
                        : selectedProcess == 2
                            ? createEventFourthStep()
                            : const SizedBox.shrink()
                  ],
                ),
              ),
            )
          : const CommonLoader(),
    );
  }

  // Create Event First Step Process BEGIN //

  bool privateListing = true;
  bool createLoader = false;

  final NetworkingFunctions _networkingFunctions = NetworkingFunctions();

  SubEventRecord? _subEventRecord;

  subEventApiCall() async {
    createLoader = true;
    final body = {
      "event_title": _eventTitleController.text,
      "category_id": selectedCategoryId,
      "event_id": "88",
      "address": _locationController.text,
      "start_date": selectedStartDate,
      "end_date": selectedEndDate,
      "start_time": selectedStartTime,
      "end_time": selectedEndTime,
      "description": _eventDesController.text,
      "event_photo_id": "1",
      "ticket_type_id": 3,
      "location": _locationController.text,
      "qty": _ticketQuantityController.text,
      "is_private": privateListing ? "yes" : "no",
    };
    final response = await _networkingFunctions.postApiCall(
      endPoint: ApiEndPoint.CREATESUBEVENT,
      body: body,
    );
    CreateSubEventModel subEventModel =
        CreateSubEventModel.fromJson(response.data);
    _subEventRecord = subEventModel.subEventRecord;
    selectedProcess = nextProcess!;
    createLoader = false;
    if (mounted) setState(() {});
  }

  createEventFirstStep() {
    nextProcess = 2;
    final localizations = MaterialLocalizations.of(context);
    String initialTime = localizations.formatTimeOfDay(TimeOfDay.now());
    return Form(
      key: _formKey1,
      child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                subHeadingText(title: 'General Information'),
                sizedBox(height: 20),
                const CreateTextTitles(title: 'Event Title'),
                sizedBox(height: 10),
                CustomFormField(
                  controller: _eventTitleController,
                  hintText: 'Event Title',
                  focusNode: _eventFocus,
                  validator: (val) => requiredField(val, 'Title'),
                ),
                sizedBox(height: 20),
                const CreateTextTitles(title: 'Category'),
                sizedBox(height: 10),
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
                          final result = _catList
                              .firstWhere((element) => element.nameEN == value);
                          selectedCategoryId = result.id;
                          debugPrint('Check Result ${result.id.toString()}');
                          debugPrint(
                              'Check Result selectedCatId $selectedCategoryId');
                          if (mounted) setState(() {});
                        },
                      )
                    : const SizedBox.shrink(),
                sizedBox(height: 20),
                const CreateTextTitles(title: 'Address'),
                sizedBox(height: 10),
                TextFormField(
                  style: poppinsRegular(fontSize: 16),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Location is required';
                    }
                    return null;
                  },
                  onTap: () async {
                    LocationResult? result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PlacePicker(mapApiKey),
                      ),
                    );
                    // Handle the result in your way
                    if (result != null) {
                      _locationController.text =
                          result.formattedAddress.toString();
                    }
                    if (mounted) setState(() {});
                  },
                  readOnly: true,
                  controller: _locationController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    hintText: "Location",
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: WeweyouColors.blackPrimary,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                sizedBox(height: 20),
                const CreateTextTitles(title: 'Start Date & Time  '),
                sizedBox(height: 10),
                CustomContainer(
                  onPressedDate: () async {
                    DateTime? result = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    debugPrint("Result Start date $result");
                    if (result != null) {
                      selectedStartDate = dateFormat.format(result);
                      debugPrint(selectedStartDate);
                      if (mounted) setState(() {});
                    } else {
                      dateFormat.format(DateTime.now());
                    }
                  },
                  selectedDate:
                      selectedStartDate ?? dateFormat.format(DateTime.now()),
                  onPressedTime: () async {
                    TimeOfDay? result = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                        DateTime.now(),
                      ),
                    );
                    if (result != null) {
                      String formattedTimeOfDay =
                          localizations.formatTimeOfDay(result);
                      selectedStartTime = formattedTimeOfDay;
                      debugPrint(selectedStartTime);
                      if (mounted) setState(() {});
                    } else {
                      selectedStartTime = localizations.formatTimeOfDay(
                        TimeOfDay.fromDateTime(
                          DateTime.now(),
                        ),
                      );
                    }
                  },
                  selectedTime: selectedStartTime ?? initialTime,
                ),
                sizedBox(height: 20),
                const CreateTextTitles(title: 'End Date & Time'),
                sizedBox(height: 10),
                CustomContainer(
                  onPressedDate: () async {
                    DateTime? result = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    if (result != null) {
                      selectedEndDate = dateFormat.format(result);
                      debugPrint(selectedEndDate);
                      if (mounted) setState(() {});
                    } else {
                      selectedEndDate = dateFormat.format(DateTime.now());
                      if (mounted) setState(() {});
                    }
                  },
                  selectedDate:
                      selectedEndDate ?? dateFormat.format(DateTime.now()),
                  onPressedTime: () async {
                    TimeOfDay? result = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                        DateTime.now(),
                      ),
                    );
                    if (result != null) {
                      String localization =
                          localizations.formatTimeOfDay(result);
                      if (selectedStartTime != localization) {
                        selectedEndTime = localization;
                      } else {
                        showToast(
                          toastMsg:
                              "End Time Should be greater than start time",
                          backgroundColor: WeweyouColors.primaryDarkRed,
                        );
                      }
                      debugPrint(selectedEndTime);
                      if (mounted) setState(() {});
                    } else {
                      selectedEndDate = localizations.formatTimeOfDay(
                        TimeOfDay.fromDateTime(
                          DateTime.now(),
                        ),
                      );
                      if (mounted) setState(() {});
                    }
                  },
                  selectedTime: selectedEndTime ?? initialTime,
                ),
                sizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CreateTextTitles(title: 'Ticket Details'),
                          sizedBox(width: 10),
                          Container(
                            height: 55,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: WeweyouColors.blackPrimary,
                            ),
                            child: Text(
                              'Free Tickets',
                              style: poppinsRegular(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    sizedBox(),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CreateTextTitles(title: 'Quantity'),
                          sizedBox(width: 10),
                          CustomFormField(
                            hintText: '0.00',
                            controller: _ticketQuantityController,
                            validator: (val) => requiredField(val, 'Quantity'),
                            textInputType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                sizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Transform.scale(
                      scale: 1.3,
                      child: Checkbox(
                        value: privateListing,
                        onChanged: (bool? val) {
                          privateListing = val!;
                          if (mounted) setState(() {});
                          debugPrint('Check box value $val');
                        },
                        fillColor: MaterialStateColor.resolveWith(
                          (states) => WeweyouColors.blackPrimary,
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        checkColor: WeweyouColors.secondaryOrange,
                      ),
                    ),
                    sizedBox(width: 10),
                    const CreateTextTitles(title: 'Private Listing'),
                  ],
                ),
                commonText(
                    text:
                        'Private listing are visible on our directory but accessible to only by the organizer approval.',
                    fontSize: 14,
                    fontColor: WeweyouColors.greyPrimary),
                sizedBox(height: 20),
                const CreateTextTitles(title: 'Description'),
                sizedBox(height: 10),
                CustomFormField(
                  controller: _eventDesController,
                  maxLine: 6,
                  hintText: 'Event Description',
                  focusNode: _eventDesFocus,
                  validator: (val) => requiredField(val, 'Event Description'),
                ),
              ],
            ),
    );
  }

  bool checkBool = true;
  bool checkBool1 = false;
  bool checkBool2 = false;

  bool checkBoolT = true;
  bool checkBoolT1 = true;
  bool checkBoolT2 = true;

  String? selectedOfficialTickets;
  String? selectedBudget;
  String? selectedCurrency;

  int? selectedPicture;

  final ImagePicker _imagePicker = ImagePicker();
  String? storedFile;
  String? storedVideo;

  String? videoThumbnail;

  _thumbnailFunction() async {
    final unit8list = await VideoThumbnail.thumbnailFile(
      video: storedVideo!,
      imageFormat: ImageFormat.JPEG,
      quality: 75,
    );
    videoThumbnail = unit8list;
    if (mounted) setState(() {});
    debugPrint("Check thumbnail $unit8list");
  }

  int checkVideoOrPhoto = 0;

  createEventFourthStep() {
    nextProcess = 2;
    return Form(
      key: _formKey4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          subHeadingText(title: 'Event Cover'),
          sizedBox(),
          checkVideoOrPhoto != 0
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.file(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                        File(checkVideoOrPhoto == 2
                            ? videoThumbnail!
                            : storedFile!),
                      ),
                      if (checkVideoOrPhoto == 2)
                        Container(
                          height: 65,
                          width: 65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey.withOpacity(0.6),
                          ),
                          child: const Icon(
                            Icons.slow_motion_video,
                            size: 45,
                            color: Colors.white,
                          ),
                        ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          onPressed: () {
                            videoThumbnail = null;
                            storedFile = null;
                            checkVideoOrPhoto = 0;
                            if (mounted) setState(() {});
                          },
                          icon: const Icon(
                            Icons.cancel_outlined,
                            color: WeweyouColors.primaryDarkRed,
                            size: 35,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : InkWell(
                  onTap: () {
                    uploadImageOrVideo();
                  },
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: WeweyouColors.blackPrimary,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        width: 1.0,
                        color: WeweyouColors.secondaryOrange,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 14,
                          backgroundColor: WeweyouColors.secondaryOrange,
                          child: Icon(
                            Icons.add,
                            color: WeweyouColors.blackPrimary,
                            size: 18,
                          ),
                        ),
                        sizedBox(),
                        Text(
                          'Upload Photo or Video',
                          style: poppinsRegular(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                ),
          sizedBox(height: 30),
        ],
      ),
    );
  }

  //Create Event Fourth Step END //

  final CommonProgress _commonProgress = CommonProgress();

  Future uploadImageVideoApi(ctx) async {
    final ProgressDialog pr = _commonProgress.commonProgressIndicator(
        context: ctx, loadingMsg: 'Creating Event... Please wait!');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_Token');
    var headers = {'Authorization': 'Bearer $token'};
    debugPrint(" token $token");
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        'https://mmfinfotech.co/Weweyou/api/user/add_sub_event_videoOrImage',
      ),
    );
    debugPrint('R D check verman');
    var body1 = {
      'img_vid_status': checkVideoOrPhoto == 1
          ? 1.toString()
          : checkVideoOrPhoto == 2
              ? 2.toString()
              : 0.toString(),
      'event_id': 78.toString(),
      'sub_event_id': _subEventRecord!.subEventId.toString(),
      'event_photo_id': checkVideoOrPhoto == 0 ? selectedPicture.toString() : ''
    };
    debugPrint("$body1");
    request.fields.addAll(body1);
    request.files.add(
      await http.MultipartFile.fromPath(
        'video_or_image',
        checkVideoOrPhoto == 0
            ? 'null'
            : checkVideoOrPhoto == 1
                ? storedFile!
                : checkVideoOrPhoto == 2
                    ? storedVideo!.toString()
                    : '',
        filename: checkVideoOrPhoto == 0
            ? ''
            : checkVideoOrPhoto == 1
                ? storedFile!
                : checkVideoOrPhoto == 2
                    ? storedVideo!.toString()
                    : '',
      ),
    );

    request.headers.addAll(headers);
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen(
      (value) async {
        Map valueMap = json.decode(value);
        if (response.statusCode == 200) {
          showToast(toastMsg: valueMap['message']);
          pr.close();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const DrawerScreen(),
            ),
          );
          pr.close();
        } else {
          pr.close();
          showToast(toastMsg: valueMap['message']);
          debugPrint('Image Error ${valueMap['message']}');
        }
      },
    );
  }

  uploadImageOrVideo() {
    showModalBottomSheet(
      context: context,
      backgroundColor: WeweyouColors.blackBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () async {
                Navigator.of(context).pop();
                checkVideoOrPhoto = 1;
                XFile? pickedFile =
                    await _imagePicker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  storedFile = pickedFile.path;
                  debugPrint("storedFile check $storedFile");
                  if (mounted) setState(() {});
                }
              },
              leading: const Icon(
                Icons.photo_size_select_actual_outlined,
                color: WeweyouColors.customPureWhite,
                size: 22,
              ),
              title: Text(
                'Photo',
                style: poppinsRegular(fontSize: 18),
              ),
            ),
            ListTile(
              onTap: () async {
                Navigator.of(context).pop();
                checkVideoOrPhoto = 2;
                XFile? pickedFile =
                    await _imagePicker.pickVideo(source: ImageSource.gallery);
                if (pickedFile != null) {
                  storedVideo = pickedFile.path;
                  debugPrint("pickedFile ${pickedFile.path}");
                  _thumbnailFunction();
                  if (mounted) setState(() {});
                }
              },
              leading: const Icon(
                Icons.video_camera_back_outlined,
                color: WeweyouColors.customPureWhite,
                size: 22,
              ),
              title: Text(
                'Video',
                style: poppinsRegular(fontSize: 18),
              ),
            )
          ],
        );
      },
    );
  }
}
