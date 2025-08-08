import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';

class AboutZedPage extends StatelessWidget {
  const AboutZedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(title: 'About Zed Nano'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSectionCard(
              title: 'General Info',
              titleColor: const Color(0xFFDC3545),
              child: _buildExpandableItem(
                icon: Icons.info_outline,
                iconColor: const Color(0xFF144166),
                title: 'What is Zed Nano?',
                content: 'It is system that allows schools to easily accepts payment from multiple payment methods, generate invoices and automate reconciliation with dashboards and reports.',
              ),
            ),
            
            16.height,
            
            // Contact Us Card
            _buildSectionCard(
              title: 'Contact Us',
              titleColor: const Color(0xFFDC3545),
              child: _buildContactInfo(),
            ),
            
            16.height,
            
            // Privacy & Security Card
            _buildSectionCard(
              title: 'Privacy & Security',
              titleColor: const Color(0xFFDC3545),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.privacy_tip_outlined,
                    iconColor: const Color(0xFF144166),
                    title: 'Privacy Policy',
                    onTap: () => _launchURL('https://zed.business/Privacy%20policy.html'),
                  ),
                  16.height,
                  _buildMenuItem(
                    icon: Icons.description_outlined,
                    iconColor: const Color(0xFF144166),
                    title: 'Terms & Conditions',
                    onTap: () => _launchURL('https://zed.business/Terms%20&%20Conditions.html'),
                  ),
                ],
              ),
            ),
            
            16.height,
            
            // Socials Card
            _buildSectionCard(
              title: 'Socials',
              titleColor: const Color(0xFFDC3545),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.facebook,
                    iconColor: const Color(0xFF1877F2),
                    title: 'Facebook',
                    onTap: () => _launchURL('https://www.facebook.com/ZedPayments/'),
                  ),
                  16.height,
                  _buildMenuItem(
                    icon: Icons.camera_alt,
                    iconColor: const Color(0xFFE4405F),
                    title: 'Instagram',
                    onTap: () => _launchURL('https://www.instagram.com/zedpayments/'),
                  ),
                  16.height,
                  _buildMenuItem(
                    icon: Icons.work,
                    iconColor: const Color(0xFF0A66C2),
                    title: 'LinkedIn',
                    onTap: () => _launchURL('https://www.linkedin.com/company/zed-payments/'),
                  ),
                  16.height,
                  _buildMenuItem(
                    icon: Icons.alternate_email,
                    iconColor: const Color(0xFF000000),
                    title: 'Twitter',
                    onTap: () => _launchURL('https://twitter.com/Zedpayments'),
                  ),
                  16.height,
                  _buildMenuItem(
                    icon: Icons.play_circle_filled,
                    iconColor: const Color(0xFFFF0000),
                    title: 'YouTube',
                    onTap: () => _launchURL('https://www.youtube.com/@zedpayments'),
                  ),
                  16.height,
                  _buildMenuItem(
                    icon: Icons.chat,
                    iconColor: const Color(0xFF25D366),
                    title: 'WhatsApp',
                    onTap: () => _launchURL('https://api.whatsapp.com/send?phone=+254769607456&text=Hello'),
                  ),
                  16.height,
                  _buildMenuItem(
                    icon: Icons.language,
                    iconColor: const Color(0xFF144166),
                    title: 'Website',
                    onTap: () => _launchURL('https://zed.business'),
                  ),
                  16.height,
                  _buildMenuItem(
                    icon: Icons.star,
                    iconColor: const Color(0xFFDC3545),
                    title: 'Rate Us On Google Play',
                    onTap: () => _launchURL('https://play.google.com/store/apps/details?id=com.rbs.zednano'),
                  ),
                ],
              ),
            ),
            
            24.height,
            
            // Version Info
            const Text(
              'Version 1.9.7',
              style: TextStyle(
                color: Color(0xFF687C8D),
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
            
            24.height,
          ],
        ),
      ).paddingSymmetric(vertical: 10),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required Color titleColor,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFC),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Text(
              title,
              style: TextStyle(
                color: titleColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          
          // Section Content
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return ExpansionTile(

      tilePadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: iconColor,
        size: 20,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xDE000000),
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Poppins',
        ),
      ),
      iconColor: const Color(0xFF687C8D),
      collapsedIconColor: const Color(0xFF687C8D),
      childrenPadding: const EdgeInsets.fromLTRB(36, 0, 0, 8),
      children: [
        Text(
          content,
          style: const TextStyle(
            color: Color(0xFF707070),
            fontSize: 13,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'If you can not find answer to your question in our FAQ, you can always contact us or email us. We will answer you shortly!',
          style: TextStyle(
            color: Color(0xFF707070),
            fontSize: 13,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
            height: 1.5,
          ),
        ),
        16.height,
        Row(
          children: [
            const Icon(
              Icons.email_outlined,
              color: Color(0xFF144166),
              size: 20,
            ),
            12.width,
            const Text(
              'info@zedbusiness',
              style: TextStyle(
                color: Color(0xDE000000),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        12.height,
        Row(
          children: [
            const Icon(
              Icons.phone_outlined,
              color: Color(0xFF144166),
              size: 20,
            ),
            12.width,
            const Text(
              'Contact: +254-700-607-458',
              style: TextStyle(
                color: Color(0xDE000000),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        12.height,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.location_on_outlined,
              color: Color(0xFF144166),
              size: 20,
            ),
            12.width,
            const Expanded(
              child: Text(
                'Location: Suite 83R, Silverpool Office Suites, Jabuyu Lane, Hurlingham',
                style: TextStyle(
                  color: Color(0xDE000000),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
            16.width,
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xDE000000),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void _showFAQ(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('FAQ'),
        content: const Text('Frequently Asked Questions will be displayed here.'),
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
