import 'package:app/exceptions/auth_exception.dart';
import 'package:app/routes/app_routes.dart';
import 'package:app/utils/validators.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateFields);
    _passwordController.addListener(_validateFields);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateFields() {
    setState(() {
      _isEmailValid = isValidEmail(_emailController.text);
      _isPasswordValid = isValidPassword(_passwordController.text);
    });
  }

  bool get _isFormValid => _isEmailValid && _isPasswordValid;

  Future<void> _login() async {
    if (!_isFormValid) return;

    setState(() => _isLoading = true);

    try {
      await _authService.signIn(_emailController.text.trim(), _passwordController.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Welcome back!'), backgroundColor: Color(0xFF008080)),
        );
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9F2),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF008080),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: const Color(0xFF008080).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
                    ),
                    child: const Icon(Icons.eco, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text('Welcome back to a greener you.', style: TextStyle(fontSize: 16, color: Color(0xFF2E3A3A), fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                ],
              ),
            ),

            // Form
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Welcome Back', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2E3A3A))),
                        const SizedBox(height: 8),
                        const Text('Sign in to continue your eco journey', style: TextStyle(fontSize: 16, color: Color(0xFF2E3A3A), fontWeight: FontWeight.w400)),
                        const SizedBox(height: 32),

                        // Email Field
                        _buildField(_emailController, 'Email Address', Icons.email_outlined, _isEmailValid, keyboardType: TextInputType.emailAddress),
                        const SizedBox(height: 20),

                        // Password Field
                        _buildField(_passwordController, 'Password', Icons.lock_outline, _isPasswordValid, isPassword: true),
                        const SizedBox(height: 12),

                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Forgot password feature coming soon!'), backgroundColor: Color(0xFF008080))),
                            child: const Text('Forgot password?', style: TextStyle(color: Color(0xFF008080), fontSize: 14, fontWeight: FontWeight.w600, decoration: TextDecoration.underline)),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Login Button
                        SizedBox(
                          width: double.infinity, height: 56,
                          child: ElevatedButton(
                            onPressed: _isFormValid && !_isLoading ? _login : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF008080),
                              disabledBackgroundColor: const Color(0xFFCDE0D0),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: _isFormValid ? 6 : 0,
                              shadowColor: const Color(0xFF008080).withOpacity(0.4),
                            ),
                            child: _isLoading
                                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                : const Text('Log In', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Links
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ", style: TextStyle(color: Color(0xFF2E3A3A), fontSize: 16)),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.register),
                        child: const Text('Register', style: TextStyle(color: Color(0xFF008080), fontSize: 16, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('By logging in, you agree to our Privacy Policy\nand Terms of Service', textAlign: TextAlign.center, style: TextStyle(color: const Color(0xFF2E3A3A).withOpacity(0.6), fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon, bool isValid, {bool isPassword = false, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword && !_isPasswordVisible,
      style: const TextStyle(fontSize: 16, color: Color(0xFF2E3A3A)),
      decoration: InputDecoration(
        labelText: label,
        helperText: controller.text.isNotEmpty && !isValid ? (isPassword ? 'Password must be at least 6 characters' : 'Enter a valid email address') : null,
        helperStyle: const TextStyle(color: Colors.red, fontSize: 12),
        prefixIcon: Icon(icon, color: controller.text.isNotEmpty && isValid ? const Color(0xFF008080) : const Color(0xFFCDE0D0), size: 22),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: const Color(0xFFCDE0D0), size: 22),
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        )
            : controller.text.isNotEmpty && isValid ? const Icon(Icons.check_circle, color: Color(0xFF008080), size: 22) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCDE0D0))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCDE0D0))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF008080), width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.red)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.red, width: 2)),
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        labelStyle: const TextStyle(color: Color(0xFF2E3A3A), fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}