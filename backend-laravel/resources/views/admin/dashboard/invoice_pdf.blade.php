<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Invoice Rekap Pendapatan Hari Ini - ReRe Petshop</title>
    <style>
        body {
            font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
            color: #1e293b;
            margin: 0;
            padding: 24px;
            font-size: 11px;
            line-height: 1.4;
        }
        .header {
            border-bottom: 2px solid #dc2626;
            padding-bottom: 14px;
            margin-bottom: 18px;
        }
        .header table {
            width: 100%;
        }
        .brand-title {
            font-size: 20px;
            font-weight: bold;
            color: #dc2626;
            margin: 0 0 4px 0;
        }
        .brand-sub {
            color: #64748b;
            font-size: 10px;
            margin: 0;
        }
        .doc-title {
            text-align: right;
        }
        .doc-badge {
            display: inline-block;
            background: #fee2e2;
            color: #991b1b;
            font-size: 10px;
            font-weight: bold;
            padding: 4px 10px;
            border-radius: 6px;
            margin-bottom: 4px;
        }
        .doc-date {
            color: #475569;
            font-size: 11px;
            font-weight: bold;
        }
        .summary-card {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 12px 16px;
            margin-bottom: 18px;
        }
        .summary-card table {
            width: 100%;
        }
        .summary-label {
            font-size: 10px;
            text-transform: uppercase;
            color: #64748b;
            font-weight: bold;
        }
        .summary-value {
            font-size: 18px;
            font-weight: bold;
            color: #0f172a;
            margin-top: 2px;
        }
        .summary-total {
            color: #dc2626;
        }
        table.data-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        table.data-table th {
            background: #f1f5f9;
            color: #334155;
            font-weight: bold;
            text-align: left;
            padding: 8px 10px;
            font-size: 10px;
            border-bottom: 1px solid #cbd5e1;
            text-transform: uppercase;
        }
        table.data-table td {
            padding: 8px 10px;
            border-bottom: 1px solid #e2e8f0;
            vertical-align: top;
            font-size: 10px;
        }
        table.data-table tr:nth-child(even) {
            background: #fafafa;
        }
        .text-right {
            text-align: right;
        }
        .text-center {
            text-align: center;
        }
        .font-bold {
            font-weight: bold;
        }
        .text-muted {
            color: #64748b;
            font-size: 9px;
        }
        .badge-paid {
            background: #dcfce7;
            color: #166534;
            padding: 2px 6px;
            border-radius: 4px;
            font-weight: bold;
            font-size: 9px;
        }
        .item-list {
            margin: 0;
            padding-left: 14px;
            color: #334155;
        }
        .footer {
            margin-top: 30px;
            padding-top: 14px;
            border-top: 1px solid #e2e8f0;
            font-size: 9px;
            color: #94a3b8;
            width: 100%;
        }
        .signature-box {
            width: 200px;
            float: right;
            text-align: center;
            margin-top: 20px;
        }
        .signature-line {
            border-bottom: 1px solid #334155;
            margin-top: 50px;
            margin-bottom: 4px;
        }
    </style>
</head>
<body>

    <!-- HEADER TOKO -->
    <div class="header">
        <table>
            <tr>
                <td style="vertical-align: middle;">
                    <h1 class="brand-title">RERE PETSHOP</h1>
                    <p class="brand-sub">Pet Care & Supplies Store &bull; Sistem Kasir & E-Commerce</p>
                    <p class="brand-sub">Website: rerepetshop.biz.id &bull; Telp / WA: 0812-3456-7890</p>
                </td>
                <td class="doc-title" style="vertical-align: middle;">
                    <div class="doc-badge">REKAP INVOICE HARIAN</div>
                    <div class="doc-date">Tanggal: {{ $tanggalFormatted }}</div>
                    <div class="text-muted">Dicetak pada: {{ now()->timezone('Asia/Jakarta')->format('d/m/Y H:i') }} WIB</div>
                </td>
            </tr>
        </table>
    </div>

    <!-- SUMMARY RINGKASAN -->
    <div class="summary-card">
        <table>
            <tr>
                <td style="width: 50%;">
                    <div class="summary-label">Total Pendapatan Hari Ini (Lunas)</div>
                    <div class="summary-value summary-total">Rp {{ number_format($totalPendapatanHariIni, 0, ',', '.') }}</div>
                </td>
                <td style="width: 50%; text-align: right;">
                    <div class="summary-label">Jumlah Pesanan Dibayar Hari Ini</div>
                    <div class="summary-value">{{ count($pesananPaidHariIni) }} Transaksi</div>
                </td>
            </tr>
        </table>
    </div>

    <!-- TABEL RINCIAN PESANAN -->
    <h3 style="font-size: 12px; margin: 0 0 8px 0; color: #334155;">Rincian Pesanan yang Sudah Dibayar Hari Ini</h3>
    <table class="data-table">
        <thead>
            <tr>
                <th style="width: 5%;" class="text-center">No</th>
                <th style="width: 18%;">Kode Pesanan</th>
                <th style="width: 18%;">Pelanggan</th>
                <th style="width: 32%;">Item Produk Dipesan</th>
                <th style="width: 12%;">Metode</th>
                <th style="width: 15%;" class="text-right">Total (Rp)</th>
            </tr>
        </thead>
        <tbody>
            @forelse($pesananPaidHariIni as $index => $p)
                <tr>
                    <td class="text-center font-bold">{{ $index + 1 }}</td>
                    <td>
                        <strong style="color: #dc2626;">{{ $p->kode_pesanan ?? '#' . $p->id_pesanan }}</strong>
                        <div class="text-muted">
                            {{ $p->pembayaran && $p->pembayaran->waktu_bayar ? \Carbon\Carbon::parse($p->pembayaran->waktu_bayar)->timezone('Asia/Jakarta')->format('H:i') . ' WIB' : 'Hari ini' }}
                        </div>
                    </td>
                    <td>
                        <strong>{{ $p->pelanggan->nama ?? ($p->pelanggan->nama_lengkap ?? 'Customer') }}</strong>
                        <div class="text-muted">{{ $p->pelanggan->telepon ?? '-' }}</div>
                    </td>
                    <td>
                        @if($p->details && $p->details->count() > 0)
                            <ul class="item-list">
                                @foreach($p->details as $d)
                                    <li>
                                        {{ $d->produk->nama_produk ?? 'Produk' }}
                                        <span class="text-muted">({{ $d->qty ?? $d->jumlah ?? 1 }} pcs &times; Rp {{ number_format($d->harga_satuan, 0, ',', '.') }})</span>
                                    </li>
                                @endforeach
                            </ul>
                        @else
                            <span class="text-muted">-</span>
                        @endif
                    </td>
                    <td>
                        <span class="badge-paid">LUNAS</span>
                        <div class="text-muted" style="margin-top: 2px;">
                            {{ $p->pembayaran->metode_bayar ?? 'Midtrans / Online' }}
                        </div>
                    </td>
                    <td class="text-right font-bold" style="color: #0f172a;">
                        Rp {{ number_format($p->total, 0, ',', '.') }}
                    </td>
                </tr>
            @empty
                <tr>
                    <td colspan="6" class="text-center" style="padding: 24px; color: #94a3b8;">
                        Belum ada transaksi pesanan yang dibayar (lunas) untuk hari ini.
                    </td>
                </tr>
            @endforelse
        </tbody>
        @if(count($pesananPaidHariIni) > 0)
            <tfoot>
                <tr style="background: #f8fafc; font-weight: bold;">
                    <td colspan="5" class="text-right" style="padding: 10px; font-size: 11px;">
                        TOTAL PENDAPATAN HARI INI :
                    </td>
                    <td class="text-right" style="padding: 10px; font-size: 12px; color: #dc2626;">
                        Rp {{ number_format($totalPendapatanHariIni, 0, ',', '.') }}
                    </td>
                </tr>
            </tfoot>
        @endif
    </table>

    <!-- TANDA TANGAN / PENGESAHAN -->
    <table style="width: 100%; margin-top: 15px;">
        <tr>
            <td style="width: 60%; vertical-align: top;">
                <p class="text-muted" style="font-size: 9px; line-height: 1.5;">
                    * Dokumen ini dibuat otomatis oleh Sistem Kasir & Admin ReRe Petshop.<br>
                    * Hanya mencatat pesanan berstatus Lunas (PAID) pada tanggal {{ $tanggalFormatted }}.<br>
                    * Bukti sah rekap transaksi harian toko.
                </p>
            </td>
            <td style="width: 40%; text-align: center; vertical-align: top;">
                <div style="font-size: 10px; font-weight: bold; margin-bottom: 50px;">
                    Pengelola / Admin ReRe Petshop,
                </div>
                <div style="font-weight: bold; border-top: 1px solid #64748b; display: inline-block; padding-top: 4px; min-width: 150px;">
                    {{ auth()->user()->name ?? 'Administrator' }}
                </div>
            </td>
        </tr>
    </table>

</body>
</html>