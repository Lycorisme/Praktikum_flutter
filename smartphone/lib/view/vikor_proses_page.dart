import 'package:flutter/material.dart';
import 'package:smartphone/controller/api_service.dart';

class VikorProsesPage extends StatefulWidget {
  const VikorProsesPage({super.key});

  @override
  State<VikorProsesPage> createState() => _VikorProsesPageState();
}

class _VikorProsesPageState extends State<VikorProsesPage> {
  bool _isProcessing = true;
  List<dynamic> _dataHasil = [];

  @override
  void initState() {
    super.initState();
    _eksekusiVikor();
  }

  void _eksekusiVikor() async {
    try {
      final hasil = await ApiService().prosesVikor();
      setState(() {
        _dataHasil = hasil;
        _isProcessing = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Proses Perhitungan VIKOR")),
      body:
          _isProcessing
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _dataHasil.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final item = _dataHasil[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.brown,
                        child: Text(
                          "${item['ranking']}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(item['nama']),
                      subtitle: Text(
                        "S: ${item['s'].toStringAsFixed(3)} | R: ${item['r'].toStringAsFixed(3)}",
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Q:", style: TextStyle(fontSize: 10)),
                          Text(
                            item['q'].toStringAsFixed(4),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
