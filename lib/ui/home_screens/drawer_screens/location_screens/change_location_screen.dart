import 'package:flutter/material.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:weweyou/data/networking/shared_pref.dart';
import 'package:weweyou/ui/utils/common_button.dart';
import 'package:weweyou/ui/utils/common_text_style.dart';

import '../../../utils/constant.dart';
import '../../create_event/widgets/common_text.dart';

class ChangeLocationScreen extends StatefulWidget {
  const ChangeLocationScreen({Key? key}) : super(key: key);

  @override
  State<ChangeLocationScreen> createState() => _ChangeLocationScreenState();
}

class _ChangeLocationScreenState extends State<ChangeLocationScreen> {
  String? inputLocation;

  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  getCurrentLocation() async {
    final location = await getLocation();
    setState(() {
      inputLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WeweyouColors.blackBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: inputLocation != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sizedBox(height: 20),
                  const CreateTextTitles(title: 'Your current location'),
                  sizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: WeweyouColors.blackPrimary,
                    ),
                    child: Text(
                      inputLocation ?? '',
                      style: poppinsRegular(
                        fontColor: WeweyouColors.customPureWhite,
                      ),
                    ),
                  ),
                  sizedBox(height: 20),
                ],
              )
            : Align(
                alignment: Alignment.center,
                child: Text(
                  'Oops! you have not added your location yet',
                  style: poppinsSemiBold(),
                ),
              ),
      ),
      bottomNavigationBar: CommonButton(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        onPressed: () async {
          LocationResult? location = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PlacePicker(mapApiKey),
            ),
          );
          if (location != null) {
            _locationController.text = location.formattedAddress.toString();
            setLocation(_locationController.text);
            getCurrentLocation();
          }
          if (mounted) setState(() {});
        },
        buttonName:
            inputLocation != null ? 'Update Location' : "Add Your Location",
      ),
    );
  }
}
