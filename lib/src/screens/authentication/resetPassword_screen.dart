import 'package:flutter/material.dart';
import 'package:swiper_app/src/controllers/auth_controller.dart';
import 'package:swiper_app/src/controllers/navigation/navigation_service.dart';
import 'package:swiper_app/src/screens/authentication/auth_screen.dart';

import '../../../service_locators.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String route = 'resetPassword-screen';
  const ResetPasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailCon = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // _passCon = TextEditingController(),
  // _pass2Con = TextEditingController(),
  // _usernameCon = TextEditingController();
  final AuthController _authController = locator<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal[400],
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                locator<NavigationService>()
                    .pushReplacementNamed(AuthScreen.route);
              }),
          title: const Text("Reset password"),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            onChanged: () {
              _formKey.currentState?.validate();
              if (mounted) {
                setState(() {});
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_authController.error?.message ?? ''),
                  TextFormField(
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                      hintText: "Email",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(
                          Icons.person,
                          color: _emailCon.text.isEmpty
                              ? Colors.black
                              : Colors.teal[400],
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(width: 3.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFF26A69A), width: 3.0),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    controller: _emailCon,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () => _authController.resetPassword(email:_emailCon.text),
                    // onPressed: (_formKey.currentState?.validate() ?? false)
                    //     ? () {
                    //         _authController.resetPassword(email:_emailCon.text.trim());
                    //         print('Email sent');
                    //         // locator<NavigationService>()
                    //         //     .pushReplacementNamed(AuthScreen.route);
                    //       }
                    //     : null,
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20),
                        primary: (_formKey.currentState?.validate() ?? false)
                            ? const Color(0xFF303030)
                            : Colors.grey),
                    child: const Text('Reset Password'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
