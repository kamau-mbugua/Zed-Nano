import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/screens/users/add_user_page.dart';
import 'package:zed_nano/screens/users/tabs/activ_user_list_page.dart';
import 'package:zed_nano/screens/users/tabs/pending_user_list_page.dart';
import 'package:zed_nano/screens/users/tabs/suspended_users_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/custom_tab_switcher.dart';
import 'package:zed_nano/utils/Colors.dart';

class UsersMainList extends StatefulWidget {
  const UsersMainList({super.key});

  @override
  _UsersMainListState createState() => _UsersMainListState();
}

class _UsersMainListState extends State<UsersMainList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AuthAppBar(
          title: 'Users',
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Expanded(
            child: SwipeableTabSwitcher(
              tabs: const ['Active', 'Pending', 'Suspended'],
              selectedTabColors: const [
                successTextColor,      // Active tab color
                primaryOrangeTextColor,     // Pending tab color
                colorBackground,        // Suspended tab color
              ],
              selectedTextColors: const [
                Colors.white,      // Active text color
                Colors.white,      // Pending text color
                textPrimary,      // Suspended text color
              ],
              selectedBorderColors: const [
                successTextColor,      // Active border color
                primaryOrangeTextColor,     // Pending border color
                colorBackground,        // Suspended border color
              ],
              children: const [
                ActiveUserListPage(),
                PendingUserListPage(),
                SuspendedUsersPage(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          const AddUserPage().launch(context);
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
