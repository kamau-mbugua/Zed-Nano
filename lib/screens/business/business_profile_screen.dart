import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/models/get_business_info/BusinessInfoResponse.dart';
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/business/business_profile_page.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';

class BusinessProfileScreen extends StatefulWidget {
  
  const BusinessProfileScreen({
    super.key,
    this.businessId,
  });
  final String? businessId;

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
    final businessId = getBusinessDetails(context)?.businessId;

    final businessData = <String, dynamic>{
      'businessId':businessId,
    };
    await context
        .read<BusinessProviders>()
        .getBusinessInfo(requestData:businessData,context: context)
        .then((value) async {
      if (value.isSuccess) {
        final businessInfo = value.data?.data;
        setState(() {
          businessInfoData = businessInfo;
        });

      } else {
        showCustomToast(
            value.message ?? 'Something went wrong',);
      }
    });
  }

  Future<void> onRefreshRequest() async {
    await _fetchBusinessProfile();
  }
  @override
  Widget build(BuildContext context) {
    return BusinessProfilePage(businessData: businessInfoData ?? BusinessInfoData(), onRefreshRequest:onRefreshRequest);
  }
}
