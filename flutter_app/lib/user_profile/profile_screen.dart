import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/user_profile_service.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;
  final String username;

  const ProfileScreen({
    Key? key,
    required this.userId,
    required this.username,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _dobController = TextEditingController();
    _emailController = TextEditingController();

    _loadFromLocal().then((_) => _fetchProfileData());
  }

  Future<void> _loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullNameController.text = prefs.getString('full_name') ?? '';
      _addressController.text = prefs.getString('address') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _phoneController.text = prefs.getString('phone_number') ?? '';
      _dobController.text = prefs.getString('date_of_birth') ?? '';
    });
  }

  Future<void> _saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('full_name', _fullNameController.text);
    await prefs.setString('address', _addressController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('phone_number', _phoneController.text);
    await prefs.setString('date_of_birth', _dobController.text);
  }

  Future<void> _fetchProfileData() async {
    final profile = await UserProfileService.getUserProfile(widget.userId);
    if (profile != null) {
      setState(() {
        _fullNameController.text = profile['full_name'] ?? _fullNameController.text;
        _addressController.text = profile['address'] ?? _addressController.text;
        _phoneController.text = profile['phone_number'] ?? _phoneController.text;
        _dobController.text = profile['date_of_birth'] ?? _dobController.text;
        _emailController.text = profile['email'] ?? _emailController.text;
      });
      await _saveToLocal();// Sync with SharedPreferences
    }
  }

  Future<void> _saveProfile() async {
    final url = Uri.parse('http://10.0.2.2:3000/api/users/update-profile/${widget.userId}');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'full_name': _fullNameController.text,
        'address': _addressController.text,
        'email': _emailController.text,
        'phone_number': _phoneController.text,
        'date_of_birth': _dobController.text,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      await _saveToLocal();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_dobController.text) ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = picked.toIso8601String().split('T').first;
      });
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
    String? hint,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _showMissingDialog() {
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
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
            onPressed: () {
              if (_fullNameController.text.isEmpty ||
                  _addressController.text.isEmpty ||
                  _emailController.text.isEmpty ||
                  _phoneController.text.isEmpty ||
                  _dobController.text.isEmpty) {
                _showMissingDialog();
              } else {
                _saveProfile();
              }
            },
            child: const Text('Save Profile'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
