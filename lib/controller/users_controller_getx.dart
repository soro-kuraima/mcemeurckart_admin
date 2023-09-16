import 'package:get/get.dart';
import 'package:mcemeurckart_admin/util/firestore_helper.dart';

class UsersController extends GetxController {
  var users = [].obs;
  var user = {}.obs;

  @override
  void onInit() {
    super.onInit();
    users.bindStream(FireBaseStoreHelper.getUsers());
    update();
  }

  @override
  void onReady() {
    super.onReady();
    update();
  }

  Future<void> setCurrentUser(String email) async {
    user.clear();
    user.value = {...await FireBaseStoreHelper.getUser(email)};
  }
}
