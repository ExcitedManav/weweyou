import 'package:flutter/material.dart';
import 'package:weweyou/ui/utils/constant.dart';

class ImageNetworkFunction extends StatelessWidget {
  const ImageNetworkFunction(
      {Key? key, required this.imagePath, this.height, this.width, this.fit})
      : super(key: key);

  final ImageProvider imagePath;
  final double? height;
  final double? width;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: FadeInImage(
          placeholder: const AssetImage('assets/loader/loader.gif'),
          image: imagePath,
          fit: fit ?? BoxFit.cover,
          imageErrorBuilder: (ctx, widget, child) {
            return const Icon(
              Icons.image_not_supported_outlined,
              color: WeweyouColors.primaryDarkRed,
              size: 35,
            );
          },
        ),
      ),
    );
  }
}
