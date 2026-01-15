import 'package:flutter/material.dart';
import 'package:smartphone/model/smartphone_model.dart';
import 'package:smartphone/controller/api_service.dart';
import 'package:smartphone/logic_spk.dart';

class RankingVikorPage extends StatelessWidget {
  const RankingVikorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ranking Metode VIKOR"),
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Smartphone>>(
        future: ApiService().getSmartphones(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.analytics_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "Tidak ada data untuk dihitung",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Perlu minimal 2 data untuk VIKOR
          if (snapshot.data!.length < 2) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning_amber, size: 64, color: Colors.orange),
                  SizedBox(height: 16),
                  Text(
                    "Diperlukan minimal 2 data\nuntuk perhitungan VIKOR",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Hitung ranking dengan metode VIKOR
          final rankedData = LogicSPK.hitungVikor(snapshot.data!);

          return ListView.builder(
            itemCount: rankedData.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              final hp = rankedData[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getRankColor(index),
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    hp.namaHp,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Harga: Rp ${hp.harga.toStringAsFixed(0)}"),
                      Text("Baterai: ${hp.baterai} mAh"),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Nilai Q",
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Text(
                        hp.skor?.toStringAsFixed(4) ?? "0",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Warna medali untuk 3 besar
  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber; // Emas
      case 1:
        return Colors.grey; // Perak
      case 2:
        return Colors.brown; // Perunggu
      default:
        return Colors.deepOrange;
    }
  }
}
