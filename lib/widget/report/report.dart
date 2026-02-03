import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

// --- MODEL DATA ---
class SalesData {
  final String id;
  final String customerName;
  final DateTime date;
  final double amount;
  final String status; // Success, Pending, Cancelled

  SalesData(this.id, this.customerName, this.date, this.amount, this.status);
}

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  // Mock Data
  final List<SalesData> _salesList = [
    SalesData("TX01", "Budi Santoso", DateTime.now(), 150000, "Success"),
    SalesData(
      "TX02",
      "Siti Aminah",
      DateTime.now().subtract(const Duration(hours: 2)),
      250000,
      "Success",
    ),
    SalesData(
      "TX03",
      "Joko Anwar",
      DateTime.now().subtract(const Duration(days: 1)),
      75000,
      "Pending",
    ),
    SalesData(
      "TX04",
      "Rina Nose",
      DateTime.now().subtract(const Duration(days: 1)),
      500000,
      "Success",
    ),
    SalesData(
      "TX05",
      "Dedi Corbuzier",
      DateTime.now().subtract(const Duration(days: 2)),
      1200000,
      "Success",
    ),
    SalesData(
      "TX06",
      "Anya Geraldine",
      DateTime.now().subtract(const Duration(days: 3)),
      300000,
      "Cancelled",
    ),
    SalesData(
      "TX07",
      "Raffi Ahmad",
      DateTime.now().subtract(const Duration(days: 4)),
      5500000,
      "Success",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Hitung total omset on the fly
    double totalOmset = _salesList
        .where((e) => e.status == 'Success')
        .fold(0, (previous, current) => previous + current.amount);

    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F7FA,
      ), // Background abu-abu muda banget (Premium look)
      appBar: AppBar(
        title: const Text(
          "Dashboard Penjualan",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E88E5), // Biru material yang solid
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(), // Efek mantul pas scroll mentok
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER SUMMARY SECTION (Gradient Card)
            _buildSummaryHeader(totalOmset, _salesList.length),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // 2. CHART SECTION
                  const Text(
                    "Analitik Mingguan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const SalesChartWidget(), // Widget Chart dipisah biar rapi

                  const SizedBox(height: 24),

                  // 3. RECENT TRANSACTION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Transaksi Terakhir",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Lihat Semua"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _salesList.length,
                    itemBuilder: (context, index) {
                      return TransactionCard(data: _salesList[index]);
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Header Gradient
  Widget _buildSummaryHeader(double total, int count) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1E88E5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total Pendapatan (Net)",
            style: TextStyle(color: Colors.blue.shade100, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            currencyFormatter.format(total),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildMiniStat(Icons.shopping_bag_outlined, "$count Transaksi"),
              const SizedBox(width: 16),
              _buildMiniStat(Icons.trending_up, "+12% vs Kemarin"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// --- WIDGET CHART (DIPISAH BIAR RAPI) ---
class SalesChartWidget extends StatefulWidget {
  const SalesChartWidget({super.key});

  @override
  State<SalesChartWidget> createState() => _SalesChartWidgetState();
}

class _SalesChartWidgetState extends State<SalesChartWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1.5,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: Colors.grey.withOpacity(0.1), strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(
                    color: Color(0xFF9098A3),
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  );
                  switch (value.toInt()) {
                    case 0:
                      return const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text('Sen', style: style),
                      );
                    case 2:
                      return const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text('Rab', style: style),
                      );
                    case 4:
                      return const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text('Jum', style: style),
                      );
                    case 6:
                      return const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text('Min', style: style),
                      );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 6,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(

              tooltipBgColor: Colors.blueAccent,

              tooltipRoundedRadius: 8,
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  return LineTooltipItem(
                    "${barSpot.y} Jt",
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 3),
                FlSpot(1, 1.5),
                FlSpot(2, 4),
                FlSpot(3, 2.8),
                FlSpot(4, 4.5),
                FlSpot(5, 3),
                FlSpot(6, 5),
              ],
              isCurved: true,
              color: const Color(0xFF1E88E5), // Warna garis utama
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                      radius: 4,
                      color: Colors.white,
                      strokeWidth: 2,
                      strokeColor: const Color(0xFF1E88E5),
                    ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1E88E5).withOpacity(0.2),
                    const Color(0xFF1E88E5).withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET LIST ITEM (DIPISAH BIAR MODULAR) ---
class TransactionCard extends StatelessWidget {
  final SalesData data;
  const TransactionCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: Color(0xFF1E88E5),
            ),
          ),
          const SizedBox(width: 16),

          // Nama & Tanggal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.customerName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd MMM, HH:mm').format(data.date),
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),

          // Harga & Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currencyFormatter.format(data.amount),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 6),
              _buildStatusPill(data.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case 'Success':
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        break;
      case 'Pending':
        bgColor = const Color(0xFFFFF3E0);
        textColor = const Color(0xFFEF6C00);
        break;
      case 'Cancelled':
        bgColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFC62828);
        break;
      default:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
