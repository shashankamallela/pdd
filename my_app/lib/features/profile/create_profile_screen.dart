import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/api_service.dart';
import '../../services/auth_storage.dart';
import '../../shared/widgets/custom_textfield.dart';
import '../../shared/widgets/gradient_button.dart';

class CreateProfileScreen extends StatefulWidget {
  final String email;

  const CreateProfileScreen({
    super.key,
    required this.email,
  });

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController foodPreferenceController =
      TextEditingController();
  final TextEditingController dentalIssuesController = TextEditingController();
  final TextEditingController waterGoalController = TextEditingController();

  bool isSaving = false;

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

  Future<void> saveProfile() async {
    if (nameController.text.trim().isEmpty) {
      showSnackBar('Please enter your full name');
      return;
    }

    setState(() {
      isSaving = true;
    });

    final String email = widget.email.isNotEmpty
        ? widget.email
        : await AuthStorage.currentEmail();

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
        throw Exception(result['message'] ?? 'Profile save failed');
      }

      if (email.isNotEmpty) {
        await AuthStorage.markProfileCreated(email);
      }

      if (!mounted) return;

      showSnackBar('Profile Saved Successfully');
      context.go('/dashboard');
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
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Create Your\nProfile",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Complete your profile for personalized oral health tracking and AI recommendations.",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF6B7280),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: 0.2),
                            blurRadius: 25,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(
                          Icons.person,
                          size: 70,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              CustomTextField(
                controller: nameController,
                hintText: "Full Name",
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: ageController,
                hintText: "Age",
                prefixIcon: Icons.calendar_today_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: genderController,
                hintText: "Gender",
                prefixIcon: Icons.wc,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: heightController,
                      hintText: "Height",
                      prefixIcon: Icons.height,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: weightController,
                      hintText: "Weight",
                      prefixIcon: Icons.monitor_weight_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: foodPreferenceController,
                hintText: "Food Preference",
                prefixIcon: Icons.restaurant_menu,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: dentalIssuesController,
                hintText: "Dental Issues",
                prefixIcon: Icons.medical_services_outlined,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: waterGoalController,
                hintText: "Daily Water Intake Goal",
                prefixIcon: Icons.water_drop_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 50),
              GradientButton(
                text: isSaving ? "Saving..." : "Save Profile",
                onTap: isSaving ? () {} : saveProfile,
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text(
                    "Back",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
