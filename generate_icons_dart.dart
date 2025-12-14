import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

void main() async {
  await generateIcons();
}

Future<void> generateIcons() async {
  print('Generating EcoVerseX launcher icons...');

  // Create the logo widget
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  // Draw green circle background
  final paint = Paint()..color = const Color(0xFF2E7D32);
  canvas.drawCircle(const Offset(128, 128), 128, paint);

  // Draw white leaf icon (simplified version)
  final leafPaint = Paint()
    ..color = Colors.white
    ..strokeWidth = 8
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  // Simplified leaf path
  final path = ui.Path();
  path.moveTo(128, 80);
  path.cubicTo(160, 60, 180, 80, 180, 120);
  path.cubicTo(180, 140, 160, 160, 128, 180);
  path.cubicTo(96, 160, 76, 140, 76, 120);
  path.cubicTo(76, 100, 96, 80, 128, 80);
  path.moveTo(128, 180);
  path.lineTo(100, 200);

  canvas.drawPath(path, leafPaint);

  // Convert to image
  final picture = recorder.endRecording();
  final image = await picture.toImage(256, 256);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final pngBytes = byteData!.buffer.asUint8List();

  // Decode and resize for different densities
  final originalImage = img.decodePng(pngBytes)!;

  final sizes = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
  };

  for (final entry in sizes.entries) {
    final folder = entry.key;
    final size = entry.value;

    final resized = img.copyResize(originalImage, width: size, height: size);
    final outputPath = 'android/app/src/main/res/$folder/ic_launcher.png';

    // Ensure directory exists
    final dir = Directory(path.dirname(outputPath));
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    // Save the image
    File(outputPath).writeAsBytesSync(img.encodePng(resized));
    print('Generated: $outputPath (${size}x${size})');
  }

  print('✅ EcoVerseX launcher icons generated successfully!');
}
