import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/data/network/network_apiservice.dart';
import 'package:flutter_cab/model/user_profile_model.dart';
import 'package:flutter_cab/res/Custom%20Page%20Layout/commonPage_Layout.dart';
import 'package:flutter_cab/res/custom_appbar_widget.dart';
import 'package:flutter_cab/res/custom_modal_bottom_sheet.dart';
import 'package:flutter_cab/res/login/login_customTextFeild.dart';
import 'package:flutter_cab/utils/assets.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/dimensions.dart';
import 'package:flutter_cab/utils/string_extenstion.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view/dashboard/account_Pages/change_password.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;

class ProfilePage extends StatefulWidget {
  final String user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // File? imgFile;
  // final profileImg = ImagePicker();
  File? _image;

  final ImagePicker _picker = ImagePicker();
  UserProfileViewModel userProfileViewModel = UserProfileViewModel();

  NetworkApiService networkApiService = NetworkApiService();

  String dataUser = '';

 
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

          setState(() {
            _image = compressedFile;
          });

          // Step 4: Upload the image
          await _uploadImage(_image!);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
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

  Future<void> _uploadImage(File file) async {
    var profilePic =
        await MultipartFile.fromFile(file.path, filename: "profile.jpg");
    // Map<String, dynamic> body = {"driverId": widget.user, "image": profilePic};
    try {
      await Provider.of<ProfileImageViewModel>(context, listen: false)
          .postProfileImageApi(context, {
        "userId": widget.user,
        "image": file,
      }).then((onValue) {
        Provider.of<UserProfileViewModel>(context, listen: false)
            .fetchUserProfileViewModelApi(context, {"userId": widget.user});
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataUser = widget.user;
    print({'dfaghjhjh': dataUser});
  }

  var userId;

  ProfileData userdata = ProfileData();
  var userImg;

  @override
  Widget build(BuildContext context) {
    userdata = context.watch<UserProfileViewModel>().DataList.data?.data ??
        ProfileData();
   
    userImg = context
            .watch<UserProfileViewModel>()
            .DataList
            .data
            ?.data
            .profileImageUrl ??
        '';
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: CustomAppBar(
        heading: "My Profile",
        rightIconOnTapReq: true,
        rightIconImage: edit,
        trailingIcon: true,
        rightIconOnTapOnTap: () => context
            .push("/profilePage/editProfilePage", extra: {'uId': dataUser}),
      ),
      body: PageLayout_Page(
          bgColor: bgGreyColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
              
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            backgroundImage: FileImage(_image!),
                            radius: 60,
                          )
                        : userImg.toString().isNotEmpty
                            ? CircleAvatar(
                                backgroundImage:
                                    Image.network(userImg.toString()).image,
                                radius: 60,
                              )
                            : const CircleAvatar(
                                radius: 60,
                                child: Icon(Icons.person, size: 60),
                              ),
                    Positioned(
                      bottom: 5,
                      right: 0,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: showCameraOption,
                        child: const Card(
                          elevation: 0,
                          shape: CircleBorder(),
                          color: btnColor,
                          child: SizedBox(
                              height: 30,
                              width: 30,
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: background,
                              )),
                        ),
                      ),
                    )
                  ],
                ),
                CommonTextFeild(
                  heading: "Customer Id",
                  headingReq: true,
                  initiValueReq: false,
                  controller: TextEditingController(text: widget.user),
                  initialValueText: widget.user ?? '',
                  prefixIcon: true,
                  readOnly: true,
                  img: profile,
                ),
                const SizedBox(height: 10),
                CommonTextFeild(
                  heading: "Full Name",
                  headingReq: true,
                  initiValueReq: false,
                  controller: TextEditingController(
                      text:
                          "${userdata.firstName ?? ''} ${userdata.lastName ?? ''}"
                              .toString()
                              .capitalizeFirstOfEach),
                  initialValueText:
                      "${userdata.firstName ?? ''} ${userdata.lastName ?? ''}",
                  prefixIcon: true,
                  readOnly: true,
                  img: profile,
                ),
                const SizedBox(height: 10),
                CommonTextFeild(
                  heading: "Email",
                  headingReq: true,
                  initiValueReq: false,
                  controller: TextEditingController(text: userdata.email),
                  initialValueText: userdata.email ?? '',
                  prefixIcon: true,
                  readOnly: true,
                  img: email,
                ),
                const SizedBox(height: 10),
                CommonTextFeild(
                  heading: "Gender",
                  headingReq: true,
                  prefixIcon: true,
                  initiValueReq: false,
                  controller: TextEditingController(text: userdata.gender),
                  initialValueText: userdata.gender ?? '',
                  readOnly: true,
                  img: genderImg,
                ),
                const SizedBox(height: 10),
                CommonTextFeild(
                  heading: "Country",
                  headingReq: true,
                  prefixIcon: true,
                  initiValueReq: false,
                  controller: TextEditingController(text: userdata.country),
                  initialValueText: userdata.country ?? '',
                  readOnly: true,
                  img: address,
                ),
                const SizedBox(height: 10),
                CommonTextFeild(
                  heading: "State",
                  headingReq: true,
                  prefixIcon: true,
                  initiValueReq: false,
                  controller: TextEditingController(text: userdata.state),
                  initialValueText: userdata.state ?? '',
                  readOnly: true,
                  img: address,
                ),
                const SizedBox(height: 10),
                CommonTextFeild(
                  heading: "Location",
                  headingReq: true,
                  prefixIcon: true,
                  initiValueReq: false,
                  controller: TextEditingController(text: userdata.address),
                  initialValueText: userdata.address ?? '',
                  readOnly: true,
                  img: address,
                ),
                const SizedBox(height: 10),
                CommonTextFeild(
                  heading: "Contact No",
                  headingReq: true,
                  prefixIcon: true,
                  initiValueReq: false,
                  controller: TextEditingController(
                      text: "+${userdata.countryCode} ${userdata.mobile}"),
                  initialValueText: userdata.mobile ?? '',
                  readOnly: true,
                  img: phone,
                ),
                const SizedBox(height: 10),
              
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomModalbottomsheet(
                      title: 'CHANGE PASSWORD',
                      child: ChangePassword(userId: dataUser)),
                ),
              
              ],
            ),
          )),
    );
  }

  showCameraOption() {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Container(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 200,
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      topLeft: Radius.circular(30.0),
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          height: 3,
                          width: 50,
                          color: Colors.grey[400],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Profile Picture',
                            style: titleTextStyle,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(color: Colors.grey),
                      const SizedBox(
                        height: 5,
                      ),
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
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProfileContainer extends StatelessWidget {
  final dynamic imgPath;
  final VoidCallback onTap;
  final String name;

  const ProfileContainer(
      {required this.onTap, this.imgPath = profile, this.name = "", super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: AppDimension.getWidth(context) * .3,
          height: AppDimension.getHeight(context) * .2,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: curvePageColor,
          ),
          child: imgPath.runtimeType != String
              ? Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          filterQuality: FilterQuality.high,
                          image: FileImage(imgPath),
                          fit: BoxFit.cover)),
                )
              : imgPath.toString().contains("http")
                  ? Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              filterQuality: FilterQuality.high,
                              image: NetworkImage(
                                  // AppUrl.userProfileUpdate +
                                  imgPath),
                              // image: AssetImage(imgPath),
                              fit: BoxFit.fill)))
                  : Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              filterQuality: FilterQuality.high,
                              image: AssetImage(
                                  // AppUrl.userProfileUpdate +
                                  imgPath),
                              // image: AssetImage(imgPath),
                              fit: BoxFit.cover))),
        ),
        Positioned(
          bottom: 20,
          right: 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: onTap,
            child: const Card(
              elevation: 0,
              shape: CircleBorder(),
              color: btnColor,
              child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: background,
                  )),
            ),
          ),
        )
      ],
    );
  }
}
