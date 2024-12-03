import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:florist/app/data/model/report.dart';
import 'package:get/get.dart';

class SalesReportController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final reports = <Report>[].obs;

  get fetchSalesReport => null;

  @override
  void onInit() {
    super.onInit();
    fetchSalesReports();
  }

  void fetchSalesReports() async {
    try {
      final querySnapshot = await _firestore.collection('sales').get();
      reports.value = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Report(
          name: data['productName'],
          // date: (data['timestamp'] as Timestamp).toDate(),
          amount: data['quantity'],
          description: '', status: 
          data['status'] ?? 'berhasil',
          // price: data['price'] ?? 30000, 

        );
      }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load sales reports');
    }
  }
}
