import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:itu_cartrack/src/model/user.dart';

class LoginController {
  // Private constructor for the Singleton pattern
  User? currentUser;  // Global variable to store the current user
  LoginController._private();

  static final LoginController _instance = LoginController._private();

  factory LoginController() {
    return _instance;
  }

  void handleLoginPressed(BuildContext context, User? selectedUser) {
    currentUser = selectedUser;  // Storing the current user in the global variable

    Navigator.pop(context);
    log("Current Logged User: ${currentUser?.name ?? 'Unknown'}");
  }

  User? getCurrentUser() {
    return currentUser;
  }

  String getCurrentUserId() {
    return currentUser!.id;
  }
}
