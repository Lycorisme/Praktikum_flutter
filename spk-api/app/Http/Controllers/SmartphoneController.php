<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class SmartphoneController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return response()->json(\App\Models\Smartphone::all());
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

        $smartphone = \App\Models\Smartphone::create($validated);
        return response()->json($smartphone, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $smartphone = \App\Models\Smartphone::find($id);
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
        $smartphone = \App\Models\Smartphone::find($id);
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
        $smartphone = \App\Models\Smartphone::find($id);
        if (!$smartphone) {
            return response()->json(['message' => 'Smartphone not found'], 404);
        }
        $smartphone->delete();
        return response()->json(['message' => 'Smartphone deleted']);
    }
}
