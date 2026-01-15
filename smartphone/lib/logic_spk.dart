import 'dart:math';
import 'package:smartphone/model/smartphone_model.dart';

class LogicSPK {
  // LOGIKA WEIGHTED PRODUCT (WP)
  static List<Smartphone> hitungWP(List<Smartphone> data) {
    if (data.isEmpty) return [];

    // Bobot: Harga(-), Ram(+), Kamera(+), Baterai(+)
    final w = {'harga': -0.4, 'ram': 0.25, 'kamera': 0.2, 'baterai': 0.15};
    List<double> lists = [];
    double totals = 0;

    for (var hp in data) {
      // Perhitungan Pangkat (Vektor S)
      double s =
          (pow(hp.harga, w['harga']!) *
                  pow(hp.ram, w['ram']!) *
                  pow(hp.kamera, w['kamera']!) *
                  pow(hp.baterai, w['baterai']!))
              .toDouble();
      lists.add(s);
      totals += s;
    }

    // Perhitungan Vektor V
    for (int i = 0; i < data.length; i++) {
      data[i].skor = lists[i] / totals;
    }

    // Urutkan dari skor terbesar (descending)
    data.sort((a, b) => (b.skor ?? 0).compareTo(a.skor ?? 0));
    return data;
  }

  // LOGIKA VIKOR
  static List<Smartphone> hitungVikor(List<Smartphone> data) {
    if (data.length < 2) return data;

    final w = [0.4, 0.25, 0.2, 0.15]; // Bobot kriteria

    // Mencari nilai min dan max tiap kriteria
    // Harga = Cost (semakin rendah semakin baik)
    double fStarHarga = data.map((e) => e.harga).reduce(min);
    double fMinHarga = data.map((e) => e.harga).reduce(max);

    // RAM = Benefit (semakin tinggi semakin baik)
    double fStarRam = data.map((e) => e.ram).reduce(max);
    double fMinRam = data.map((e) => e.ram).reduce(min);

    // Kamera = Benefit
    double fStarKamera = data.map((e) => e.kamera).reduce(max);
    double fMinKamera = data.map((e) => e.kamera).reduce(min);

    // Baterai = Benefit
    double fStarBaterai = data.map((e) => e.baterai).reduce(max);
    double fMinBaterai = data.map((e) => e.baterai).reduce(min);

    List<double> listS = []; // Menyimpan nilai S
    List<double> listR = []; // Menyimpan nilai R

    for (var hp in data) {
      // Normalisasi VIKOR
      double sHarga =
          w[0] *
          (fStarHarga - hp.harga).abs() /
          (fStarHarga - fMinHarga == 0 ? 1 : (fStarHarga - fMinHarga).abs());
      double sRam =
          w[1] *
          (fStarRam - hp.ram).abs() /
          (fStarRam - fMinRam == 0 ? 1 : (fStarRam - fMinRam).abs());
      double sKamera =
          w[2] *
          (fStarKamera - hp.kamera).abs() /
          (fStarKamera - fMinKamera == 0
              ? 1
              : (fStarKamera - fMinKamera).abs());
      double sBaterai =
          w[3] *
          (fStarBaterai - hp.baterai).abs() /
          (fStarBaterai - fMinBaterai == 0
              ? 1
              : (fStarBaterai - fMinBaterai).abs());

      double sTotal = (sHarga + sRam + sKamera + sBaterai).abs();
      double rMax = [
        sHarga.abs(),
        sRam.abs(),
        sKamera.abs(),
        sBaterai.abs(),
      ].reduce(max);

      listS.add(sTotal);
      listR.add(rMax);
    }

    double sStar = listS.reduce(min);
    double sMin = listS.reduce(max);
    double rStar = listR.reduce(min);
    double rMin = listR.reduce(max);

    // Menghitung Nilai Indeks Q
    for (int i = 0; i < data.length; i++) {
      double q =
          0.5 * (listS[i] - sStar) / (sMin - sStar == 0 ? 1 : sMin - sStar) +
          0.5 * (listR[i] - rStar) / (rMin - rStar == 0 ? 1 : rMin - rStar);
      data[i].skor = q;
    }

    // Urutkan ascending (nilai Q terkecil = rank terbaik)
    data.sort((a, b) => (a.skor ?? 0).compareTo(b.skor ?? 0));
    return data;
  }
}
