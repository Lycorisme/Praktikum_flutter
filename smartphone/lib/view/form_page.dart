import 'package:flutter/material.dart';
import 'package:smartphone/model/smartphone_model.dart';
import 'package:smartphone/controller/api_service.dart';

class SmartphoneFormPage extends StatefulWidget {
  final Smartphone? smartphone; // Digunakan jika ingin fitur edit
  const SmartphoneFormPage({super.key, this.smartphone});

  @override
  State<SmartphoneFormPage> createState() => _SmartphoneFormPageState();
}

class _SmartphoneFormPageState extends State<SmartphoneFormPage> {
  final _formKey = GlobalKey<FormState>(); // Kunci validasi form
  final ApiService apiService = ApiService();

  // Controller untuk menangkap input teks
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _ramController = TextEditingController();
  final _kameraController = TextEditingController();
  final _bateraiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Jika ada data smartphone (mode edit), isi controller dengan data lama
    if (widget.smartphone != null) {
      _namaController.text = widget.smartphone!.namaHp;
      _hargaController.text = widget.smartphone!.harga.toString();
      _ramController.text = widget.smartphone!.ram.toString();
      _kameraController.text = widget.smartphone!.kamera.toString();
      _bateraiController.text = widget.smartphone!.baterai.toString();
    }
  }

  @override
  void dispose() {
    // Bersihkan controller saat widget di-dispose
    _namaController.dispose();
    _hargaController.dispose();
    _ramController.dispose();
    _kameraController.dispose();
    _bateraiController.dispose();
    super.dispose();
  }

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      // Membuat objek smartphone dari input user
      Smartphone hp = Smartphone(
        id: widget.smartphone?.id, // Penting untuk mode edit
        namaHp: _namaController.text,
        harga: double.parse(_hargaController.text),
        ram: double.parse(_ramController.text),
        kamera: double.parse(_kameraController.text),
        baterai: double.parse(_bateraiController.text),
      );

      // Kirim data ke API Laravel
      if (widget.smartphone == null) {
        // Mode Tambah
        await apiService.addSmartphone(hp);
      } else {
        // Mode Edit - untuk saat ini masih pakai add sesuai modul
        await apiService.addSmartphone(hp);
      }

      if (!mounted) return;

      // Tampilkan snackbar sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.smartphone == null
                ? "Data berhasil ditambahkan!"
                : "Data berhasil diubah!",
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context); // Kembali ke halaman daftar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.smartphone == null ? "Tambah Smartphone" : "Ubah Smartphone",
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: "Nama Smartphone",
                  prefixIcon: Icon(Icons.phone_android),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Harus diisi" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hargaController,
                decoration: const InputDecoration(
                  labelText: "Harga (Contoh: 3500000)",
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Harus diisi" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ramController,
                decoration: const InputDecoration(
                  labelText: "RAM (GB)",
                  prefixIcon: Icon(Icons.memory),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Harus diisi" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kameraController,
                decoration: const InputDecoration(
                  labelText: "Kamera (MP)",
                  prefixIcon: Icon(Icons.camera_alt),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Harus diisi" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bateraiController,
                decoration: const InputDecoration(
                  labelText: "Baterai (mAh)",
                  prefixIcon: Icon(Icons.battery_full),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Harus diisi" : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _submitData,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "Simpan Data",
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
