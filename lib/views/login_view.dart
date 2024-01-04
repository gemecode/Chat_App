import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/constants/app_routes.dart';
import 'package:chat_app/cubit/login_cubit/login_cubit.dart';
import 'package:chat_app/cubit/login_cubit/login_state.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_register_button.dart';
import 'package:chat_app/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<LoginCubit>(context);
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          cubit.isLoading = true;
        } else if (state is LoginSuccess) {
          Navigator.pushNamed(context, AppRoutes.chatView);
          cubit.isLoading = false;
        } else if (state is LoginFailure) {
          showSnackBar(context, message: state.error);
          cubit.isLoading = false;
        }
      },
      builder: (context, state) => ModalProgressHUD(
        inAsyncCall: cubit.isLoading,
        child: Scaffold(
          backgroundColor: AppColors.primaryColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Form(
              key: cubit.formKey,
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
                      cubit.email = data;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    hintText: 'Password',
                    obscureText: true,
                    onChanged: (data) {
                      cubit.password = data;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    txt: 'LOGIN',
                    onTap: () {
                      if (cubit.formKey.currentState!.validate()) {
                        BlocProvider.of<LoginCubit>(context).signInUser(
                            email: cubit.email!, password: cubit.password!);
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
      ),
    );
  }
}
