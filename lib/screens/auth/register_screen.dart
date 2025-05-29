import 'package:flutter/material.dart';
import 'package:newshive/screens/auth/login_screen.dart';
import 'package:newshive/utils/form_validator.dart';
import 'package:newshive/utils/helper.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isObsecure = true;
  bool _isObsecureConfirmation = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Validate if confirmation password matches password
  String? validateConfirmPassword(String? value) {
    if (value!.isEmpty) {
      return 'Confirmation password can\'t be empty';
    } else if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      print('Name: ${_nameController.text}');
      print('Username: ${_usernameController.text}');
      print('Password: ${_passwordController.text}');
      print('Registration valid, processing...');
      // Add your registration logic here
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
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: "John Doe",
                          hintStyle: subtitle2,
                          labelText: "Nama Lengkap",
                          labelStyle: subtitle2,
                          border: defaultInputBorder,
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: PhosphorIcon(
                              PhosphorIcons.user(PhosphorIconsStyle.regular),
                            ),
                          ),
                        ),
                        validator: validateName,
                      ),
                      SizedBox(height: 14),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: "johndoe123",
                          hintStyle: subtitle2,
                          labelText: "Username",
                          labelStyle: subtitle2,
                          border: defaultInputBorder,
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: PhosphorIcon(
                              PhosphorIcons.userCircle(
                                PhosphorIconsStyle.regular,
                              ),
                            ),
                          ),
                        ),
                        validator: validateUsername,
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
                            padding: EdgeInsets.only(left: 12),
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
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _isObsecureConfirmation,
                        decoration: InputDecoration(
                          hintText: "Konfirmasi Password",
                          hintStyle: subtitle2,
                          labelText: "Konfirmasi Password",
                          labelStyle: subtitle2,
                          border: defaultInputBorder,
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: PhosphorIcon(
                              PhosphorIcons.lockKey(PhosphorIconsStyle.regular),
                            ),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObsecureConfirmation =
                                      !_isObsecureConfirmation;
                                });
                              },
                              icon:
                                  _isObsecureConfirmation
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
                        validator: validateConfirmPassword,
                      ),
                      SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleRegister,
                          child: Text('Daftar', style: subtitle2),
                        ),
                      ),
                      SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Sudah memiliki akun?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            child: Text('Masuk'),
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
