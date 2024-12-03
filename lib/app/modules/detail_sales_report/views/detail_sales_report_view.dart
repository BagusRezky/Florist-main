import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_sales_report_controller.dart';

class DetailSalesReportView extends GetView<DetailSalesReportController> {
  const DetailSalesReportView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailSalesReportView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DetailSalesReportView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
