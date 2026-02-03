import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

// Model Data (Biar rapi, bayangin ini struktur tabel db lo)
class SalesData {
  final String customerName;
  final DateTime date;
  final double amount;
  final String status;

  SalesData(this.customerName, this.date, this.amount, this.status);
}

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  // Ceritanya ini data yang diambil dari DB Postgres lo lewat API
  final List<SalesData> _salesList = [
    SalesData("Budi Santoso", DateTime.now(), 150000, "Success"),
    SalesData("Siti Aminah", DateTime.now().subtract(const Duration(hours: 2)), 250000, "Success"),
    SalesData("Joko Anwar", DateTime.now().subtract(const Duration(days: 1)), 75000, "Pending"),
    SalesData("Rina Nose", DateTime.now().subtract(const Duration(days: 1)), 500000, "Success"),
    SalesData("Dedi Corbuzier", DateTime.now().subtract(const Duration(days: 2)), 1200000, "Success"),
    SalesData("Anya Geraldine", DateTime.now().subtract(const Duration(days: 3)), 300000, "Cancelled"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Laporan Penjualan"),
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. CHART SECTION
              const Text("Trend Penjualan (Minggu Ini)", 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              
              Container(
                height: 250, // Tinggi Chart
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
                  ]
                ),
                child: LineChart(
                  _mainData(), // Panggil fungsi chart di bawah
                ),
              ),

              const SizedBox(height: 30),

              // 2. LIST DATA CUSTOMER SECTION
              const Text("Riwayat Transaksi", 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              // List View data customer
              ListView.builder(
                shrinkWrap: true, // Wajib biar ga error di dalem SingleChildScrollView
                physics: const NeverScrollableScrollPhysics(), // Scroll ikut parent
                itemCount: _salesList.length,
                itemBuilder: (context, index) {
                  final data = _salesList[index];
                  return _buildSalesCard(data);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Card buat tiap item penjualan
  Widget _buildSalesCard(SalesData data) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, color: Colors.blue[700]),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.customerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(DateFormat('dd MMM yyyy, HH:mm').format(data.date), 
                      style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(currencyFormatter.format(data.amount), 
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 14)),
              const SizedBox(height: 4),
              _buildStatusBadge(data.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'Success': color = Colors.green; break;
      case 'Pending': color = Colors.orange; break;
      case 'Cancelled': color = Colors.red; break;
      default: color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  // Konfigurasi Chart (Agak teknis dikit disini, ini bawaan fl_chart)
  LineChartData _mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.1), strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              // Label bawah chart (Sen, Sel, Rab...)
              const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12);
              switch (value.toInt()) {
                case 1: return const Text('Sen', style: style);
                case 3: return const Text('Rab', style: style);
                case 5: return const Text('Jum', style: style);
                case 7: return const Text('Min', style: style);
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)), // Hide angka kiri biar bersih
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 7,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            // Titik Koordinat Grafik (X, Y)
            FlSpot(0, 3),
            FlSpot(1, 2),
            FlSpot(2, 5),
            FlSpot(3, 3.1),
            FlSpot(4, 4),
            FlSpot(5, 3),
            FlSpot(6, 4),
            FlSpot(7, 5.5),
          ],
          isCurved: true, // Biar garisnya melengkung halus
          gradient: LinearGradient(colors: [Colors.blue, Colors.blueAccent]),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false), // Ilangin titik-titik
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [Colors.blue.withOpacity(0.3), Colors.blue.withOpacity(0.0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }
}