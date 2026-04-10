<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Keranjang;
use App\Models\KeranjangItem;
use App\Models\Produk;
use Illuminate\Http\Request;

class CartController extends Controller
{
    public function add(Request $request)
    {
        $user = $request->user();

        $request->validate([
            'id_produk' => 'required|exists:produk,id_produk',
            'qty' => 'required|integer|min:1'
        ]);

        $produk = Produk::findOrFail($request->id_produk);

        $keranjang = Keranjang::firstOrCreate(
            ['id_pelanggan' => $user->id],
            ['total' => 0]
        );

        $item = KeranjangItem::where('id_keranjang', $keranjang->id_keranjang)
            ->where('id_produk', $produk->id_produk)
            ->first();

        if ($item) {
            $item->qty += $request->qty;
        } else {
            $item = new KeranjangItem();
            $item->id_keranjang = $keranjang->id_keranjang;
            $item->id_produk = $produk->id_produk;
            $item->qty = $request->qty;
            $item->harga_satuan = $produk->harga;
        }

        $item->subtotal = $item->qty * $item->harga_satuan;
        $item->save();

        $keranjang->total = KeranjangItem::where('id_keranjang', $keranjang->id_keranjang)
            ->sum('subtotal');

        $keranjang->save();

        return response()->json([
            'success' => true,
            'message' => 'Produk berhasil ditambahkan ke keranjang'
        ]);
    }

    public function cart(Request $request)
    {
        $user = $request->user();

        $keranjang = Keranjang::with('items.produk')
            ->where('id_pelanggan', $user->id)
            ->first();

        return response()->json([
            'success' => true,
            'data' => $keranjang
        ]);
    }

    public function remove(Request $request, $id)
    {
        $user = $request->user();

        $item = KeranjangItem::where('id', $id)
            ->whereHas('keranjang', function ($q) use ($user) {
                $q->where('id_pelanggan', $user->id);
            })
            ->firstOrFail();

        $keranjang = $item->keranjang;

        $item->delete();

        // update total
        $keranjang->total = $keranjang->items()->sum('subtotal');
        $keranjang->save();

        return response()->json([
            'success' => true,
            'message' => 'Item dihapus dari keranjang'
        ]);
    }
}