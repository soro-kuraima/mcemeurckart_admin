import 'package:get/get.dart';
import 'package:mcemeurckart_admin/util/firestore_helper.dart';

class GenericsController extends GetxController {
  RxList<dynamic> generics = [].obs;

  @override
  void onInit() {
    super.onInit();
    generics.bindStream(FireBaseStoreHelper.getGenerics());
  }
}
