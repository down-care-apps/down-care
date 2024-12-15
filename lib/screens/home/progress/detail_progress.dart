import 'package:down_care/api/progress_services.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DetailProgress extends StatefulWidget {
  final Map<String, dynamic> kidProfile;

  const DetailProgress({super.key, required this.kidProfile});

  @override
  DetailProgressState createState() => DetailProgressState();
}

class DetailProgressState extends State<DetailProgress> {
  final ProgressServices progressKid = ProgressServices();
  List<FlSpot> weightSpots = [];
  List<FlSpot> heightSpots = [];
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _fetchProgressData();
  }

  int _getMonthIndex(String month) {
    const monthMapping = {
      'Januari': 0,
      'Februari': 1,
      'Maret': 2,
      'April': 3,
      'Mei': 4,
      'Juni': 5,
      'Juli': 6,
      'Agustus': 7,
      'September': 8,
      'Oktober': 9,
      'November': 10,
      'Desember': 11
    };

    return monthMapping[month] ?? -1;
  }

  String getMonthTitle(int index) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[index];
  }

  Future<void> _fetchProgressData() async {
    try {
      final progressData = await progressKid.getProgressByChildId(widget.kidProfile['id']);
      List<FlSpot> weightData = [];
      List<FlSpot> heightData = [];

      for (var record in progressData) {
        var monthData = record['month'];
        monthData.forEach((month, data) {
          int monthIndex = _getMonthIndex(month);
          if (monthIndex != -1) {
            double weight = double.tryParse(data['weight']) ?? 0.0;
            double height = double.tryParse(data['height']) ?? 0.0;

            weightData.add(FlSpot(monthIndex.toDouble(), weight));
            heightData.add(FlSpot(monthIndex.toDouble(), height));
          }
        });
      }

      setState(() {
        weightSpots = weightData;
        heightSpots = heightData;
        isLoading = false;
      });
    } catch (e) {
      // print('Error fetching progress data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildLineChart(BuildContext context, List<FlSpot> spots, Color lineColor, Color areaColor, String title, double interval) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w500, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: interval,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          value.toStringAsFixed(0),
                          style: const TextStyle(fontSize: 10, color: Colors.black54),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            getMonthTitle(value.toInt()),
                            style: const TextStyle(fontSize: 10, color: Colors.black54),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: lineColor,
                      belowBarData: BarAreaData(show: true, color: areaColor.withOpacity(0.3)),
                      dotData: const FlDotData(show: false),
                      spots: spots,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text('Statistik Pertumbuhan', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      radius: 30,
                      child: Text(widget.kidProfile['name'][0],
                          style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.kidProfile['name'], style: Theme.of(context).textTheme.titleLarge),
                        Text('${widget.kidProfile['age']} tahun', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Loading indicator while fetching data
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      // Weight Chart
                      buildLineChart(context, weightSpots, Colors.blue, Colors.blue, 'Berat Badan', 1),
                      const SizedBox(height: 16),

                      // Height Chart
                      buildLineChart(context, heightSpots, Colors.green, Colors.green, 'Tinggi Badan', 4),
                      const SizedBox(height: 16),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
