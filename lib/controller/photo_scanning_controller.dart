import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final photoScanningControllerProvider =
    ChangeNotifierProvider.autoDispose<PhotoScanningController>((ref) {
  return PhotoScanningController(ref.read);
});

class PhotoScanningController extends ChangeNotifier {
  final Reader _read;
  // final String _listType;
  // int _page = 1;

  PhotoScanningController(this._read);

  bool _imageLabelChecking = false;
  bool get imageLabelChecking => _imageLabelChecking;
  
  XFile? _imageFile;
  XFile? get imageFile => _imageFile;

  String _imageLabel = "";
  String get imageLabel => _imageLabel;

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        _imageLabelChecking = true;
        _imageFile = pickedImage;
        notifyListeners();
        getImageLabels(pickedImage);
      }
    } catch (e) {
      _imageLabelChecking = false;
      _imageFile = null;
      _imageLabel = "Error occurred while getting image Label";
      notifyListeners();
    }
  }

  void getImageLabels(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    ImageLabeler imageLabeler =
        ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.75));
    List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
    StringBuffer sb = StringBuffer();
    for (ImageLabel imgLabel in labels) {
      String lblText = imgLabel.label;
      double confidence = imgLabel.confidence;
      sb.write(lblText);
      sb.write(" : ");
      sb.write((confidence * 100).toStringAsFixed(2));
      sb.write("%\n");
    }
    imageLabeler.close();
    _imageLabel = sb.toString();
    _imageLabelChecking = false;
    notifyListeners();
  }
}
