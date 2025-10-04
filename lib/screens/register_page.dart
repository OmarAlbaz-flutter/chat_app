// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/constants.dart';
import 'package:chat_app/cubits/register_cubit/register_cubit.dart';
import 'package:chat_app/screens/chat_page.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/helper/show_snackbar.dart';
import 'package:chat_app/widgets/custom_form_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatelessWidget {
  String? email, password, username;
  AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction;
  static String id = 'RegisterPage';

  GlobalKey<FormState> formKey = GlobalKey();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          isLoading = true;
        } else if (state is RegisterSuccess) {
          isLoading = false;
          Navigator.of(context).pushReplacementNamed(
            ChatPage.id,
            arguments: email,
          );
        } else if (state is RegisterFailure) {
          isLoading = false;
          showSnackBar(context, state.errMessage);
        }
      },
      builder: (context, state) {
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
                        Image.asset(
                          kLogo,
                          height: 400,
                          width: 300,
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
                          controller: TextEditingController(),
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
                            controller: TextEditingController(),
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
                          controller: TextEditingController(),
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
                              BlocProvider.of<RegisterCubit>(context)
                                  .registerUser(
                                      email: email!,
                                      password: password!,
                                      username: username!);
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
      },
    );
  }
}
