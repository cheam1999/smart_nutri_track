import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

import 'package:image_picker/image_picker.dart';
import 'package:smart_nutri_track/controller/barcode_products_controller.dart';
import 'package:smart_nutri_track/screen/barcode_details.dart';
import 'package:smart_nutri_track/screen/barcode_scanning.dart';
import 'package:smart_nutri_track/screen/init.dart';

import '../constant/showLoadingDialog.dart';
import '../main.dart';
import 'painters/barcode_detector_painter.dart';

enum ScreenMode { liveFeed, gallery }

class CameraView extends StatefulWidget {
  CameraView(
      {Key? key,
      required this.title,
      this.onScreenModeChanged,
      this.initialDirection = CameraLensDirection.back})
      : super(key: key);

  final String title;
  final Function(ScreenMode mode)? onScreenModeChanged;
  final CameraLensDirection initialDirection;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  ScreenMode _mode = ScreenMode.liveFeed;
  CameraController? _controller;
  File? _image;
  String? _path;
  ImagePicker? _imagePicker;
  int _cameraIndex = -1;
  double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0;
  final bool _allowPicker = true;
  bool _changingCameraLens = false;

  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;

  @override
  void initState() {
    super.initState();

    _imagePicker = ImagePicker();

    if (cameras.any(
      (element) =>
          element.lensDirection == widget.initialDirection &&
          element.sensorOrientation == 90,
    )) {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere((element) =>
            element.lensDirection == widget.initialDirection &&
            element.sensorOrientation == 90),
      );
    } else {
      for (var i = 0; i < cameras.length; i++) {
        if (cameras[i].lensDirection == widget.initialDirection) {
          _cameraIndex = i;
          break;
        }
      }
    }

    if (_cameraIndex != -1) {
      _startLiveFeed();
    } else {
      _mode = ScreenMode.gallery;
    }
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
    _canProcess = false;
    _barcodeScanner.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (_allowPicker)
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: _switchScreenMode,
                child: Icon(
                  _mode == ScreenMode.liveFeed
                      ? Icons.photo_library_outlined
                      : (Platform.isIOS
                          ? Icons.camera_alt_outlined
                          : Icons.camera),
                ),
              ),
            ),
        ],
      ),
      body: _galleryBody(),
      // floatingActionButton: _floatingActionButton(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Widget? _floatingActionButton() {
  //   if (_mode == ScreenMode.gallery) return null;
  //   if (cameras.length == 1) return null;
  //   return SizedBox(
  //       height: 70.0,
  //       width: 70.0,
  //       child: FloatingActionButton(
  //         onPressed: _switchLiveCamera,
  //         child: Icon(
  //           Platform.isIOS
  //               ? Icons.flip_camera_ios_outlined
  //               : Icons.flip_camera_android_outlined,
  //           size: 40,
  //         ),
  //       ));
  // }

  Widget _galleryBody() {
    return ListView(shrinkWrap: true, children: [
      _image != null
          ? SizedBox(
              height: 400,
              width: 400,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.file(_image!),
                  if (_customPaint != null) _customPaint!,
                ],
              ),
            )
          : Icon(
              Icons.image,
              size: 200,
            ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          child: Text('From Gallery'),
          onPressed: () => _getImage(ImageSource.gallery),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          child: Text('Take a picture'),
          onPressed: () {
            _getImage(ImageSource.camera);

            // await Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => BarcodeDetailScreen(code: widget.code),
            //     ));
          },
        ),
      ),
      // if (_image != null)
      //   Padding(
      //     padding: const EdgeInsets.all(16.0),
      //     child: Text(
      //         '${_path == null ? '' : 'Image path: $_path'}\n\n${widget.text ?? ''}'),
      //   ),
    ]);
  }

  Future _getImage(ImageSource source) async {
    setState(() {
      _image = null;
      _path = null;
    });
    final pickedFile = await _imagePicker?.pickImage(source: source);
    if (pickedFile != null) {
      _processPickedFile(pickedFile);
    }
    setState(() {});
  }

  void _switchScreenMode() {
    _image = null;
    if (_mode == ScreenMode.liveFeed) {
      _mode = ScreenMode.gallery;
      _stopLiveFeed();
    } else {
      _mode = ScreenMode.liveFeed;
      _startLiveFeed();
    }
    if (widget.onScreenModeChanged != null) {
      widget.onScreenModeChanged!(_mode);
    }
    setState(() {});
  }

  Future _startLiveFeed() async {
    final camera = cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.getMinZoomLevel().then((value) {
        zoomLevel = value;
        minZoomLevel = value;
      });
      _controller?.getMaxZoomLevel().then((value) {
        maxZoomLevel = value;
      });
      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Future _switchLiveCamera() async {
    setState(() => _changingCameraLens = true);
    _cameraIndex = (_cameraIndex + 1) % cameras.length;

    await _stopLiveFeed();
    await _startLiveFeed();
    setState(() => _changingCameraLens = false);
  }

  Future _processPickedFile(XFile? pickedFile) async {
    final path = pickedFile?.path;
    if (path == null) {
      return;
    }
    setState(() {
      _image = File(path);
    });
    _path = path;
    final inputImage = InputImage.fromFilePath(path);

    processImage(inputImage);
  }

  Future _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final camera = cameras[_cameraIndex];
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    if (imageRotation == null) return;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw);
    if (inputImageFormat == null) return;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    processImage(inputImage);
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;

    final barcodes = await _barcodeScanner.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = BarcodeDetectorPainter(
          barcodes,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      _customPaint = CustomPaint(painter: painter);
    } else {
      // TODO if no barcode found

      // var text = 'Barcodes found: ${barcodes.length}\n\n';
      String text = 'Barcodes found: ${barcodes.length}\n\n';
      String? code;
      for (final barcode in barcodes) {
        text += 'Barcode: ${barcode.rawValue}\n\n';
        code = barcode.rawValue!;
      }

      if (code == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('NO BARCODE DETECTED! PLEASE TRY AGAIN!')));
      } else {
        showLoadingDialog(context: context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BarcodeDetailScreen(
                code: code,
              ),
            ));
      }

      // TODO: set _customPaint to draw boundingRect on top of image
      _customPaint = null;
    }
    _isBusy = false;
  }
}
