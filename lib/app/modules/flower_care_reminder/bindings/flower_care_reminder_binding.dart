import 'package:get/get.dart';

import '../controllers/flower_care_reminder_controller.dart';

class FlowerCareReminderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FlowerCareReminderController>(
      () => FlowerCareReminderController(),
    );
  }
}
