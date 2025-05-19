import 'package:flutter/material.dart';
import 'package:newshive/views/auth/login_screen.dart';
// import 'package:newshive/views/utils/helper.dart';
import 'package:newshive/views/utils/form_validator.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Register',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _nameController,
                  validator: validateName,
                  decoration: const InputDecoration(
                    hintText: "Input Nama Lengkap",
                    labelText: "Nama Lengkap",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _usernameController,
                  validator: validateUsername,
                  decoration: const InputDecoration(
                    hintText: "Input Username",
                    labelText: "Username",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _isObsecure,
                  validator: validatePassword,
                  decoration: InputDecoration(
                    hintText: "Input Password",
                    labelText: "Password",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObsecure = !_isObsecure;
                        });
                      },
                      icon:
                          _isObsecure
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _isObsecureConfirmation,
                  validator: validateConfirmPassword,
                  decoration: InputDecoration(
                    hintText: "Input Password Confirmation",
                    labelText: "Password Confirmation",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObsecureConfirmation = !_isObsecureConfirmation;
                        });
                      },
                      icon:
                          _isObsecureConfirmation
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Form is valid, proceed with registration
                        print('Registration valid, processing...');
                        // Add your registration logic here
                      }
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Sudah punya akun?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
