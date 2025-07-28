import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  List<Map<String, String>> getReports() {
    return [
      {"title": "Monthly Catch", "value": "2,300 KG", "date": "July 2025"},
      {"title": "Illegal Fishing Alerts", "value": "5", "date": "July 2025"},
      {"title": "Pollution Reports", "value": "3", "date": "July 2025"},
      {"title": "New Registrations", "value": "120", "date": "July 2025"},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final reports = getReports();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports"),
        backgroundColor: const Color(0xFF00ACC1),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: const Icon(Icons.analytics, color: Color(0xFF00838F)),
              title: Text(report['title']!),
              subtitle: Text("Date: ${report['date']}"),
              trailing: Text(
                report['value']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00796B),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
