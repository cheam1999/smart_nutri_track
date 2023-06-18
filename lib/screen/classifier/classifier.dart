
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import '../../controller/photo_scanning_controller.dart';
import 'classfier_model.dart';
import 'classifier_category.dart';

final photoScanningControllerProvider =
    ChangeNotifierProvider.autoDispose<PhotoScanningController>((ref) {
  return PhotoScanningController(ref.read);
});

typedef ClassifierLabels = List<String>;

class Classifier extends ChangeNotifier  {
  final ClassifierLabels _labels;
  final ClassifierModel _model;

  Classifier._({
    required ClassifierLabels labels,
    required ClassifierModel model,
  })  : _labels = labels,
        _model = model;

  static Future<Classifier?> loadWith({
    required String labelsFileName,
    required String modelFileName,
  }) async {
    try {
      final labels = await _loadLabels(labelsFileName);
      final model = await _loadModel(modelFileName);
      return Classifier._(labels: labels, model: model);
    } catch (e) {
      print('Can\'t initialize Classifier: ${e.toString()}');
      if (e is Error) {
        debugPrintStack(stackTrace: e.stackTrace);
      }
      return null;
    }
  }

  static Future<ClassifierModel> _loadModel(String modelFileName) async {
    final interpreter = await Interpreter.fromAsset(modelFileName);

    // Get input and output shape from the model
    final inputShape = interpreter.getInputTensor(0).shape;
    final outputShape = interpreter.getOutputTensor(0).shape;

    print('Input shape: $inputShape');
    print('Output shape: $outputShape');

    // Get input and output type from the model
    final inputType = interpreter.getInputTensor(0).type;
    final outputType = interpreter.getOutputTensor(0).type;

    print('Input type: $inputType');
    print('Output type: $outputType');

    return ClassifierModel(
      interpreter: interpreter,
      inputShape: inputShape,
      outputShape: outputShape,
      inputType: inputType,
      outputType: outputType,
    );
  }

  static Future<ClassifierLabels> _loadLabels(String labelsFileName) async {
    final rawLabels = await FileUtil.loadLabels(labelsFileName);

    // Remove the index number from the label
    final labels = rawLabels
        .map((label) => label.substring(label.indexOf(' ')).trim())
        .toList();

    print('Labels: $labels');
    return labels;
  }

  void close() {
    _model.interpreter.close();
  }

  ClassifierCategory predict(Image image) {
    print(
      'Image: ${image.width}x${image.height}, '
      'size: ${image.length} bytes',
    );

    // Load the image and convert it to TensorImage for TensorFlow Input
    final inputImage = _preProcessInput(image);

    print(
      'Pre-processed image: ${inputImage.width}x${image.height}, '
      'size: ${inputImage.buffer.lengthInBytes} bytes',
    );

    // Define the output buffer
    final outputBuffer = TensorBuffer.createFixedSize(
      _model.outputShape,
      _model.outputType,
    );

    // Run inference
    _model.interpreter.run(inputImage.buffer, outputBuffer.buffer);

    print('OutputBuffer: ${outputBuffer.getDoubleList()}');

    // Post Process the outputBuffer
    final resultCategories = _postProcessOutput(outputBuffer);
    final topResult = resultCategories.first;

    print('Top category: $topResult');

    return topResult;
  }

  List<ClassifierCategory> _postProcessOutput(TensorBuffer outputBuffer) {
    final probabilityProcessor = TensorProcessorBuilder().build();

    probabilityProcessor.process(outputBuffer);

    final labelledResult = TensorLabel.fromList(_labels, outputBuffer);

    final categoryList = <ClassifierCategory>[];
    labelledResult.getMapWithFloatValue().forEach((key, value) {
      final category = ClassifierCategory(key, value);
      categoryList.add(category);
      print('label: ${category.label}, score: ${category.score}');
    });
    categoryList.sort((a, b) => (b.score > a.score ? 1 : -1));

    return categoryList;
  }

  TensorImage _preProcessInput(Image image) {
    // #1
    final inputTensor = TensorImage(_model.inputType);
    inputTensor.loadImage(image);

    // #2
    final minLength = min(inputTensor.height, inputTensor.width);
    final cropOp = ResizeWithCropOrPadOp(minLength, minLength);

    // #3
    final shapeLength = _model.inputShape[1];
    final resizeOp = ResizeOp(shapeLength, shapeLength, ResizeMethod.BILINEAR);

    // #4
    final normalizeOp = NormalizeOp(127.5, 127.5);

    // #5
    final imageProcessor = ImageProcessorBuilder()
        .add(cropOp)
        .add(resizeOp)
        .add(normalizeOp)
        .build();

    imageProcessor.process(inputTensor);

    // #6
    return inputTensor;
  }
}