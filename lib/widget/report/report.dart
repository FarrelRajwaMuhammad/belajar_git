// Halaman Report tetep sama
import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Laporan"), backgroundColor: Colors.red),
      body: const Center(child: Text("Halaman Reportabcdefg")),
    );
  }
}

class ReportSales extends StatelessWidget{
  const ReportSales({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('testing'),),
    );
  }
}