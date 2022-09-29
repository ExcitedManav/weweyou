import 'package:flutter/material.dart';

import '../../../utils/common_text_style.dart';
import '../../../utils/constant.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    Key? key,
    required this.onPressedDate,
    required this.selectedDate,
    required this.onPressedTime,
    required this.selectedTime,
  }) : super(key: key);
  final VoidCallback onPressedDate;
  final String selectedDate;
  final VoidCallback onPressedTime;
  final String selectedTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: InkWell(
              onTap: onPressedDate,
              child: Container(
                height: 55,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: WeweyouColors.blackPrimary,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      color: WeweyouColors.secondaryOrange,
                      size: 22,
                    ),
                    sizedBox(),
                    Text(
                      selectedDate,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: poppinsRegular(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),),
        sizedBox(),
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: onPressedTime,
            child: Container(
              height: 55,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: WeweyouColors.blackPrimary,
              ),
              child: Text(
                selectedTime,
                style: poppinsRegular(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
