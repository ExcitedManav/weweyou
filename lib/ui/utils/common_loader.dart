import 'package:flutter/cupertino.dart';

import 'constant.dart';

class CommonLoader extends StatelessWidget {
  const CommonLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CupertinoActivityIndicator(
        color: WeweyouColors.customPureWhite,
        radius: 20,
      ),
    );
  }
}
