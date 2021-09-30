import 'package:creator_content/utils/popup.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtils {
  static final ImagePicker _picker = ImagePicker();

  static Future<List<XFile>> multiImage() async {
    try {
      final pickedFileList = await _picker.pickMultiImage(
          // maxWidth: maxWidth,
          // maxHeight: maxHeight,
          // imageQuality: quality,
          );
      return pickedFileList != null && pickedFileList.length > 0
          ? pickedFileList
          : [];
    } catch (e) {
      Popup.error(e.toString());
      return [];
    }
  }

  static Future<XFile?> singleImageCamera() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        // maxWidth: maxWidth,
        // maxHeight: maxHeight,
        // imageQuality: quality,
      );
      return pickedFile ?? null;
    } catch (e) {
      Popup.error(e.toString());
      return null;
    }
  }

  static Future<XFile?> ImageGallery() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        // maxWidth: maxWidth,
        // maxHeight: maxHeight,
        // imageQuality: quality,
      );
      return pickedFile ?? null;
    } catch (e) {
      Popup.error(e.toString());
      return null;
    }
  }

  static Future<XFile?> videoGallery() async {
    try {
      final pickedFile = await _picker.pickVideo(
          source: ImageSource.gallery,
          maxDuration: const Duration(seconds: 30));
      return pickedFile ?? null;
    } catch (e) {
      Popup.error(e.toString());
      return null;
    }
  }

  static Future<XFile?> videoCapture() async {
    try {
      final pickedFile = await _picker.pickVideo(
          source: ImageSource.camera, maxDuration: const Duration(seconds: 30));
      return pickedFile ?? null;
    } catch (e) {
      Popup.error(e.toString());
      return null;
    }
  }
}
