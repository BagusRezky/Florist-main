import 'package:get/get.dart';

import '../controllers/flower_detail_controller.dart';

class FlowerDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FlowerController>(
      () => FlowerController(),
    );
  }
}
