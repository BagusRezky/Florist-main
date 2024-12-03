import 'package:firebase_auth/firebase_auth.dart';
import 'package:florist/app/data/service/signup_service.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  Future<bool> login(String email, String password) async {
    try {
      // Attempt Firebase login
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      print("Firebase Login Failed: ${e.message}");
      SignupService service = SignupService();
      // Fallback to SQLite login
      String? localResult = await service.loginUser(email, password);
      if (localResult == "Login Successful") {
        return true;
      } else {
        return false; // Error message from local login
      }
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
}
