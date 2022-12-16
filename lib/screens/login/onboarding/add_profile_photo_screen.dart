import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:sizer/sizer.dart';

import 'package:mentor_me/helpers/image_helper.dart';
import 'package:mentor_me/screens/login/login_cubit/login_cubit.dart';
import 'package:mentor_me/screens/login/widgets/standard_elevated_button.dart';
import 'package:mentor_me/utils/theme_constants.dart';

class AddProfilePhotoScreen extends StatefulWidget {
  final PageController pageController;
  const AddProfilePhotoScreen({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  State<AddProfilePhotoScreen> createState() => _AddProfilePhotoScreenState();
}

class _AddProfilePhotoScreenState extends State<AddProfilePhotoScreen> {
  final TextEditingController _profilePicChecker = TextEditingController();
  bool isButtonNotActive = true;
  File? profileImage;

  @override
  void initState() {
    _profilePicChecker.addListener(() {
      final isButtonNotActive = _profilePicChecker.text.isEmpty;
      setState(() {
        this.isButtonNotActive = isButtonNotActive;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            SizedBox(height: 4.h),
            Text(
              "Add a profile picture!",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
                fontFamily: kFontFamily,
              ),
            ),
            Spacer(),
            BlocListener<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state.profilePhotoStatus == ProfilePhotoStatus.uploading) {
                  Center(
                      child: Platform.isIOS
                          ? const CupertinoActivityIndicator(
                              color: kPrimaryBlackColor)
                          : const CircularProgressIndicator(
                              color: kPrimaryBlackColor));
                }
              },
              child: GestureDetector(
                onTap: () => _selectProfileImage(context),
                child: Card(
                    elevation: profileImage == null ? 5 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(
                          color: kPrimaryBlackColor, width: 1.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(40.sp),
                      child: profileImage == null
                          ? Icon(FontAwesomeIcons.photoFilm, size: 45.sp)
                          : Image(image: FileImage(profileImage!)),
                    )),
              ),
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StandardElevatedButton(
                  isArrowButton: true,
                  labelText: "Continue",
                  onTap: () async {
                    BlocProvider.of<LoginCubit>(context)
                        .updateProfilePhoto(profileImage);
                    widget.pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  },
                  isButtonNull: isButtonNotActive,
                ),
                SizedBox(height: 1.5.h),
                Text(
                  "This is visible to everyone",
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontFamily: kFontFamily,
                  ),
                ),
              ],
            ),
            Spacer()
          ],
        ),
      ),
    );
  }

  void _selectProfileImage(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromGallery(
      context: context,
      cropStyle: CropStyle.circle,
      title: 'Profile Image',
    );
    if (pickedFile != null) {
      profileImage = pickedFile;
      _profilePicChecker.text = 'done';
      // context.read<EditProfileCubit>().profileImageChanged(pickedFile);
    }
  }
}
