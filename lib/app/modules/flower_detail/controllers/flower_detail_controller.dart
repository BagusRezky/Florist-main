import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../data/model/flower.dart';

class FlowerController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<Flower> flowers = <Flower>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getFlowers();
  }

  Future<void> getFlowers() async {
    try {
      isLoading.value = true;
      QuerySnapshot querySnapshot = await _firestore.collection('flowers').get();
      flowers.value = querySnapshot.docs
          .map((doc) => Flower.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching flowers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<int> getFlowerStock(String flowerId) async {
    DocumentSnapshot doc = await _firestore.collection('flowers').doc(flowerId).get();
    return doc['stock'] as int;
  }

  Future<void> updateFlowerStock(String flowerId, int newStock) async {
    await _firestore.collection('flowers').doc(flowerId).update({'stock': newStock});
    await getFlowers();
  }
}
