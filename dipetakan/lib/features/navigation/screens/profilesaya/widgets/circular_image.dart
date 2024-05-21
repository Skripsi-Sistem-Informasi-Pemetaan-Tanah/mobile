import 'package:cached_network_image/cached_network_image.dart';
import 'package:dipetakan/features/navigation/screens/widgets/shimmer.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class DCircularImages extends StatelessWidget {
  const DCircularImages(
      {super.key,
      this.fit = BoxFit.cover,
      required this.image,
      this.isNetworkImage = false,
      this.overlayColor,
      this.backgroundColor,
      this.width = 50,
      this.height = 50,
      this.padding = DSizes.sm});

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      // padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ??
            (DHelperFunctions.isDarkMode(context)
                ? DColors.black
                : DColors.white),
        borderRadius: BorderRadius.circular(100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Center(
          child: isNetworkImage
              ? CachedNetworkImage(
                  fit: fit,
                  color: overlayColor,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      const DShimmerEfffect(width: 55, height: 55, radius: 55),
                  imageUrl: image,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              : Image(
                  fit: fit,
                  image: isNetworkImage
                      ? NetworkImage(image)
                      : AssetImage(image) as ImageProvider,
                  color: overlayColor,
                ),
        ),
      ),
    );
  }
}
