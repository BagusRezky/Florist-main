import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for utf8.encode

class SignupService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> signupUser(String email, String password, String name) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String uid = userCredential.user?.uid ?? '';
      await _saveUserToSQLite(uid, name, email, password);
      return "Signup Successful";
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message;
    }
  }

  Future<void> _saveUserToSQLite(
      String uid, String name, String email, String password) async {
    final Database db = await _getDatabase();
    String hashedPassword = _hashPassword(password);
    await db.insert(
      'users',
      {'id': uid, 'name': name, 'email': email, 'password': hashedPassword},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Database> _getDatabase() async {
    final String dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'app_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users (id TEXT PRIMARY KEY, name TEXT, email TEXT, password TEXT)',
        );
      },
      version: 2,
    );
  }

  Future<String?> loginUser(String email, String password) async {
    try {
      final Database db = await _getDatabase();
      String hashedPassword = _hashPassword(password);
      List<Map<String, dynamic>> result = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, hashedPassword],
      );

      if (result.isNotEmpty) {
        return "Login Successful";
      } else {
        return "Invalid email or password";
      }
    } catch (e) {
      print(e);
      return "An error occurred during login";
    }
  }

  String _hashPassword(String password) {
    // Use SHA-256 hashing algorithm to hash the password
    final bytes = utf8.encode(password); // Convert password to bytes
    final digest = sha256.convert(bytes); // Hash the bytes
    return digest.toString(); // Convert to a hexadecimal string
  }
}
