import 'package:flutter/material.dart';

class AdminAnnouncements extends StatefulWidget {
  const AdminAnnouncements({super.key});

  @override
  State<AdminAnnouncements> createState() => _AdminAnnouncementsState();
}

class _AdminAnnouncementsState extends State<AdminAnnouncements> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Published', 'Draft', 'Scheduled'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showCreateAnnouncementDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surface,
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

          // Announcements List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _AnnouncementCard(
                  title: 'Semester Break Schedule',
                  content:
                      'The semester break will be from January 20-27, 2026. Classes will resume on January 28, 2026. Have a great break!',
                  publishedBy: 'Admin Sarah Cruz',
                  date: 'Jan 15, 2026',
                  time: '8:30 AM',
                  status: 'Published',
                  priority: 'High',
                  targetAudience: 'All Students',
                  views: 1089,
                ),
                const SizedBox(height: 12),
                _AnnouncementCard(
                  title: 'New Attendance Policy',
                  content:
                      'Starting next month, students must maintain 95% attendance to avoid sanctions. Please review the updated policy document.',
                  publishedBy: 'Admin John Doe',
                  date: 'Jan 14, 2026',
                  time: '2:15 PM',
                  status: 'Published',
                  priority: 'High',
                  targetAudience: 'All Students',
                  views: 856,
                ),
                const SizedBox(height: 12),
                _AnnouncementCard(
                  title: 'Campus WiFi Maintenance',
                  content:
                      'The campus WiFi will undergo maintenance on January 18 from 2 AM to 6 AM. Service may be intermittent during this time.',
                  publishedBy: 'Admin Sarah Cruz',
                  date: 'Jan 14, 2026',
                  time: '10:00 AM',
                  status: 'Published',
                  priority: 'Medium',
                  targetAudience: 'All Students',
                  views: 634,
                ),
                const SizedBox(height: 12),
                _AnnouncementCard(
                  title: 'Student Council Elections',
                  content:
                      'Nominations for the Student Council elections are now open. Submit your application by January 25, 2026.',
                  publishedBy: 'Admin John Doe',
                  date: 'Jan 17, 2026',
                  time: '9:00 AM',
                  status: 'Scheduled',
                  priority: 'Medium',
                  targetAudience: 'All Students',
                  scheduledFor: 'Jan 17, 2026 - 9:00 AM',
                ),
                const SizedBox(height: 12),
                _AnnouncementCard(
                  title: 'Library Extended Hours',
                  content:
                      'The library will be open until 10 PM during exam week to accommodate students who need extra study time.',
                  publishedBy: 'Admin Sarah Cruz',
                  date: 'Jan 13, 2026',
                  time: '3:45 PM',
                  status: 'Draft',
                  priority: 'Low',
                  targetAudience: 'All Students',
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showCreateAnnouncementDialog();
        },
        icon: const Icon(Icons.add),
        label: const Text('New Announcement'),
      ),
    );
  }

  void _showCreateAnnouncementDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Announcement'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.priority_high),
                ),
                items: ['High', 'Medium', 'Low']
                    .map((priority) => DropdownMenuItem(value: priority, child: Text(priority)))
                    .toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Target Audience',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.people),
                ),
                items: ['All Students', 'BSCS', 'BSIT', 'BSIS', '1st Year', '2nd Year', '3rd Year', '4th Year']
                    .map((audience) => DropdownMenuItem(value: audience, child: Text(audience)))
                    .toList(),
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Announcement saved as draft')),
              );
            },
            child: const Text('Save Draft'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Announcement published successfully')),
              );
            },
            child: const Text('Publish'),
          ),
        ],
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final String title;
  final String content;
  final String publishedBy;
  final String date;
  final String time;
  final String status;
  final String priority;
  final String targetAudience;
  final int? views;
  final String? scheduledFor;

  const _AnnouncementCard({
    required this.title,
    required this.content,
    required this.publishedBy,
    required this.date,
    required this.time,
    required this.status,
    required this.priority,
    required this.targetAudience,
    this.views,
    this.scheduledFor,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case 'Published':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Scheduled':
        statusColor = Colors.blue;
        statusIcon = Icons.schedule;
        break;
      case 'Draft':
        statusColor = Colors.grey;
        statusIcon = Icons.drafts;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    Color priorityColor;
    switch (priority) {
      case 'High':
        priorityColor = Colors.red;
        break;
      case 'Medium':
        priorityColor = Colors.orange;
        break;
      default:
        priorityColor = Colors.grey;
    }

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Content
            Text(
              content,
              style: const TextStyle(fontSize: 14, height: 1.5),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            // Metadata
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _MetadataChip(
                  icon: Icons.priority_high,
                  label: priority,
                  color: priorityColor,
                ),
                _MetadataChip(
                  icon: Icons.people,
                  label: targetAudience,
                  color: Colors.blue,
                ),
                if (views != null)
                  _MetadataChip(
                    icon: Icons.visibility,
                    label: '$views views',
                    color: Colors.grey,
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Footer
            Row(
              children: [
                Icon(Icons.person, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  publishedBy,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(width: 12),
                Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  '$date • $time',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),

            if (scheduledFor != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.schedule, size: 16, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Text(
                      'Scheduled for: $scheduledFor',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const Divider(height: 24),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showAnnouncementDetails(context);
                    },
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('View'),
                  ),
                ),
                const SizedBox(width: 8),
                if (status != 'Published') ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        print('Edit announcement');
                      },
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit'),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (status == 'Published') {
                        print('Unpublish announcement');
                      } else {
                        print('Publish announcement');
                      }
                    },
                    icon: Icon(
                      status == 'Published' ? Icons.cancel : Icons.send,
                      size: 16,
                    ),
                    label: Text(status == 'Published' ? 'Unpublish' : 'Publish'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          status == 'Published' ? Colors.orange : Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAnnouncementDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(content, style: const TextStyle(height: 1.5)),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              _DetailRow(label: 'Status', value: status),
              _DetailRow(label: 'Priority', value: priority),
              _DetailRow(label: 'Target Audience', value: targetAudience),
              _DetailRow(label: 'Published By', value: publishedBy),
              _DetailRow(label: 'Date', value: '$date at $time'),
              if (views != null) _DetailRow(label: 'Views', value: '$views'),
              if (scheduledFor != null) _DetailRow(label: 'Scheduled For', value: scheduledFor!),
            ],
          ),
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
}

class _MetadataChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetadataChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}