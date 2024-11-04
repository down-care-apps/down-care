import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DetailProgress extends StatelessWidget {
  final String kidProfile;

  DetailProgress({required this.kidProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Statistik Perkembangan",
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(kidProfile[0]), // Placeholder for profile pic
                  radius: 30,
                ),
                SizedBox(width: 16),
                Text(
                  kidProfile,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Progress Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: 16),
            // Add the minimalist line chart here
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, interval: 1, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return Text('Jul');
                            case 1:
                              return Text('Aug');
                            case 2:
                              return Text('Sep');
                            case 3:
                              return Text('Oct');
                            case 4:
                              return Text('Nov');
                            case 5:
                              return Text('Dec');
                            default:
                              return Text('');
                          }
                        },
                        reservedSize: 40,
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: Colors.blue,
                      belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.2)),
                      dotData: FlDotData(show: false),
                      spots: [
                        FlSpot(0, 2),
                        FlSpot(1, 3),
                        FlSpot(2, 1.5),
                        FlSpot(3, 2.8),
                        FlSpot(4, 2.2),
                        FlSpot(5, 3.2),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Details table with labels and values
            DataTable(
              columns: [
                DataColumn(label: Text('Label')),
                DataColumn(label: Text('Value')),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text('Umur')),
                    DataCell(Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text('7 Tahun'),
                      ),
                    )),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Jenis Kelamin')),
                    DataCell(Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text('Laki-Laki'),
                      ),
                    )),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Tinggi Badan')),
                    DataCell(Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text('145 cm'),
                      ),
                    )),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Berat Badan')),
                    DataCell(Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text('35 Kg', style: TextStyle(color: Colors.blueGrey)),
                      ),
                    )),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Tanggal Lahir')),
                    DataCell(Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text('25 Maret 2017'),
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
