import 'package:flutter/material.dart';
import 'package:smartphone/controller/api_service.dart';
import 'package:smartphone/model/smartphone_model.dart';
import 'package:smartphone/view/form_page.dart';

class SmartphoneListPage extends StatefulWidget {
  const SmartphoneListPage({super.key});

  @override
  State<SmartphoneListPage> createState() => _SmartphoneListPageState();
}

class _SmartphoneListPageState extends State<SmartphoneListPage> {
  final ApiService apiService = ApiService();
  late Future<List<Smartphone>> _smartphonesFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _smartphonesFuture = apiService.getSmartphones();
    });
  }

  void _deleteSmartphone(int id) async {
    await apiService.deleteSmartphone(id);
    _refreshData(); // Refresh list setelah hapus
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Smartphone"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<List<Smartphone>>(
        future: _smartphonesFuture,
        builder: (context, snapshot) {
          // Tampilkan loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Tampilkan error jika ada
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text("Error: ${snapshot.error}"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshData,
                    child: const Text("Coba Lagi"),
                  ),
                ],
              ),
            );
          }

          // Tampilkan pesan jika data kosong
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone_android, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "Belum ada data smartphone",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Tampilkan daftar smartphone
          List<Smartphone> smartphones = snapshot.data!;
          return ListView.builder(
            itemCount: smartphones.length,
            itemBuilder: (context, index) {
              Smartphone hp = smartphones[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.phone_android)),
                  title: Text(
                    hp.namaHp,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Harga: Rp ${hp.harga.toStringAsFixed(0)}"),
                      Text("RAM: ${hp.ram} GB | Kamera: ${hp.kamera} MP"),
                      Text("Baterai: ${hp.baterai} mAh"),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tombol Edit
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      SmartphoneFormPage(smartphone: hp),
                            ),
                          ).then(
                            (value) => _refreshData(),
                          ); // Refresh saat kembali
                        },
                      ),
                      // Tombol Hapus
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Konfirmasi sebelum hapus
                          showDialog(
                            context: context,
                            builder:
                                (ctx) => AlertDialog(
                                  title: const Text("Hapus Data"),
                                  content: Text(
                                    "Apakah Anda yakin ingin menghapus ${hp.namaHp}?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text("Batal"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        _deleteSmartphone(hp.id!);
                                      },
                                      child: const Text(
                                        "Hapus",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigasi ke halaman form dan refresh setelah kembali
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SmartphoneFormPage()),
          );
          _refreshData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
