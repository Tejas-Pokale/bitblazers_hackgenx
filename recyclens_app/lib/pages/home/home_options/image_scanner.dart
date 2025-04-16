import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'package:image/image.dart' as img;

class ImageScanPage extends StatefulWidget {
  const ImageScanPage({super.key});

  @override
  State<ImageScanPage> createState() => _ImageScanPageState();
}

class _ImageScanPageState extends State<ImageScanPage>
    with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  late AnimationController _animationController;
  late Animation<double> _scannerAnimation;
  File? _selectedImage;
  bool _cameraPermissionGranted = false;
  bool _imageCaptured = false;
  late Interpreter interpreter1;
  late Interpreter interpreter2;
  dynamic Labels = ['Battery', 'Keyboard', 'Laptop', 'Microwave', 'Mobile', 'Mouse', 'PCB', 'Player', 'Printer', 'Television', 'Washing Machine'];
  dynamic types = ['resell', 'recycle', 'dispose'];

  @override
  void initState() {
    super.initState();
    loadModel();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scannerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);

    _requestCameraPermissionAndInit();
  }

  Future<void> loadModel() async {
    try {
      interpreter1 = await Interpreter.fromAsset(
        'assets/models/classier.tflite',
      );
      interpreter2 = await Interpreter.fromAsset(
        'assets/models/ewaste_processing_model.tflite',
      );
    } catch (e) {
      print('Error loading model: $e');
      Get.snackbar('opps...', 'failed to load model');
    }
  }

  

 Future<String> classifyImage(File image, Interpreter interpreter, List<String> eWasteNames, int imageSize) async {
  final inputImage = img.decodeImage(await image.readAsBytes())!;
  final resizedImage = img.copyResize(inputImage, width: imageSize, height: imageSize);

  final input = List.generate(1, (batch) => List.generate(imageSize, (y) => List.generate(imageSize, (x) {
        final pixel = resizedImage.getPixel(x, y);
        return [
          pixel.r.toDouble(),
          pixel.g.toDouble(),
          pixel.b.toDouble()
        ];
      })));

  var output = List.filled(eWasteNames.length, 0.0).reshape([1, eWasteNames.length]);
  interpreter.run(input, output);

  List<double> probabilities = output.first.cast<double>();

  int maxIndex = probabilities.indexWhere((val) => val == probabilities.reduce((a, b) => a > b ? a : b));
  return eWasteNames[maxIndex];
}

 Future<String> runClassification(File? image ,Interpreter interpreter, int imageSize) async {
  List<String> eWasteNames = Labels; // Load e-waste names from labels.txt
  
  if (image != null) {
    String result = await classifyImage(image, interpreter, eWasteNames, imageSize);
    print(result);
    return result;
  } else {
    print('No image selected.');
    return 'bal';
  }
 }

 Future<String> determineType(File image, Interpreter interpreter, List<String> types, int imageSize) async {
  final inputImage = img.decodeImage(await image.readAsBytes())!;
  final resizedImage = img.copyResize(inputImage, width: imageSize, height: imageSize);

  final input = List.generate(1, (batch) => List.generate(imageSize, (y) => List.generate(imageSize, (x) {
        final pixel = resizedImage.getPixel(x, y);
        return [
          pixel.r.toDouble() / 255,
          pixel.g.toDouble() / 255,
          pixel.b.toDouble() / 255
        ];
      })));

  var output = List.filled(types.length, 0.0).reshape([1, types.length]);
  interpreter.run(input, output);

  List<double> probabilities = output.first.cast<double>();

  int maxIndex = probabilities.indexWhere((val) => val == probabilities.reduce((a, b) => a > b ? a : b));
  return types[maxIndex];
}

 Future<String> runDetermination(File? image ,Interpreter interpreter, int imageSize) async {
  List<String> type = types; // Load e-waste names from labels.txt
  
  if (image != null) {
    String result = await determineType(image, interpreter, type, imageSize);
    print(result);
    return result;
  } else {
    print('No image selected.');
    return 'bal';
  }
 }


  Future<void> _requestCameraPermissionAndInit() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() => _cameraPermissionGranted = true);
      await _initializeCamera();
    } else {
      setState(() => _cameraPermissionGranted = false);
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final backCam = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
      );

      _cameraController = CameraController(
        backCam,
        ResolutionPreset.max,
        enableAudio: false,
      );

      await _cameraController?.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Camera error: $e");
    }
  }

  Future<void> _pickFromGallery() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      _stopCameraAndAnimation();
      setState(() {
        _selectedImage = File(picked.path);
        _imageCaptured = true;
      });
    }
  }

  Future<void> _captureImageFromCamera() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final file = await _cameraController!.takePicture();
        _stopCameraAndAnimation();
        setState(() {
          _selectedImage = File(file.path);
          _imageCaptured = true;
        });
      } catch (e) {
        debugPrint('Error capturing image: $e');
      }
    }
  }

  void _stopCameraAndAnimation() {
    _animationController.stop();
    // _cameraController?.dispose();
    // _cameraController = null;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Widget _buildScannerOverlay() {
    return AnimatedBuilder(
      animation: _scannerAnimation,
      builder: (context, child) {
        return Align(
          alignment: Alignment(0, (_scannerAnimation.value * 2) - 1),
          child: Container(
            width: 250,
            height: 2,
            color: Colors.greenAccent.withOpacity(0.9),
          ),
        );
      },
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 30,
      child: Column(
        children: [
          if (!_imageCaptured && _cameraController != null)
            ElevatedButton.icon(
              onPressed: _captureImageFromCamera,
              icon: const Icon(Icons.camera_alt),
              label: const Text("Capture Image"),
              style: _buttonStyle(),
            ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _pickFromGallery,
            icon: const Icon(Icons.photo_library_outlined),
            label: const Text("Upload from Gallery"),
            style: _buttonStyle(),
          ),
        ],
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.teal.shade700,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_selectedImage != null)
            Image.file(
              _selectedImage!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            )
          else if (_cameraPermissionGranted &&
              _cameraController?.value.isInitialized == true)
            CameraPreview(_cameraController!)
          else if (!_cameraPermissionGranted)
            const Center(
              child: Text(
                "Camera permission not granted",
                style: TextStyle(color: Colors.white),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(color: Colors.greenAccent),
            ),

          // Scanner overlay
          if (!_imageCaptured &&
              _cameraPermissionGranted &&
              _cameraController?.value.isInitialized == true)
            Center(
              child: SizedBox(
                width: 250,
                height: 250,
                child: Stack(
                  children: [
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white30, width: 1.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    _buildScannerOverlay(),
                  ],
                ),
              ),
            ),

          _buildBottomControls(),

          if (_imageCaptured)
            Positioned(
              top: 50,
              right: 20,
              child: ElevatedButton.icon(
                onPressed: () async {
                  // Use _selectedImage!
                  // List<List<List<List<double>>>> inputData = await imageToInput(
                  //   _selectedImage!.path,
                  //   224,
                  //   224,
                  // ); // your input data.
                  // List<double> output = await runInference(inputData);
                  // String result = await processOutput(output, ['Battery', 'Keyboard', 'Microwave', 'Mobile', 'Mouse', 'PCB', 'Player', 'Printer', 'Television', 'Washing Machine']);
                  String result1 = await runClassification(File(_selectedImage!.path) , interpreter1, 224);
                  String result2 = await runDetermination(File(_selectedImage!.path) , interpreter2, 224);
                  Get.snackbar('Hehe', '${result1} ${result2}');
                  print('${result1} ${result2}');
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text("Proceed"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
