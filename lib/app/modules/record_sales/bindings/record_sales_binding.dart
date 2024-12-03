import 'package:get/get.dart';

import '../controllers/record_sales_controller.dart';

class RecordSalesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecordSalesController>(
      () => RecordSalesController(),
    );
  }
}
