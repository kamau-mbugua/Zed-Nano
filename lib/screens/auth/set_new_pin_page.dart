import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';

class SetNewPinPage extends StatefulWidget {
  const SetNewPinPage({Key? key}) : super(key: key);

  @override
  _SetNewPinPageState createState() => _SetNewPinPageState();
}

class _SetNewPinPageState extends State<SetNewPinPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(
        title: 'Set Pin',
      ),
      body: SingleChildScrollView(
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.height,
            Text('Enter a New PIN', style: boldTextStyle(size: 24,
              fontFamily: "Poppins",
            )).paddingSymmetric(horizontal: 16),
            8.height,
            Text("Secure your account with a new PIN.",
                style: secondaryTextStyle(size: 12,
                    weight: FontWeight.w500,
                    color: getBodyColor(),
                    fontFamily: "Poppins")
            ).paddingSymmetric(horizontal: 16),
            16.height,
            Text("New Pin.",
                style: secondaryTextStyle(size: 12,
                    weight: FontWeight.w600,
                    color: textPrimary,
                    fontFamily: "Poppins")
            ).paddingSymmetric(horizontal: 16),
            8.height,
            const  Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: StyledTextField(
                textFieldType: TextFieldType.PASSWORD,
                hintText: "Pin",
              ),
            ),
            16.height,
            Text("Confirm New PIN.",
                style: secondaryTextStyle(size: 12,
                    weight: FontWeight.w600,
                    color: textPrimary,
                    fontFamily: "Poppins")
            ).paddingSymmetric(horizontal: 16),
            8.height,
            const  Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: StyledTextField(
                textFieldType: TextFieldType.PASSWORD,
                hintText: "Pin",
              ),
            ),
            16.height,
            appButton(text: "Set Pin",
                onTap: (){
                },
                context: context).paddingSymmetric(horizontal: 16),
            16.height,

          ],
        )
      ),
    );
  }
}
