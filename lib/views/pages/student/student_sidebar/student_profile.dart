// lib/views/pages/student/student_sidebar/student_profile.dart
import 'package:flutter/material.dart';
import 'package:thesis_attendance/services/student_service.dart';
import 'package:thesis_attendance/services/firebase_service.dart';
import 'package:thesis_attendance/models/student_model.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({super.key});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  final StudentService _service = StudentService();
  bool _isEditing = false;
  bool _isSaving = false;

  // Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseService.currentUserId;

    if (uid == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Profile')),
        body: const Center(child: Text('Not logged in')),
      );
    }

    return StreamBuilder<Student?>(
      stream: _service.getStudentProfile(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('My Profile')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('My Profile')),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('My Profile')),
            body: const Center(child: Text('Profile not found')),
          );
        }

        final student = snapshot.data!;

        // Set initial values when not editing
        if (!_isEditing) {
          _nameController.text = student.name;
          _phoneController.text = student.phone;
          _addressController.text = student.address;
          _emergencyNameController.text = student.emergencyContactName;
          _emergencyPhoneController.text = student.emergencyContactNumber;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Profile'),
            actions: [
              if (!_isEditing)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                )
              else
                TextButton(
                  onPressed: _isSaving ? null : () => _saveProfile(uid, student),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'SAVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Picture Section
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          student.name.isNotEmpty ? student.name[0] : 'S',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (_isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt, size: 20),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Photo upload - Coming soon!'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Student ID Card
                _buildIDCard(context, student),

                const SizedBox(height: 24),

                // Personal Information Section
                _SectionHeader(title: 'Personal Information'),
                const SizedBox(height: 12),
                _ProfileField(
                  label: 'Full Name',
                  controller: _nameController,
                  icon: Icons.person,
                  isEditing: _isEditing,
                ),
                const SizedBox(height: 12),
                _ProfileField(
                  label: 'Email Address',
                  value: student.email,
                  icon: Icons.email,
                  isEditing: false, // Email cannot be edited
                ),
                const SizedBox(height: 12),
                _ProfileField(
                  label: 'Phone Number',
                  controller: _phoneController,
                  icon: Icons.phone,
                  isEditing: _isEditing,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                _ProfileField(
                  label: 'Address',
                  controller: _addressController,
                  icon: Icons.location_on,
                  isEditing: _isEditing,
                  maxLines: 2,
                ),

                const SizedBox(height: 24),

                // Academic Information Section
                _SectionHeader(title: 'Academic Information'),
                const SizedBox(height: 12),
                _InfoCard(
                  title: 'Department',
                  value: student.department,
                  icon: Icons.school,
                ),
                const SizedBox(height: 8),
                _InfoCard(
                  title: 'Program',
                  value: '${student.program} - ${student.yearLevel}',
                  icon: Icons.menu_book,
                ),
                const SizedBox(height: 8),
                _InfoCard(
                  title: 'Section',
                  value: student.section,
                  icon: Icons.class_,
                ),
                const SizedBox(height: 8),
                _InfoCard(
                  title: 'Status',
                  value: student.status,
                  icon: Icons.check_circle,
                  valueColor: Colors.green,
                ),

                const SizedBox(height: 24),

                // Quick Stats Section
                _SectionHeader(title: 'Quick Stats'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'GPA',
                        value: student.gpa.toStringAsFixed(2),
                        icon: Icons.grade,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: 'Units',
                        value: student.totalUnits.toString(),
                        icon: Icons.subject,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Emergency Contact Section
                _SectionHeader(title: 'Emergency Contact'),
                const SizedBox(height: 12),
                _ProfileField(
                  label: 'Contact Person',
                  controller: _emergencyNameController,
                  icon: Icons.person_outline,
                  isEditing: _isEditing,
                ),
                const SizedBox(height: 8),
                _ProfileField(
                  label: 'Contact Number',
                  controller: _emergencyPhoneController,
                  icon: Icons.phone_in_talk,
                  isEditing: _isEditing,
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 24),

                // Action Buttons
                if (!_isEditing) ...[
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showChangePasswordDialog(),
                      icon: const Icon(Icons.lock),
                      label: const Text('Change Password'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Download feature - Coming soon!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.download),
                      label: const Text('Download Student ID'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ] else
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = false;
                          // Reset values
                          _nameController.text = student.name;
                          _phoneController.text = student.phone;
                          _addressController.text = student.address;
                          _emergencyNameController.text = student.emergencyContactName;
                          _emergencyPhoneController.text = student.emergencyContactNumber;
                        });
                      },
                      child: const Text('Cancel'),
                    ),
                  ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIDCard(BuildContext context, Student student) {
    return Card(
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Student ID',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    student.status.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              student.studentId,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _IDInfoItem(label: 'Program', value: student.program),
                _IDInfoItem(label: 'Year', value: student.yearLevel.split(' ')[0]),
                _IDInfoItem(label: 'Section', value: student.section),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile(String uid, Student student) async {
    setState(() {
      _isSaving = true;
    });

    try {
      final success = await _service.updateProfile(
        uid: uid,
        name: _nameController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        emergencyContactName: _emergencyNameController.text,
        emergencyContactNumber: _emergencyPhoneController.text,
      );

      if (!mounted) return;

      setState(() {
        _isEditing = false;
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success 
              ? 'Profile updated successfully' 
              : 'Failed to update profile'),
          backgroundColor: success ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool isChanging = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isChanging ? null : () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isChanging
                  ? null
                  : () async {
                      if (newPasswordController.text != confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Passwords do not match'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (newPasswordController.text.length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password must be at least 6 characters'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      setDialogState(() {
                        isChanging = true;
                      });

                      try {
                        await FirebaseService.changePassword(
                          currentPasswordController.text,
                          newPasswordController.text,
                        );

                        if (!context.mounted) return;

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password changed successfully'),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      } catch (e) {
                        if (!context.mounted) return;

                        setDialogState(() {
                          isChanging = false;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
              child: isChanging
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== WIDGET CLASSES ====================

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? value;
  final IconData icon;
  final bool isEditing;
  final TextInputType? keyboardType;
  final int maxLines;

  const _ProfileField({
    required this.label,
    this.controller,
    this.value,
    required this.icon,
    required this.isEditing,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = value ?? controller?.text ?? '';

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (isEditing && controller != null)
              TextField(
                controller: controller,
                keyboardType: keyboardType,
                maxLines: maxLines,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              )
            else
              Text(
                displayValue,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
        ),
        title: Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _IDInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _IDInfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}