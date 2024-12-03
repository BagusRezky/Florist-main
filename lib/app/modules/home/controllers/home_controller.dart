import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:florist/app/data/model/flower.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var flowers = <Flower>[].obs;
  var isLoading = true.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchFlowers();
  }

  Future<void> fetchFlowers() async {
    try {
      isLoading.value = true;
      QuerySnapshot snapshot = await _firestore.collection('flowers').get();
      flowers.value =
          snapshot.docs.map((doc) => Flower.fromFirestore(doc)).toList();
    } catch (e) {
      print("Error fetching flowers: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh function for pull-to-refresh
  Future<void> refreshData() async {
    isLoading.value = true;
    await fetchFlowers();
    isLoading.value = false;
  }
}
