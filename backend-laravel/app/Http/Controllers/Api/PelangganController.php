<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class PelangganController extends Controller
{
    public function updateProfile(Request $request)
    {
        // Ambil data pelanggan yang sedang login lewat token
        $pelanggan = $request->user(); 

        $request->validate([
            'nama'     => 'sometimes|string|max:255',
            'no_hp'    => 'sometimes|string|max:15',
            'password' => 'sometimes|nullable|min:6|confirmed',
        ]);

        // Update jika ada datanya
        if ($request->has('nama')) $pelanggan->nama = $request->nama;
        if ($request->has('no_hp')) $pelanggan->no_hp = $request->no_hp;
        
        // Update password kalau diisi
        if ($request->filled('password')) {
            $pelanggan->password = Hash::make($request->password);
        }

        $pelanggan->save();

        return response()->json([
            'success' => true,
            'message' => 'Data profil Rere Petshop berhasil diperbarui!',
            'data'    => $pelanggan
        ]);
    }
}