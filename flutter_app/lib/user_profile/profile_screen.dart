import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/user_profile_service.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;
  final String username;
  final String email;
  final String fullName;
  final String address;
  final String phone;
  final String dob;

  const ProfileScreen({
    Key? key,
    required this.userId,
    required this.username,
    required this.email,
    required this.fullName,
    required this.address,
    required this.phone,
    required this.dob,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;
  late TextEditingController _emailController; // <-- Added controller for email

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _dobController = TextEditingController();
    _emailController = TextEditingController(); // Init email controller

    _fetchProfileData();
  }

  void _fetchProfileData() async {
    final profile = await UserProfileService.getUserProfile(widget.userId);
    if (profile != null) {
      setState(() {
        _fullNameController.text = profile['full_name'] ?? '';
        _addressController.text = profile['address'] ?? '';
        _phoneController.text = profile['phone_number'] ?? '';
        _dobController.text = profile['date_of_birth'] ?? '';
        _emailController.text = profile['email'] ?? ''; // Set email here
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _emailController.dispose(); // Dispose email controller
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final url = Uri.parse('http://10.0.2.2:3000/api/users/update-profile/${widget.userId}');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'full_name': _fullNameController.text,
        'address': _addressController.text,
        'email': _emailController.text, // Use controller text here
        'phone_number': _phoneController.text,
        'date_of_birth': _dobController.text,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/image/pf.jpg'),
          ),
          const SizedBox(height: 20),
          Text(widget.username, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          const SizedBox(height: 20),

          // Editable Email field
          _buildTextField(
            label: 'Email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            hint: _emailController.text.isEmpty ? 'Please fill your information' : null,
          ),

          _buildTextField(
            label: 'Full Name',
            controller: _fullNameController,
            hint: _fullNameController.text.isEmpty ? 'Please fill your information' : null,
          ),
          _buildTextField(
            label: 'Address',
            controller: _addressController,
            hint: _addressController.text.isEmpty ? 'Please fill your information' : null,
          ),
          _buildTextField(
            label: 'Phone Number',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            hint: _phoneController.text.isEmpty ? 'Please fill your information' : null,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Only digits allowed
          ),
          _buildTextField(
            label: 'Date of Birth',
            controller: _dobController,
            readOnly: true,
            onTap: _pickDate,
            hint: _dobController.text.isEmpty ? 'Please fill your information' : null,
          ),

          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              // Validate all fields including email
              if (_fullNameController.text.isEmpty ||
                  _addressController.text.isEmpty ||
                  _emailController.text.isEmpty ||
                  _phoneController.text.isEmpty ||
                  _dobController.text.isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Missing Information'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.network(
                            'https://media.tenor.com/LniIoRRKroYAAAAM/point-at-you-point.gif',
                            height: 200,
                          ),
                          const SizedBox(height: 40),
                          const Text('Please fill all fields before saving.'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
                return; // Stop further execution
              }

              await _saveProfile();
            },
            child: const Text('Save Profile'),
          )
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
    String? hint,
    List<TextInputFormatter>? inputFormatters, // Add this parameter
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters, // Use it here
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }


  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_dobController.text) ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dobController.text = picked.toIso8601String().split('T').first;
    }
  }
}
