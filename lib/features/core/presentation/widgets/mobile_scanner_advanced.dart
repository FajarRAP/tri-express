import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

enum _PopupMenuItems {
  cameraResolution,
  detectionSpeed,
  detectionTimeout,
  returnImage,
  invertImage,
  autoZoom,
  useBarcodeOverlay,
  boxFit,
  formats,
  scanWindow,
}

/// Implementation of Mobile Scanner example with advanced configuration
class MobileScannerAdvanced extends StatefulWidget {
  /// Constructor for advanced Mobile Scanner example
  const MobileScannerAdvanced({super.key});

  @override
  State<MobileScannerAdvanced> createState() => _MobileScannerAdvancedState();
}

class _MobileScannerAdvancedState extends State<MobileScannerAdvanced> {
  MobileScannerController? controller;

  // A scan window does work on web, but not the overlay to preview the scan
  // window. This is why we disable it here for web examples.
  bool useScanWindow = !kIsWeb;

  bool autoZoom = false;
  bool invertImage = false;
  bool returnImage = false;

  Size desiredCameraResolution = const Size(1920, 1080);
  DetectionSpeed detectionSpeed = DetectionSpeed.unrestricted;
  int detectionTimeoutMs = 1000;

  bool useBarcodeOverlay = true;
  BoxFit boxFit = BoxFit.contain;
  bool enableLifecycle = false;

  /// Hides the MobileScanner widget while the MobileScannerController is
  /// rebuilding
  bool hideMobileScannerWidget = false;

  List<BarcodeFormat> selectedFormats = [];

  MobileScannerController initController() => MobileScannerController(
        autoStart: false,
        cameraResolution: desiredCameraResolution,
        detectionSpeed: detectionSpeed,
        detectionTimeoutMs: detectionTimeoutMs,
        formats: selectedFormats,
        returnImage: returnImage,
        // torchEnabled: true,
        invertImage: invertImage,
        autoZoom: autoZoom,
      );

  @override
  void initState() {
    super.initState();
    controller = initController();
    unawaited(controller!.start());
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller?.dispose();
    controller = null;
  }

  Future<void> _showResolutionDialog() async {
    final Size? result = await showDialog<Size>(
      context: context,
      builder: (context) =>
          ResolutionDialog(initialResolution: desiredCameraResolution),
    );

    if (result != null) {
      setState(() {
        desiredCameraResolution = result;
      });
    }
  }

  Future<void> _showDetectionSpeedDialog() async {
    final DetectionSpeed? result = await showDialog<DetectionSpeed>(
      context: context,
      builder: (context) => DetectionSpeedDialog(selectedSpeed: detectionSpeed),
    );

    if (result != null) {
      setState(() {
        detectionSpeed = result;
      });
    }
  }

  Future<void> _showDetectionTimeoutDialog() async {
    final int? result = await showDialog<int>(
      context: context,
      builder: (context) =>
          DetectionTimeoutDialog(initialTimeoutMs: detectionTimeoutMs),
    );

    if (result != null) {
      setState(() {
        detectionTimeoutMs = result;
      });
    }
  }

  Future<void> _showBoxFitDialog() async {
    final BoxFit? result = await showDialog<BoxFit>(
      context: context,
      builder: (context) => BoxFitDialog(selectedBoxFit: boxFit),
    );

    if (result != null) {
      setState(() {
        boxFit = result;
      });
    }
  }

  Future<void> _showBarcodeFormatDialog() async {
    final List<BarcodeFormat>? result = await showDialog<List<BarcodeFormat>>(
      context: context,
      builder: (context) =>
          BarcodeFormatDialog(selectedFormats: selectedFormats),
    );

    if (result != null) {
      setState(() {
        selectedFormats = result;
      });
    }
  }

  /// This implementation fully disposes and reinitializes the
  /// MobileScannerController every time a setting is changed via the menu.
  ///
  /// This is NOT optimized for production use.
  /// Replacing the controller like this should not happen when MobileScanner is
  /// active. It causes a short visible flicker and can impact user experience.
  ///
  /// The settings should be defined once, or be configurable outside of a
  /// MobileScanner page, not while the MobileScanner is open.
  ///
  /// This is only used here to demonstrate dynamic configuration changes
  /// without restarting the whole app or navigating away from the scanner view.
  Future<void> _reinitializeController() async {
    // Hide the MobileScanner widget temporarily
    setState(() => hideMobileScannerWidget = true);

    // Let the UI settle
    await Future<void>.delayed(const Duration(milliseconds: 300));

    // Dispose of the current controller safely
    await controller?.dispose();
    controller = null;

    // Create a new controller with updated configuration
    controller = initController();

    // Show the scanner again
    setState(() => hideMobileScannerWidget = false);
    await Future<void>.delayed(const Duration(milliseconds: 300));

    // Start scanning again
    await controller?.start();
  }

  @override
  Widget build(BuildContext context) {
    late final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(const Offset(0, -100)),
      width: 300,
      height: 200,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Mobile Scanner'),
        actions: [
          PopupMenuButton<_PopupMenuItems>(
            tooltip: 'Menu',
            onSelected: (item) async {
              switch (item) {
                case _PopupMenuItems.cameraResolution:
                  await _showResolutionDialog();
                case _PopupMenuItems.detectionSpeed:
                  await _showDetectionSpeedDialog();
                case _PopupMenuItems.detectionTimeout:
                  await _showDetectionTimeoutDialog();
                case _PopupMenuItems.formats:
                  await _showBarcodeFormatDialog();
                case _PopupMenuItems.boxFit:
                  await _showBoxFitDialog();
                case _PopupMenuItems.returnImage:
                  returnImage = !returnImage;
                case _PopupMenuItems.invertImage:
                  invertImage = !invertImage;
                case _PopupMenuItems.autoZoom:
                  autoZoom = !autoZoom;
                case _PopupMenuItems.useBarcodeOverlay:
                  useBarcodeOverlay = !useBarcodeOverlay;
                case _PopupMenuItems.scanWindow:
                  useScanWindow = !useScanWindow;
              }

              // Rebuild and restart the controller with updated settings
              await _reinitializeController();
            },
            itemBuilder: (context) => [
              if (!kIsWeb && Platform.isAndroid)
                PopupMenuItem(
                  value: _PopupMenuItems.cameraResolution,
                  child: Text(_PopupMenuItems.cameraResolution.name),
                ),
              PopupMenuItem(
                value: _PopupMenuItems.detectionSpeed,
                child: Text(_PopupMenuItems.detectionSpeed.name),
              ),
              PopupMenuItem(
                value: _PopupMenuItems.detectionTimeout,
                enabled: detectionSpeed == DetectionSpeed.normal,
                child: Text(_PopupMenuItems.detectionTimeout.name),
              ),
              PopupMenuItem(
                value: _PopupMenuItems.boxFit,
                child: Text(_PopupMenuItems.boxFit.name),
              ),
              PopupMenuItem(
                value: _PopupMenuItems.formats,
                child: Text(_PopupMenuItems.formats.name),
              ),
              const PopupMenuDivider(),
              if (!kIsWeb && Platform.isAndroid)
                CheckedPopupMenuItem(
                  value: _PopupMenuItems.autoZoom,
                  checked: autoZoom,
                  child: Text(_PopupMenuItems.autoZoom.name),
                ),
              if (!kIsWeb && Platform.isAndroid)
                CheckedPopupMenuItem(
                  value: _PopupMenuItems.invertImage,
                  checked: invertImage,
                  child: Text(_PopupMenuItems.invertImage.name),
                ),
              CheckedPopupMenuItem(
                value: _PopupMenuItems.returnImage,
                checked: returnImage,
                child: Text(_PopupMenuItems.returnImage.name),
              ),
              CheckedPopupMenuItem(
                value: _PopupMenuItems.useBarcodeOverlay,
                checked: useBarcodeOverlay,
                child: Text(_PopupMenuItems.useBarcodeOverlay.name),
              ),
              CheckedPopupMenuItem(
                value: _PopupMenuItems.scanWindow,
                checked: useScanWindow,
                child: Text(_PopupMenuItems.scanWindow.name),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: controller == null || hideMobileScannerWidget
          ? const Placeholder()
          : Stack(
              children: [
                MobileScanner(
                  // useAppLifecycleState: false, // Only set to false if you want
                  // to handle lifecycle changes yourself
                  scanWindow: useScanWindow ? scanWindow : null,
                  controller: controller,
                  errorBuilder: (context, error) {
                    return ScannerErrorWidget(error: error);
                  },
                  fit: boxFit,
                ),
                if (useBarcodeOverlay)
                  BarcodeOverlay(controller: controller!, boxFit: boxFit),
                // The scanWindow is not supported on the web.
                if (useScanWindow)
                  ScanWindowOverlay(
                    scanWindow: scanWindow,
                    controller: controller!,
                  ),
                if (returnImage)
                  Align(
                    alignment: Alignment.topRight,
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: StreamBuilder<BarcodeCapture>(
                          stream: controller!.barcodes,
                          builder: (context, snapshot) {
                            final BarcodeCapture? barcode = snapshot.data;

                            if (barcode == null) {
                              return const Center(
                                child: Text(
                                  'Your scanned barcode will appear here',
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }

                            final Uint8List? barcodeImage = barcode.image;

                            if (barcodeImage == null) {
                              return const Center(
                                child: Text('No image for this barcode.'),
                              );
                            }

                            return Image.memory(
                              barcodeImage,
                              fit: BoxFit.cover,
                              gaplessPlayback: true,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Text(
                                    'Could not decode image bytes. $error',
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    height: 200,
                    color: const Color.fromRGBO(0, 0, 0, 0.4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ScannedBarcodeLabel(
                            barcodes: controller!.barcodes,
                          ),
                        ),
                        if (!kIsWeb) ZoomScaleSlider(controller: controller!),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ToggleFlashlightButton(controller: controller!),
                            StartStopButton(controller: controller!),
                            PauseButton(controller: controller!),
                            SwitchCameraButton(controller: controller!),
                            AnalyzeImageButton(controller: controller!),
                          ],
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

/// Button widget for analyze image function
class AnalyzeImageButton extends StatelessWidget {
  /// Construct a new [AnalyzeImageButton] instance.
  const AnalyzeImageButton({required this.controller, super.key});

  /// Controller which is used to call analyzeImage
  final MobileScannerController controller;

  Future<void> _onPressed(BuildContext context) async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Analyze image is not supported on web'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    final BarcodeCapture? barcodes = await controller.analyzeImage(image.path);

    if (!context.mounted) {
      return;
    }

    final snackBar = barcodes != null && barcodes.barcodes.isNotEmpty
        ? const SnackBar(
            content: Text('Barcode found!'),
            backgroundColor: Colors.green,
          )
        : const SnackBar(
            content: Text('No barcode found!'),
            backgroundColor: Colors.red,
          );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.white,
      icon: const Icon(Icons.image),
      iconSize: 32,
      onPressed: () => _onPressed(context),
    );
  }
}

/// Button widget for pause function
class PauseButton extends StatelessWidget {
  /// Construct a new [PauseButton] instance.
  const PauseButton({required this.controller, super.key});

  /// Controller which is used to call pause
  final MobileScannerController controller;

  Future<void> _onPressed() async => controller.pause();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        return IconButton(
          color: Colors.white,
          iconSize: 32,
          icon: const Icon(Icons.pause),
          onPressed: _onPressed,
        );
      },
    );
  }
}

/// Button widget for stop or start function

class StartStopButton extends StatelessWidget {
  /// Construct a new [StartStopButton] instance.
  const StartStopButton({required this.controller, super.key});

  /// Controller which is used to call stop or start
  final MobileScannerController controller;

  Future<void> _onPressedStop() async => controller.stop();

  Future<void> _onPressedStart() async => controller.start();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return IconButton(
            color: Colors.white,
            icon: const Icon(Icons.play_arrow),
            iconSize: 32,
            onPressed: _onPressedStart,
          );
        }

        return IconButton(
          color: Colors.white,
          icon: const Icon(Icons.stop),
          iconSize: 32,
          onPressed: _onPressedStop,
        );
      },
    );
  }
}

/// Button widget for switch camera function
class SwitchCameraButton extends StatelessWidget {
  /// Construct a new [SwitchCameraButton] instance.
  const SwitchCameraButton({required this.controller, super.key});

  /// Controller which is used to call switchCamera
  final MobileScannerController controller;

  Future<void> _onPressed() async => controller.switchCamera();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        final int? availableCameras = state.availableCameras;

        if (availableCameras != null && availableCameras < 2) {
          return const SizedBox.shrink();
        }

        final Widget icon;

        switch (state.cameraDirection) {
          case CameraFacing.front:
            icon = const Icon(Icons.camera_front);
          case CameraFacing.back:
            icon = const Icon(Icons.camera_rear);
          case CameraFacing.external:
            icon = const Icon(Icons.usb);
          case CameraFacing.unknown:
            icon = const Icon(Icons.device_unknown);
        }

        return IconButton(
          color: Colors.white,
          iconSize: 32,
          icon: icon,
          onPressed: _onPressed,
        );
      },
    );
  }
}

/// Button widget for toggle torch (flash) function
class ToggleFlashlightButton extends StatelessWidget {
  /// Construct a new [ToggleFlashlightButton] instance.
  const ToggleFlashlightButton({required this.controller, super.key});

  /// Controller which is used to call toggleTorch
  final MobileScannerController controller;

  Future<void> _onPressed() async => controller.toggleTorch();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        switch (state.torchState) {
          case TorchState.auto:
            return IconButton(
              color: Colors.white,
              iconSize: 32,
              icon: const Icon(Icons.flash_auto),
              onPressed: _onPressed,
            );
          case TorchState.off:
            return IconButton(
              color: Colors.white,
              iconSize: 32,
              icon: const Icon(Icons.flash_off),
              onPressed: _onPressed,
            );
          case TorchState.on:
            return IconButton(
              color: Colors.white,
              iconSize: 32,
              icon: const Icon(Icons.flash_on),
              onPressed: _onPressed,
            );
          case TorchState.unavailable:
            return const SizedBox.square(
              dimension: 48,
              child: Icon(Icons.no_flash, size: 32, color: Colors.grey),
            );
        }
      },
    );
  }
}

/// A dialog widget that allows users to select multiple barcode formats.
///
/// The user can choose from a list of predefined barcode formats using
/// checkboxes. The selected formats are returned when the user confirms their
/// choice.
class BarcodeFormatDialog extends StatefulWidget {
  /// Creates a [BarcodeFormatDialog].
  ///
  /// Requires a list of [selectedFormats] that represents the currently
  /// selected barcode formats.
  const BarcodeFormatDialog({required this.selectedFormats, super.key});

  /// The list of currently selected [BarcodeFormat] options.
  final List<BarcodeFormat> selectedFormats;

  @override
  State<BarcodeFormatDialog> createState() => _BarcodeFormatDialogState();
}

class _BarcodeFormatDialogState extends State<BarcodeFormatDialog> {
  late List<BarcodeFormat> tempSelectedFormats;

  @override
  void initState() {
    super.initState();
    tempSelectedFormats = List<BarcodeFormat>.from(widget.selectedFormats);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Barcode Formats'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: BarcodeFormat.values.map((format) {
            return CheckboxListTile(
              title: Text(format.name.toUpperCase()),
              value: tempSelectedFormats.contains(format),
              onChanged: (bool? value) {
                setState(() {
                  if (value ?? false) {
                    tempSelectedFormats.add(format);
                  } else {
                    tempSelectedFormats.remove(format);
                  }
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, tempSelectedFormats);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

/// A dialog widget that allows users to select a [BoxFit] value.
///
/// The [BoxFit] value is chosen from a list of predefined options using radio
/// buttons. The selected value is returned when the user confirms their choice.
class BoxFitDialog extends StatefulWidget {
  /// Creates a [BoxFitDialog].
  ///
  /// Requires a [selectedBoxFit] which represents the currently selected fit
  /// option.
  const BoxFitDialog({required this.selectedBoxFit, super.key});

  /// The currently selected [BoxFit] option.
  final BoxFit selectedBoxFit;

  @override
  State<BoxFitDialog> createState() => _BoxFitDialogState();
}

class _BoxFitDialogState extends State<BoxFitDialog> {
  late BoxFit tempBoxFit;

  @override
  void initState() {
    super.initState();
    tempBoxFit = widget.selectedBoxFit;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select BoxFit'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final fit in BoxFit.values)
            RadioListTile<BoxFit>(
              title: Text(fit.name),
              value: fit,
              groupValue: tempBoxFit,
              onChanged: (BoxFit? value) {
                if (value != null) {
                  setState(() {
                    tempBoxFit = value;
                  });
                }
              },
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, tempBoxFit);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

/// A dialog widget that allows users to select a detection speed for the
/// scanner.
///
/// The detection speed is chosen from a predefined set of options using radio
/// buttons. Once the user selects a speed, the dialog closes and returns the
/// selected value.
class DetectionSpeedDialog extends StatelessWidget {
  /// Creates a [DetectionSpeedDialog].
  ///
  /// Requires a [selectedSpeed] which represents the currently chosen speed.
  const DetectionSpeedDialog({required this.selectedSpeed, super.key});

  /// The currently selected detection speed.
  final DetectionSpeed selectedSpeed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Detection Speed'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final speed in DetectionSpeed.values)
            RadioListTile<DetectionSpeed>(
              title: Text(speed.name),
              value: speed,
              groupValue: selectedSpeed,
              onChanged: (DetectionSpeed? value) {
                if (value != null) {
                  Navigator.pop(context, value);
                }
              },
            ),
        ],
      ),
    );
  }
}

/// A dialog widget that allows users to set a detection timeout value in
/// milliseconds.
///
/// The timeout is selected using a slider, with values ranging from 0 to
/// 5000 ms. The selected value is returned when the user confirms their choice.
class DetectionTimeoutDialog extends StatefulWidget {
  /// Creates a [DetectionTimeoutDialog].
  ///
  /// Requires an [initialTimeoutMs] which is displayed as the default timeout
  /// value.
  const DetectionTimeoutDialog({required this.initialTimeoutMs, super.key});

  /// The initial timeout value in milliseconds.
  final int initialTimeoutMs;

  @override
  State<DetectionTimeoutDialog> createState() => _DetectionTimeoutDialogState();
}

class _DetectionTimeoutDialogState extends State<DetectionTimeoutDialog> {
  late int tempTimeout;

  @override
  void initState() {
    super.initState();
    tempTimeout = widget.initialTimeoutMs;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Detection Timeout (ms)'),
      content: SizedBox(
        height: 100,
        child: Column(
          children: [
            Slider(
              value: tempTimeout.toDouble(),
              max: 5000,
              divisions: 50,
              label: '$tempTimeout ms',
              onChanged: (double value) {
                setState(() {
                  tempTimeout = value.toInt();
                });
              },
            ),
            Text('$tempTimeout ms'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, tempTimeout);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

/// A dialog widget that allows users to input and set a camera resolution.
///
/// The dialog presents two text fields where users can enter width and height
/// values. The resolution is validated to ensure it is within a reasonable
/// range before being returned to the calling widget.
class ResolutionDialog extends StatefulWidget {
  /// Creates a [ResolutionDialog].
  ///
  /// Requires an [initialResolution] which serves as the default width and
  /// height values displayed in the text fields.
  const ResolutionDialog({required this.initialResolution, super.key});

  /// The initial resolution size (width and height) that appears in the dialog.
  final Size initialResolution;

  @override
  State<ResolutionDialog> createState() => _ResolutionDialogState();
}

class _ResolutionDialogState extends State<ResolutionDialog> {
  late TextEditingController widthController;
  late TextEditingController heightController;

  @override
  void initState() {
    super.initState();
    widthController = TextEditingController(
      text: widget.initialResolution.width.toInt().toString(),
    );
    heightController = TextEditingController(
      text: widget.initialResolution.height.toInt().toString(),
    );
  }

  @override
  void dispose() {
    widthController.dispose();
    heightController.dispose();
    super.dispose();
  }

  void _saveResolution(BuildContext context) {
    final String widthText = widthController.text.trim();
    final String heightText = heightController.text.trim();

    // Check for empty input
    if (widthText.isEmpty || heightText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Width and Height cannot be empty')),
      );
      return;
    }

    final int? width = int.tryParse(widthText);
    final int? height = int.tryParse(heightText);

    // Check if values are valid numbers
    if (width == null || height == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numbers')),
      );
      return;
    }

    // Ensure values are within a reasonable range
    if (width <= 144 || height <= 144) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Width and Height must be greater than 144'),
        ),
      );
      return;
    }

    if (width > 4000 || height > 4000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Width and Height must be 4000 or less')),
      );
      return;
    }

    // Return the new resolution size
    Navigator.pop(context, Size(width.toDouble(), height.toDouble()));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Camera Resolution'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: widthController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Width'),
          ),
          TextField(
            controller: heightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Height'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => _saveResolution(context),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

/// Widget to display scanned barcodes.
class ScannedBarcodeLabel extends StatelessWidget {
  /// Construct a new [ScannedBarcodeLabel] instance.
  const ScannedBarcodeLabel({required this.barcodes, super.key});

  /// Barcode stream for scanned barcodes to display
  final Stream<BarcodeCapture> barcodes;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: barcodes,
      builder: (context, snapshot) {
        final List<Barcode> scannedBarcodes = snapshot.data?.barcodes ?? [];

        final String values =
            scannedBarcodes.map((e) => e.displayValue).join('\n');

        if (scannedBarcodes.isEmpty) {
          return const Text(
            'Scan something!',
            overflow: TextOverflow.fade,
            style: TextStyle(color: Colors.white),
          );
        }

        return Text(
          values.isEmpty ? 'No display value.' : values,
          overflow: TextOverflow.fade,
          style: const TextStyle(color: Colors.white),
        );
      },
    );
  }
}

/// Button widget for analyze image function
class ScannerErrorWidget extends StatelessWidget {
  /// Construct a new [ScannerErrorWidget] instance.
  const ScannerErrorWidget({required this.error, super.key});

  /// Error to display
  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              error.errorCode.message,
              style: const TextStyle(color: Colors.white),
            ),
            if (error.errorDetails?.message case final String message)
              Text(message, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

/// Slider widget for zoom function
class ZoomScaleSlider extends StatelessWidget {
  /// Slider widget for zoom function
  const ZoomScaleSlider({required this.controller, super.key});

  /// Controller which is used to call the zoom function
  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        final TextStyle labelStyle = Theme.of(
          context,
        ).textTheme.headlineMedium!.copyWith(color: Colors.white);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Text('0%', overflow: TextOverflow.fade, style: labelStyle),
              Expanded(
                child: Slider(
                  value: state.zoomScale,
                  onChanged: controller.setZoomScale,
                ),
              ),
              Text('100%', overflow: TextOverflow.fade, style: labelStyle),
            ],
          ),
        );
      },
    );
  }
}
