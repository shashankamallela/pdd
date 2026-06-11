import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TermsPrivacyScreen extends StatefulWidget {
  const TermsPrivacyScreen({super.key});

  @override
  State<TermsPrivacyScreen> createState() => _TermsPrivacyScreenState();
}

class _TermsPrivacyScreenState extends State<TermsPrivacyScreen> {
  bool isChecked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      Container(
                        height: 110,
                        width: 110,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: const Icon(
                          Icons.verified_user_outlined,
                          size: 56,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        "Terms & Privacy",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const _TermsParagraph(
                        title: "1. Health Disclaimer: ",
                        body:
                            "SmileWell provides information and tools for tracking oral and mental health but is not a substitute for professional medical advice.",
                      ),
                      const SizedBox(height: 22),
                      const _TermsParagraph(
                        title: "2. Data Privacy: ",
                        body:
                            "Your health data is encrypted and stored securely. We never share your personal information without consent.",
                      ),
                      const SizedBox(height: 22),
                      const _TermsParagraph(
                        title: "3. Emergency: ",
                        body:
                            "In case of a medical emergency, please contact your local emergency services immediately.",
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        "By continuing, you agree to our Terms of Service and Privacy Policy.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xFF4B5563),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: isChecked,
                            activeColor: Colors.cyan,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value ?? false;
                              });
                            },
                          ),
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: Text(
                                "I have read and agree to the Terms and Conditions and Privacy Policy.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF4B5563),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: isChecked
                      ? () {
                          context.go('/login');
                        }
                      : null,
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text(
                  "Previous",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TermsParagraph extends StatelessWidget {
  const _TermsParagraph({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: const TextStyle(
          fontSize: 17,
          height: 1.55,
          color: Color(0xFF4B5563),
        ),
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          TextSpan(text: body),
        ],
      ),
    );
  }
}
