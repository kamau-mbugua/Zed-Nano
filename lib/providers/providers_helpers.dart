import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/providers/authenticated_app_providers.dart';

AuthenticatedAppProviders getAuthProvider(BuildContext context) {
  return Provider.of<AuthenticatedAppProviders>(context, listen: false);
}