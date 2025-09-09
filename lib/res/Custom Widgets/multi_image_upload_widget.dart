import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:image_picker/image_picker.dart';

class MultiImageUploadWidget extends StatefulWidget {
  final Function(List<File>) onImagesSelected;
  final List<String> initialImageUrls;
  const MultiImageUploadWidget({
    super.key,
    required this.onImagesSelected,
    required this.initialImageUrls,
  });

  @override
  State<MultiImageUploadWidget> createState() => _MultiImageUploadWidgetState();
}

class _MultiImageUploadWidgetState extends State<MultiImageUploadWidget> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _images = [];
  List<String> _apiImages = [];
  @override
  void initState() {
    super.initState();
    if (widget.initialImageUrls.isNotEmpty) {
      _apiImages = List<String>.from(widget.initialImageUrls);
    }
  }

  @override
  void didUpdateWidget(covariant MultiImageUploadWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialImageUrls != oldWidget.initialImageUrls) {
      setState(() {
        _apiImages = List<String>.from(widget.initialImageUrls);
      });
    }
  }

  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    setState(() {
      _images.addAll(pickedFiles.map((file) => File(file.path)));
    });
    widget.onImagesSelected(_images);
  }

  Future<void> _pickFromCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _images.add(File(photo.path));
      });
      widget.onImagesSelected(_images);
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
    widget.onImagesSelected(_images);
  }

  void _removeApiImage(int index) {
    setState(() {
      _apiImages.removeAt(index);
    });
    // optional: also notify backend about deletion here
  }

  @override
  Widget build(BuildContext context) {
    

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        // Add Image Button
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (_) => SafeArea(
                child: Wrap(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text("Gallery"),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImages();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.camera_alt),
                      title: const Text("Camera"),
                      onTap: () {
                        Navigator.pop(context);
                        _pickFromCamera();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: greyColor1),
            ),
            child: const Icon(
              Icons.add_a_photo,
              size: 30,
              color: btnColor,
            ),
          ),
        ),
        // Show API Images
        ..._apiImages.asMap().entries.map((entry) {
          int index = entry.key;
          String imageUrl = entry.value;

          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () => _removeApiImage(index),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    padding: const EdgeInsets.all(4),
                    child:
                        const Icon(Icons.close, color: Colors.white, size: 18),
                  ),
                ),
              )
            ],
          );
        }),

        // Show Selected Images
        ..._images.asMap().entries.map((entry) {
          int index = entry.key;
          File imageFile = entry.value;

          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  imageFile,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () => _removeImage(index),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: btnColor,
                    ),
                    padding: const EdgeInsets.all(4),
                    child:
                        const Icon(Icons.close, color: Colors.white, size: 18),
                  ),
                ),
              )
            ],
          );
        }),
      ],
    );
  }
}
