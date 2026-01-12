<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Smartphone;

class SmartphoneSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $smartphones = [
            [
                'nama_hp' => 'Samsung Galaxy S24 Ultra',
                'harga' => 21999000,
                'ram' => 12,
                'kamera' => 200,
                'baterai' => 5000,
            ],
            [
                'nama_hp' => 'iPhone 15 Pro Max',
                'harga' => 24999000,
                'ram' => 8,
                'kamera' => 48,
                'baterai' => 4422,
            ],
            [
                'nama_hp' => 'Xiaomi 14 Ultra',
                'harga' => 16999000,
                'ram' => 16,
                'kamera' => 50,
                'baterai' => 5000,
            ],
            [
                'nama_hp' => 'OPPO Find X7 Ultra',
                'harga' => 18999000,
                'ram' => 16,
                'kamera' => 50,
                'baterai' => 5000,
            ],
            [
                'nama_hp' => 'Vivo X100 Pro',
                'harga' => 15999000,
                'ram' => 16,
                'kamera' => 50,
                'baterai' => 5400,
            ],
            [
                'nama_hp' => 'Samsung Galaxy A54',
                'harga' => 5999000,
                'ram' => 8,
                'kamera' => 50,
                'baterai' => 5000,
            ],
            [
                'nama_hp' => 'Xiaomi Redmi Note 13 Pro',
                'harga' => 3999000,
                'ram' => 8,
                'kamera' => 200,
                'baterai' => 5100,
            ],
            [
                'nama_hp' => 'OPPO Reno 11',
                'harga' => 5499000,
                'ram' => 12,
                'kamera' => 50,
                'baterai' => 5000,
            ],
            [
                'nama_hp' => 'Realme GT 5 Pro',
                'harga' => 9999000,
                'ram' => 16,
                'kamera' => 50,
                'baterai' => 5400,
            ],
            [
                'nama_hp' => 'Google Pixel 8 Pro',
                'harga' => 17999000,
                'ram' => 12,
                'kamera' => 50,
                'baterai' => 5050,
            ],
        ];

        foreach ($smartphones as $smartphone) {
            Smartphone::create($smartphone);
        }
    }
}
