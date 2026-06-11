import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/api_service.dart';
import '../../services/auth_storage.dart';
import '../../shared/widgets/custom_textfield.dart';
import '../../shared/widgets/gradient_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool savePassword = true;
  bool passwordWasAutofilled = false;
  List<Map<String, String>> savedAccounts = [];
  List<Map<String, String>> matchingSavedAccounts = [];

  @override
  void initState() {
    super.initState();
    loadSavedCredentials();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showSnackBar('Please enter email and password');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await ApiService.login(
        email,
        password,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        await AuthStorage.setCurrentEmail(email);

        if (savePassword) {
          await AuthStorage.saveCredentials(
            email: email,
            password: password,
          );
        } else {
          await AuthStorage.removeSavedCredential(email);
        }

        final bool profileExists = result['profile_created'] == true ||
            await AuthStorage.hasProfile(email);

        if (!mounted) return;

        if (profileExists) {
          context.go('/dashboard');
        } else {
          context.go('/login-success', extra: email);
        }
        return;
      }

      showSnackBar(result['message'] ?? 'Invalid Credentials');
    } catch (error) {
      if (!mounted) return;

      showSnackBar(
        error.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> loadSavedCredentials() async {
    final accounts = await AuthStorage.savedAccounts();

    if (!mounted) return;

    setState(() {
      savedAccounts = accounts;
      savePassword = accounts.isNotEmpty;
    });
  }

  void onEmailChanged(String value) {
    final String query = value.trim().toLowerCase();
    final account = savedAccounts.firstWhere(
      (account) => account['email']?.toLowerCase() == query,
      orElse: () => {
        'email': '',
        'password': '',
      },
    );

    setState(() {
      matchingSavedAccounts = query.isEmpty
          ? []
          : savedAccounts
              .where(
                (account) =>
                    account['email']?.toLowerCase().contains(query) ?? false,
              )
              .toList();

      if ((account['email'] ?? '').isNotEmpty) {
        passwordController.text = account['password'] ?? '';
        savePassword = true;
        passwordWasAutofilled = true;
      } else if (passwordWasAutofilled) {
        passwordController.clear();
        passwordWasAutofilled = false;
      }
    });
  }

  void selectSavedAccount(Map<String, String> account) {
    setState(() {
      emailController.text = account['email'] ?? '';
      passwordController.text = account['password'] ?? '';
      matchingSavedAccounts = [];
      savePassword = true;
      passwordWasAutofilled = true;
    });
  }

  void onPasswordChanged(String _) {
    setState(() {
      passwordWasAutofilled = false;
    });
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Login to continue your oral health journey.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 50),
                CustomTextField(
                  controller: emailController,
                  hintText: "Email",
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: onEmailChanged,
                ),
                if (matchingSavedAccounts.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    child: Column(
                      children: matchingSavedAccounts
                          .map(
                            (account) => ListTile(
                              leading: const Icon(
                                Icons.mail_outline,
                                color: Colors.blueGrey,
                              ),
                              title: Text(account['email'] ?? ''),
                              subtitle: const Text('Saved password available'),
                              onTap: isLoading
                                  ? null
                                  : () {
                                      selectSavedAccount(account);
                                    },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                CustomTextField(
                  controller: passwordController,
                  hintText: "Password",
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  onChanged: onPasswordChanged,
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  value: savePassword,
                  onChanged: isLoading
                      ? null
                      : (value) {
                          setState(() {
                            savePassword = value ?? false;
                          });
                        },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    "Save password",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            context.go('/forgot');
                          },
                    child: const Text(
                      "Forgot Password?",
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GradientButton(
                  text: isLoading ? "Loading..." : "Login",
                  onTap: isLoading ? () {} : login,
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                    ),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              context.go('/signup');
                            },
                      child: const Text(
                        "Sign Up",
                      ),
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
