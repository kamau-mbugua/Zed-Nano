import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/screens/customers/add_customer/add_customers.dart';
import 'package:zed_nano/screens/users/add_user_page.dart';
import 'package:zed_nano/screens/users/tabs/activ_user_list_page.dart';
import 'package:zed_nano/screens/users/tabs/pending_user_list_page.dart';
import 'package:zed_nano/screens/users/tabs/suspended_users_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/custom_tab_switcher.dart';
import 'package:zed_nano/utils/Colors.dart';

class UsersMainList extends StatefulWidget {
  const UsersMainList({Key? key}) : super(key: key);

  @override
  _UsersMainListState createState() => _UsersMainListState();
}

class _UsersMainListState extends State<UsersMainList> {
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(
          title: 'Users'
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          // Tabs
          CustomTabSwitcher(
            tabs: const ['Active', 'Pending', 'Suspended'],
            selectedIndex: selectedTab,
            onTabSelected: (index) => setState(() => selectedTab = index),
            selectedTabColors: const [
              successTextColor,      // Approved tab color
              primaryOrangeTextColor,     // Pending tab color
              colorBackground,        // Rejected tab color
            ],
            selectedTextColors: const [
              Colors.white,      // Approved text color
              Colors.white,      // Pending text color
              textPrimary,      // Rejected text color
            ],
            selectedBorderColors: const [
              successTextColor,      // Approved border color
              primaryOrangeTextColor,     // Pending border color
              colorBackground,        // Rejected border color
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: selectedTab == 0
                ? const ActiveUserListPage()
                : selectedTab == 1
                ? const PendingUserListPage()
                : const SuspendedUsersPage(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          AddUserPage().launch(context);
        },
        backgroundColor: const Color(0xFF032541),
        icon: const Icon(Icons.add, size: 20, color: Colors.white),
        label: const Text(
          'Add',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
