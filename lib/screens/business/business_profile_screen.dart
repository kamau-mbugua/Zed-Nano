import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/models/get_business_info/BusinessInfoResponse.dart';
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'business_profile_page.dart';

class BusinessProfileScreen extends StatefulWidget {
  final String? businessId;
  
  const BusinessProfileScreen({
    Key? key,
    this.businessId,
  }) : super(key: key);

  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  BusinessInfoData? businessInfoData;

  @override
  void initState() {
    super.initState();
    _fetchBusinessProfile();
  }
  
  Future<void> _fetchBusinessProfile() async {
    var businessId = getBusinessDetails(context)?.businessId;

    Map<String, dynamic> businessData = {
      'businessId':businessId
    };
    await context
        .read<BusinessProviders>()
        .getBusinessInfo(requestData:businessData,context: context)
        .then((value) async {
      if (value.isSuccess) {
        var businessInfo = value.data?.data;
        setState(() {
          businessInfoData = businessInfo;
        });

      } else {
        showCustomToast(
            value.message ?? 'Something went wrong');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          await _fetchBusinessProfile();
        },
        child: BusinessProfilePage(businessData: businessInfoData ?? BusinessInfoData()));
  }
}
