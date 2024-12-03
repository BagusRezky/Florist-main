import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserModel {
  final String name;
  final String email;
  final String? photoUrl;

  UserModel({
    required this.name,
    required this.email,
    this.photoUrl,
  });

  factory UserModel.fromFirebase(User firebaseUser) {
    return UserModel(
      name: firebaseUser.displayName ?? 'User',
      email: firebaseUser.email ?? '',
      photoUrl: firebaseUser.photoURL,
    );
  }
}

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //TODO: Implement ProfileController
  final Rx<UserModel> currentUser = UserModel(
    name: 'User',
    email: '',
    photoUrl: null,
  ).obs;

  final isDarkMode = false.obs;
  final adminName = ''.obs;
  var profileImageUrl = ''.obs;
  final profileImage = Rx<File?>(null);
  final totalOrders = 0;
  final activeOrders = 0;
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData() {
    final User? user = _auth.currentUser;
    if (user != null) {
      currentUser.value = UserModel.fromFirebase(user);
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void setUserData(String name, String imageUrl) {
    adminName.value = name;
    profileImageUrl.value = imageUrl;
  }

  Future<void> updateProfileImage() async {
    try {} catch (e) {
      print('Error updating profile image: $e');
    }
  }

  void logout() {
    Get.offNamed('/login');
    // Implement logout logic
  }
}
