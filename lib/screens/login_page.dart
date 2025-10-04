import 'package:chat_app/constants.dart';
import 'package:chat_app/cubits/login_cubit/login_cubit.dart';
import 'package:chat_app/screens/chat_page.dart';
import 'package:chat_app/screens/register_page.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/helper/show_snackbar.dart';
import 'package:chat_app/widgets/custom_form_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  String? email, password;
  static String id = 'LoginPage';

  bool isLoading = false;
  AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = true;
        } else if (state is LoginSuccess) {
          isLoading = false;
          Navigator.of(context).pushNamed(ChatPage.id, arguments: email);
        } else if (state is LoginFailure) {
          isLoading = false;

          showSnackBar(context, state.errMessage);
        }
      },
      builder: (context, state) => ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Form(
              autovalidateMode: autovalidateMode,
              key: formKey,
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
                            "Log In",
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
                        validator: (data) {
                          if (data == null || data.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        onChanged: (data) {
                          email = data;
                        },
                        labelText: 'Email Address',
                        hintText: "Email",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                        controller: TextEditingController(),
                        validator: (data) {
                          if (data == null || data.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        obscureText: true,
                        onChanged: (data) {
                          password = data;
                        },
                        labelText: 'Password',
                        hintText: "Password",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<LoginCubit>(context)
                                .loginUser(email: email!, password: password!);
                          } else {
                            return;
                          }
                        },
                        centerText: "Log in",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "don't have an account?   ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                RegisterPage.id,
                                arguments: email,
                              );
                            },
                            child: Text(
                              "Register",
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
      ),
    );
  }
}
