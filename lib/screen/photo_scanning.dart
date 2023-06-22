import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:smart_nutri_track/screen/add_meal.dart';
import 'package:smart_nutri_track/screen/photo_view.dart';
import 'package:smart_nutri_track/size_config.dart';

import '../component/default_button.dart';
import '../constant/colour_constant.dart';
import 'classifier/classifier.dart';

const _labelsFileName = 'assets/labels.txt';
const _modelFileName = 'assets/model_unquant.tflite';

class PlantRecogniser extends StatefulWidget {
  static String routeName = "/plantRecogniser";
  const PlantRecogniser({super.key});

  @override
  State<PlantRecogniser> createState() => _PlantRecogniserState();
}

enum _ResultStatus {
  notStarted,
  notFound,
  found,
}

class _PlantRecogniserState extends State<PlantRecogniser> {
  bool _isAnalyzing = false;
  final picker = ImagePicker();
  File? _selectedImageFile;

  // Result
  _ResultStatus _resultStatus = _ResultStatus.notStarted;
  String _plantLabel = ''; // Name of Error Message
  double _accuracy = 0.0;

  late Classifier _classifier;

  @override
  void initState() {
    super.initState();
    _loadClassifier();
  }

  Future<void> _loadClassifier() async {
    print(
      'Start loading of Classifier with '
      'labels at $_labelsFileName, '
      'model at $_modelFileName',
    );

    final classifier = await Classifier.loadWith(
      labelsFileName: 'assets/labels.txt',
      modelFileName: 'model_unquant.tflite',
    );
    _classifier = classifier!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Photo Scanning",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: ColourConstant.kWhiteColor,
      ),
      body: Container(
        // color: kBgColor,
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            _buildPhotolView(),
            SizedBox(height: getProportionateScreenHeight(20)),
            _buildPickPhotoButton(
              title: 'Take a photo',
              source: ImageSource.camera,
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            _buildPickPhotoButton(
              title: 'Pick from gallery',
              source: ImageSource.gallery,
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            _buildResultView(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotolView() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        PhotoView(file: _selectedImageFile),
        _buildAnalyzingText(),
      ],
    );
  }

  Widget _buildAnalyzingText() {
    if (!_isAnalyzing) {
      return const SizedBox.shrink();
    }
    return const Text('Analyzing...');
  }

  Widget _buildPickPhotoButton({
    required ImageSource source,
    required String title,
  }) {
    return DefaultButton(
      text: title,
      press: () {
        _onPickPhoto(source);
      },
    );
  }

  void _setAnalyzing(bool flag) {
    setState(() {
      _isAnalyzing = flag;
    });
  }

  void _onPickPhoto(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile == null) {
      return;
    }

    final imageFile = File(pickedFile.path);
    setState(() {
      _selectedImageFile = imageFile;
    });

    _analyzeImage(imageFile);
  }

  void _analyzeImage(File image) {
    _setAnalyzing(true);

    final imageInput = img.decodeImage(image.readAsBytesSync())!;

    final resultCategory = _classifier.predict(imageInput);

    final result = resultCategory.score >= 0.8
        ? _ResultStatus.found
        : _ResultStatus.notFound;
    final plantLabel = resultCategory.label;
    final accuracy = resultCategory.score;

    _setAnalyzing(false);

    setState(() {
      _resultStatus = result;
      _plantLabel = plantLabel;
      _accuracy = accuracy;
    });
  }

  Widget _buildResultView() {
    var title = '';

    if (_resultStatus == _ResultStatus.notFound) {
      title = 'Fail to recognise';
    } else if (_resultStatus == _ResultStatus.found) {
      title = _plantLabel;
    } else {
      title = '';
    }

    //
    var accuracyLabel = '';
    if (_resultStatus == _ResultStatus.found) {
      accuracyLabel = 'Accuracy: ${(_accuracy * 100).toStringAsFixed(2)}%';
    }

    return Column(
      children: [
        if (title != "")
          Text(
            "Food Name: $title",
          ),
        const SizedBox(height: 10),
        Text(
          accuracyLabel,
        ),
        SizedBox(height: getProportionateScreenHeight(20)),
        if (title != "")
          DefaultButton(
            text: "Search food",
            press: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMealScreen(
                      foodName: title,
                    ),
                  ));
            },
          )
      ],
    );
  }
}
