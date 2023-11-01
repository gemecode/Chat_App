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

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
                Image.asset(
                  'assets/images/scholar.png',
                  height: 100,
                ),
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
                      'REGISTER',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  hintText: 'email',
                  onChanged: (data) {
                    email = data;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  hintText: 'password',
                  obscureText: true,
                  onChanged: (data) {
                    password = data;
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  txt: 'REGISTER',
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});
                      try {
                        await registerUser();
                        showSnackBar(context, message: 'Success Registration');
                        Navigator.pushNamed(context, AppRoutes.chatView,
                            arguments: email);

                        // Navigator.pop(context);
                      } on FirebaseAuthException catch (ex) {
                        if (ex.code == 'weak-password') {
                          showSnackBar(context,
                              message: 'The password provided is too weak.');
                        } else if (ex.code == 'email-already-in-use') {
                          showSnackBar(context,
                              message:
                                  'The account already exists for that email.');
                        }
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
                  txt: 'already have an account?',
                  txtBtn: '  Login',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
