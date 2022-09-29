import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:weweyou/data/models/onboarding_models/createEventModel.dart';
import 'package:weweyou/data/networking/api_end_point.dart';
import 'package:weweyou/data/networking/api_provider.dart';
import 'package:weweyou/data/networking/shared_pref.dart';
import 'package:weweyou/ui/home_screens/create_event/stripe_view.dart';
import 'package:weweyou/ui/home_screens/create_event/widgets/common_text.dart';
import 'package:weweyou/ui/home_screens/create_event/widgets/common_widgets_create_event.dart';
import 'package:weweyou/ui/home_screens/create_event/widgets/customContainer.dart';
import 'package:weweyou/ui/home_screens/drawer_screens/drawer_screen.dart';
import 'package:weweyou/ui/utils/common_drop_down.dart';
import 'package:weweyou/ui/utils/common_loader.dart';
import 'package:weweyou/ui/utils/common_widgets.dart';
import 'package:weweyou/ui/utils/input_text_field.dart';
import 'package:weweyou/ui/utils/validator.dart';

import '../../../data/models/onboarding_models/categoryModel.dart';
import '../../utils/common_button.dart';
import '../../utils/common_text_style.dart';
import '../../utils/constant.dart';
import '../widgets/image_network_function.dart';

class CreateEventScreen extends StatefulWidget {
  CreateEventScreen({Key? key, this.categoryData}) : super(key: key);
  static const String route = '/createEventRoute';
  List<CategoryData>? categoryData = [];

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final TextEditingController _eventTitleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _eventDesController = TextEditingController();

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
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey4 = GlobalKey<FormState>();

  @override
  void initState() {
    getCoverImages();
    getCategories();
    getTicketTypes();
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

  List<TicketListData> _ticketTypeListData = [];

  getTicketTypes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_Token');
    try {
      loadingCatList = true;
      var headers = {"Authorization": "Bearer $token", "X-localization": 'en'};
      Dio dio = Dio();
      final response = await dio.get(
        baseUrl + ApiEndPoint.GETTICKETTYPES,
        options: Options(
          contentType: 'Application/json',
          headers: headers,
          method: 'Get',
          validateStatus: (val) => true,
        ),
      );
      if (response.statusCode == 200 && response.data['status'] == true) {
        TicketTypeListModel ticketTypeListModel =
            TicketTypeListModel.fromJson(response.data);
        _ticketTypeListData = ticketTypeListModel.ticketListData!;
        _ticketTypesName = _ticketTypeListData.map<String>((e) {
          return e.name!;
        }).toList();
        _ticketTypesId = _ticketTypeListData.map((e) => e.id!).toList();
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
      showToast(
        toastMsg: e.toString(),
        backgroundColor: WeweyouColors.primaryDarkRed,
      );
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
        backgroundColor: WeweyouColors.primaryDarkRed,
      );
    }
  }

  Record? _createEventData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WeweyouColors.blackBackground,
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
                  print('selected Process $selectedProcess');
                  if (selectedProcess == 1) {
                    if (_formKey1.currentState!.validate()) {
                      _formKey1.currentState!.save();
                      if (selectedStartDate != null &&
                          selectedEndDate != null &&
                          selectedStartTime != null &&
                          selectedEndTime != null) {
                        selectedProcess = nextProcess!;
                        if (mounted) setState(() {});
                      } else {
                        showToast(
                          toastMsg:
                              "Please selected Date and Time Correctly..!",
                          backgroundColor: Colors.blue,
                        );
                      }
                    }
                  } else if (selectedProcess == 2) {
                    if (selectedTicketSaleOptionId == 3) {
                      selectedProcess = nextProcess!;
                      if (mounted) setState(() {});
                    } else {
                      if (_formKey2.currentState!.validate()) {
                        _formKey2.currentState!.save();
                        for (int i = 0;
                            i < _controllerCheckAmount.length;
                            i++) {
                          _ticketsContainer.add(<String, dynamic>{
                            "ticket_type_id": _selectedTicketTypeIds[i],
                            "title": _controllerCheckTitle[i].text,
                            "price": int.parse(_controllerCheckAmount[i].text),
                            "quantity":
                                int.parse(_controllerCheckQuantity[i].text)
                          });
                        }
                        if (stripeConnected != null) {
                          selectedProcess = nextProcess!;
                        } else {
                          showToast(
                            toastMsg:
                                'Please Connect your Stripe Account to Continue',
                            backgroundColor: Colors.blue,
                          );
                        }
                        if (mounted) setState(() {});
                      }
                    }
                  } else if (selectedProcess == 3) {
                    if (selectedTicketSaleOptionId == 3) {}
                    if (_formKey3.currentState!.validate()) {
                      _formKey3.currentState!.save();
                      final ProgressDialog pr =
                          _commonProgress.commonProgressIndicator(
                        context: context,
                        loadingMsg: 'Adding Event Detail... Please wait!',
                      );
                      var body = {
                        "event_title": _eventTitleController.text,
                        "category": selectedCategoryId.toString(),
                        "address": _locationController.text,
                        "start_date": selectedStartDate,
                        "end_date": selectedEndDate,
                        "start_time": selectedStartTime,
                        "end_time": selectedEndTime,
                        "description": _eventDesController.text,
                        "ticket_sale_option": selectedTicketOption,
                        "add_ticket_price": _ticketsContainer,
                        "official_tickets": selectedOfficialTickets,
                        "ticket_type": stringTicketTypeIdsList,
                        "budget_type": selectedBudget,
                        "currency": selectedCurrency,
                        "event_service": _selectedEventType,
                      };
                      debugPrint('Check Create Event Body data $body');
                      var token = await getAuthToken();
                      var headers = {
                        'Authorization': "Bearer $token",
                        "X-localization": "en",
                        "Content-Type": "application/json"
                      };
                      try {
                        Dio dio = Dio();
                        final response = await dio.post(
                          baseUrl + ApiEndPoint.CREATEEVENT,
                          data: jsonEncode(body),
                          options: Options(
                            method: "Post",
                            validateStatus: (val) => true,
                            headers: headers,
                            contentType: 'Application/json',
                          ),
                        );
                        if (response.statusCode == 200 &&
                            response.data['status'] == true) {
                          CreateEventModel createEventModel =
                              CreateEventModel.fromJson(response.data);
                          _createEventData = createEventModel.createEventData;
                          showToast(toastMsg: response.data['message']);
                          pr.close();
                        }
                      } catch (e) {
                        pr.close();
                        showToast(
                          toastMsg: e.toString(),
                          backgroundColor: WeweyouColors.primaryDarkRed,
                        );
                        debugPrint(e.toString());
                      }
                      selectedProcess = nextProcess!;
                      if (mounted) setState(() {});
                    }
                  } else {
                    if (_formKey4.currentState!.validate()) {
                      _formKey4.currentState!.save();
                      uploadImageVideoApi(context);
                      if (mounted) setState(() {});
                    }
                  }
                },
                buttonName: 'Next',
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
                                : WeweyouColors.blackPrimary),
                        processStep(
                            text: '2',
                            backgroundColor: selectedProcess >= 2
                                ? WeweyouColors.secondaryOrange
                                : WeweyouColors.blackPrimary),
                        line(
                            backgroundColor: selectedProcess >= 3
                                ? WeweyouColors.secondaryOrange
                                : WeweyouColors.blackPrimary),
                        processStep(
                            text: '3',
                            backgroundColor: selectedProcess >= 3
                                ? WeweyouColors.secondaryOrange
                                : WeweyouColors.blackPrimary),
                        line(
                            backgroundColor: selectedProcess >= 4
                                ? WeweyouColors.secondaryOrange
                                : WeweyouColors.blackPrimary),
                        processStep(
                          text: '4',
                        ),
                      ],
                    ),
                    sizedBox(height: 25),
                    selectedProcess == 1
                        ? createEventFirstStep()
                        : selectedProcess == 2
                            ? createEventSecondStep()
                            : selectedProcess == 3
                                ? createEventThirdStep()
                                : selectedProcess == 4
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

  createEventFirstStep() {
    nextProcess = 2;
    final localizations = MaterialLocalizations.of(context);
    String initialTime = localizations.formatTimeOfDay(TimeOfDay.now());
    return Form(
      key: _formKey1,
      child: Column(
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
              LocationResult result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PlacePicker(mapApiKey),
                ),
              );
              // Handle the result in your way
              _locationController.text = result.formattedAddress.toString();
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
              if (result != null) {
                selectedStartDate = dateFormat.format(result);
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
                if (mounted) setState(() {});
              } else {
                selectedEndDate = dateFormat.format(DateTime.now());
                if (mounted) setState(() {});
              }
            },
            selectedDate: selectedEndDate ?? dateFormat.format(DateTime.now()),
            onPressedTime: () async {
              TimeOfDay? result = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(
                  DateTime.now(),
                ),
              );
              if (result != null) {
                String localization = localizations.formatTimeOfDay(result);
                if (selectedStartTime != localization) {
                  selectedEndTime = localization;
                } else {
                  showToast(
                    toastMsg: "End Time Should be greater than start time",
                    backgroundColor: WeweyouColors.primaryDarkRed,
                  );
                }
              } else {
                selectedEndDate = localizations.formatTimeOfDay(
                  TimeOfDay.fromDateTime(
                    DateTime.now(),
                  ),
                );
              }
              if (mounted) setState(() {});
            },
            selectedTime: selectedEndTime ?? initialTime,
          ),
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

  // Create Event First Step Process END //

  // Create Event Second Step Process BEGIN //

  bool checkBool = true;
  bool checkBool1 = false;
  bool checkBool2 = false;

  bool checkBoolT = true;
  bool checkBoolT1 = true;
  bool checkBoolT2 = true;

  final List<String> _officialTickets = [
    'Yes, WEWEYOU tickets are valid for accessing to the event.',
    'No, the official ticket will be given by Presenting the WEWEYOU ticket.'
  ];

  final List<String> _budgetType = [
    'Low Budget',
    'Medium Budget',
    'High Budget',
  ];

  final List<String> _currency = ['USD', 'EUR', 'CHF'];

  String? selectedOfficialTickets;
  String? selectedBudget;
  String? selectedCurrency;

  List<String> _ticketTypesName = [];
  List<int> _ticketTypesId = [];

  final List<Map<String, dynamic>> _ticketsContainer = [];
  final List<TextEditingController> _controllerCheckTitle = [];
  final List<TextEditingController> _controllerCheckAmount = [];
  final List<TextEditingController> _controllerCheckQuantity = [];
  final List<String> _selectedTicketType = [];
  final List<int> _selectedTicketTypeIds = [];

  void remove(int index) {
    _controllerCheckTitle.removeAt(index);
    _controllerCheckAmount.removeAt(index);
    _controllerCheckQuantity.removeAt(index);
    _selectedTicketType.removeAt(index);
    _selectedTicketTypeIds.removeAt(index);
    if (mounted) setState(() {});
  }

  void add() {
    _controllerCheckTitle.add(TextEditingController());
    _controllerCheckAmount.add(TextEditingController());
    _controllerCheckQuantity.add(TextEditingController());
    _selectedTicketType.add(_ticketTypesName[0]);
    _selectedTicketTypeIds.add(_ticketTypesId[0]);
    if (mounted) setState(() {});
    Future.delayed(const Duration(milliseconds: 500), () {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  List<String> ticketSaleOptions = ['Online', 'Collect Onsite', 'No Ticket'];

  String? selectedTicketOption;
  int selectedTicketSaleOptionId = 1;

  final List<String> _pariList = [];
  final List<int> _sendTicketTypeId = [];

  int? paidTicket;

  final List<String> _cardList = [
    'assets/images_icons/create_event_card/jcb.png',
    'assets/images_icons/create_event_card/visa.png',
    'assets/images_icons/create_event_card/master_card.png',
    'assets/images_icons/create_event_card/amex.png',
    'assets/images_icons/create_event_card/disc.png',
    'assets/images_icons/create_event_card/d_c_i.png',
  ];

  String? stripeConnected;

  String congratsUrl = "https://mmfinfotech.co/Weweyou/user/thankyou";
  var stringTicketTypeIdsList;

  createEventSecondStep() {
    return Form(
      key: _formKey2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          subHeadingText(title: 'Ticket Info'),
          sizedBox(height: 15),
          const CreateTextTitles(title: 'Ticket Sale Options'),
          sizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customCheckBox(
                  title: ticketSaleOptions[0],
                  selectedValBool: checkBool,
                  onChanged: (value) {
                    checkBool = value!;
                    checkBool1 = false;
                    checkBool2 = false;
                    selectedTicketOption = ticketSaleOptions[0];
                    selectedTicketSaleOptionId = 1;
                    if (mounted) setState(() {});
                  }),
              customCheckBox(
                  title: ticketSaleOptions[1],
                  selectedValBool: checkBool1,
                  onChanged: (value) {
                    checkBool1 = value!;
                    checkBool = false;
                    checkBool2 = false;
                    selectedTicketOption = ticketSaleOptions[1];
                    selectedTicketSaleOptionId = 2;
                    if (mounted) setState(() {});
                  }),
              customCheckBox(
                title: ticketSaleOptions[2],
                selectedValBool: checkBool2,
                onChanged: (value) {
                  checkBool2 = value!;
                  checkBool1 = false;
                  checkBool = false;
                  selectedTicketOption = ticketSaleOptions[2];
                  selectedTicketSaleOptionId = 3;
                  nextProcess = 3;
                  if (mounted) setState(() {});
                },
              ),
            ],
          ),
          if (selectedTicketSaleOptionId != 3)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sizedBox(height: 30),
                const CreateTextTitles(title: 'Ticket Types'),
                sizedBox(height: 15),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                      separatorBuilder: (context, i) => sizedBox(width: 25),
                      itemCount: _ticketTypesName.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () {
                            if (_pariList.contains(_ticketTypesName[i])) {
                              _pariList.removeWhere(
                                  (element) => element == _ticketTypesName[i]);
                              final result = _ticketTypeListData.firstWhere(
                                  (element) =>
                                      element.name == _ticketTypesName[i]);
                              _sendTicketTypeId.remove(result.id!);
                              if (result.id == 2) {
                                paidTicket = null;
                              }
                            } else {
                              _pariList.add(_ticketTypesName[i]);
                              final result = _ticketTypeListData.firstWhere(
                                  (element) =>
                                      element.name == _ticketTypesName[i]);
                              _sendTicketTypeId.add(result.id!);

                              if (result.id == 2) {
                                paidTicket = result.id;
                              }
                            }
                            var stringList = _sendTicketTypeId.join(",");
                            stringTicketTypeIdsList = stringList;
                            if (mounted) setState(() {});
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: WeweyouColors.blackPrimary,
                                  borderRadius: BorderRadius.circular(2),
                                  border: Border.all(
                                      color: WeweyouColors.secondaryOrange,
                                      width: 1),
                                ),
                                child: _pariList.contains(_ticketTypesName[i])
                                    ? const Icon(
                                        Icons.check,
                                        color: WeweyouColors.secondaryOrange,
                                        size: 18,
                                      )
                                    : null,
                              ),
                              sizedBox(width: 10),
                              Text(
                                _ticketTypesName[i],
                                style: poppinsRegular(fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
                sizedBox(height: 30),
                if (paidTicket == 2)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CreateTextTitles(title: 'Budget type'),
                      sizedBox(),
                      CommonDropDown(
                        hintText: _budgetType[0],
                        selectedValue: selectedBudget ?? _budgetType[0],
                        onChanged: (value) {
                          selectedBudget = value;
                          if (mounted) setState(() {});
                        },
                        items: _budgetType.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: poppinsRegular(fontSize: 16),
                            ),
                          );
                        }).toList(),
                      ),
                      sizedBox(height: 30),
                      const CreateTextTitles(title: 'Currency'),
                      sizedBox(),
                      CommonDropDown(
                        hintText: _currency[0],
                        selectedValue: selectedCurrency ?? _currency[0],
                        onChanged: (value) {
                          selectedCurrency = value;
                          if (mounted) setState(() {});
                        },
                        items: _currency.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: poppinsRegular(fontSize: 16),
                            ),
                          );
                        }).toList(),
                      ),
                      sizedBox(height: 30),
                    ],
                  ),
                const CreateTextTitles(title: 'Are these official tickets?'),
                sizedBox(),
                CommonDropDown(
                  hintText: _officialTickets[0],
                  dropdownMaxHeight: 220,
                  itemHeight: 55,
                  buttonHeight: 65,
                  iconSize: 28,
                  selectedValue: selectedOfficialTickets ?? _officialTickets[0],
                  itemPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  onChanged: (value) {
                    selectedOfficialTickets = value;
                    debugPrint(" Tickets $value");
                    if (mounted) setState(() {});
                  },
                  items: _officialTickets.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: poppinsRegular(fontSize: 14),
                      ),
                    );
                  }).toList(),
                ),
                sizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ticket Price',
                      style: poppinsBold(
                          fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    InkWell(
                      onTap: () => add(),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 13,
                            backgroundColor: WeweyouColors.secondaryOrange,
                            child: Icon(
                              Icons.add,
                              color: WeweyouColors.customPureWhite,
                              size: 22,
                            ),
                          ),
                          sizedBox(width: 10),
                          Text(
                            'Add Ticket Price',
                            style: poppinsRegular(
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _controllerCheckTitle.length,
                  itemBuilder: (ctx, i) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sizedBox(height: 30),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CreateTextTitles(title: 'Ticket Type'),
                                  sizedBox(),
                                  CommonDropDown(
                                    dropdownWidth: 170,
                                    hintText: 'Select',
                                    selectedValue: _selectedTicketType[i],
                                    onChanged: (value) {
                                      _selectedTicketType[i] = value;
                                      final result = _ticketTypeListData
                                          .firstWhere((element) =>
                                              element.name == value);
                                      _selectedTicketTypeIds[i] = result.id!;
                                      if (mounted) setState(() {});
                                    },
                                    items: _ticketTypesName.map((e) {
                                      return DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e,
                                          style: poppinsRegular(
                                            fontSize: 16,
                                          ),
                                        ),
                                      );
                                    }).toList(),
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
                                  const CreateTextTitles(title: 'Title'),
                                  sizedBox(),
                                  CustomFormField(
                                    controller: _controllerCheckTitle[i],
                                    hintText: 'Ticket Title',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        sizedBox(height: 30),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CreateTextTitles(title: 'Amount'),
                                  sizedBox(),
                                  CustomFormField(
                                    controller: _controllerCheckQuantity[i],
                                    hintText: "0.00",
                                    textInputType: TextInputType.number,
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
                                  sizedBox(),
                                  CustomFormField(
                                    controller: _controllerCheckAmount[i],
                                    hintText: '0',
                                    textInputType: TextInputType.number,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        sizedBox(height: 5),
                        TextButton.icon(
                          onPressed: () => remove(i),
                          icon: const Icon(
                            Icons.delete,
                            size: 22,
                            color: WeweyouColors.primaryDarkRed,
                          ),
                          label: Text(
                            'Remove',
                            style: poppinsRegular(
                                fontSize: 16,
                                fontColor: WeweyouColors.primaryDarkRed,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                sizedBox(height: 25),
                const CreateTextTitles(
                  title:
                      'Connect your Stripe account to sell tickets for your paid Event',
                ),
                sizedBox(height: 25),
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StripeWebView(),
                      ),
                    );
                    if (result != null) {
                      stripeConnected = result;
                      nextProcess = 3;
                    } else {
                      showToast(
                        toastMsg:
                            "Please connect your stripe account to continue.",
                      );
                    }
                  },
                  child: Container(
                    height: 55,
                    width: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xff449DD1),
                          Color(0xff57B3E9),
                          Color(0xff298CDD),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'S',
                          style: poppinsBold(
                            fontWeight: FontWeight.w900,
                            fontSize: 26,
                            fontColor: WeweyouColors.customPureWhite,
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 2,
                          color: const Color(0xff3C799D),
                        ),
                        Text(
                          'Connect With Stripe',
                          style: poppinsRegular(
                            fontColor: WeweyouColors.customPureWhite,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                sizedBox(height: 25),
                const CreateTextTitles(
                  title: 'Accept major cards',
                ),
                sizedBox(),
                SizedBox(
                  height: 35,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, i) {
                      return Image.asset(
                        _cardList[i],
                        fit: BoxFit.fill,
                      );
                    },
                    separatorBuilder: (_, i) => sizedBox(width: 5),
                    itemCount: _cardList.length,
                  ),
                ),
                sizedBox(height: 25),
                const CreateTextTitles(
                  title: 'Transaction fees:',
                ),
                sizedBox(),
                subHeadingText(title: '2.9% + 30 cents'),
              ],
            ),
        ],
      ),
    );
  }

  // Create Event Second Step END//

  // Create Event Third Step BEGIN //

  final List<String> _eventType = [
    'Private Listing',
    'Stealth Listing',
    'Online Event'
  ];

  String? _selectedEventType;

  String networkUrl =
      'https://media.istockphoto.com/photos/party-people-enjoy-concert-at-festival-summer-music-festival-picture-id1324561072?b=1&k=20&m=1324561072&s=170667a&w=0&h=LwWrgpVzxoznttv_6qXMVtZHer1QSLNbfHmORZCFhN0=';

  int _eventTypeInt = 0;

  createEventThirdStep() {
    nextProcess = 4;
    final size = MediaQuery.of(context).size;
    return Form(
      key: _formKey3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          subHeadingText(title: 'Create an Event'),
          sizedBox(),
          SizedBox(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _eventType.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (ctx, i) {
                return GestureDetector(
                  onTap: () {
                    _eventTypeInt = i;
                    _selectedEventType = _eventType[i];
                    if (mounted) setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: WeweyouColors.blackPrimary,
                      borderRadius: BorderRadius.circular(5),
                      border: _eventTypeInt == i
                          ? Border.all(
                              width: 1.0,
                              color: WeweyouColors.secondaryOrange,
                            )
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
                                networkUrl,
                              ),
                            ),
                          ),
                        ),
                        sizedBox(),
                        Expanded(
                          flex: 1,
                          child: Text(
                            _eventType[i],
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
        ],
      ),
    );
  }

  // Create Event Third Step END //

  // Create Event Fourth Step BEGIN //

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
  }

  int checkVideoOrPhoto = 0;

  createEventFourthStep() {
    nextProcess = 4;
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
          // if (checkVideoOrPhoto == 0)
          // Column(
          //   children: [
          //     Text(
          //       "If you don't have a Cover Image, please select from our Library",
          //       style: poppinsRegular(
          //           fontColor: AppColors.greyPrimary, fontSize: 16),
          //     ),
          //     sizedBox(),
          //     SizedBox(
          //       height: 200,
          //       width: MediaQuery.of(context).size.width,
          //       child: ListView.builder(
          //           scrollDirection: Axis.horizontal,
          //           itemCount: _coverImageData.length,
          //           shrinkWrap: true,
          //           itemBuilder: (ctx, i) {
          //             return Stack(
          //               alignment: Alignment.center,
          //               children: [
          //                 ClipRRect(
          //                   borderRadius: BorderRadius.circular(5),
          //                   child: ImageNetworkFunction(
          //                     imagePath: NetworkImage(
          //                         "http://${_coverImageData[i].imageUrl!}"),
          //                     width: MediaQuery.of(context).size.width * 0.9,
          //                     fit: BoxFit.fill,
          //                   ),
          //                 ),
          //                 Positioned(
          //                   left: 5,
          //                   child: InkWell(
          //                     onTap: () {
          //                       // selectedPicture = i - 1;
          //                       print('Check $i');
          //                       if (mounted) setState(() {});
          //                     },
          //                     child: const CircleAvatar(
          //                       backgroundColor: AppColors.secondaryLightRed,
          //                       radius: 10,
          //                       child: Icon(
          //                         Icons.arrow_back_ios_new_rounded,
          //                         color: AppColors.customPureWhite,
          //                         size: 16,
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                 Positioned(
          //                   right: 5,
          //                   child: InkWell(
          //                     onTap: () {},
          //                     child: const CircleAvatar(
          //                       backgroundColor: AppColors.secondaryLightRed,
          //                       radius: 10,
          //                       child: Icon(
          //                         Icons.arrow_forward_ios_rounded,
          //                         color: AppColors.customPureWhite,
          //                         size: 16,
          //                       ),
          //                     ),
          //                   ),
          //                 )
          //               ],
          //             );
          //           }),
          //     ),
          //     sizedBox(height: 20),
          //     Container(
          //       padding: const EdgeInsets.only(top: 5, bottom: 5),
          //       height: 60,
          //       width: MediaQuery.of(context).size.width,
          //       child: ListView.separated(
          //         separatorBuilder: (_, i) => sizedBox(),
          //         scrollDirection: Axis.horizontal,
          //         // controller: _controller,
          //         itemCount: _coverImageData.length,
          //         shrinkWrap: true,
          //         itemBuilder: (ctx, i) {
          //           return InkWell(
          //             onTap: () {
          //               selectedPicture = _coverImageData[i].id;
          //               print('Check cover image id');
          //               print(selectedPicture);
          //               if (mounted) setState(() {});
          //             },
          //             child: Container(
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(5),
          //                 border: selectedPicture == _coverImageData[i].id
          //                     ? Border.all(
          //                         width: 1.0,
          //                         color: AppColors.secondaryOrange)
          //                     : null,
          //               ),
          //               child: ClipRRect(
          //                 borderRadius: BorderRadius.circular(5),
          //                 child: ImageNetworkFunction(
          //                   imagePath: NetworkImage(
          //                       "http://${_coverImageData[i].imageUrl!}"),
          //                   height: 50,
          //                   width: 50,
          //                   fit: BoxFit.fill,
          //                 ),
          //               ),
          //             ),
          //           );
          //         },
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  //Create Event Fourth Step END //

  final CommonProgress _commonProgress = CommonProgress();

  Future uploadImageVideoApi(ctx) async {
    final ProgressDialog pr = _commonProgress.commonProgressIndicator(
        context: ctx, loadingMsg: 'Creating Event... Please wait!');

    var token = await getAuthToken();
    var headers = {'Authorization': 'Bearer $token'};
    debugPrint(" token $token");
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        'https://mmfinfotech.co/Weweyou/api/user/add_videoOrImage',
      ),
    );

    var body1 = {
      'image_video_status': checkVideoOrPhoto == 1
          ? 1.toString()
          : checkVideoOrPhoto == 2
              ? 2.toString()
              : 0.toString(),
      'event_id': _createEventData!.eventId.toString(),
      // 'event_id': 36.toString(),
      'cover_img_id': checkVideoOrPhoto == 0 ? selectedPicture.toString() : ''
    };
    debugPrint('Check multipart Api body ---> $body1');
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
