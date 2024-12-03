import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:florist/app/modules/record_sales/controllers/db_helper.dart';
import 'package:florist/app/modules/record_sales/models/sale.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class Sale {
//   String productName;
//   int quantity;
//   double price;
//   final DateTime timestamp;

//   Sale({required this.productName, required this.quantity, required this.price, required this.timestamp,});
// }

class RecordSalesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController productNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  var totalAmount = 0.0.obs;
  var sales = <Sale>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSales();
  }

  Future<void> _loadSales() async {
    final localSales = await DBHelper.getSales();
    sales.addAll(localSales);
    totalAmount.value = sales.fold(
      0.0,
      (sum, item) => sum + (item.quantity * item.price),
    );
  }

  // Fungsi untuk mengambil stok dari Firebase berdasarkan nama produk
  Future<int> getFlowerStock(String flowerName) async {
    final snapshot = await _firestore
        .collection('flowers')
        .where('name', isEqualTo: flowerName)
        .get();
    
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first['stock'];
    }
    return 0;
  }

  // Fungsi untuk memperbarui stok di Firebase
  Future<void> updateFlowerStock(String flowerName, int quantitySold) async {
    final snapshot = await _firestore
        .collection('flowers')
        .where('name', isEqualTo: flowerName)
        .get();
    
    if (snapshot.docs.isNotEmpty) {
      final docRef = snapshot.docs.first.reference;
      final currentStock = snapshot.docs.first['stock'];
      final newStock = currentStock - quantitySold;

      await docRef.update({'stock': newStock});
    }
  }

  // Fungsi untuk menambahkan penjualan dan mengupdate stok di Firebase
  void addSale() async {
    final productName = productNameController.text;
    final quantity = int.tryParse(quantityController.text) ?? 0;
    final price = double.tryParse(priceController.text) ?? 0.0;

    if (productName.isNotEmpty && quantity > 0 && price > 0) {
      final newSale = Sale(
        productName: productName,
        quantity: quantity,
        price: price,
      );
      sales.add(newSale);
      totalAmount.value += newSale.quantity * newSale.price;

      await DBHelper.insertSale(newSale);
      await _firestore.collection('sales').add({
        'productName': newSale.productName,
        'quantity': newSale.quantity,
        'price': newSale.price,
      });

      // Update stok jika bunga tersedia
      await updateFlowerStock(productName, quantity);

      // Clear input fields
      productNameController.clear();
      quantityController.clear();
      priceController.clear();
    }
  }

  void clearFields() {
    productNameController.clear();
    quantityController.clear();
    priceController.clear();
  }
}
