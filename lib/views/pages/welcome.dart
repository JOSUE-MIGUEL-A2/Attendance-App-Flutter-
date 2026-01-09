import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:thesis_attendance/data/notifiers.dart';
import 'package:thesis_attendance/views/pages/student/student_widget_tree.dart';
import 'package:thesis_attendance/views/pages/admin/admin_widget_tree.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool isSignIn = true;
  UserRole selectedRole = UserRole.student;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    studentIdController.dispose();
    super.dispose();
  }

  void _handleAuth() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!isSignIn && nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    currentUserNotifier.value = CurrentUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text.isNotEmpty ? nameController.text : 'Test User',
      email: emailController.text,
      role: selectedRole,
      section: selectedRole == UserRole.student ? 'Section A' : null,
      studentId: selectedRole == UserRole.student
          ? studentIdController.text
          : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSignIn ? 'Welcome Tradeans!' : 'Account created successfully!',
        ),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => selectedRole == UserRole.student
            ? const StudentWidgetTree()
            : const AdminWidgetTree(),
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
                        onTap: () =>
                            setState(() => selectedRole = UserRole.student),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: selectedRole == UserRole.student
                                ? Colors.blue.shade700
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.school,
                                color: selectedRole == UserRole.student
                                    ? Colors.white
                                    : Colors.grey.shade700,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Student',
                                style: TextStyle(
                                  color: selectedRole == UserRole.student
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
                        onTap: () =>
                            setState(() => selectedRole = UserRole.admin),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: selectedRole == UserRole.admin
                                ? Colors.blue.shade700
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.admin_panel_settings,
                                color: selectedRole == UserRole.admin
                                    ? Colors.white
                                    : Colors.grey.shade700,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Admin',
                                style: TextStyle(
                                  color: selectedRole == UserRole.admin
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

              if (!isSignIn) ...[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                if (selectedRole == UserRole.student) ...[
                  TextField(
                    controller: studentIdController,
                    decoration: InputDecoration(
                      labelText: 'Student ID',
                      prefixIcon: const Icon(Icons.badge),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ],

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
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

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleAuth,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isSignIn ? 'SIGN IN' : 'SIGN UP',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

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
            ],
          ),
        ),
      ),
    );
  }
}