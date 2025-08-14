import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/services/saved_credentials_service.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/utils/Common.dart';

class SavedCredentialsBottomSheet extends StatefulWidget {
  final String type; // 'email' or 'phone'
  final Function(SavedCredential) onCredentialSelected;

  const SavedCredentialsBottomSheet({
    super.key,
    required this.type,
    required this.onCredentialSelected,
  });

  @override
  State<SavedCredentialsBottomSheet> createState() => _SavedCredentialsBottomSheetState();
}

class _SavedCredentialsBottomSheetState extends State<SavedCredentialsBottomSheet> {
  List<SavedCredential> credentials = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    try {
      final savedCredentials = await SavedCredentialsService.getSavedCredentialsByType(widget.type);
      setState(() {
        credentials = savedCredentials;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      logger.e('Failed to load saved credentials: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          16.height,
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(
                  widget.type == 'email' ? Icons.email_outlined : Icons.phone_outlined,
                  color: appThemePrimary,
                  size: 24,
                ),
                12.width,
                Expanded(
                  child: Text(
                    'Saved ${widget.type == 'email' ? 'Email Addresses' : 'Phone Numbers'}',
                    style: boldTextStyle(
                      size: 18,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          16.height,
          
          // Content
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            )
          else if (credentials.isEmpty)
            _buildEmptyState()
          else
            _buildCredentialsList(),
          
          24.height,
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            widget.type == 'email' ? Icons.email_outlined : Icons.phone_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          16.height,
          Text(
            'No saved ${widget.type == 'email' ? 'email addresses' : 'phone numbers'}',
            style: boldTextStyle(
              size: 16,
              color: Colors.grey[600],
              fontFamily: 'Poppins',
            ),
          ),
          8.height,
          Text(
            'Your saved ${widget.type == 'email' ? 'emails' : 'phone numbers'} will appear here after successful logins',
            style: secondaryTextStyle(
              size: 14,
              color: Colors.grey[500],
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCredentialsList() {
    return Flexible(
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: credentials.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final credential = credentials[index];
          return _buildCredentialItem(credential);
        },
      ),
    );
  }

  Widget _buildCredentialItem(SavedCredential credential) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: appThemePrimary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          widget.type == 'email' ? Icons.email : Icons.phone,
          color: appThemePrimary,
          size: 20,
        ),
      ),
      title: Text(
        credential.identifier,
        style: boldTextStyle(
          size: 14,
          fontFamily: 'Poppins',
        ),
      ),
      subtitle: Text(
        'Last used: ${_formatLastUsed(credential.lastUsed)}',
        style: secondaryTextStyle(
          size: 12,
          color: Colors.grey[600],
          fontFamily: 'Poppins',
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => _showDeleteConfirmation(credential),
            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
            tooltip: 'Remove',
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
      onTap: () {
        widget.onCredentialSelected(credential);
        Navigator.pop(context);
      },
    );
  }

  String _formatLastUsed(DateTime lastUsed) {
    final now = DateTime.now();
    final difference = now.difference(lastUsed);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  void _showDeleteConfirmation(SavedCredential credential) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Saved Credential'),
        content: Text('Are you sure you want to remove "${credential.identifier}" from saved credentials?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await SavedCredentialsService.removeCredential(credential.identifier);
              _loadCredentials(); // Refresh the list
              showCustomToast('Credential removed', isError: false);
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

/// Show saved credentials bottom sheet
Future<void> showSavedCredentialsBottomSheet({
  required BuildContext context,
  required String type,
  required Function(SavedCredential) onCredentialSelected,
}) async {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => SavedCredentialsBottomSheet(
      type: type,
      onCredentialSelected: onCredentialSelected,
    ),
  );
}
