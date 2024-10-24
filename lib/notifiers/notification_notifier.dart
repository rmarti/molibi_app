import 'package:flutter/material.dart';
import 'package:molibi_app/constants/notification_type.dart';

class NotificationNotifier extends ChangeNotifier {
  String? _message;
  String _type="info";

  String? get message => _message;
  String get type => _type;

  void showSuccessMessage({required String message}) {
    _message = message;
    _type =MessageType.success;
    notifyListeners();
  }
  
  void showErrorMessage({required String message}) {
    _message = message;
    _type = MessageType.error;
    notifyListeners();
  }
  
  void showInfoMessage({required String message}) {
    _message = message;
    _type = MessageType.info;
    notifyListeners();
  }

  void clearMessage() {
    _message = null;
  }
}
