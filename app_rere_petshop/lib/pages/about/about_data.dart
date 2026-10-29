import 'package:flutter/material.dart';

class AboutBranch {
  const AboutBranch({
    required this.name,
    required this.address,
    required this.hours,
    required this.phone,
    required this.mapsUrl,
  });

  final String name;
  final String address;
  final String hours;
  final String phone;
  final String mapsUrl;
}

class AboutStat {
  const AboutStat(this.value, this.label, this.icon);
  final String value;
  final String label;
  final IconData icon;
}

class AboutBenefit {
  const AboutBenefit(this.title, this.description, this.icon);
  final String title;
  final String description;
  final IconData icon;
}

const aboutStats = <AboutStat>[
  AboutStat('10.5k', 'Penjual aktif di situs kami', Icons.storefront_outlined),
  AboutStat('33k', 'Penjualan produk bulanan', Icons.account_balance_wallet_outlined),
  AboutStat('45.5k', 'Pelanggan aktif di situs kami', Icons.shopping_bag_outlined),
  AboutStat('25k', 'Penjualan kotor tahunan', Icons.attach_money),
];

const aboutBenefits = <AboutBenefit>[
  AboutBenefit(
    'Pengiriman Gratis dan Cepat',
    'Gratis pengiriman untuk pesanan di atas Rp 200.000',
    Icons.local_shipping_outlined,
  ),
  AboutBenefit(
    'Layanan Pelanggan 24/7',
    'Dukungan pelanggan yang ramah setiap saat',
    Icons.headset_mic_outlined,
  ),
  AboutBenefit(
    'Garansi Uang Kembali',
    'Pengembalian dana dapat diproses hingga 30 hari',
    Icons.verified_user_outlined,
  ),
];

const aboutBranches = <AboutBranch>[
  AboutBranch(
    name: 'Petshop ReRe',
    address: 'Jl. Kecubung 1 No.14, Kuta Baru, Kec. Ps. Kemis, Kabupaten Tangerang, Banten 15560',
    hours: 'Setiap hari, 09.00 - 21.00',
    phone: '+62 813-1941-0250',
    mapsUrl: 'https://maps.app.goo.gl/KhHZDREz16k6FWgx8',
  ),
  AboutBranch(
    name: 'Petshop Rumah Kucing ReRe',
    address: 'Bugel, Kec. Karawaci, Kota Tangerang, Banten',
    hours: 'Setiap hari, 09.00 - 21.00',
    phone: '+62 813-1941-0250',
    mapsUrl: 'https://maps.app.goo.gl/qKCWPHzqdAmWaA5K6',
  ),
  AboutBranch(
    name: 'Petshop ReRe, Cilongok New',
    address: 'Ds, Jl. Raya pasar Kemis Kp, Cilongok RGGV+W83 pos, RT.004/RW.04, Sukamantri, Kec. Ps. Kemis, Kabupaten Tangerang, Banten 15560',
    hours: 'Setiap hari, 09.00 - 21.00',
    phone: '+62 813-1941-0250',
    mapsUrl: 'https://maps.app.goo.gl/VsBzfAZgBpQmtdvc7',
  ),
  AboutBranch(
    name: 'Petshop Rumah Kucing',
    address: 'Kuta Jaya, Kec. Ps. Kemis, Kabupaten Tangerang, Banten',
    hours: 'Setiap hari, 09.00 - 21.00',
    phone: '+62 813-1941-0250',
    mapsUrl: 'https://maps.app.goo.gl/jmiutxKqxbPTThcm6',
  ),
  AboutBranch(
    name: 'Rumah Kucing',
    address: 'Jl. Prabu Kian Santang No.18, RT.001/RW.012, Sangiang Jaya, Kec. Periuk, Kota Tangerang, Banten 15131',
    hours: 'Setiap hari, 09.00 - 21.00',
    phone: '+62 813-1941-0250',
    mapsUrl: 'https://maps.app.goo.gl/yWVGt1LMVmMARdgt9',
  ),
  AboutBranch(
    name: 'Petshop ReRe, Sepatan',
    address: 'Pd. Jaya, Kec. Sepatan, Kabupaten Tangerang, Banten',
    hours: 'Setiap hari, 09.00 - 21.00',
    phone: '+62 813-1941-0250',
    mapsUrl: 'https://maps.app.goo.gl/bJu4a27vJGebag4K6',
  ),
  AboutBranch(
    name: 'Petshop ReRe, Total Persada',
    address: 'RHHM+497, Jl. Raya Villa Tangerang Indah, RT.004/RW.007, Gembor, Kec. Periuk, Kota Tangerang, Banten 15133',
    hours: 'Setiap hari, 09.00 - 21.00',
    phone: '+62 813-1941-0250',
    mapsUrl: 'https://maps.app.goo.gl/Jm4AeZ2bVZXZpqPo9',
  ),
];
