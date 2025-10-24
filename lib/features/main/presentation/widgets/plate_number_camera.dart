import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';
import 'plate_detected_notification.dart';

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
  final Logger _logger = Logger();
  bool _hasPermission = false;
  bool _showPlateDetected = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialPlate != null && widget.initialPlate!.isNotEmpty) {
      _recognizedPlate = widget.initialPlate!;
    }
    _textRecognizer = TextRecognizer();
    _checkPermissionsAndInitialize();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _textRecognizer?.close();
    super.dispose();
  }

  /// Check camera permissions before initializing
  Future<void> _checkPermissionsAndInitialize() async {
    try {
      final status = await Permission.camera.request();
      if (status.isGranted) {
        setState(() {
          _hasPermission = true;
        });
        await _initializeCamera();
      } else {
        setState(() {
          _recognizedPlate = 'Camera permission denied. Please enable camera access in settings.';
        });
        _logger.e('Camera permission denied');
      }
    } catch (e) {
      setState(() {
        _recognizedPlate = 'Error checking permissions: $e';
      });
      _logger.e('Permission check error: $e');
    }
  }

  /// Initialize the camera
  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.medium, // Reduced resolution to prevent memory issues
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.yuv420, // Explicit format
        );
        
        await _cameraController!.initialize();
        
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          
          // Don't start continuous scanning automatically
          // User will trigger scanning with button press
        }
      } else {
        setState(() {
          _recognizedPlate = 'No cameras available on this device';
        });
        _logger.e('No cameras available');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _recognizedPlate = 'Error initializing camera: $e';
        });
      }
      _logger.e('Camera initialization error: $e');
    }
  }


  /// Capture and process a single image for plate recognition
  Future<void> _captureAndProcessImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized || _isProcessing) {
      return;
    }

    try {
      setState(() {
        _isProcessing = true;
      });

      // Take a picture
      final XFile imageFile = await _cameraController!.takePicture();
      
      // Create InputImage from file path (simpler and more reliable)
      final InputImage inputImage = InputImage.fromFilePath(imageFile.path);

      if (_textRecognizer != null) {
        final RecognizedText recognizedText = await _textRecognizer!.processImage(inputImage);
        
        String rawText = recognizedText.text.toUpperCase();
        String extractedPlate = _extractLicensePlate(rawText);

        if (extractedPlate.isNotEmpty && extractedPlate != 'NOT_FOUND') {
          if (mounted) {
            setState(() {
              _recognizedPlate = extractedPlate;
              _showPlateDetected = true;
            });
            widget.onPlateRecognized(extractedPlate);
          }
        } else {
          if (mounted) {
            setState(() {
              _recognizedPlate = 'No plate detected. Try again.';
            });
          }
        }
      }
    } catch (e) {
      _logger.e('Error capturing and processing image: $e');
      if (mounted) {
        setState(() {
          _recognizedPlate = 'Error processing image: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }




  /// Simple heuristic/regex to filter recognized text for a common plate pattern.
  String _extractLicensePlate(String rawText) {
    // Clean up the text by removing newlines and non-plate-related symbols
    String cleanText = rawText.replaceAll(RegExp(r'[^\w\s\-]'), '').trim();
    
    // Multiple regex patterns for different plate formats
    final List<RegExp> platePatterns = [
      // Standard format: ABC-1234, ABC1234
      RegExp(r'[A-Z]{3}[ -]?[0-9]{4}', caseSensitive: false),
      // Format with letters and numbers mixed: A1B-2345
      RegExp(r'[A-Z0-9]{2,4}[ -]?[A-Z0-9]{3,4}', caseSensitive: false),
      // Short format: AB-123
      RegExp(r'[A-Z]{2}[ -]?[0-9]{3}', caseSensitive: false),
      // Long format: ABC-12345
      RegExp(r'[A-Z]{3}[ -]?[0-9]{5}', caseSensitive: false),
    ];

    for (final pattern in platePatterns) {
      final matches = pattern.allMatches(cleanText);
      if (matches.isNotEmpty) {
        String plate = matches.first.group(0)?.replaceAll(RegExp(r'[ -]'), '') ?? '';
        // Validate plate length (typically 5-8 characters)
        if (plate.length >= 5 && plate.length <= 8) {
          return plate;
        }
      }
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Stack(
        children: [
          // Live camera preview
          if (_isInitialized && _cameraController != null && _hasPermission)
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
                      if (_recognizedPlate.contains('Error') || _recognizedPlate.contains('permission'))
                        Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.red[400],
                        )
                      else if (!_hasPermission)
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 60,
                          color: Colors.orange[400],
                        )
                      else
                        const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        _recognizedPlate.contains('Error') || _recognizedPlate.contains('permission')
                            ? _recognizedPlate
                            : !_hasPermission
                                ? 'Requesting camera permission...'
                                : 'Initializing camera...',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (!_hasPermission && _recognizedPlate.contains('permission'))
                        const SizedBox(height: 16),
                      if (!_hasPermission && _recognizedPlate.contains('permission'))
                        ElevatedButton(
                          onPressed: () async {
                            await _checkPermissionsAndInitialize();
                          },
                          child: const Text('Retry Permission'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          
          // Single capture button overlay
          if (_isInitialized && _cameraController != null && _hasPermission)
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isProcessing ? Icons.hourglass_empty : Icons.touch_app,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: _isProcessing ? null : _captureAndProcessImage,
                    iconSize: 32,
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ),
          
          // Processing indicator overlay
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
                        'Processing image...',
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
          
          // Plate detected notification overlay
          if (_showPlateDetected)
            PlateDetectedNotification(
              plateNumber: _recognizedPlate,
              onDismiss: () {
                setState(() {
                  _showPlateDetected = false;
                });
              },
            ),
        ],
      ),
    );
  }
}
