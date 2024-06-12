import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/layout/mobile_screen_layout.dart';
import 'package:instagram_clone/layout/responsive_layout.dart';
import 'package:instagram_clone/layout/web_screen_layout.dart';
import 'package:instagram_clone/resources/firebase_services/auth.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/pick_image.dart';
import 'package:instagram_clone/utils/snack_bar.dart';
import 'package:instagram_clone/widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  Uint8List? _image;
  bool _Loading = false;

  final FocusNode email_F = FocusNode();
  final FocusNode username_F = FocusNode();
  final FocusNode bio_F = FocusNode();
  final FocusNode password_F = FocusNode();
  final FocusNode confirmPassword_F = FocusNode();

  bool isEmailFocused = false;
  bool isUsernameFocused = false;
  bool isBioFocused = false;
  bool isPasswordFocused = false;
  bool isConfirmPasswordFocused = false;

  @override
  void initState() {
    super.initState();

    email_F.addListener(() {
      setState(() {
        isEmailFocused = email_F.hasFocus;
      });
    });

    username_F.addListener(() {
      setState(() {
        isUsernameFocused = username_F.hasFocus;
      });
    });

    bio_F.addListener(() {
      setState(() {
        isBioFocused = bio_F.hasFocus;
      });
    });

    password_F.addListener(() {
      setState(() {
        isPasswordFocused = password_F.hasFocus;
      });
    });

    confirmPassword_F.addListener(() {
      setState(() {
        isConfirmPasswordFocused = confirmPassword_F.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _username.dispose();
    _bio.dispose();
    _password.dispose();
    _confirmPassword.dispose();

    email_F.dispose();
    username_F.dispose();
    bio_F.dispose();
    password_F.dispose();
    confirmPassword_F.dispose();
    super.dispose();
  }

  void selectImage(ImageSource source) async {
    Uint8List img = await pickImage(source);
    setState(() {
      _image = img;
    });
  }

  void signUpUser() async {
    setState(() {
      _Loading = true;
    });

    Uint8List defaultImage = (await NetworkAssetBundle(
                Uri.parse('https://i.stack.imgur.com/l60Hf.png'))
            .load(''))
        .buffer
        .asUint8List();

    Uint8List imageToUpload = _image ?? defaultImage;

    String res = await AuthMethods().signUpUser(
      email: _email.text,
      username: _username.text,
      bio: _bio.text,
      password: _password.text,
      confirmPassword: _confirmPassword.text,
      file: imageToUpload,
    );

    if (res == 'success') {
      setState(() {
        _Loading = false;
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileSreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    } else {
      setState(() {
        _Loading = false;
      });
      showSnackBar(context, res);
    }
  }

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 60.0,
                width: 96.0,
              ),
              Center(
                child: Image.asset('assets/Logo/instagram.jpg'),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Center(
                child: Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64.0,
                            backgroundImage: MemoryImage(_image!),
                            backgroundColor: profileBgColor,
                          )
                        : const CircleAvatar(
                            radius: 64.0,
                            backgroundImage: NetworkImage(
                                'https://i.stack.imgur.com/l60Hf.png'),
                            backgroundColor: secondaryColor,
                          ),
                    Positioned(
                      bottom: 0.0,
                      right: 0.0,
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return SafeArea(
                                child: Wrap(
                                  children: <Widget>[
                                    ListTile(
                                      leading: const Icon(Icons.photo_library),
                                      title: const Text('Gallery'),
                                      onTap: () {
                                        selectImage(ImageSource.gallery);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.photo_camera),
                                      title: const Text('Camera'),
                                      onTap: () {
                                        selectImage(ImageSource.camera);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          width: 36.0,
                          height: 36.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: blueAccentColor,
                            border: Border.all(
                              color: primaryColor,
                              width: 2.0,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add_a_photo,
                              color: primaryColor,
                              size: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              CustomTextFieldContainer(
                controller: _username,
                focusNode: username_F,
                hintText: 'Username',
                prefixIcon: Icons.person,
                isFocused: isUsernameFocused,
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 15.0,
              ),
              CustomTextFieldContainer(
                controller: _email,
                focusNode: email_F,
                hintText: 'Email',
                prefixIcon: Icons.email,
                isFocused: isEmailFocused,
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 15.0,
              ),
              CustomTextFieldContainer(
                controller: _bio,
                focusNode: bio_F,
                hintText: 'Bio',
                prefixIcon: Icons.abc,
                isFocused: isBioFocused,
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 15.0,
              ),
              CustomTextFieldContainer(
                controller: _password,
                focusNode: password_F,
                hintText: 'Enter Password',
                prefixIcon: Icons.lock,
                isFocused: isPasswordFocused,
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(
                height: 15.0,
              ),
              CustomTextFieldContainer(
                controller: _confirmPassword,
                focusNode: confirmPassword_F,
                hintText: 'Confirm Password',
                prefixIcon: Icons.verified,
                isFocused: isConfirmPasswordFocused,
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(
                height: 10.0,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: InkWell(
                  onTap: signUpUser,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 45.0,
                    decoration: BoxDecoration(
                      color: blueColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: !_Loading
                        ? const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 24.0,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const CircularProgressIndicator(
                            color: primaryColor,
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Have an Account? ",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: loginTextColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: navigateToLogin,
                      child: const Text(
                        "LogIn",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: blueColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
