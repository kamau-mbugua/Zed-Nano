import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/posLoginVersion2/login_response.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/business/get_started_page.dart';
import 'package:zed_nano/screens/widget/common/custom_app_bar.dart';
import 'package:zed_nano/screens/widget/common/feature_card.dart';
import 'package:zed_nano/screens/widgets/custom_drawer.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/Images.dart';

class WelcomeSetupScreen extends StatefulWidget {
  const WelcomeSetupScreen({super.key});

  @override
  State<WelcomeSetupScreen> createState() => _WelcomeSetupScreenState();
}

class _WelcomeSetupScreenState extends State<WelcomeSetupScreen> {

  LoginResponse? loginResponse;

  @override
  void initState() {
    loginResponse = getAuthProvider(context).loginResponse;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomDrawer(
        onClose: () => Navigator.pop(context),
      ),
      appBar: const CustomDashboardAppBar(title:'',),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Greeting
              Text(
                'Hello ${loginResponse?.username ?? ''}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff1f2024),
                  fontFamily: 'Poppins',
                ),
              ),
              8.height,
              const Text(
                'We are glad to have you with us.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff71727a),
                  fontFamily: 'Poppins',
                ),
              ),
              24.height,
              // Empowerment Text
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Zed Nano empowers you ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffdc3545),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    TextSpan(
                      text: '\nwith the necessary tools to',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff1f2024),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    TextSpan(
                      text: '\nmanage your business',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffdc3545),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              32.height,
              // Feature cards – horizontally scrollable
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    const FeatureCard(
                      iconColor: Color(0xff1573fe),
                      assetPath: addProduct,
                      title: 'All in one place',
                      subtitle: 'Add Products',
                    ),
                    12.width,
                    const FeatureCard(
                      iconColor: Color(0xffff8503),
                      assetPath: acceptPayment,
                      title: 'Multiple methods',
                      subtitle: 'Accept Payments',
                    ),
                    12.width,
                    const FeatureCard(
                      iconColor: Color(0xff17ae7b),
                      assetPath: sellQuicker,
                      title: 'Easy steps',
                      subtitle: 'Sell Quicker!',
                    ),
                    12.width,
                    const FeatureCard(
                      iconColor: Color(0xff1573fe),
                      assetPath: trackStockIcon,
                      title: 'Get Notified',
                      subtitle: 'Track your Stock',
                    ),
                  ],
                ),
              ),
              40.height,
              // Start your journey
              const Text(
                'Start Your Journey!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff1f2024),
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Join thousands of businesses using Zed Nano today!',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff71727a),
                  fontFamily: 'Poppins',
                ),
              ),
              32.height,
              // Buttons
              appButton(
                  text: 'Create Your Business Today!',
                  onTap: (){
                    const GetStartedPage().launch(context);
                  },
                  context: context,
              ),
              16.height,
              Visibility(
                visible: false,
                child: outlineButton(
                    text: 'Join a Business',
                    onTap: (){
                    },
                    context: context,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
