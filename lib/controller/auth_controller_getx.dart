import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final user = Rxn<User>();

  @override
  void onReady() {
    super.onReady();
    user.bindStream(FirebaseAuth.instance.authStateChanges());
    update();
  }
}
