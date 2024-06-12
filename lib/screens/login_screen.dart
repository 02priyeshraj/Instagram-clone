import 'package:flutter/material.dart';
import 'package:instagram_clone/layout/mobile_screen_layout.dart';
import 'package:instagram_clone/layout/responsive_layout.dart';
import 'package:instagram_clone/layout/web_screen_layout.dart';
import 'package:instagram_clone/resources/firebase_services/auth.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/snack_bar.dart';
import 'package:instagram_clone/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _Loading = false;

  final FocusNode email_F = FocusNode();
  final FocusNode password_F = FocusNode();

  bool isEmailFocused = false;
  bool isPasswordFocused = false;

  @override
  void initState() {
    super.initState();

    email_F.addListener(() {
      setState(() {
        isEmailFocused = email_F.hasFocus;
      });
    });

    password_F.addListener(() {
      setState(() {
        isPasswordFocused = password_F.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    email_F.dispose();
    password_F.dispose();
    super.dispose();
  }

  void logInUser() async {
    setState(() {
      _Loading = true;
    });

    String res = await AuthMethods()
        .logInUser(email: _email.text, password: _password.text);

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

  void navigateToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
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
                height: 100.0,
                width: 96.0,
              ),
              Center(
                child: Image.asset('assets/Logo/instagram.jpg'),
              ),
              const SizedBox(
                height: 120.0,
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
                controller: _password,
                focusNode: password_F,
                hintText: 'Password',
                prefixIcon: Icons.lock,
                isFocused: isPasswordFocused,
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(
                height: 10.0,
              ),
              GestureDetector(
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'Forgot your Password',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: blueColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: InkWell(
                  onTap: logInUser,
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
                            'Log In',
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
                      "Don't have an Account? ",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: loginTextColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: navigateToSignUp,
                      child: const Text(
                        "SignUp",
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
