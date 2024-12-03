import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/record_sales_controller.dart';

class RecordSalesView extends GetView<RecordSalesController> {
  const RecordSalesView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RecordSalesController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Catat Penjualan',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: false,
        backgroundColor: Colors.green[400],
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSalesForm(),
            const SizedBox(height: 20),
            Expanded(child: _buildSalesList()),
            _buildTotalAmountSection(),
          ],
        ),
      ),
    );
  }

  // Sales entry form for inputting product details
  Widget _buildSalesForm() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.productNameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller.quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller.priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => controller.addSale(),
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                    child: Text(
                  "Tambahkan Penjualan",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }

  // List of recorded sales with dynamic updates
  // List of recorded sales with dynamic updates
Widget _buildSalesList() {
  return Obx(() {
    return ListView.builder(
      itemCount: controller.sales.length,
      itemBuilder: (context, index) {
        final sale = controller.sales[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Icon(Icons.shopping_bag, color: Colors.green[400]),
            title: Text(
              sale.productName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quantity: ${sale.quantity} • Price: Rp ${sale.price}'),
                // Text(
                //   'Added: ${DateFormat('dd MMM yyyy, HH:mm').format(sale.timestamp)}',
                //   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                // ),
              ],
            ),
            trailing: Text(
              'Rp ${(sale.quantity * sale.price).toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.green[700],
              ),
            ),
          ),
        );
      },
    );
  });
}


  // Total amount section at the bottom
  Widget _buildTotalAmountSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Obx(() {
            final totalAmount = controller.totalAmount;
            return Text(
              'Rp ${totalAmount.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            );
          }),
        ],
      ),
    );
  }
}
