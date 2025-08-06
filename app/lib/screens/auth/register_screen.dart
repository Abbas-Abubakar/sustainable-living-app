import 'package:app/exceptions/auth_exception.dart';
import 'package:app/routes/app_routes.dart';
import 'package:app/utils/validators.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isNameValid = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateFields);
    _emailController.addListener(_validateFields);
    _passwordController.addListener(_validateFields);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateFields() {
    setState(() {
      _isNameValid = isValidName(_nameController.text);
      _isEmailValid = isValidEmail(_emailController.text);
      _isPasswordValid = isValidPassword(_passwordController.text);
    });
  }

  bool get _isFormValid => _isNameValid && _isEmailValid && _isPasswordValid;

  Future<void> _register() async {
    // Simple check - no form validation needed since we have real-time validation
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (mounted) {
        // Navigate to home page or show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: Color(0xFF008080),
            duration: Duration(seconds: 2),
          ),
        );

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          }
        });
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9F2),
      body: SafeArea(
        child: Column(
          children: [
            // Expanded section to center the form
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: _buildFormCard(),
                ),
              ),
            ),

            // Bottom section pinned to bottom
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400), // Optional: limit max width
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3A3A),
              ),
            ),
            const SizedBox(height: 24),

            // Full Name Field
            _buildInputField(
              controller: _nameController,
              label: 'Full Name',
              icon: Icons.eco,
              isValid: _isNameValid,
              helperText: 'Name must be at least 3 characters with letters only',
            ),

            const SizedBox(height: 16),

            // Email Field
            _buildInputField(
              controller: _emailController,
              label: 'Email Address',
              icon: Icons.email_outlined,
              isValid: _isEmailValid,
              keyboardType: TextInputType.emailAddress,
              helperText: 'Enter a valid email address',
            ),

            const SizedBox(height: 16),

            // Password Field
            _buildInputField(
              controller: _passwordController,
              label: 'Password',
              icon: Icons.lock_outline,
              isValid: _isPasswordValid,
              isPassword: true,
              helperText: 'Password must be at least 6 characters',
            ),

            const SizedBox(height: 32),

            // Register Button
            _buildRegisterButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isValid,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword && !_isPasswordVisible,
          decoration: InputDecoration(
            labelText: label,
            helperText: controller.text.isNotEmpty && !isValid
                ? helperText
                : null,
            helperStyle: const TextStyle(color: Colors.red, fontSize: 12),
            prefixIcon: Icon(
              icon,
              color: controller.text.isNotEmpty && isValid
                  ? const Color(0xFF008080)
                  : const Color(0xFFCDE0D0),
            ),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: const Color(0xFFCDE0D0),
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            )
                : controller.text.isNotEmpty && isValid
                ? const Icon(
              Icons.check_circle,
              color: Color(0xFF008080),
            )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCDE0D0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCDE0D0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF008080), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: const Color(0xFFF9F9F9),
            labelStyle: const TextStyle(color: Color(0xFF2E3A3A)),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isFormValid && !_isLoading ? _register : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF008080),
          disabledBackgroundColor: const Color(0xFFCDE0D0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: _isFormValid ? 4 : 0,
          shadowColor: const Color(0xFF008080).withOpacity(0.3),
        ),
        child: _isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Text(
          'Create Account',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account? ',
                style: TextStyle(
                  color: Color(0xFF2E3A3A),
                  fontSize: 16,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to login page
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
                child: const Text(
                  'Login here',
                  style: TextStyle(
                    color: Color(0xFF008080),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'By creating an account, you agree to our Privacy Policy\nand Terms of Service',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF2E3A3A).withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}