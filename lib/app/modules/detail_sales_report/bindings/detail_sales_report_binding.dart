import 'package:get/get.dart';

import '../controllers/detail_sales_report_controller.dart';

class DetailSalesReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailSalesReportController>(
      () => DetailSalesReportController(),
    );
  }
}
