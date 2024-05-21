import 'package:carousel_slider/carousel_slider.dart';
import 'package:dipetakan/features/lahansaya/controllers/carousal_controller.dart';
import 'package:dipetakan/features/lahansaya/screens/widgets/circular_container.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarouselSlide extends StatelessWidget {
  const CarouselSlide({
    super.key,
    required this.photos,
  });

  final List<String> photos;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CarousalController());

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          CarouselSlider(
              options: CarouselOptions(
                  viewportFraction: 1,
                  onPageChanged: (index, _) =>
                      controller.updatePageIndicator(index)),
              items: photos
                  .map((url) =>
                      DRoundedImage(imageUrl: url, isNetworkimage: true))
                  .toList()),
          const SizedBox(height: DSizes.spaceBtwItems),
          Center(
            child: Obx(
              () => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < photos.length; i++)
                    DCircularContainer(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 10),
                      backgroundColor:
                          controller.carousalCurrentIndex.value == i
                              ? DColors.primary
                              : DColors.grey,
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DRoundedImage extends StatelessWidget {
  const DRoundedImage({
    super.key,
    this.width = 900,
    this.height,
    this.applyImageRadius = true,
    this.border,
    this.backgroundColor = DColors.white,
    this.fit = BoxFit.cover,
    this.padding,
    this.isNetworkimage = true,
    this.onPressed,
    this.borderRadius = 0,
    required this.imageUrl,
  });

  final double? width, height;
  final String imageUrl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkimage;
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
            borderRadius: applyImageRadius
                ? BorderRadius.circular(borderRadius)
                : BorderRadius.zero,
            child: Image(
              fit: fit,
              image: isNetworkimage
                  ? NetworkImage(imageUrl)
                  : AssetImage(imageUrl) as ImageProvider,
            )),
      ),
    );
  }
}
