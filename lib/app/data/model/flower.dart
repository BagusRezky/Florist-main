import 'package:cloud_firestore/cloud_firestore.dart';

class Flower {
  final String id;
  final String name;
  final String description;
  final String image;
  final dynamic price;
  final dynamic stock;

  Flower({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.stock,
  });

  factory Flower.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Flower(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      price: data['price'] ?? 0,
      stock: data['stock'] ?? 0,
    );
  }
}




// List<Flower> flowers = [
//   Flower(
//     name: 'Mawar',
//     image: 'lib/app/data/assets/images/mawar.jpg',
//     description: 'Bunga yang indah dan harum, sering melambangkan cinta dan romansa.',
//     stock: 15,
//     price: 30000, id: ''
//   ),
//   Flower(
//     name: 'Tulip',
//     image: 'lib/app/data/assets/images/tulip.jpg',
//     description: 'Bunga yang cerah dengan banyak warna, populer di musim semi.',
//     stock: 20,
//      price: 30000, id: ''
//   ),
//   Flower(
//     name: 'Bunga Matahari',
//     image: 'lib/app/data/assets/images/matahari.jpg',
//     description: 'Bunga besar dan ceria yang mengikuti arah matahari.',
//     stock: 10,
//      price: 30000, id: ''
//   ),
//   Flower(
//     name: 'Anggrek',
//     image: 'lib/app/data/assets/images/anggrek.jpg',
//     description: 'Bunga elegan dengan pola kelopak yang unik, melambangkan keindahan eksotis.',
//     stock: 8,
//      price: 30000, id: ''
//   ),
//   Flower(
//     name: 'Lili',
//     image: 'lib/app/data/assets/images/lili.jpg',
//     description: 'Bunga anggun dengan aroma yang kuat, sering dikaitkan dengan kemurnian.',
//     stock: 12,
//      price: 30000, id: ''
//   ),
//   Flower(
//     name: 'Aster',
//     image: 'lib/app/data/assets/images/aster.jpg',
//     description: 'Bunga sederhana namun menawan dengan kelopak putih dan pusat kuning.',
//     stock: 25,
//      price: 30000, id: ''
//   ),
// ];
