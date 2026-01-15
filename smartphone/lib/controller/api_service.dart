import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartphone/model/smartphone_model.dart';

class ApiService {
  // Jika pakai Emulator Android, ganti localhost menjadi 10.0.2.2
  final String baseUrl = "http://localhost:8000/api/smartphones";
  final String apiBaseUrl = "http://localhost:8000/api";

  // Mengambil Data
  Future<List<Smartphone>> getSmartphones() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => Smartphone.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load data");
    }
  }

  // Menambah Data
  Future<void> addSmartphone(Smartphone smartphone) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(smartphone.toJson()),
    );
  }

  // Menghapus Data
  Future<void> deleteSmartphone(int id) async {
    await http.delete(Uri.parse("$baseUrl/$id"));
  }

  // Proses Perhitungan VIKOR (GET)
  Future<List<dynamic>> prosesVikor() async {
    final response = await http.get(Uri.parse("$apiBaseUrl/spk/vikor-proses"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Gagal memproses VIKOR");
    }
  }

  // Proses Perhitungan WP (POST)
  Future<List<dynamic>> prosesWP() async {
    final response = await http.post(
      Uri.parse("$apiBaseUrl/spk/wp-proses"),
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Gagal memproses WP");
    }
  }
}
