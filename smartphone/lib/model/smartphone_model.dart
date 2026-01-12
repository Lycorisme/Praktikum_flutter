class Smartphone {
  final int? id;
  final String namaHp;
  final double harga;
  final double ram;
  final double kamera;
  final double baterai;

  Smartphone({
    this.id,
    required this.namaHp,
    required this.harga,
    required this.ram,
    required this.kamera,
    required this.baterai,
  });

  // Untuk mengubah JSON dari API menjadi objek Flutter
  factory Smartphone.fromJson(Map<String, dynamic> json) {
    return Smartphone(
      id: json['id'],
      namaHp: json['nama_hp'],
      harga: json['harga'].toDouble(),
      ram: json['ram'].toDouble(),
      kamera: json['kamera'].toDouble(),
      baterai: json['baterai'].toDouble(),
    );
  }

  // Untuk mengubah objek Flutter menjadi JSON saat mengirim data ke API
  Map<String, dynamic> toJson() => {
        "nama_hp": namaHp,
        "harga": harga,
        "ram": ram,
        "kamera": kamera,
        "baterai": baterai,
      };
}
