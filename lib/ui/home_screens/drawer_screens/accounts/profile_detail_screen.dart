import 'package:flutter/material.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:weweyou/ui/home_screens/drawer_screens/accounts/set_new_password.dart';
import 'package:weweyou/ui/home_screens/drawer_screens/accounts/widgets/custom_text.dart';
import 'package:weweyou/ui/home_screens/widgets/image_network_function.dart';
import 'package:weweyou/ui/onboarding_screens/registration_screens/set_new_password.dart';
import 'package:weweyou/ui/utils/common_button.dart';
import 'package:weweyou/ui/utils/common_text_style.dart';
import 'package:weweyou/ui/utils/constant.dart';
import 'package:weweyou/ui/utils/input_text_field.dart';
import 'package:weweyou/ui/utils/validator.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();

  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _dobFocus = FocusNode();
  final FocusNode _phoneNumFocus = FocusNode();
  final FocusNode _companyFocus = FocusNode();
  final FocusNode _websiteFocus = FocusNode();
  final FocusNode _postalCodeFocus = FocusNode();
  final FocusNode _regionFocus = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: WeweyouColors.blackBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MY ACCOUNT',
                style: poppinsBold(fontWeight: FontWeight.w700, fontSize: 20),
              ),
              sizedBox(),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const ImageNetworkFunction(
                  height: 87,
                  width: 84,
                  imagePath: NetworkImage(
                    'https://st.depositphotos.com/1371851/1256/i/600/depositphotos_12560182-stock-photo-handsome-man-with-eyeglasses.jpg',
                  ),
                ),
              ),
              sizedBox(height: 20),
              const CustomText(
                initialText: 'First Name',
                requiredText: ' *',
              ),
              sizedBox(height: 10),
              CustomFormField(
                controller: _firstNameController,
                hintText: 'Enter First Name',
                focusNode: _firstNameFocus,
                validator: (val) => requiredField(
                  val,
                  'First Name',
                ),
              ),
              sizedBox(height: 20),
              const CustomText(
                initialText: 'Last Name',
                requiredText: ' *',
              ),
              sizedBox(height: 10),
              CustomFormField(
                controller: _lastNameController,
                hintText: 'Enter Last Name',
                focusNode: _lastNameFocus,
                validator: (val) => requiredField(
                  val,
                  'Last Name',
                ),
              ),
              sizedBox(height: 20),
              const CustomText(
                initialText: 'Date of Birth',
                requiredText: ' *',
              ),
              sizedBox(height: 10),
              CustomFormField(
                controller: _dobController,
                hintText: 'Enter Date of Birth',
                focusNode: _dobFocus,
                textInputType: TextInputType.number,
                validator: (val) => requiredField(
                  val,
                  'Date of Birth',
                ),
              ),
              sizedBox(height: 20),
              const CustomText(
                initialText: 'Phone Number',
                requiredText: ' *',
              ),
              sizedBox(height: 10),
              CustomFormField(
                controller: _phoneNumberController,
                hintText: 'Enter Phone number',
                focusNode: _phoneNumFocus,
                textInputType: TextInputType.number,
                validator: (val) => requiredField(
                  val,
                  'Phone number',
                ),
              ),
              sizedBox(height: 20),
              const CustomText(
                initialText: 'Company',
              ),
              sizedBox(height: 10),
              CustomFormField(
                controller: _companyController,
                hintText: 'Enter Company',
                focusNode: _companyFocus,
              ),
              sizedBox(height: 20),
              const CustomText(
                initialText: 'Website',
              ),
              sizedBox(height: 10),
              CustomFormField(
                controller: _websiteController,
                hintText: 'Enter Website',
                focusNode: _websiteFocus,
                textInputType: TextInputType.url,
              ),
              sizedBox(height: 20),
              Text(
                'Address',
                style: poppinsMedium(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              sizedBox(height: 20),
              const CustomText(
                initialText: 'Address',
              ),
              sizedBox(height: 10),
              CustomFormField(
                controller: _locationController,
                hintText: 'Enter Address',
                onPressed: () async {
                  LocationResult result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PlacePicker(
                        mapApiKey,
                      ),
                    ),
                  );
                  _locationController.text = result.formattedAddress.toString();
                },
                validator: (val) => requiredField(val, 'Location'),
                maxLine: 2,
                readOnly: true,
              ),
              sizedBox(height: 20),
              const CustomText(
                initialText: 'Postal Code',
              ),
              sizedBox(height: 10),
              CustomFormField(
                controller: _postalCodeController,
                hintText: 'Enter Postal Code',
                focusNode: _postalCodeFocus,
                textInputType: TextInputType.url,
              ),
              sizedBox(height: 20),
              const CustomText(
                initialText: 'Region',
              ),
              sizedBox(height: 10),
              CustomFormField(
                controller: _regionController,
                hintText: 'Enter Region',
                focusNode: _regionFocus,
                textInputType: TextInputType.url,
              ),
              sizedBox(height: 30),
              CommonButton(
                onPressed: () {
                  if(_formKey.currentState!.validate()){
                    _formKey.currentState!.save();
                  }
                },
                buttonName: "Save",
              ),
              sizedBox(height: 20),
              CommonButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SetNewPasswordProfile(),
                    ),
                  );
                },
                buttonName: "Set New Password",
              )
            ],
          ),
        ),
      ),
    );
  }
}
