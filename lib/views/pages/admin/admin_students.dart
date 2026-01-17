import 'package:flutter/material.dart';

class AdminStudents extends StatefulWidget {
  const AdminStudents({super.key});

  @override
  State<AdminStudents> createState() => _AdminStudentsState();
}

class _AdminStudentsState extends State<AdminStudents> {
  // ignore: unused_field
  String _searchQuery = '';
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Active', 'Inactive', 'On Leave'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search and Filter Section
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            children: [
              // Search Bar
              TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search students by name or ID...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              // Filter Chips
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _filters.map((filter) {
                          final isSelected = _selectedFilter == filter;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(filter),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedFilter = filter;
                                });
                              },
                              selectedColor: Theme.of(context).colorScheme.primary,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : null,
                                fontWeight: isSelected ? FontWeight.bold : null,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      _showAdvancedFilters();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        // Students List
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _StudentCard(
                name: 'Juan Dela Cruz',
                studentId: '2024-12345',
                email: 'juan.delacruz@isatu.edu.ph',
                program: 'BSIT',
                year: '3rd Year',
                section: 'A',
                status: 'Active',
                attendanceRate: 95,
                sanctions: 0,
              ),
              const SizedBox(height: 12),
              _StudentCard(
                name: 'Maria Santos',
                studentId: '2024-12346',
                email: 'maria.santos@isatu.edu.ph',
                program: 'BSIT',
                year: '3rd Year',
                section: 'B',
                status: 'Active',
                attendanceRate: 92,
                sanctions: 1,
              ),
              const SizedBox(height: 12),
              _StudentCard(
                name: 'Pedro Reyes',
                studentId: '2024-12347',
                email: 'pedro.reyes@isatu.edu.ph',
                program: 'BSCS',
                year: '4th Year',
                section: 'A',
                status: 'Active',
                attendanceRate: 88,
                sanctions: 0,
              ),
              const SizedBox(height: 12),
              _StudentCard(
                name: 'Ana Garcia',
                studentId: '2024-12348',
                email: 'ana.garcia@isatu.edu.ph',
                program: 'BSIS',
                year: '2nd Year',
                section: 'C',
                status: 'Active',
                attendanceRate: 97,
                sanctions: 0,
              ),
              const SizedBox(height: 12),
              _StudentCard(
                name: 'Carlos Lopez',
                studentId: '2024-12349',
                email: 'carlos.lopez@isatu.edu.ph',
                program: 'BSIT',
                year: '4th Year',
                section: 'B',
                status: 'On Leave',
                attendanceRate: 0,
                sanctions: 0,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAdvancedFilters() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Advanced Filters',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Program',
                border: OutlineInputBorder(),
              ),
              items: ['All', 'BSCS', 'BSIT', 'BSIS']
                  .map((program) => DropdownMenuItem(
                        value: program,
                        child: Text(program),
                      ))
                  .toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Year Level',
                border: OutlineInputBorder(),
              ),
              items: ['All', '1st Year', '2nd Year', '3rd Year', '4th Year']
                  .map((year) => DropdownMenuItem(
                        value: year,
                        child: Text(year),
                      ))
                  .toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Clear'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final String name;
  final String studentId;
  final String email;
  final String program;
  final String year;
  final String section;
  final String status;
  final int attendanceRate;
  final int sanctions;

  const _StudentCard({
    required this.name,
    required this.studentId,
    required this.email,
    required this.program,
    required this.year,
    required this.section,
    required this.status,
    required this.attendanceRate,
    required this.sanctions,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (status) {
      case 'Active':
        statusColor = Colors.green;
        break;
      case 'Inactive':
        statusColor = Colors.red;
        break;
      case 'On Leave':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }

    Color attendanceColor;
    if (attendanceRate >= 95) {
      attendanceColor = Colors.green;
    } else if (attendanceRate >= 85) {
      attendanceColor = Colors.blue;
    } else if (attendanceRate >= 75) {
      attendanceColor = Colors.orange;
    } else {
      attendanceColor = Colors.red;
    }

    return Card(
      elevation: 2,
      child: ExpansionTile(
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Text(
            name[0],
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID: $studentId',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$program - $year',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$attendanceRate%',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: attendanceColor,
              ),
            ),
            Text(
              'Attendance',
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Contact Info
                _InfoRow(
                  icon: Icons.email,
                  label: 'Email',
                  value: email,
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.class_,
                  label: 'Section',
                  value: section,
                ),
                const SizedBox(height: 16),

                // Statistics
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        label: 'Attendance',
                        value: '$attendanceRate%',
                        color: attendanceColor,
                        icon: Icons.event_available,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatBox(
                        label: 'Sanctions',
                        value: sanctions.toString(),
                        color: sanctions > 0 ? Colors.red : Colors.green,
                        icon: Icons.warning,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showStudentDetails(context);
                        },
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text('View Profile'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showSendNotification(context);
                        },
                        icon: const Icon(Icons.message, size: 16),
                        label: const Text('Message'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          print('View attendance history');
                        },
                        icon: const Icon(Icons.history, size: 16),
                        label: const Text('History'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          print('Generate report');
                        },
                        icon: const Icon(Icons.assessment, size: 16),
                        label: const Text('Report'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showStudentDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Student ID: $studentId'),
            Text('Email: $email'),
            Text('Program: $program'),
            Text('Year: $year'),
            Text('Section: $section'),
            Text('Status: $status'),
            Text('Attendance Rate: $attendanceRate%'),
            Text('Sanctions: $sanctions'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSendNotification(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Send Message to $name'),
        content: TextField(
          maxLines: 4,
          decoration: InputDecoration(
            labelText: 'Message',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Message sent successfully'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}