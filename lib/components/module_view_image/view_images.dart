import 'package:creator_content/components/layout_objects/layout_image.dart';
import 'package:creator_content/themes/color_constants.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/controller.dart';

// ignore: must_be_immutable
class PhotoViewPage extends StatelessWidget {
  final List<ModelImage>? image;
  final String? heroTag;
  final bool isImageBase64;
  int currentIndex;
  PhotoViewPage({
    Key? key,
    this.image,
    this.heroTag,
    this.currentIndex = 0,
    this.isImageBase64 = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('heroTag : $heroTag');
    final controller = Get.put(ViewImageController());
    controller.initData(
      images: image,
      currentIndex: currentIndex,
    );
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          child: Stack(children: <Widget>[
            ExtendedImageGesturePageView.builder(
              controller: controller.pageController!,
              scrollDirection: Axis.horizontal,
              itemCount: controller.images.length,
              onPageChanged: (v) => controller.setCurrentPage(v),
              itemBuilder: (BuildContext context, int index) {
                var tag = controller.images[index].id;
                debugPrint('tag : $tag');
                return ExtendedImageSlidePage(
                  child: Hero(
                    transitionOnUserGestures: true,
                    tag: heroTag!,
                    child: ExtendedImage.memory(
                      controller.images[index].image!,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      enableSlideOutPage: true,
                      mode: ExtendedImageMode.gesture,
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.contain,
                      clearMemoryCacheIfFailed: true,
                      enableMemoryCache: true,
                      clearMemoryCacheWhenDispose: true,
                      loadStateChanged: (state) {
                        if (state.extendedImageLoadState == LoadState.failed) {
                          return Icon(
                            Icons.error,
                            color: ColorConstant.red,
                          );
                        }
                      },
                      initGestureConfigHandler: (state) {
                        return GestureConfig(
                            initialAlignment: InitialAlignment.center,
                            minScale: 0.9,
                            animationMinScale: 0.7,
                            maxScale: 5.0,
                            animationMaxScale: 6.0,
                            speed: 1.0,
                            initialScale: 1.0,
                            inertialSpeed: 100,
                            inPageView: true);
                      },
                    ),
                  ),
                  slideAxis: SlideAxis.both,
                  slideType: SlideType.onlyImage,
                  resetPageDuration: Duration(milliseconds: 2000),
                );
              },
            ),
            Positioned(
              right: 10,
              child: SafeArea(
                child: CircleAvatar(
                  backgroundColor: ColorConstant.black,
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 80.0,
                child: Center(
                    child: Obx(() => Text(
                          "${controller.currentIndex}/${controller.images.length}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
              ),
            )
          ]),
        ));
  }
}
