import 'package:flutter/material.dart';
import 'package:zed_nano/models/approval_data.dart';
import 'package:zed_nano/screens/approvals/itemBuilders/approval_types.dart';

/// Callback function type for handling approval item taps
typedef ApprovalItemTapCallback = void Function(ApprovalData item);

/// Reusable grid view widget for displaying approval items
/// Handles both even and odd number of items with proper layout
class ApprovalGridView extends StatelessWidget {
  final List<ApprovalData>? approvalData;
  final String status;
  final ApprovalItemTapCallback onItemTap;

  const ApprovalGridView({
    super.key,
    required this.approvalData,
    required this.status,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = approvalData ?? [];
    if (items.isEmpty) {
      return const Expanded(child: SizedBox());
    }

    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: _buildGridRows(items),
        ),
      ),
    );
  }

  List<Widget> _buildGridRows(List<ApprovalData> items) {
    List<Widget> rows = [];
    
    // Process items in pairs for normal rows
    for (int i = 0; i < items.length - 1; i += 2) {
      rows.add(
        Row(
          children: [
            Expanded(
              child: _buildGridItem(items[i], i),
            ),
            const SizedBox(width: 12), // Horizontal spacing
            Expanded(
              child: _buildGridItem(items[i + 1], i + 1),
            ),
          ],
        ),
      );
      
      // Add vertical spacing between rows
      if (i + 2 < items.length) {
        rows.add(const SizedBox(height: 12));
      }
    }
    
    // Handle the last item if odd number of items
    if (items.length % 2 == 1) {
      // Add spacing before the last item if there are previous rows
      if (rows.isNotEmpty) {
        rows.add(const SizedBox(height: 12));
      }
      
      // Add the last item spanning full width but with same height
      rows.add(
        Row(
          children: [
            Expanded(
              child: _buildGridItem(items.last, items.length - 1, isFullWidth: true),
            ),
          ],
        ),
      );
    }
    
    return rows;
  }

  Widget _buildGridItem(ApprovalData item, int index, {bool isFullWidth = false}) {
    return AspectRatio(
      aspectRatio: isFullWidth ? 3.2 : 1.6, // Double the aspect ratio for full width to maintain same height
      child: createListItem(
        item,
        status,
        onTap: () => onItemTap(item),
      ),
    );
  }
}
