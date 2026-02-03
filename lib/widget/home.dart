import 'package:flutter/material.dart';
import 'package:belajar_git/widget/report/report.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Warna background agak abu biar kontras
      appBar: AppBar(
        title: const Text('Gojek KW Super'),
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      // 1. INI SOLUSI RESPONSIVE: Bungkus semua body pake SingleChildScrollView
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- BAGIAN HEADER (Saldo) ---
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              decoration: BoxDecoration(
                color: Colors.green[700],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Halo, Sultan!", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text("Saldo: Rp 99.999.999", style: TextStyle(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.account_balance_wallet, color: Colors.green),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),
            
            // --- BAGIAN BANNER PROMO (Horizontal Scroll) ---
            // Ini biar "keliatan rame" cuy
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text("Promo Buat Lo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 140, // Tinggi area banner
              child: ListView(
                scrollDirection: Axis.horizontal, // Bisa digeser ke samping
                padding: const EdgeInsets.only(left: 20), // Padding kiri biar ga nempel layar
                children: [
                  _buildPromoCard(Colors.blue, "Diskon 50%", "Makan Puas!"),
                  _buildPromoCard(Colors.orange, "Gratis Ongkir", "Khusus Hari Ini"),
                  _buildPromoCard(Colors.red, "Cashback 90%", "Gopay Coins"),
                  _buildPromoCard(Colors.purple, "Flash Sale", "Serba 10rb"),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --- BAGIAN MENU UTAMA ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text("Menu Pilihan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            
            // GridView ditaruh disini
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                shrinkWrap: true, // WAJIB: Biar gridnya ngikutin tinggi konten (ga full screen)
                physics: const NeverScrollableScrollPhysics(), // WAJIB: Biar scrollnya ikut SingleChildScrollView induknya
                crossAxisCount: 4,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  _buildMenuButton(context, icon: Icons.motorcycle, label: "Ride", color: Colors.green),
                  _buildMenuButton(context, icon: Icons.fastfood, label: "Food", color: Colors.red),
                  _buildMenuButton(context, icon: Icons.local_shipping, label: "Send", color: Colors.orange),
                  _buildMenuButton(context, icon: Icons.shopping_bag, label: "Mart", color: Colors.pink),
                  
                  // Tombol Report
                  _buildMenuButton(context, icon: Icons.bar_chart_rounded, label: "Report", color: Colors.blue, isReport: true),
                  
                  _buildMenuButton(context, icon: Icons.movie, label: "Tix", color: Colors.purple),
                  _buildMenuButton(context, icon: Icons.electric_bolt, label: "PLN", color: Colors.yellow[800]!),
                  _buildMenuButton(context, icon: Icons.more_horiz, label: "Lainnya", color: Colors.grey),
                ],
              ),
            ),
            
            const SizedBox(height: 50), // Jarak bawah biar scrollnya enak
          ],
        ),
      ),
    );
  }

  // Widget buat bikin Card Banner Promo
  Widget _buildPromoCard(Color color, String title, String subtitle) {
    return Container(
      width: 280, // Lebar card
      margin: const EdgeInsets.only(right: 15), // Jarak antar card
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient( // Efek gradasi biar kece
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        ],
      ),
    );
  }

  // Widget buat bikin tombol menu (sama kayak sebelumnya)
  Widget _buildMenuButton(BuildContext context, {required IconData icon, required String label, required Color color, bool isReport = false}) {
    return InkWell(
      onTap: () {
        if (isReport) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportPage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Menu $label dipencet!")));
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(color: Colors.grey.shade200, blurRadius: 5, offset: const Offset(0, 2))
              ]
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

