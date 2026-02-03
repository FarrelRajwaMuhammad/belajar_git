import 'package:flutter/material.dart';
import 'package:belajar_git/widget/report/report.dart'; // Sesuaikan path ini

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Putih bersih
      // BOTTOM NAV BAR BIAR KEREN
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))
          ]
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF00AA13), // Hijau Gojek
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          backgroundColor: Colors.white,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Beranda"),
            BottomNavigationBarItem(icon: Icon(Icons.discount_outlined), label: "Promo"),
            BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: "Pesanan"),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Akun"),
          ],
        ),
      ),
      body: Stack(
        children: [
          // 1. BACKGROUND HIJAU DI ATAS (HEADER)
          Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00AA13), Color(0xFF00880F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),

          // 2. KONTEN UTAMA (SCROLLABLE)
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // --- HEADER SEARCH & PROFILE ---
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      children: [
                        // Search Bar
                        Expanded(
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.white.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 15),
                                const Icon(Icons.search, color: Colors.white, size: 20),
                                const SizedBox(width: 10),
                                Text("Cari layanan...", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        // Profile Icon
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=12"), // Gambar dummy
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- WALLET CARD (MELAYANG) ---
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 10))
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Saldo Info
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Gopay", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text("Rp 99.999.999", 
                              style: TextStyle(color: Colors.grey[800], fontSize: 18, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 4),
                            const Text("Tap for history", style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        // Action Buttons (Pay, Topup, Explore)
                        Row(
                          children: [
                            _buildWalletAction(Icons.arrow_upward, "Top Up"),
                            const SizedBox(width: 12),
                            _buildWalletAction(Icons.qr_code_scanner, "Pay"),
                            const SizedBox(width: 12),
                            _buildWalletAction(Icons.explore, "More"),
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- GRID MENU UTAMA ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      mainAxisSpacing: 25, // Jarak vertikal
                      crossAxisSpacing: 10, // Jarak horizontal
                      childAspectRatio: 0.85, // Biar agak tinggi (muat text)
                      children: [
                        _buildMenuButton(context, icon: Icons.motorcycle_rounded, label: "GoRide", color: Colors.green),
                        _buildMenuButton(context, icon: Icons.local_taxi_rounded, label: "GoCar", color: Colors.green),
                        _buildMenuButton(context, icon: Icons.restaurant_rounded, label: "GoFood", color: Colors.red),
                        _buildMenuButton(context, icon: Icons.local_shipping_rounded, label: "GoSend", color: Colors.orange),
                        _buildMenuButton(context, icon: Icons.shopping_basket_rounded, label: "GoMart", color: Colors.red),
                        _buildMenuButton(context, icon: Icons.receipt_long_rounded, label: "GoBill", color: Colors.blue),
                        // Tombol Report Special
                        _buildMenuButton(context, icon: Icons.bar_chart_rounded, label: "Report", color: Colors.purple, isReport: true),
                        _buildMenuButton(context, icon: Icons.apps_rounded, label: "Lainnya", color: Colors.grey),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- BANNER PROMO ---
                  _buildSectionTitle("Promo Spesial"),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildPromoCard(
                           const [Color(0xFF00AA13), Color(0xFF006C0D)], 
                           "Diskon 70%", "Pake kode: MAKANENAK", Icons.fastfood
                        ),
                        _buildPromoCard(
                           const [Color(0xFFEE2737), Color(0xFFA5000E)], 
                           "Cashback", "Belanja di GoMart", Icons.shopping_bag
                        ),
                        _buildPromoCard(
                           const [Color(0xFF00AED6), Color(0xFF007599)], 
                           "Jalan-Jalan", "Diskon GoCar 50rb", Icons.local_taxi
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100), // Space bawah
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET PENDUKUNG ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text("Lihat Semua", style: TextStyle(color: Color(0xFF00AA13), fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletAction(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF00AA13).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF00AA13), size: 20),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }

  Widget _buildMenuButton(BuildContext context, {required IconData icon, required String label, required Color color, bool isReport = false}) {
    return InkWell(
      onTap: () {
        if (isReport) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportPage()));
        }
      },
      borderRadius: BorderRadius.circular(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isReport ? color : Colors.white, // Kalau Report backgroundnya ungu, kalau lain putih
              borderRadius: BorderRadius.circular(18),
              border: isReport ? null : Border.all(color: Colors.grey.withOpacity(0.2)),
              boxShadow: isReport 
                  ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))]
                  : [], // Menu biasa ga usah shadow biar clean
            ),
            child: Icon(icon, color: isReport ? Colors.white : color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildPromoCard(List<Color> colors, String title, String subtitle, IconData icon) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: colors.first.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Stack(
        children: [
          // Background Icon (Hiasan)
          Positioned(
            right: -10, bottom: -10,
            child: Icon(icon, size: 80, color: Colors.white.withOpacity(0.2)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                child: const Text("Limited Offer", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}