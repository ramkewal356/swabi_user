import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SingleImagePicker extends StatefulWidget {
  final String? noteText;
  final String? hintText;
  final String? initialImageUrl;
  final ValueChanged<File?>? onImageSelected;

  const SingleImagePicker({
    super.key,
    this.noteText,
    this.hintText,
    this.initialImageUrl,
    this.onImageSelected,
  });

  @override
  State<SingleImagePicker> createState() => _SingleImagePickerState();
}

class _SingleImagePickerState extends State<SingleImagePicker> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      widget.onImageSelected?.call(_selectedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasLocalImage = _selectedImage != null;
    final hasNetworkImage =
        widget.initialImageUrl != null && widget.initialImageUrl!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                  image: hasLocalImage
                      ? DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        )
                      : hasNetworkImage
                          ? DecorationImage(
                              image: NetworkImage(widget.initialImageUrl ?? ''),
                              fit: BoxFit.cover,
                            )
                          : null,
                ),
                child: !hasLocalImage && !hasNetworkImage
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.cloud_upload_outlined,
                                size: 40, color: Colors.grey),
                            const SizedBox(height: 6),
                            Text(
                              widget.hintText ?? 'Tap to upload image',
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 14),
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
              if (hasLocalImage || hasNetworkImage)
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.teal,
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.edit, color: Colors.white, size: 18),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (widget.noteText != null)
          Text(
            widget.noteText!,
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }
}
