import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cab/widgets/custom_bottomsheet_image_modal.dart';
import 'package:flutter_cab/common/styles/app_color.dart';

// class ImagePickerWidget extends StatefulWidget {
//   final String? initialImageUrl;
//   // final File? initialImage;
//   final bool isEditable;
//   final double radius;
//   final Function(File compressedImage) onImageSelected;
//   const ImagePickerWidget(
//       {super.key,
//       // required this.userImg,
//       this.initialImageUrl,
//       this.radius = 60,
//       this.isEditable = false,
//       required this.onImageSelected});

//   @override
//   State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
// }

// class _ImagePickerWidgetState extends State<ImagePickerWidget> {
//   File? _selectedImage;
// String? _initialImageUrl;
//   @override
//   void initState() {
//     _initialImageUrl = widget.initialImageUrl;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         _selectedImage != null
//             ? CircleAvatar(
//                 radius: widget.radius + 1,
//                 backgroundColor: btnColor,
//                 child: CircleAvatar(
//                   backgroundImage: FileImage(_selectedImage!),
//                   radius: widget.radius,
//                 ),
//               )
//             : _initialImageUrl != null && _initialImageUrl!.isNotEmpty
//                 ? CircleAvatar(
//                     radius: widget.radius + 1,
//                     backgroundColor: btnColor,
//                     child: CircleAvatar(
//                       backgroundImage:
//                           Image.network(widget.initialImageUrl ?? '').image,
//                       radius: widget.radius,
//                     ),
//                   )
//                 : CircleAvatar(
//                     radius: widget.radius,
//                     child: const Icon(Icons.person, size: 60),
//                   ),
//         widget.isEditable
//             ? Positioned(
//                 bottom: 0,
//                 right: -5,
//                 child: CustomBottomsheetImageModal(
//                   isProfileChange: true,
//                   isEditable: widget.isEditable,
//                   icon: const Card(
//                     elevation: 0,
//                     shape: CircleBorder(),
//                     color: btnColor,
//                     child: SizedBox(
//                         height: 30,
//                         width: 30,
//                         child: Icon(
//                           Icons.camera_alt_outlined,
//                           color: Colors.white,
//                         )),
//                   ),
//                   onImagePicked: (compressedImage) {
//                     setState(() {
//                       _selectedImage = compressedImage;
//                     });
//                     widget.onImageSelected(compressedImage);
//                   },
//                 ),
//               )
//             : const SizedBox.shrink()
//       ],
//     );
//   }
// }

class ImagePickerWidget extends StatefulWidget {
  final String? initialImageUrl; // For existing network image
  final bool isEditable; // To show/hide camera icon
  final double radius; // Avatar size
  final Function(File) onImageSelected; // Callback after picking image

  const ImagePickerWidget({
    super.key,
    this.initialImageUrl,
    this.isEditable = false,
    this.radius = 60,
    required this.onImageSelected,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 🖼️ Profile / Default / Picked Image
        _selectedImage != null
            ? _buildLocalImage()
            : widget.initialImageUrl != null &&
                    widget.initialImageUrl!.isNotEmpty
                ? _buildNetworkImage()
                : _buildDefaultAvatar(),

        // 📸 Edit Icon
        if (widget.isEditable)
          Positioned(
            bottom: 0,
            right: -5,
            child: CustomBottomsheetImageModal(
              isProfileChange: true,
              isEditable: widget.isEditable,
              icon: const Card(
                elevation: 0,
                shape: CircleBorder(),
                color: btnColor,
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Icon(Icons.camera_alt_outlined, color: Colors.white),
                ),
              ),
              onImagePicked: (compressedImage) {
                setState(() {
                  _selectedImage = compressedImage;
                });
                widget.onImageSelected(compressedImage);
              },
            ),
          ),
      ],
    );
  }

  /// 🧩 Helper widgets for readability
  Widget _buildLocalImage() => CircleAvatar(
        radius: widget.radius + 1,
        backgroundColor: btnColor,
        child: CircleAvatar(
          backgroundImage: FileImage(_selectedImage!),
          radius: widget.radius,
        ),
      );

  Widget _buildNetworkImage() => CircleAvatar(
        radius: widget.radius + 1,
        backgroundColor: btnColor,
        child: CircleAvatar(
          backgroundImage: NetworkImage(widget.initialImageUrl!),
          radius: widget.radius,
        ),
      );

  Widget _buildDefaultAvatar() => CircleAvatar(
        radius: widget.radius,
        child: const Icon(Icons.person, size: 60),
      );
}
