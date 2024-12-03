import 'package:get/get.dart';

import '../controllers/sales_report_controller.dart';

class SalesReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalesReportController>(
      () => SalesReportController(),
    );
  }
}
