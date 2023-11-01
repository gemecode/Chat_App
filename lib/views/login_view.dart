// ignore_for_file: use_build_context_synchronously
import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/constants/app_routes.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_register_button.dart';
import 'package:chat_app/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String? email;
  String? password;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                const SizedBox(height: 75),
                Image.asset('assets/images/scholar.png', height: 100),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Scholar Chat',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontFamily: 'Pacifico'),
                    ),
                  ],
                ),
                const SizedBox(height: 75),
                const Row(
                  children: [
                    Text(
                      'LOGIN',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  hintText: 'Email',
                  onChanged: (data) {
                    email = data;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  hintText: 'Password',
                  obscureText: true,
                  onChanged: (data) {
                    password = data;
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  txt: 'LOGIN',
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});

                      try {
                        await signInUser();
                        showSnackBar(context, message: 'Success SignIn');
                        Navigator.pushNamed(context, AppRoutes.chatView,
                            arguments: email);
                      } on FirebaseAuthException catch (ex) {
                        print('Failed with error code: ${ex.code}');
                        print(ex.message);
                        showSnackBar(context, message: ex.message.toString());

                        // if (ex.code == 'user-not-found') {
                        //   showSnackBar(context,
                        //       message: 'No user found for that email.');
                        // } else if (ex.code == 'wrong-password') {
                        //   showSnackBar(context,
                        //       message:
                        //           'Wrong password provided for that user.');
                        // }
                      } catch (ex) {
                        showSnackBar(context,
                            message: 'there was an error, please try again');
                      }
                      isLoading = false;
                      setState(() {});
                    }
                  },
                ),
                const SizedBox(height: 10),
                CustomRegisterButton(
                  txt: 'dont\'t have an account?',
                  txtBtn: '  Register',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.registerView);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signInUser() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
