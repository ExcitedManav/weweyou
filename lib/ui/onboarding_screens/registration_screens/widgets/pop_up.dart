import 'package:flutter/material.dart';

import '../../../utils/common_text_style.dart';
import '../../../utils/constant.dart';
import '../../../utils/input_text_field.dart';

class PopUp extends StatefulWidget {
  const PopUp({Key? key, this.formField, required this.context}) : super(key: key);

  final Widget? formField;
  final BuildContext context;

  @override
  State<PopUp> createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  showPopUp({required BuildContext context}) {
    return showDialog(
        builder: (c) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: WeweyouColors.blackBackground,
              ),
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    width: 70,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black),
                    child:
                        Image.asset('assets/images_icons/onboarding/key.png'),
                  ),
                  sizedBox(),
                  headingText(
                    heading: 'Forgot Password',
                    fontSize: 22,
                  ),
                  sizedBox(height: 5),
                  headingText2(
                    heading2: 'Please Enter the email below',
                    fontSize: 16,
                  ),
                  sizedBox(height: 20),
                  widget.formField ?? const SizedBox.shrink()
                ],
              ),
            )),
        context: context);
  }

  showTestPopUp({required BuildContext context}) {
    return showDialog(
        builder: (c) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: WeweyouColors.blackBackground,
              ),
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    width: 70,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black),
                    child:
                        Image.asset('assets/images_icons/onboarding/key.png'),
                  ),
                  sizedBox(),
                  headingText(
                    heading: 'Forgot Password',
                    fontSize: 22,
                  ),
                  sizedBox(height: 5),
                  headingText2(
                    heading2: 'Please Enter the email below',
                    fontSize: 16,
                  ),
                  sizedBox(height: 20),
                  CustomFormField(
                    controller: TextEditingController(),
                    hintText: 'Email',
                    focusNode: FocusNode(),
                  ),
                ],
              ),
            )),
        context: widget.context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:  showTestPopUp(context: widget.context)
    );
  }
}
