import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vartaa/screens/auth/register_screen.dart';
import 'package:vartaa/screens/home_screen.dart';
import 'package:vartaa/utils/form_validator.dart';
import 'package:vartaa/utils/helper.dart';
import 'package:vartaa/controllers/auth_controller.dart';
import 'package:vartaa/utils/helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObsecure = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late VoidCallback _authListener;

  @override
  void initState() {
    super.initState();
    final authController = Provider.of<AuthController>(context, listen: false);

    _authListener = () {
      if (authController.errorMessage != null && !authController.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authController.errorMessage!),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      } else if (authController.isAuthenticated && !authController.isLoading) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    };
    authController.addListener(_authListener);
  }

  @override
  void dispose() {
    Provider.of<AuthController>(
      context,
      listen: false,
    ).removeListener(_authListener);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthController>().login(
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(14),
          child: Center(
            child: Form(
              key: _formKey,
              child: Consumer<AuthController>(
                builder: (context, authController, child) {
                  return Container(
                    decoration: BoxDecoration(
                      color: cWhite,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [defaultShadow],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('images/logo_light.png', width: 150),
                          vsXLarge,
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: "johndoe@gmail.com",
                              hintStyle: subtitle2,
                              labelText: "Email",
                              labelStyle: subtitle2,
                              border: defaultInputBorder,
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 12),
                                child: PhosphorIcon(
                                  PhosphorIcons.user(
                                    PhosphorIconsStyle.regular,
                                  ),
                                ),
                              ),
                            ),
                            validator: validateEmail,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _isObsecure,
                            decoration: InputDecoration(
                              hintText: "Masukkan Password",
                              hintStyle: subtitle2,
                              labelText: "Password",
                              labelStyle: subtitle2,
                              border: defaultInputBorder,
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 12),
                                child: PhosphorIcon(
                                  PhosphorIcons.lock(
                                    PhosphorIconsStyle.regular,
                                  ),
                                ),
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isObsecure = !_isObsecure;
                                    });
                                  },
                                  icon:
                                      _isObsecure
                                          ? PhosphorIcon(
                                            PhosphorIcons.eye(
                                              PhosphorIconsStyle.regular,
                                            ),
                                          )
                                          : PhosphorIcon(
                                            PhosphorIcons.eyeSlash(
                                              PhosphorIconsStyle.regular,
                                            ),
                                          ),
                                ),
                              ),
                            ),
                            validator: validatePassword,
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  authController.isLoading
                                      ? null
                                      : _handleLogin,
                              child:
                                  authController.isLoading
                                      ? LoadingAnimationWidget.inkDrop(
                                        color: cSecondary,
                                        size: 20,
                                      )
                                      : Text('Masuk', style: subtitle2),
                            ),
                          ),
                          // const SizedBox(height: 14),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     const Text("Belum memiliki akun?"),
                          //     TextButton(
                          //       onPressed: () {
                          //         Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //             builder: (context) => RegisterScreen(),
                          //           ),
                          //         );
                          //       },
                          //       child: const Text('Buat Akun Baru'),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
