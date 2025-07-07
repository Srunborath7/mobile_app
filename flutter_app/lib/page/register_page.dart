import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_page.dart';
import '../connection/connection.dart';

class RegisterPage extends StatefulWidget {
  final bool canSelectRole;

  const RegisterPage({super.key, this.canSelectRole = false});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  int? selectedRoleId;
  String message = '';

  Future<void> registerUser() async {
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        message = 'Passwords do not match';
      });
      return;
    }

    if (widget.canSelectRole && selectedRoleId == null) {
      setState(() {
        message = 'Please select a role';
      });
      return;
    }

    final int roleIdToSend = widget.canSelectRole ? selectedRoleId! : 3; // default to User role id 3

    final url = Uri.parse('$baseUrl/api/users/register');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'username': usernameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'role_id': roleIdToSend,
        }),
      );

      if (response.statusCode == 201) {
        setState(() {
          message = 'Registration successful! Please log in.';
        });

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        });
      } else {
        final error = jsonDecode(response.body);
        setState(() {
          message = error['message'] ?? 'Registration failed';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error connecting to server: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.deepPurple),
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3B0C99), Color(0xFF5A31F4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.deepPurple,
                        ),
                        labelText: 'Username',
                        border: inputBorder,
                        focusedBorder: inputBorder,
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.deepPurple,
                        ),
                        labelText: 'Email',
                        border: inputBorder,
                        focusedBorder: inputBorder,
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (widget.canSelectRole)
                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: 'Select Role',
                          border: inputBorder,
                          focusedBorder: inputBorder,
                          prefixIcon:
                          const Icon(Icons.admin_panel_settings, color: Colors.deepPurple),
                        ),
                        value: selectedRoleId,
                        items: const [
                          DropdownMenuItem(value: 1, child: Text('Admin')),
                          DropdownMenuItem(value: 2, child: Text('Editor')),
                          DropdownMenuItem(value: 3, child: Text('User')),
                        ],
                        onChanged: (val) {
                          setState(() {
                            selectedRoleId = val;
                          });
                        },
                      ),
                    if (widget.canSelectRole) const SizedBox(height: 16),

                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.deepPurple,
                        ),
                        labelText: 'Password',
                        border: inputBorder,
                        focusedBorder: inputBorder,
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.deepPurple,
                        ),
                        labelText: 'Confirm Password',
                        border: inputBorder,
                        focusedBorder: inputBorder,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Register button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: registerUser,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF5A31F4), Color(0xFF3B0C99)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            constraints: const BoxConstraints(minHeight: 50),
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    if (widget.canSelectRole) const SizedBox(height: 12),

                    // Back to Home button if role selector is visible
                    if (widget.canSelectRole)
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Back to Home',
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.deepPurple),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    if (message.isNotEmpty)
                      Text(
                        message,
                        style: TextStyle(
                          color: message.contains('success') ? Colors.green : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
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
  }
}
