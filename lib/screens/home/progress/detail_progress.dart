import 'package:down_care/api/childrens_service.dart';
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
      body: SingleChildScrollView(
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
                'Berat Badan',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: 16),
// Line chart for Berat Badan
            SizedBox(
              width: 340,
              height: 150,
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
                          // Menampilkan bulan dengan ukuran font lebih kecil
                          switch (value.toInt()) {
                            case 0:
                              return Text(
                                'Jan',
                                style: TextStyle(fontSize: 10), // Ukuran font lebih kecil
                              );
                            case 1:
                              return Text(
                                'Feb',
                                style: TextStyle(fontSize: 10), // Ukuran font lebih kecil
                              );
                            case 2:
                              return Text(
                                'Mar',
                                style: TextStyle(fontSize: 10), // Ukuran font lebih kecil
                              );
                            case 3:
                              return Text(
                                'Apr',
                                style: TextStyle(fontSize: 10), // Ukuran font lebih kecil
                              );
                            case 4:
                              return Text(
                                'May',
                                style: TextStyle(fontSize: 10), // Ukuran font lebih kecil
                              );
                            case 5:
                              return Text(
                                'Jun',
                                style: TextStyle(fontSize: 10), // Ukuran font lebih kecil
                              );
                            case 6:
                              return Text(
                                'Jul',
                                style: TextStyle(fontSize: 10), // Ukuran font lebih kecil
                              );
                            case 7:
                              return Text(
                                'Aug',
                                style: TextStyle(fontSize: 10), // Ukuran font lebih kecil
                              );
                            case 8:
                              return Text(
                                'Sep',
                                style: TextStyle(fontSize: 10), // Ukuran font lebih kecil
                              );
                            case 9:
                              return Text(
                                'Oct',
                                style: TextStyle(fontSize: 10), // Ukuran font lebih kecil
                              );
                            case 10:
                              return Text(
                                'Nov',
                                style: TextStyle(fontSize: 10), // Ukuran font lebih kecil
                              );
                            case 11:
                              return Text(
                                'Dec',
                                style: TextStyle(fontSize: 10), // Ukuran font lebih kecil
                              );
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
                        FlSpot(0, 35),
                        FlSpot(1, 36),
                        FlSpot(2, 36.5),
                        FlSpot(3, 37),
                        FlSpot(4, 37.5),
                        FlSpot(5, 38),
                        FlSpot(6, 38.5),
                        FlSpot(7, 39),
                        FlSpot(8, 39.2),
                        FlSpot(9, 39.5),
                        FlSpot(10, 39.7),
                        FlSpot(11, 40),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),
            Center(
              child: Text(
                'Tinggi Badan',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: 16),
// Line chart for Tinggi Badan
            SizedBox(
              width: 340,
              height: 150,
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, interval: 5, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          // Menampilkan bulan secara urut dari Januari hingga Desember dengan ukuran teks lebih kecil
                          switch (value.toInt()) {
                            case 0:
                              return Text(
                                'Jan',
                                style: TextStyle(fontSize: 10), // Ukuran font lebih kecil
                              );
                            case 1:
                              return Text(
                                'Feb',
                                style: TextStyle(fontSize: 10), // Ukuran font lebih kecil
                              );
                            case 2:
                              return Text(
                                'Mar',
                                style: TextStyle(fontSize: 10), // Ukuran font lebih kecil
                              );
                            case 3:
                              return Text(
                                'Apr',
                                style: TextStyle(fontSize: 10), // Ukuran font lebih kecil
                              );
                            case 4:
                              return Text(
                                'May',
                                style: TextStyle(fontSize: 10), // Ukuran font lebih kecil
                              );
                            case 5:
                              return Text(
                                'Jun',
                                style: TextStyle(fontSize: 10), // Ukuran font lebih kecil
                              );
                            case 6:
                              return Text(
                                'Jul',
                                style: TextStyle(fontSize: 10), // Ukuran font lebih kecil
                              );
                            case 7:
                              return Text(
                                'Aug',
                                style: TextStyle(fontSize: 10), // Ukuran font lebih kecil
                              );
                            case 8:
                              return Text(
                                'Sep',
                                style: TextStyle(fontSize: 10), // Ukuran font lebih kecil
                              );
                            case 9:
                              return Text(
                                'Oct',
                                style: TextStyle(fontSize: 10), // Ukuran font lebih kecil
                              );
                            case 10:
                              return Text(
                                'Nov',
                                style: TextStyle(fontSize: 10), // Ukuran font lebih kecil
                              );
                            case 11:
                              return Text(
                                'Dec',
                                style: TextStyle(fontSize: 10), // Ukuran font lebih kecil
                              );
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
                      color: Colors.green,
                      belowBarData: BarAreaData(show: true, color: Colors.green.withOpacity(0.2)),
                      dotData: FlDotData(show: false),
                      spots: [
                        FlSpot(0, 140), // Jan
                        FlSpot(1, 142), // Feb
                        FlSpot(2, 144), // Mar
                        FlSpot(3, 146), // Apr
                        FlSpot(4, 148), // May
                        FlSpot(5, 150), // Jun
                        FlSpot(6, 152), // Jul
                        FlSpot(7, 153), // Aug
                        FlSpot(8, 154), // Sep
                        FlSpot(9, 156), // Oct
                        FlSpot(10, 157), // Nov
                        FlSpot(11, 158), // Dec
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: DataTable(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                columns: [
                  DataColumn(
                    label: Text(
                      'Label',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Value',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(Text('Umur')),
                      DataCell(
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text('7 Tahun'),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Jenis Kelamin')),
                      DataCell(
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text('Laki-Laki'),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Tinggi Badan')),
                      DataCell(
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text('150 cm'),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Berat Badan')),
                      DataCell(
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '38 Kg',
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Tanggal Lahir')),
                      DataCell(
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text('25 Maret 2017'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Tambahkan setelah DataTable
            SizedBox(height: 16),
            Center(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Catatan Penting:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '- Grafik menunjukkan perkembangan anak selama 12 bulan terakhir.',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    Text(
                      '- Pastikan data tinggi badan dan berat badan telah diperbarui secara rutin.',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    Text(
                      '- Data ini membantu memantau pertumbuhan anak secara menyeluruh.',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
