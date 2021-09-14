import 'package:creator_content/components/layout_objects/layout_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewImageController extends GetxController {
  static ViewImageController get to => Get.find();
  PageController? pageController;
  List<ModelImage> images = <ModelImage>[];
  var currentIndex = 0.obs;

  @override
  void onInit() {
    debugPrint('onInit');
    pageController = PageController(initialPage: 0);
    super.onInit();
  }

  @override
  void onReady() {
    debugPrint('onReady');
    super.onReady();
  }

  void initData({
    List<ModelImage>? images,
    String? heroTag,
    bool? isImageBase64 = false,
    int? currentIndex = 0,
  }) {
    this.pageController = PageController(initialPage: currentIndex!);
    this.images = List.of(images ?? []);
    this.currentIndex(currentIndex + 1);
  }

  void setCurrentPage(int newPage) => currentIndex(newPage + 1);
}
