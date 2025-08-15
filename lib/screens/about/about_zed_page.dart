import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart' hide getPackageInfo;
import 'package:url_launcher/url_launcher.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Constants.dart';
import 'package:zed_nano/utils/Images.dart';

class AboutZedPage extends StatefulWidget {
  const AboutZedPage({Key? key}) : super(key: key);

  @override
  State<AboutZedPage> createState() => _AboutZedPageState();
}

class _AboutZedPageState extends State<AboutZedPage> {

  String appVersion = '';
  String appVersionWithBuild = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    // Method 1: Get just the version
    final version = await getAppVersion();

    // Method 2: Get version with build number
    final versionWithBuild = await getAppVersionWithBuild();

    // Method 3: Get full package info (if you need more details)
    final packageInfo = await getPackageInfo();

    setState(() {
      appVersion = version;
      appVersionWithBuild = versionWithBuild;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(title: 'About Zed Nano'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // What is Zed Nano Section
            _buildSection(
              title: 'What is Zed Nano?',
              child: _buildInfoItem(
                iconPath: infoIcon,
                content: 'Zed Nano allows you to create and receive payments for your business.\n\nEasily manage sales, payments, inventory, customers, and generate reports.',
              ),
            ),

            24.height,

            // For More Information Section
            _buildSection(
              title: 'For More Information',
              subtitle: 'Visit our website or read through out FAQs.',
              child: Column(
                children: [
                  _buildListItem(
                    icon: websiteUrlIcon,
                    title: 'www.zed.business',
                    onTap: () => _launchURL('https://zed.business'),
                  ),
                  16.height,
                  _buildListItem(
                    icon: faqsIcon,
                    title: 'FAQs',
                    onTap: () => _showFAQ(context),
                  ),
                ],
              ),
            ),

            24.height,

            // Contact Us Section
            _buildSection(
              title: 'Contact Us',
              subtitle: 'If you can not find answer to your question in our FAQ, kindly contact us through:',
              child: Column(
                children: [
                  _buildListItem(
                    icon: phoneIconSvg,
                    title: '+254 769 607 456',
                    onTap: () => _launchURL('tel:+254769607456'),
                  ),
                  16.height,
                  _buildListItem(
                    icon: emailSvgIcon,
                    title: 'info@zed.business',
                    onTap: () => _launchURL('mailto:info@zed.business'),
                  ),
                  16.height,
                  _buildListItem(
                    icon: locationSvgIcon,
                    title: 'Suite B31, Silverpool Office Suites\nJabavu Lane,\nHurlingham, Nairobi.',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            24.height,

            // Privacy and Security Section
            _buildSection(
              title: 'Privacy and Security',
              child: Column(
                children: [
                  _buildListItem(
                    icon: privacyPolicyIcon,
                    title: 'Privacy Policy',
                    titleColor: const Color(0xFF144166),
                    onTap: () => _launchURL('https://zed.business/Privacy%20policy.html'),
                  ),
                  16.height,
                  _buildListItem(
                    icon: termsCondition,
                    title: 'Terms and Conditions',
                    titleColor: const Color(0xFF144166),
                    onTap: () => _launchURL('https://zed.business/Terms%20&%20Conditions.html'),
                  ),
                ],
              ),
            ),

            24.height,

            // Find us on Socials Section
            _buildSection(
              title: 'Find us on Socials',
              child: Column(
                children: [
                  _buildListItem(
                    icon: facebookSVGIcon,
                    iconColor: const Color(0xFF0866FF),
                    title: 'Facebook',
                    titleColor: const Color(0xFF144166),
                    onTap: () => _launchURL('https://www.facebook.com/ZedPayments/'),
                  ),
                  16.height,
                  _buildListItem(
                    icon: instagramIcon,
                    iconColor: const Color(0xFFE4405F),
                    title: 'Instagram',
                    titleColor: const Color(0xFF144166),
                    onTap: () => _launchURL('https://www.instagram.com/zedpayments/'),
                  ),
                  16.height,
                  _buildListItem(
                    icon: linkedIn,
                    iconColor: const Color(0xFF0A66C2),
                    title: 'LinkedIn',
                    titleColor: const Color(0xFF144166),
                    onTap: () => _launchURL('https://www.linkedin.com/company/zed-payments/'),
                  ),
                  16.height,
                  _buildListItem(
                    icon: twitter,
                    iconColor: const Color(0xFF000000),
                    title: 'X (formerly Twitter)',
                    titleColor: const Color(0xFF144166),
                    onTap: () => _launchURL('https://twitter.com/Zedpayments'),
                  ),
                  16.height,
                  _buildListItem(
                    icon: youtubeIcon,
                    iconColor: const Color(0xFFFF0302),
                    title: 'YouTube',
                    titleColor: const Color(0xFF144166),
                    onTap: () => _launchURL('https://www.youtube.com/@zedpayments'),
                  ),
                  16.height,
                  _buildListItem(
                    icon: whatsAppIcon,
                    iconColor: const Color(0xFF25D366),
                    title: 'WhatsApp',
                    titleColor: const Color(0xFF144166),
                    onTap: () => _launchURL('https://api.whatsapp.com/send?phone=+254769607456&text=Hello'),
                  ),
                ],
              ),
            ),

            24.height,

            // Rate Us Section
            _buildSection(
              title: 'Rate Us',
              child: _buildListItem(
                icon: playstoreIcon,
                iconColor: const Color(0xFF4285F4),
                title: 'Rate us on Play Store',
                onTap: () => _launchURL('https://play.google.com/store/apps/details?id=com.rbs.zednano'),
              ),
            ),

            32.height,
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    String? subtitle,
    Color? titleColor,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Zed Nano Logo (only for first section)
              if (title == 'What is Zed Nano?')
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: titleColor ?? const Color(0xFF333333),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),

                    rfCommonCachedNetworkImage(
                      zedNanoIcon,
                      height: 28,
                      width: 67,
                      fit: BoxFit.contain,
                      radius: 0,
                    ),
                  ],
                )
              else
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor ?? const Color(0xFF333333),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              if (subtitle != null) ...[
                8.height,
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF71727A),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ],
          ),
        ),
        16.height,
        child,
      ],
    );
  }

  Widget _buildInfoItem({
    required String iconPath,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rfCommonCachedNetworkImage(
            iconPath,
            height: 16,
            width: 16,
            fit: BoxFit.cover,
            radius: 0,
          ),
          16.width,
          Expanded(
            child: Text(
              content,
              style: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    required String icon,
    Color? iconColor,
    required String title,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              rfCommonCachedNetworkImage(
                icon,
                height: 16,
                width: 16,
                fit: BoxFit.cover,
                radius: 0,
              ),
              16.width,
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: titleColor ?? const Color(0xFF333333),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
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
