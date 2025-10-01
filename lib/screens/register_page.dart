// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/chat_page.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/helper/show_snackbar.dart';
import 'package:chat_app/widgets/custom_form_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
  });
  static String id = 'RegisterPage';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email, password, username;
  AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction;

  GlobalKey<FormState> formKey = GlobalKey();

  bool isLoading = false;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Form(
            key: formKey,
            autovalidateMode: autovalidateMode,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                    ),
                    Image.asset(
                      kLogo,
                      height: 200,
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                    Row(
                      children: [
                        Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextFormField(
                      controller: usernameController,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Enter Your Username';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        username = value;
                        formKey.currentState!.validate();
                      },
                      hintText: 'Enter Your Username',
                      labelText: "UserName",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextFormField(
                        controller: emailController,
                        validator: (data) {
                          if (data == null || data.isEmpty) {
                            return 'Email is required';
                          }
                          return null;
                        },
                        onChanged: (data) {
                          email = data;
                        },
                        labelText: 'Email Address',
                        hintText: "Email"),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextFormField(
                      controller: passwordController,
                      validator: (data) {
                        if (data == null || data.isEmpty) {
                          return 'Password is required';
                        }
                        if (data.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                      obscureText: true,
                      onChanged: (data) {
                        password = data;
                      },
                      labelText: "Password",
                      hintText: "Password",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          isLoading = true;
                          setState(() {});
                          try {
                            await registerUser();
                            Navigator.of(context).pushReplacementNamed(
                              ChatPage.id,
                              arguments: email,
                            );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              showSnackBar(
                                  context, "The password provided is too weak");
                            } else if (e.code == 'email-already-in-use') {
                              showSnackBar(context,
                                  "The account already exists for that email.");
                            }
                          } catch (e) {
                            showSnackBar(context, e.toString());
                          }
                          isLoading = false;
                          setState(() {});
                        } else {
                          return;
                        }
                      },
                      centerText: "Register",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?   ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Log in",
                            style: TextStyle(
                              color: kSecondaryColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email!,
      password: password!,
    );
    credential.user!.updateDisplayName(username);
    await credential.user!.reload();
  }
}
