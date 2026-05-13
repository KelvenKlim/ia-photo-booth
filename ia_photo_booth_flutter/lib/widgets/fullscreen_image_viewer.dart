import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class FullscreenImageViewer extends StatelessWidget {
  final ImageProvider imageProvider;
  final String heroTag;

  const FullscreenImageViewer({
    super.key,
    required this.imageProvider,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: Hero(
            tag: heroTag,
            child: InteractiveViewer(
              child: Image(image: imageProvider),
            ),
          ),
        ),
      ),
    );
  }
}

void showFullscreenImage(BuildContext context, ImageProvider imageProvider, String heroTag) {
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.black87,
      pageBuilder: (context, animation, secondaryAnimation) => FullscreenImageViewer(
        imageProvider: imageProvider,
        heroTag: heroTag,
      ),
    ),
  );
}

ImageProvider buildBase64Image(String imageBase64) {
  return MemoryImage(base64Decode(imageBase64));
}

ImageProvider buildFileImage(File file) {
  return FileImage(file);
}
