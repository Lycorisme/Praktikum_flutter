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
  String? _error;

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
      setState(() {
        _error = e.toString();
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Proses Perhitungan VIKOR"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF3E0), // Light orange
              Colors.white,
            ],
          ),
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_isProcessing) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.orange),
            SizedBox(height: 20),
            Text(
              "Memproses perhitungan VIKOR...",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              "Error: $_error",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isProcessing = true;
                  _error = null;
                });
                _eksekusiVikor();
              },
              icon: const Icon(Icons.refresh),
              label: const Text("Coba Lagi"),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header Info
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: Column(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 40),
              const SizedBox(height: 8),
              const Text(
                "Perhitungan VIKOR Selesai!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Hasil telah disimpan ke database",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        // List Hasil
        Expanded(
          child: ListView.builder(
            itemCount: _dataHasil.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final item = _dataHasil[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: _getRankColor(item['ranking']),
                    child: Text(
                      "${item['ranking']}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  title: Text(
                    item['nama'] ?? 'Unknown',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _buildValueRow(
                        "Nilai S",
                        item['s']?.toStringAsFixed(4) ?? '-',
                      ),
                      _buildValueRow(
                        "Nilai R",
                        item['r']?.toStringAsFixed(4) ?? '-',
                      ),
                      _buildValueRow(
                        "Nilai Q",
                        item['q']?.toStringAsFixed(4) ?? '-',
                        isHighlight: true,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildValueRow(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              color: isHighlight ? Colors.orange[800] : Colors.black87,
              fontSize: isHighlight ? 14 : 13,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int? rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return Colors.orange;
    }
  }
}
