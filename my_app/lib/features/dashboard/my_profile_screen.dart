import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/api_service.dart';
import '../../services/auth_storage.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController foodPreferenceController =
      TextEditingController();
  final TextEditingController dentalIssuesController = TextEditingController();
  final TextEditingController waterGoalController = TextEditingController();

  String email = '';
  Map<String, dynamic>? profile;
  bool isLoading = true;
  bool isEditing = false;
  bool isSaving = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadCurrentEmail();
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    genderController.dispose();
    heightController.dispose();
    weightController.dispose();
    foodPreferenceController.dispose();
    dentalIssuesController.dispose();
    waterGoalController.dispose();
    super.dispose();
  }

  Future<void> loadCurrentEmail() async {
    final currentEmail = await AuthStorage.currentEmail();

    if (!mounted) return;

    setState(() {
      email = currentEmail;
      isLoading = currentEmail.isNotEmpty;
    });

    if (currentEmail.isEmpty) {
      return;
    }

    await loadProfile(currentEmail);
  }

  Future<void> loadProfile(String currentEmail) async {
    try {
      final result = await ApiService.fetchProfile(currentEmail);

      if (!mounted) return;

      setState(() {
        profile = result['profile'] is Map
            ? Map<String, dynamic>.from(result['profile'])
            : null;
        errorMessage = null;
        isLoading = false;
      });
      fillEditFields();
    } catch (error) {
      if (!mounted) return;

      setState(() {
        errorMessage = error.toString().replaceFirst('Exception: ', '');
        isLoading = false;
      });
    }
  }

  void fillEditFields() {
    nameController.text = profileValue(
      'name',
      email.isEmpty ? '' : email.split('@').first,
    );
    ageController.text = profileValue('age', '');
    genderController.text = profileValue('gender', '');
    heightController.text = profileValue('height', '');
    weightController.text = profileValue('weight', '');
    foodPreferenceController.text = profileValue('food_preference', '');
    dentalIssuesController.text = profileValue('dental_issues', '');
    waterGoalController.text = profileValue('water_goal', '');
  }

  void startEditing() {
    fillEditFields();

    setState(() {
      isEditing = true;
    });
  }

  void cancelEditing() {
    setState(() {
      isEditing = false;
    });
  }

  Future<void> saveProfile() async {
    if (email.isEmpty) {
      showSnackBar('Please login first');
      return;
    }

    if (nameController.text.trim().isEmpty) {
      showSnackBar('Please enter your full name');
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final result = await ApiService.saveProfile(
        email: email,
        name: nameController.text,
        age: ageController.text,
        gender: genderController.text,
        height: heightController.text,
        weight: weightController.text,
        foodPreference: foodPreferenceController.text,
        dentalIssues: dentalIssuesController.text,
        waterGoal: waterGoalController.text,
      );

      if (result['success'] != true) {
        throw Exception(result['message'] ?? 'Profile update failed');
      }

      await AuthStorage.markProfileCreated(email);

      if (!mounted) return;

      setState(() {
        profile = {
          'email': email,
          'name': nameController.text.trim(),
          'age': ageController.text.trim(),
          'gender': genderController.text.trim(),
          'height': heightController.text.trim(),
          'weight': weightController.text.trim(),
          'food_preference': foodPreferenceController.text.trim(),
          'dental_issues': dentalIssuesController.text.trim(),
          'water_goal': waterGoalController.text.trim(),
        };
        isEditing = false;
      });

      showSnackBar('Profile updated successfully');
    } catch (error) {
      if (!mounted) return;

      showSnackBar(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  String profileValue(String key, String fallback) {
    final value = profile?[key]?.toString().trim() ?? '';
    return value.isEmpty ? fallback : value;
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 60,
                left: 24,
                right: 24,
                bottom: 40,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF2563EB),
                    Color(0xFF06B6D4),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 70,
                      color: Colors.blue.shade400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    profileValue(
                      'name',
                      email.isEmpty ? "User" : email.split('@').first,
                    ),
                    style: TextStyle(
                      fontSize: 34,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    email.isEmpty ? "Not logged in" : email,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 22),
                  ElevatedButton.icon(
                    onPressed: isSaving
                        ? null
                        : isEditing
                            ? cancelEditing
                            : startEditing,
                    icon: Icon(
                      isEditing ? Icons.close : Icons.edit_outlined,
                    ),
                    label: Text(isEditing ? "Cancel" : "Edit Profile"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    )
                  else if (errorMessage != null)
                    _messageCard(
                      Icons.cloud_off_outlined,
                      errorMessage!,
                    )
                  else ...[
                    if (isEditing)
                      _buildEditForm()
                    else ...[
                      _profileTile(
                        Icons.email_outlined,
                        "Email",
                        email.isEmpty ? "Not logged in" : email,
                      ),
                      _profileTile(
                        Icons.calendar_today_outlined,
                        "Age",
                        profileValue('age', 'Not added'),
                      ),
                      _profileTile(
                        Icons.wc,
                        "Gender",
                        profileValue('gender', 'Not added'),
                      ),
                      _profileTile(
                        Icons.height,
                        "Height",
                        profileValue('height', 'Not added'),
                      ),
                      _profileTile(
                        Icons.monitor_weight_outlined,
                        "Weight",
                        profileValue('weight', 'Not added'),
                      ),
                      _profileTile(
                        Icons.restaurant_menu,
                        "Diet Preference",
                        profileValue('food_preference', 'Not added'),
                      ),
                      _profileTile(
                        Icons.medical_services_outlined,
                        "Dental Issues",
                        profileValue('dental_issues', 'Not added'),
                      ),
                      _profileTile(
                        Icons.water_drop_outlined,
                        "Water Goal",
                        profileValue('water_goal', 'Not added'),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          _editField(
            controller: nameController,
            label: "Full Name",
            icon: Icons.person_outline,
          ),
          _editField(
            controller: ageController,
            label: "Age",
            icon: Icons.calendar_today_outlined,
            keyboardType: TextInputType.number,
          ),
          _editField(
            controller: genderController,
            label: "Gender",
            icon: Icons.wc,
          ),
          Row(
            children: [
              Expanded(
                child: _editField(
                  controller: heightController,
                  label: "Height",
                  icon: Icons.height,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _editField(
                  controller: weightController,
                  label: "Weight",
                  icon: Icons.monitor_weight_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          _editField(
            controller: foodPreferenceController,
            label: "Diet Preference",
            icon: Icons.restaurant_menu,
          ),
          _editField(
            controller: dentalIssuesController,
            label: "Dental Issues",
            icon: Icons.medical_services_outlined,
          ),
          _editField(
            controller: waterGoalController,
            label: "Water Goal",
            icon: Icons.water_drop_outlined,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: isSaving ? null : saveProfile,
              icon: isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(isSaving ? "Saving..." : "Save Changes"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _editField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        enabled: !isSaving,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: const Color(0xFFF4F7FB),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  static Widget _profileTile(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _messageCard(
    IconData icon,
    String message,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.blueGrey,
            size: 42,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.blueGrey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
