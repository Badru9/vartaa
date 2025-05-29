import 'package:flutter/material.dart';
import 'package:newshive/screens/auth/register_screen.dart';
import 'package:newshive/utils/form_validator.dart';
import 'package:newshive/utils/helper.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      print('Username: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(14),
          child: Center(
            child: Form(
              key: _formKey,
              child: Container(
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
                            padding: EdgeInsets.only(
                              left: 12,
                            ), // Padding kiri untuk icon
                            child: PhosphorIcon(
                              PhosphorIcons.user(PhosphorIconsStyle.regular),
                            ),
                          ),
                        ),
                        validator: validateEmail,
                      ),
                      SizedBox(height: 14),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _isObsecure,
                        decoration: InputDecoration(
                          hintText: "Input Password",
                          hintStyle: subtitle2,
                          labelText: "Password",
                          labelStyle: subtitle2,
                          border: defaultInputBorder,
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(
                              left: 12,
                            ), // Padding kiri untuk icon
                            child: PhosphorIcon(
                              PhosphorIcons.lock(PhosphorIconsStyle.regular),
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
                      SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleLogin,
                          child: Text('Masuk ya', style: subtitle2),
                        ),
                      ),
                      SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Belum memiliki akun?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterScreen(),
                                ),
                              );
                            },
                            child: Text('Buat Akun Baru'),
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
