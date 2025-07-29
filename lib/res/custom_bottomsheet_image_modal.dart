import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/utils/utils.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:image_picker/image_picker.dart';

class CustomBottomsheetImageModal extends StatefulWidget {
  final Widget icon;
  final bool isProfileChange;
  final bool isEditable;
  final Function(File compressedImage) onImagePicked;
  const CustomBottomsheetImageModal({
    super.key,
    required this.icon,
    this.isProfileChange = false,
    this.isEditable = false,
    required this.onImagePicked,
  });

  @override
  State<CustomBottomsheetImageModal> createState() =>
      _CustomBottomsheetImageModalState();
}

class _CustomBottomsheetImageModalState
    extends State<CustomBottomsheetImageModal> {
  // File? _image;

  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage(ImageSource source) async {
    try {
      // Step 1: Pick an image from the selected source
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 100, // Max quality
      );

      if (pickedFile != null) {
        // Step 2: Crop the image
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          cropStyle: CropStyle.rectangle,
          aspectRatio:
              const CropAspectRatio(ratioX: 1, ratioY: 1), // Square crop
          compressQuality: 100, // Max quality during cropping
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: btnColor,
              toolbarWidgetColor: Colors.white,
              hideBottomControls: true,
              lockAspectRatio: true,
            ),
            IOSUiSettings(title: 'Crop Image'),
          ],
        );

        if (croppedFile != null) {
          // Step 3: Compress the image
          var compressedFile = await _compressImage(File(croppedFile.path));
          if (compressedFile.path.isNotEmpty) {
            widget.onImagePicked(compressedFile); // ✅ Trigger parent callback
          }
          // setState(() {
          //   _image = compressedFile;
          // });

          // Step 4: Upload the image
          // await _uploadImage(_image!);
        }
      }
    } catch (e) {
      Utils.toastMessage('error');
    }
  }

  Future<File> _compressImage(File file) async {
    final dir = await Directory.systemTemp.createTemp();
    final targetPath = '${dir.path}/temp.jpg';
    final result1 = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 85, // Adjust quality as needed
      format: CompressFormat.jpeg,
    );
    final File result = File(result1?.path ?? '');

    return result; // Return the File
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isEditable ? _showImageSourceSelection : () {},
      child: widget.icon,
    );
  }

  Future<void> _showImageSourceSelection() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Select Image',
                    style: titleTextStyle,
                  ),
                  const Divider(),
                  Wrap(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.camera),
                        title: const Text("Camera"),
                        onTap: () {
                          Navigator.of(context).pop();

                          _pickImage(ImageSource.camera);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo),
                        title: const Text("Gallery"),
                        onTap: () {
                          Navigator.of(context).pop();

                          _pickImage(ImageSource.gallery);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
