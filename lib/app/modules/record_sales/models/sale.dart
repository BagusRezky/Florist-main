class Sale {
  String productName;
  int quantity;
  double price;
  // DateTime timestamp;

  Sale({
    required this.productName,
    required this.quantity,
    required this.price,
    // required this.timestamp,
  });

  // Convert Sale object to a map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'quantity': quantity,
      'price': price,
      // 'timestamp': timestamp,
    };
  }
}
