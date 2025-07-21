import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImagePreviewView extends StatelessWidget {
  final File imageFile;
  final VoidCallback onDelete;

  const ImagePreviewView({
    super.key,
    required this.imageFile,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.file(imageFile),
            ),
          ),
          // ❌ Close Button (top-right)
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: const CircleAvatar(
                backgroundColor: Colors.white54,
                child: Icon(Icons.close, color: Colors.black),
              ),
            ),
          ),
          // 🗑 Delete Button (top-left)
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Get.defaultDialog(
                  title: "Delete Image?",
                  middleText: "Are you sure you want to delete this image?",
                  textCancel: "Cancel",
                  textConfirm: "Delete",
                  confirmTextColor: Colors.white,
                  onConfirm: () {
                    Get.back(); // ❗ Close the dialog
                    Future.delayed(Duration(milliseconds: 100), () {
                      onDelete(); // ✅ Then call delete + focus + Get.back()
                    });
                  },
                );
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white54,
                child: Icon(Icons.delete, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
