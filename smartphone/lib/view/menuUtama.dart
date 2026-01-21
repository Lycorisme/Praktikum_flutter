import 'package:flutter/material.dart';
import 'package:smartphone/view/list_page.dart';
import 'package:smartphone/view/wp_page.dart';
import 'package:smartphone/view/vikor_page.dart';
import 'package:smartphone/view/vikor_proses_page.dart';
import 'package:smartphone/view/wp_proses_page.dart';
import 'package:smartphone/view/uji_page.dart';
import 'package:smartphone/view/vikor_chart_page.dart';
import 'package:smartphone/view/wp_chart_page.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SPK Smartphone"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEDE7F6), // Light purple
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Icon
                Icon(
                  Icons.phone_android,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Sistem Pendukung Keputusan",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Pemilihan Smartphone",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 40),

                // Tombol Kelola Data (CRUD) - White/Light button
                SizedBox(
                  width: 280,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SmartphoneListPage(),
                          ),
                        ),
                    icon: const Icon(Icons.edit_note, size: 20),
                    label: const Text(
                      "Kelola Data (CRUD)",
                      style: TextStyle(fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Tombol Hitung & Simpan VIKOR - Orange button
                SizedBox(
                  width: 280,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VikorProsesPage(),
                          ),
                        ),
                    icon: const Icon(Icons.play_arrow, size: 20),
                    label: const Text(
                      "Hitung & Simpan VIKOR",
                      style: TextStyle(fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Tombol Ranking Metode WP - Light blue button
                SizedBox(
                  width: 280,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RankingWPPage(),
                          ),
                        ),
                    icon: const Icon(Icons.bar_chart, size: 20),
                    label: const Text(
                      "Ranking Metode WP",
                      style: TextStyle(fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[50],
                      foregroundColor: Colors.blue[800],
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: Colors.blue.shade200),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Tombol Lihat Ranking VIKOR - Light button
                SizedBox(
                  width: 280,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RankingVikorPage(),
                          ),
                        ),
                    icon: const Icon(Icons.bar_chart, size: 20),
                    label: const Text(
                      "Lihat Ranking VIKOR",
                      style: TextStyle(fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[50],
                      foregroundColor: Colors.orange[800],
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: Colors.orange.shade200),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Tombol Hitung & Simpan WP - Blue button (at bottom)
                SizedBox(
                  width: 280,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WpProsesPage(),
                          ),
                        ),
                    icon: const Icon(Icons.flash_on, size: 20),
                    label: const Text(
                      "Hitung & Simpan WP",
                      style: TextStyle(fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Tombol Uji Validitas Spearman - Indigo button
                SizedBox(
                  width: 280,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const UjiPage()),
                        ),
                    icon: const Icon(Icons.analytics, size: 20),
                    label: const Text(
                      "Uji Validitas (Spearman)",
                      style: TextStyle(fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Tombol Grafik Hasil VIKOR - Teal button
                SizedBox(
                  width: 280,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VikorChartPage(),
                          ),
                        ),
                    icon: const Icon(Icons.bar_chart, size: 20),
                    label: const Text(
                      "Grafik Hasil VIKOR",
                      style: TextStyle(fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Tombol Grafik Hasil WP - Purple button
                SizedBox(
                  width: 280,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WpChartPage(),
                          ),
                        ),
                    icon: const Icon(Icons.bar_chart, size: 20),
                    label: const Text(
                      "Grafik Hasil WP",
                      style: TextStyle(fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
