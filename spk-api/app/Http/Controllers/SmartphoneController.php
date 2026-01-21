<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Smartphone;
use App\Models\vikor_results;
use App\Models\wp_results;

class SmartphoneController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return response()->json(Smartphone::all());
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'nama_hp' => 'required|string|max:255',
            'harga' => 'required|numeric|min:0',
            'ram' => 'required|numeric|min:0',
            'kamera' => 'required|numeric|min:0',
            'baterai' => 'required|numeric|min:0',
        ]);

        $smartphone = Smartphone::create($validated);
        return response()->json($smartphone, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $smartphone = Smartphone::find($id);
        if (!$smartphone) {
            return response()->json(['message' => 'Smartphone not found'], 404);
        }
        return response()->json($smartphone);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $smartphone = Smartphone::find($id);
        if (!$smartphone) {
            return response()->json(['message' => 'Smartphone not found'], 404);
        }

        $validated = $request->validate([
            'nama_hp' => 'sometimes|required|string|max:255',
            'harga' => 'sometimes|required|numeric|min:0',
            'ram' => 'sometimes|required|numeric|min:0',
            'kamera' => 'sometimes|required|numeric|min:0',
            'baterai' => 'sometimes|required|numeric|min:0',
        ]);

        $smartphone->update($validated);
        return response()->json($smartphone);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $smartphone = Smartphone::find($id);
        if (!$smartphone) {
            return response()->json(['message' => 'Smartphone not found'], 404);
        }
        $smartphone->delete();
        return response()->json(['message' => 'Smartphone deleted']);
    }

    /**
     * Hitung dan Simpan Hasil VIKOR
     * Metode VIKOR: Menghitung Nilai S (Utility), R (Regret), dan Q (Index)
     */
    public function hitungDanSimpanVikor()
    {
        $data = Smartphone::all();
        if ($data->isEmpty()) {
            return response()->json(['message' => 'Data kosong'], 404);
        }

        $w = [0.4, 0.25, 0.2, 0.15]; // Bobot: Harga, RAM, Kamera, Baterai

        // 1. Cari f* (Terbaik) dan f- (Terburuk)
        $fStar = [
            'harga' => $data->min('harga'),    // Cost: min adalah terbaik
            'ram' => $data->max('ram'),         // Benefit: max adalah terbaik
            'kamera' => $data->max('kamera'),   // Benefit: max adalah terbaik
            'baterai' => $data->max('baterai')  // Benefit: max adalah terbaik
        ];
        $fMin = [
            'harga' => $data->max('harga'),    // Cost: max adalah terburuk
            'ram' => $data->min('ram'),         // Benefit: min adalah terburuk
            'kamera' => $data->min('kamera'),   // Benefit: min adalah terburuk
            'baterai' => $data->min('baterai')  // Benefit: min adalah terburuk
        ];

        $listS = [];
        $listR = [];
        $tempResults = [];

        // 2. Hitung S dan R untuk setiap alternatif
        foreach ($data as $hp) {
            // Normalisasi bobot per kriteria
            $sHarga = 0.4 * ($hp->harga - $fStar['harga']) / (max($fMin['harga'] - $fStar['harga'], 1));
            $sRam = 0.25 * ($fStar['ram'] - $hp->ram) / (max($fStar['ram'] - $fMin['ram'], 1));
            $sKamera = 0.2 * ($fStar['kamera'] - $hp->kamera) / (max($fStar['kamera'] - $fMin['kamera'], 1));
            $sBaterai = 0.15 * ($fStar['baterai'] - $hp->baterai) / (max($fStar['baterai'] - $fMin['baterai'], 1));

            $sTotal = $sHarga + $sRam + $sKamera + $sBaterai; // Nilai Utility (S)
            $rMax = max($sHarga, $sRam, $sKamera, $sBaterai); // Nilai Regret (R)

            $tempResults[] = [
                'id' => $hp->id,
                'nama' => $hp->nama_hp,
                's' => $sTotal,
                'r' => $rMax
            ];
            $listS[] = $sTotal;
            $listR[] = $rMax;
        }

        // 3. Hitung Q (Index VIKOR)
        $sStar = min($listS);
        $sMin = max($listS);
        $rStar = min($listR);
        $rMin = max($listR);

        foreach ($tempResults as &$res) {
            $res['q'] = 0.5 * ($res['s'] - $sStar) / (max($sMin - $sStar, 0.0001)) +
                        0.5 * ($res['r'] - $rStar) / (max($rMin - $rStar, 0.0001));
        }

        // 4. Urutkan berdasarkan Q (terkecil ke terbesar)
        usort($tempResults, fn($a, $b) => $a['q'] <=> $b['q']);

        // 5. Kosongkan tabel hasil lama
        \DB::table('vikor_results')->truncate();

        // 6. Simpan hasil dan beri ranking
        foreach ($tempResults as $index => &$res) {
            $rank = $index + 1;

            \DB::table('vikor_results')->insert([
                'smartphone_id' => $res['id'],
                'nilai_s' => $res['s'],
                'nilai_r' => $res['r'],
                'nilai_q' => $res['q'],
                'ranking' => $rank,
                'created_at' => now(),
                'updated_at' => now(),
            ]);

            $res['ranking'] = $rank;
        }

        return response()->json($tempResults);
    }

    /**
     * Hitung dan Simpan Hasil Weighted Product (WP)
     * Metode WP: Menghitung Vektor S dan Vektor V
     */
    public function hitungDanSimpanWP()
    {
        $data = Smartphone::all();
        if ($data->isEmpty()) {
            return response()->json(['message' => 'Data kosong'], 404);
        }

        // Bobot: Harga(-0.4/Cost), RAM(0.25/Benefit), Kamera(0.2/Benefit), Baterai(0.15/Benefit)
        $w = ['harga' => -0.4, 'ram' => 0.25, 'kamera' => 0.2, 'baterai' => 0.15];

        $totalS = 0;
        $tempResults = [];

        // 1. Hitung Vektor S
        foreach ($data as $item) {
            $s = pow($item->harga, $w['harga']) *
                 pow($item->ram, $w['ram']) *
                 pow($item->kamera, $w['kamera']) *
                 pow($item->baterai, $w['baterai']);

            $tempResults[] = [
                'id' => $item->id,
                'nama' => $item->nama_hp,
                's' => $s
            ];
            $totalS += $s;
        }

        // 2. Hitung Vektor V
        foreach ($tempResults as &$res) {
            $res['v'] = $res['s'] / $totalS;
        }

        // 3. Urutkan dari V terbesar (Juara 1)
        usort($tempResults, fn($a, $b) => $b['v'] <=> $a['v']);

        // 4. Simpan ke Database
        \DB::table('wp_results')->truncate();
        foreach ($tempResults as $index => &$res) {
            $rank = $index + 1;
            \DB::table('wp_results')->insert([
                'smartphone_id' => $res['id'],
                'nilai_s' => $res['s'],
                'nilai_v' => $res['v'],
                'ranking' => $rank,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
            $res['ranking'] = $rank;
        }

        return response()->json($tempResults);
    }

    /**
     * Bandingkan Hasil WP dan VIKOR dengan Korelasi Spearman
     */
    public function bandingkanMetode() {
        $wp = \DB::table('wp_results')
            ->join('smartphones', 'wp_results.smartphone_id', '=', 'smartphones.id')
            ->select('smartphones.nama_hp', 'wp_results.ranking as rank_wp')
            ->get();

        $vikor = \DB::table('vikor_results')
            ->select('smartphone_id', 'ranking as rank_vikor')
            ->get();

        $perbandingan = [];
        $totalD2 = 0; // Untuk hitung Spearman
        $n = count($wp);

        foreach ($wp as $w) {
            // Cari ranking vikor untuk hp yang sama
            $v = \DB::table('vikor_results')
                ->where('smartphone_id', 
                    \DB::table('smartphones')->where('nama_hp', $w->nama_hp)->value('id')
                )->first();

            $d = $w->rank_wp - $v->ranking; // Selisih peringkat (di)
            $d2 = pow($d, 2); // d kuadrat
            $totalD2 += $d2;

            $perbandingan[] = [
                'nama' => $w->nama_hp,
                'wp' => $w->rank_wp,
                'vikor' => $v->ranking,
                'selisih' => abs($d),
            ];
        }

        // Rumus Spearman: 1 - (6 * sum(d^2) / (n * (n^2 - 1)))
        $koefisien = ($n > 1) ? 1 - ((6 * $totalD2) / ($n * (pow($n, 2) - 1))) : 1;

        return response()->json([
            'data' => $perbandingan,
            'spearman' => round($koefisien, 4),
            'kategori' => $this->kategoriSpearman($koefisien)
        ]);
    }

    private function kategoriSpearman($k) {
        if ($k >= 0.8) return "Sangat Kuat (Konsisten)";
        if ($k >= 0.6) return "Kuat";
        if ($k >= 0.4) return "Cukup";
        return "Lemah (Hasil Berbeda Jauh)";
    }

    /**
     * Get VIKOR Ranking untuk Chart
     */
    public function getVikorRanking() {
        $ranking = \DB::table('vikor_results')
            ->join('smartphones', 'vikor_results.smartphone_id', '=', 'smartphones.id')
            ->select('smartphones.nama_hp', 'vikor_results.nilai_q as skor', 'vikor_results.ranking')
            ->orderBy('vikor_results.ranking', 'asc')
            ->get();
        return response()->json($ranking);
    }

    /**
     * Get WP Ranking untuk Chart
     */
    public function getWpRanking() {
        $ranking = \DB::table('wp_results')
            ->join('smartphones', 'wp_results.smartphone_id', '=', 'smartphones.id')
            ->select('smartphones.nama_hp', 'wp_results.nilai_v as skor', 'wp_results.ranking')
            ->orderBy('wp_results.ranking', 'asc')
            ->get();
        return response()->json($ranking);
    }
}
