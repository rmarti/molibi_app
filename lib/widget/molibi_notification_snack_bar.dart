import 'package:flutter/material.dart';
import 'package:molibi_app/themes/theme_molibi.dart';
import 'package:provider/provider.dart';
import 'package:molibi_app/notifiers/notification_notifier.dart';
import 'package:molibi_app/constants/notification_type.dart';

class MolibiNotificationSnackBar extends StatelessWidget {
  const MolibiNotificationSnackBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationNotifier>(
      builder: (context, snackbarNotifier, child) {
        if (snackbarNotifier.message != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(snackbarNotifier.message!),
                behavior: SnackBarBehavior.floating, 
                margin: const EdgeInsets.all(15.0), 
                backgroundColor: _getBackgroundColor(snackbarNotifier.type) ,
              ),
            );
            snackbarNotifier.clearMessage(); 
          });
        }
        return Container();
      },
    );
  }

  Color _getBackgroundColor(String type) {
    switch (type) {
      case MessageType.error:
        return MolibiThemeData.molibierror;
      case MessageType.info:
        return MolibiThemeData.molibiinfo;
      default:
        return MolibiThemeData.molibisuccess;
    }
  }
}
