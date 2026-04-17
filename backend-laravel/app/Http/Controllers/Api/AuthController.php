<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Pelanggan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name'     => 'required|string|max:255',
            'email'    => 'required|email|unique:users,email|unique:pelanggan,email',
            'password' => 'required|string|min:6',
            'no_hp'    => 'nullable|string|max:20',
            'alamat'   => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors'  => $validator->errors(),
            ], 422);
        }

        // 1. Buat pelanggan dulu untuk dapat id_pelanggan
        $pelanggan = Pelanggan::create([
            'nama'     => $request->name,
            'email'    => $request->email,
            'password' => Hash::make($request->password),
            'no_hp'    => $request->no_hp,
            'alamat'   => $request->alamat,
        ]);

        // 2. Buat user, langsung isi pelanggan_id
        $user = User::create([
            'name'         => $request->name,
            'email'        => $request->email,
            'password'     => Hash::make($request->password),
            'role'         => 'customer',
            'pelanggan_id' => $pelanggan->id_pelanggan, // sinkron
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Register berhasil',
            'data'    => [
                'user'      => $user,
                'pelanggan' => $pelanggan,
            ],
        ], 201);
    }

    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email'    => 'required|email',
            'password' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors'  => $validator->errors(),
            ], 422);
        }

        if (! Auth::attempt([
            'email'    => $request->email,
            'password' => $request->password,
        ])) {
            return response()->json([
                'success' => false,
                'message' => 'Email atau password salah',
            ], 401);
        }

        $user = User::where('email', $request->email)->first();

        if ($user->role !== 'customer') {
            return response()->json([
                'success' => false,
                'message' => 'Akun ini bukan customer',
            ], 403);
        }

        // Hapus token lama, buat token baru
        $user->tokens()->delete();
        $token = $user->createToken('customer_token')->plainTextToken;

        // Ambil data pelanggan sekalian untuk response
        $pelanggan = Pelanggan::where('id_pelanggan', $user->pelanggan_id)->first();

        return response()->json([
            'success' => true,
            'message' => 'Login berhasil',
            'token'   => $token,
            'data'    => [
                'user'      => $user,
                'pelanggan' => $pelanggan,
            ],
        ]);
    }

    public function logout(Request $request)
    {
        $request->user()->tokens()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Logout berhasil',
        ]);
    }

    public function me(Request $request)
    {
        $user      = $request->user();
        $pelanggan = Pelanggan::where('email', $user->email)->first();
        return response()->json([
            'success' => true,
            'user'      => $user,
            'pelanggan' => $pelanggan,
        ]);
    }
}