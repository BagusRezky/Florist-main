import 'package:firebase_auth/firebase_auth.dart';
import 'package:florist/app/data/service/signup_service.dart';
import 'package:florist/app/modules/login/controllers/login_controller.dart';
import 'package:florist/app/modules/navigation_bar/views/navigation_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

const users = {
  'surya@gmail.com': '12345',
  'rezky@gmail.com': 'hunter',
};

class LoginView extends StatelessWidget {
  LoginView({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  LoginController _loginController = Get.find<LoginController>();

  Future<String?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return 'Sign in aborted';
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Now we have access to the user data
      final User? user = userCredential.user;
      if (user != null) {
        // You can store additional user data in your database here if needed
        return null;
      }
      return 'Failed to get user data';
    } catch (e) {
      return 'Error occurred during Google Sign-In: $e';
    }
  }

  Future<String?> _authUser(LoginData data) async {
    print("login sini");
    debugPrint('Name: ${data.name}, Password: ${data.password}');

    var isLogin = await _loginController.login(data.name, data.password);

    return Future.delayed(loginTime).then((_) {
      if (isLogin) {
        return null;
      } else {
        return "Ops gagal login harap check email atau password anda";
      }
    });
  }

  Future<String?> _signupUser(SignupData data) async {
    try {
      SignupService service = SignupService();
      var response =
          await service.signupUser(data.name!, data.password!, data.name!);
      print(response);
      return null;
    } catch (e) {
      return "Gagal registrasi terjadi kesalahaan";
    }
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return "null";
    });
  }

  @override
  Widget build(BuildContext context) {
    final LoginController _loginController = Get.find<LoginController>();

    return FlutterLogin(
      theme: LoginTheme(
        primaryColor: const Color.fromARGB(255, 87, 218, 91),
        accentColor: Colors.yellow,
        errorColor: Colors.deepOrange,
        titleStyle: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            letterSpacing: 4,
            fontWeight: FontWeight.bold),
        bodyStyle: const TextStyle(
          fontStyle: FontStyle.italic,
          decoration: TextDecoration.underline,
        ),
        textFieldStyle: const TextStyle(
          color: Colors.green,
          shadows: [Shadow(color: Colors.green, blurRadius: 2)],
        ),
        buttonStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
      title: 'Florist',
      logo: const AssetImage('lib/app/data/assets/icons/plant.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      loginProviders: <LoginProvider>[
        LoginProvider(
            icon: FontAwesomeIcons.google,
            label: 'Google',
            callback: _signInWithGoogle),
        LoginProvider(
          icon: FontAwesomeIcons.facebookF,
          label: 'Facebook',
          callback: () async {
            debugPrint('start facebook sign in');
            await Future.delayed(loginTime);
            debugPrint('stop facebook sign in');
            return null;
          },
        ),
      ],
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const NavigationBarView(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
