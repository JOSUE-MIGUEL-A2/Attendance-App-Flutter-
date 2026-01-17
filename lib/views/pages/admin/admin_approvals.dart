import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesis_attendance/models/student_model.dart';
import 'package:thesis_attendance/services/data_provider.dart';

class AdminApprovals extends StatefulWidget {
  const AdminApprovals({super.key});

  @override
  State<AdminApprovals> createState() => _AdminApprovalsState();
}

class _AdminApprovalsState extends State<AdminApprovals> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Documents', 'Appeals', 'Clearances'];
  String _selectedStatus = 'Pending';
  final List<String> _statuses = ['Pending', 'Approved', 'Rejected'];

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, provider, child) {
        // Filter approvals by status
        List<ApprovalRequest> filteredApprovals;
        if (_selectedStatus == 'Pending') {
          filteredApprovals = provider.approvalRequests
              .where((r) => r.status == 'Pending')
              .toList();
        } else if (_selectedStatus == 'Approved') {
          filteredApprovals = provider.approvalRequests
              .where((r) => r.status == 'Approved')
              .toList();
        } else {
          filteredApprovals = provider.approvalRequests
              .where((r) => r.status == 'Rejected')
              .toList();
        }

        // Filter by type
        if (_selectedFilter != 'All') {
          String filterType = '';
          switch (_selectedFilter) {
            case 'Documents':
              filterType = 'Document Verification';
              break;
            case 'Appeals':
              filterType = 'Sanction Appeal';
              break;
            case 'Clearances':
              filterType = 'Clearance Request';
              break;
          }
          if (filterType.isNotEmpty) {
            filteredApprovals = filteredApprovals
                .where((r) => r.type == filterType)
                .toList();
          }
        }

        return Column(
          children: [
            // Filter Section
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Tabs
                  Row(
                    children: _statuses.map((status) {
                      final isSelected = _selectedStatus == status;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedStatus = status;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              status,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.grey.shade700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  // Type Filters
                  SingleChildScrollView(
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
                            selectedColor: Theme.of(context).colorScheme.secondary,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.black : null,
                              fontWeight: isSelected ? FontWeight.bold : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Approvals List
            Expanded(
              child: filteredApprovals.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _selectedStatus == 'Pending'
                                ? Icons.inbox
                                : _selectedStatus == 'Approved'
                                    ? Icons.check_circle_outline
                                    : Icons.cancel_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No ${_selectedStatus.toLowerCase()} requests',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredApprovals.length,
                      itemBuilder: (context, index) {
                        final approval = filteredApprovals[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ApprovalDetailCard(
                            approval: approval,
                            onApprove: () => _handleApprove(approval),
                            onReject: () => _handleReject(approval),
                            onView: () => _handleViewDetails(approval),
                            isProcessing: _isProcessing,
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleApprove(ApprovalRequest approval) async {
    final notesController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Approve ${approval.category} for ${approval.studentName}?'),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Additional Notes (Optional)',
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Approve'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final provider = Provider.of<DataProvider>(context, listen: false);
      final success = await provider.approveRequest(
        approval.id,
        'Admin Sarah Cruz',
        notesController.text.isNotEmpty ? notesController.text : null,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${approval.type} approved for ${approval.studentName}'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to approve request'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _handleReject(ApprovalRequest approval) async {
    final reasonController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Reject ${approval.category} for ${approval.studentName}?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Reason for Rejection *',
                hintText: 'Explain why this request is being rejected...',
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
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please provide a reason for rejection'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (reasonController.text.trim().isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final provider = Provider.of<DataProvider>(context, listen: false);
      final success = await provider.rejectRequest(
        approval.id,
        'Admin Sarah Cruz',
        reasonController.text,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${approval.type} rejected for ${approval.studentName}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to reject request'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _handleViewDetails(ApprovalRequest approval) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(approval.type),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _DetailRow('Student:', approval.studentName),
              _DetailRow('Student ID:', approval.studentId),
              _DetailRow('Category:', approval.category),
              _DetailRow('Urgency:', approval.urgency),
              _DetailRow('Status:', approval.status),
              _DetailRow('Submitted:', _formatDateTime(approval.submittedDate)),
              const Divider(height: 24),
              const Text(
                'Reason:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(approval.reason),
              if (approval.attachments != null && approval.attachments!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Attachments: ${approval.attachments!.length} file(s)',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
              if (approval.approvedBy != null) ...[
                const Divider(height: 24),
                _DetailRow('Approved By:', approval.approvedBy!),
                _DetailRow('Approved On:', _formatDateTime(approval.approvedDate!)),
                if (approval.notes != null) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Notes:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(approval.notes!),
                ],
              ],
              if (approval.rejectedBy != null) ...[
                const Divider(height: 24),
                _DetailRow('Rejected By:', approval.rejectedBy!),
                _DetailRow('Rejected On:', _formatDateTime(approval.rejectedDate!)),
                const SizedBox(height: 8),
                const Text(
                  'Rejection Reason:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                Text(
                  approval.rejectionReason ?? 'No reason provided',
                  style: const TextStyle(color: Colors.red),
                ),
              ],
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

  String _formatDateTime(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _ApprovalDetailCard extends StatelessWidget {
  final ApprovalRequest approval;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onView;
  final bool isProcessing;

  const _ApprovalDetailCard({
    required this.approval,
    required this.onApprove,
    required this.onReject,
    required this.onView,
    required this.isProcessing,
  });

  @override
  Widget build(BuildContext context) {
    Color urgencyColor;
    switch (approval.urgency) {
      case 'High':
        urgencyColor = Colors.red;
        break;
      case 'Medium':
        urgencyColor = Colors.orange;
        break;
      default:
        urgencyColor = Colors.grey;
    }

    Color statusColor;
    IconData statusIcon;
    switch (approval.status) {
      case 'Approved':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
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
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  child: Text(
                    approval.studentName[0],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        approval.studentName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'ID: ${approval.studentId}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: approval.status == 'Pending'
                        ? urgencyColor.withOpacity(0.1)
                        : statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: approval.status == 'Pending' ? urgencyColor : statusColor,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (approval.status != 'Pending') ...[
                        Icon(statusIcon, size: 14, color: statusColor),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        approval.status == 'Pending' ? approval.urgency : approval.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: approval.status == 'Pending' ? urgencyColor : statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            // Type and Category
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    _getTypeIcon(approval.type),
                    color: Colors.blue.shade700,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          approval.type,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          approval.category,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Reason
            Text(
              'Reason:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              approval.reason,
              style: const TextStyle(fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            // Metadata
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  _formatDate(approval.submittedDate),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (approval.attachments != null && approval.attachments!.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  Icon(Icons.attach_file, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    '${approval.attachments!.length} files',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),

            // Status Info
            if (approval.approvedBy != null ||approval.rejectedBy != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, size: 14, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          '${approval.status} by: ${approval.approvedBy ?? approval.rejectedBy}',
                          style: TextStyle(
                            fontSize: 12,
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (approval.rejectionReason != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        approval.rejectionReason!,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],

            // Action Buttons (only for pending)
            if (approval.status == 'Pending') ...[
              const Divider(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isProcessing ? null : onView,
                      icon: const Icon(Icons.visibility, size: 16),
                      label: const Text('View'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isProcessing ? null : onReject,
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Reject'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isProcessing ? null : onApprove,
                      icon: isProcessing
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check, size: 16),
                      label: Text(isProcessing ? 'Processing...' : 'Approve'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Document Verification':
        return Icons.verified;
      case 'Sanction Appeal':
        return Icons.gavel;
      case 'Clearance Request':
        return Icons.fact_check;
      default:
        return Icons.description;
    }
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}