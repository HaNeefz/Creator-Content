import 'package:get/get.dart';

class PreviewController extends GetxController {
  static PreviewController get to => Get.find();
  var isListLayout = false.obs;

  changeLayout() => isListLayout.toggle();
}
