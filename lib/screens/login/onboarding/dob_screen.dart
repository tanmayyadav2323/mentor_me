import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mentor_me/models/models.dart';
import 'package:mentor_me/repositories/repositories.dart';
import 'package:sizer/sizer.dart';
import 'package:mentor_me/blocs/auth/auth_bloc.dart';

import 'package:mentor_me/screens/login/widgets/standard_elevated_button.dart';
import 'package:mentor_me/utils/session_helper.dart';
import 'package:mentor_me/utils/theme_constants.dart';
import 'package:mentor_me/widgets/widgets.dart';

class DobScreen extends StatefulWidget {
  final PageController pageController;

  const DobScreen({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  State<DobScreen> createState() => _DobScreenState();
}

class _DobScreenState extends State<DobScreen> {
  final TextEditingController _ageController = TextEditingController();
  bool isButtonNotActive = true;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.requestFocus();
    _ageController.text = SessionHelper.age ?? "";
    _ageController.addListener(() {
      final isButtonNotActive = _ageController.text.isEmpty;
      setState(() {
        this.isButtonNotActive = isButtonNotActive;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 4.h),
                Text(
                  "How old are you? 🍰",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: kFontFamily,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  "It helps us personalising your experience and will not be visible on your profile.",
                  style: TextStyle(
                    fontSize: 10.sp,
                    height: 1.3,
                    fontFamily: kFontFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: SizedBox(
                      height: 8.h,
                      width: 40.w,
                      child: TextField(
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: kFontFamily,
                        ),
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            FontAwesomeIcons.hashtag,
                            color: kPrimaryBlackColor.withOpacity(0.8),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: kPrimaryBlackColor,
                              style: BorderStyle.solid,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: kPrimaryBlackColor,
                              style: BorderStyle.solid,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: kPrimaryBlackColor,
                              style: BorderStyle.solid,
                            ),
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: kPrimaryBlackColor,
                              style: BorderStyle.solid,
                            ),
                          ),
                          filled: true,
                          hintText: "your age",
                          hintStyle: TextStyle(
                              fontFamily: kFontFamily,
                              fontSize: 12.sp,
                              color: kPrimaryBlackColor,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    )),
              ],
            ),
            StandardElevatedButton(
              isArrowButton: true,
              labelText: "Continue",
              onTap: () {
                final age = int.parse(_ageController.text);
                if (age >= 13) {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.grey[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        // side: BorderSide(color: kPrimaryBlackColor, width: 2.0),
                      ),
                      title: Center(
                        child: Text(
                          "You're ${_ageController.text} years old. Is it correct?",
                          style: TextStyle(
                            fontFamily: kFontFamily,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: kPrimaryBlackColor,
                          ),
                        ),
                      ),
                      actions: [
                        OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "RE-ENTER AGE",
                              style: TextStyle(
                                  fontFamily: kFontFamily,
                                  color: kPrimaryBlackColor,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400),
                            )),
                        OutlinedButton(
                            onPressed: () async {
                              SessionHelper.age = _ageController.text;
                              context.read<AuthBloc>().isFirstTime = true;
                              widget.pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                              FocusScope.of(context).unfocus();
                              Navigator.of(context).pop();
                              await UserRepository().setUser(
                                user: User(
                                  id: context
                                          .read<AuthBloc>()
                                          .state
                                          .user
                                          ?.uid ??
                                      "",
                                  username: SessionHelper.username ?? "",
                                  displayName: SessionHelper.displayName ?? "",
                                  profileImageUrl:
                                      SessionHelper.profileImageUrl ?? '',
                                  age: SessionHelper.age ?? '',
                                  phone: context
                                          .read<AuthBloc>()
                                          .state
                                          .user
                                          ?.phoneNumber ??
                                      '',
                                  isPrivate: false,
                                  bio: "",
                                ),
                              );
                              // BlocProvider.of<InitializeStreamChatCubit>(
                              //         context)
                              //     .initializeStreamChat(context);
                            },
                            child: Text(
                              "YES, I'M ${_ageController.text}",
                              style: TextStyle(
                                  fontFamily: kFontFamily,
                                  color: kPrimaryBlackColor,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400),
                            )),
                      ],
                    ),
                  );
                } else {
                  flutterToast(msg: "sorry, below 13 not allowed");
                }
              },
              isButtonNull: isButtonNotActive,
            ),
            Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom)),
          ],
        ),
      ),
    );
  }
}
