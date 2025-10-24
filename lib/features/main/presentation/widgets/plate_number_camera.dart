import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class PlateNumberCamera extends StatefulWidget {
  final Function(String) onPlateRecognized;
  final String? initialPlate;

  const PlateNumberCamera({
    super.key,
    required this.onPlateRecognized,
    this.initialPlate,
  });

  @override
  State<PlateNumberCamera> createState() => _PlateNumberCameraState();
}

class _PlateNumberCameraState extends State<PlateNumberCamera> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  String _recognizedPlate = '';
  bool _isProcessing = false;
  bool _isInitialized = false;
  TextRecognizer? _textRecognizer;
  DateTime? _lastScanTime;

  @override
  void initState() {
    super.initState();
    if (widget.initialPlate != null && widget.initialPlate!.isNotEmpty) {
      _recognizedPlate = widget.initialPlate!;
    }
    _initializeCamera();
    _textRecognizer = TextRecognizer();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _textRecognizer?.close();
    super.dispose();
  }

  /// Initialize the camera
  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        
        await _cameraController!.initialize();
        
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          
          // Start continuous scanning
          _startContinuousScanning();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _recognizedPlate = 'Error initializing camera: $e';
        });
      }
    }
  }

  /// Start continuous scanning for plate numbers
  void _startContinuousScanning() {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      _cameraController!.startImageStream(_processCameraImage);
    }
  }

  /// Process camera image stream for plate detection
  Future<void> _processCameraImage(CameraImage image) async {
    if (_isProcessing || _textRecognizer == null) return;
    
    // Throttle scanning to avoid too frequent processing
    final now = DateTime.now();
    if (_lastScanTime != null && now.difference(_lastScanTime!).inMilliseconds < 2000) {
      return;
    }
    _lastScanTime = now;

    try {
      setState(() {
        _isProcessing = true;
      });

      final InputImage inputImage = _inputImageFromCameraImage(image);
      final RecognizedText recognizedText = await _textRecognizer!.processImage(inputImage);
      
      String rawText = recognizedText.text.toUpperCase();
      String extractedPlate = _extractLicensePlate(rawText);

      if (extractedPlate.isNotEmpty && extractedPlate != 'NOT_FOUND') {
        if (mounted) {
          setState(() {
            _recognizedPlate = extractedPlate;
          });
          widget.onPlateRecognized(extractedPlate);
        }
      }
    } catch (e) {
      // Silent error handling for continuous scanning
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  /// Convert CameraImage to InputImage
  InputImage _inputImageFromCameraImage(CameraImage image) {
    final camera = _cameras![0];
    final rotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    final plane = image.planes.first;
    
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation ?? InputImageRotation.rotation0deg,
        format: format ?? InputImageFormat.nv21,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }


  /// Simple heuristic/regex to filter recognized text for a common plate pattern.
  String _extractLicensePlate(String rawText) {
    // Regex for many common plate formats (e.g., AAA-111, 1AA-1111, A1A-111).
    final RegExp plateRegex = RegExp(r'[A-Z0-9]{2,4}[ -]?[A-Z0-9]{3,4}', caseSensitive: false);
    
    // Clean up the text by removing newlines and non-plate-related symbols
    String cleanText = rawText.replaceAll(RegExp(r'[^\w\s\-]'), '').trim();

    final matches = plateRegex.allMatches(cleanText);

    if (matches.isNotEmpty) {
      // Return the first match found, removing any spaces or dashes for a clean result
      return matches.first.group(0)?.replaceAll(RegExp(r'[ -]'), '') ?? 'NOT_FOUND';
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
      ),
      child: Stack(
        children: [
          // Live camera preview
          if (_isInitialized && _cameraController != null)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CameraPreview(_cameraController!),
              ),
            )
          else
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_recognizedPlate.contains('Error'))
                        Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.red[400],
                        )
                      else
                        const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        _recognizedPlate.contains('Error') 
                            ? _recognizedPlate
                            : 'Initializing camera...',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          
          // Scanning indicator overlay
          if (_isProcessing)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Scanning...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          
          // Recognized plate display overlay
          if (_recognizedPlate.isNotEmpty && !_recognizedPlate.contains('Error') && !_recognizedPlate.contains('Initializing'))
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green[300]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green[700],
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Plate detected: $_recognizedPlate',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
