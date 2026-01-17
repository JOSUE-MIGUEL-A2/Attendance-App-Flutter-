import 'package:flutter/material.dart';

class AdminDocumentLibrary extends StatefulWidget {
  const AdminDocumentLibrary({super.key});

  @override
  State<AdminDocumentLibrary> createState() => _AdminDocumentLibraryState();
}

class _AdminDocumentLibraryState extends State<AdminDocumentLibrary> {
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Templates',
    'Policies',
    'Forms',
    'Guidelines',
    'Student Documents',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () {
              _showUploadDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.create_new_folder),
            onPressed: () {
              _showCreateFolderDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Tabs
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: Theme.of(context).colorScheme.surface,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
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

          // Documents Grid
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,
              children: [
                _FolderCard(
                  name: 'Templates',
                  fileCount: 15,
                  icon: Icons.folder_special,
                  color: Colors.blue,
                ),
                _FolderCard(
                  name: 'Policies',
                  fileCount: 8,
                  icon: Icons.policy,
                  color: Colors.purple,
                ),
                _FolderCard(
                  name: 'Forms',
                  fileCount: 23,
                  icon: Icons.description,
                  color: Colors.orange,
                ),
                _FolderCard(
                  name: 'Guidelines',
                  fileCount: 12,
                  icon: Icons.menu_book,
                  color: Colors.teal,
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Recent Documents
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Documents',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                _DocumentTile(
                  name: 'Student Handbook 2025-2026',
                  type: 'PDF',
                  size: '2.4 MB',
                  uploadedBy: 'Admin Sarah',
                  date: 'Jan 14, 2026',
                  category: 'Guidelines',
                ),
                _DocumentTile(
                  name: 'Attendance Policy',
                  type: 'PDF',
                  size: '456 KB',
                  uploadedBy: 'Admin John',
                  date: 'Jan 13, 2026',
                  category: 'Policies',
                ),
                _DocumentTile(
                  name: 'Event Request Form',
                  type: 'DOCX',
                  size: '128 KB',
                  uploadedBy: 'Admin Sarah',
                  date: 'Jan 12, 2026',
                  category: 'Forms',
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showUploadDialog();
        },
        icon: const Icon(Icons.add),
        label: const Text('Upload Document'),
      ),
    );
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload Document'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: _categories
                  .where((cat) => cat != 'All')
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Document Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.attach_file),
              label: const Text('Choose File'),
            ),
          ],
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
                  content: Text('Document uploaded successfully'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  void _showCreateFolderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Folder'),
        content: TextField(
          decoration: InputDecoration(
            labelText: 'Folder Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                  content: Text('Folder created successfully'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _FolderCard extends StatelessWidget {
  final String name;
  final int fileCount;
  final IconData icon;
  final Color color;

  const _FolderCard({
    required this.name,
    required this.fileCount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          print('Open folder: $name');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 64, color: color),
              const SizedBox(height: 12),
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '$fileCount files',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocumentTile extends StatelessWidget {
  final String name;
  final String type;
  final String size;
  final String uploadedBy;
  final String date;
  final String category;

  const _DocumentTile({
    required this.name,
    required this.type,
    required this.size,
    required this.uploadedBy,
    required this.date,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    IconData fileIcon;
    Color fileColor;

    switch (type) {
      case 'PDF':
        fileIcon = Icons.picture_as_pdf;
        fileColor = Colors.red;
        break;
      case 'DOCX':
        fileIcon = Icons.description;
        fileColor = Colors.blue;
        break;
      case 'XLSX':
        fileIcon = Icons.table_chart;
        fileColor = Colors.green;
        break;
      default:
        fileIcon = Icons.insert_drive_file;
        fileColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: fileColor.withOpacity(0.1),
          child: Icon(fileIcon, color: fileColor, size: 24),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(type, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                Text(size, style: const TextStyle(fontSize: 11)),
              ],
            ),
            const SizedBox(height: 2),
            Text('$uploadedBy • $date', style: const TextStyle(fontSize: 11)),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            _showDocumentOptions(context);
          },
        ),
      ),
    );
  }

  void _showDocumentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.visibility),
            title: const Text('View'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Download'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Rename'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete', style: TextStyle(color: Colors.red)),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}