// lib/views/welcome.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:thesis_attendance/views/pages/student/student_dashboard.dart';
import 'package:thesis_attendance/views/pages/admin/admin_dashboard.dart';
import 'package:thesis_attendance/services/auth_service.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final AuthService _authService = AuthService();
  
  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  // Sign Up Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController programController = TextEditingController();
  final TextEditingController yearLevelController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();
  
  // UI State
  bool isSignIn = true;
  String selectedRole = 'student';
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    studentIdController.dispose();
    programController.dispose();
    yearLevelController.dispose();
    sectionController.dispose();
    super.dispose();
  }

  void _handleAuth() async {
    // Basic validation
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (isSignIn) {
        await _handleSignIn();
      } else {
        await _handleSignUp();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleSignIn() async {
    final result = await _authService.signIn(
      emailController.text.trim(),
      passwordController.text,
    );

    if (!mounted) return;

    if (result['success']) {
      final role = result['role'] as String;
      
      // Navigate based on role
      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminDashboard(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const StudentDashboard(),
          ),
        );
      }
    } else {
      _showError(result['message']);
    }
  }

  Future<void> _handleSignUp() async {
    // Validate sign up fields
    if (nameController.text.isEmpty ||
        studentIdController.text.isEmpty ||
        programController.text.isEmpty ||
        yearLevelController.text.isEmpty ||
        sectionController.text.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    final result = await _authService.signUp(
      email: emailController.text.trim(),
      password: passwordController.text,
      studentId: studentIdController.text.trim(),
      name: nameController.text.trim(),
      program: programController.text.trim(),
      yearLevel: yearLevelController.text.trim(),
      section: sectionController.text.trim(),
    );

    if (!mounted) return;

    if (result['success']) {
      _showSuccess('Registration successful! Please sign in.');
      setState(() {
        isSignIn = true;
        // Clear sign up fields
        nameController.clear();
        studentIdController.clear();
        programController.clear();
        yearLevelController.clear();
        sectionController.clear();
      });
    } else {
      _showError(result['message']);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // Lottie Animation
              Hero(
                tag: 'logo',
                child: Lottie.asset(
                  'assets/login_animation.json',
                  height: 200,
                  width: 200,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),

              // Title
              Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    isSignIn ? 'Welcome Tradeans!' : 'Create Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    isSignIn ? 'Welcome Tradeans!' : 'Create Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                isSignIn ? 'Sign in to continue' : 'Sign up to get started',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // Role Selector (only for sign in)
              if (isSignIn) ...[
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => selectedRole = 'student'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: selectedRole == 'student'
                                  ? Colors.blue.shade700
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.school,
                                  color: selectedRole == 'student'
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Student',
                                  style: TextStyle(
                                    color: selectedRole == 'student'
                                        ? Colors.white
                                        : Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => selectedRole = 'admin'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: selectedRole == 'admin'
                                  ? Colors.blue.shade700
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.admin_panel_settings,
                                  color: selectedRole == 'admin'
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Admin',
                                  style: TextStyle(
                                    color: selectedRole == 'admin'
                                        ? Colors.white
                                        : Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Sign Up Fields
              if (!isSignIn) ...[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: studentIdController,
                  decoration: InputDecoration(
                    labelText: 'Student ID',
                    hintText: 'e.g., 2024-12345',
                    prefixIcon: const Icon(Icons.badge),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: programController,
                        decoration: InputDecoration(
                          labelText: 'Program',
                          hintText: 'BSIT',
                          prefixIcon: const Icon(Icons.school),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: yearLevelController,
                        decoration: InputDecoration(
                          labelText: 'Year',
                          hintText: '1st Year',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: sectionController,
                  decoration: InputDecoration(
                    labelText: 'Section',
                    hintText: 'A',
                    prefixIcon: const Icon(Icons.class_),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Email Field
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Password Field
              TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Sign In/Up Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleAuth,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          isSignIn ? 'SIGN IN' : 'SIGN UP',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Toggle Sign In/Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isSignIn
                        ? "Don't have an account? "
                        : "Already have an account? ",
                  ),
                  InkWell(
                    onTap: () => setState(() => isSignIn = !isSignIn),
                    child: Text(
                      isSignIn ? 'Sign Up' : 'Sign In',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              if (isSignIn) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _handleForgotPassword,
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isSignIn
                            ? (selectedRole == 'student'
                                ? 'Students can mark attendance and view records'
                                : 'Admins manage events, approvals, and student records')
                            : 'Sign up to create your student account',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleForgotPassword() async {
    final emailController = TextEditingController();
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your email address to receive a password reset link.'),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Send'),
          ),
        ],
      ),
    );

    if (result == true && emailController.text.isNotEmpty) {
      final resetResult = await _authService.resetPassword(emailController.text.trim());
      if (mounted) {
        if (resetResult['success']) {
          _showSuccess(resetResult['message']);
        } else {
          _showError(resetResult['message']);
        }
      }
    }
  }
}