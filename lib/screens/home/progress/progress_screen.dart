import 'package:down_care/api/progressServices.dart';
import 'package:flutter/material.dart';
import 'package:down_care/widgets/input_field.dart';
import 'package:down_care/screens/home/progress/detail_progress.dart';
import 'package:down_care/api/childrens_service.dart';

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final ChildrensService _childrensService = ChildrensService();
  String? selectedKid;
  Map<String, dynamic>? selectedKidData;
  String? selectedMonth;
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController importantNoteController = TextEditingController();

  List<Map<String, dynamic>> children = [];
  List<String> months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    try {
      final List<dynamic> data = await _childrensService.getAllChildrens();
      setState(() {
        children = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load children: $e')),
      );
    }
  }

  Future<void> _loadChildDetails(String childId) async {
    try {
      final data = await _childrensService.getChildrenById(childId);
      setState(() {
        selectedKidData = data;
        weightController.text = data['weight']?.toString() ?? '';
        heightController.text = data['height']?.toString() ?? '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load child details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Progress Tracker", style: TextStyle(color: Colors.white, fontSize: 24)),
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
            DropdownButtonFormField<String>(
              value: selectedKid,
              hint: const Text('Select Kid Profile'),
              items: children.map((child) {
                return DropdownMenuItem<String>(
                  value: child['id'].toString(),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(child['imageUrl'] ?? 'https://example.com/default_image.jpg'),
                        child: child['imageUrl'] == null ? Text(child['name']?[0] ?? '?') : null,
                      ),
                      const SizedBox(width: 8),
                      Text(child['name'] ?? 'Unnamed Child'),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedKid = newValue;
                  if (newValue != null) {
                    _loadChildDetails(newValue);
                  }
                });
              },
            ),
            if (selectedKid != null) ...[
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailProgress(kidProfile: selectedKidData!),
                    ),
                  );
                },
                child: const Text('View Details'),
              ),
              const SizedBox(height: 16),
              const Text('Month', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                value: selectedMonth,
                hint: const Text('Select Month'),
                items: months.map((month) {
                  return DropdownMenuItem<String>(
                    value: month,
                    child: Text(month),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedMonth = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text('Weight', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              InputField(
                hintText: 'Enter weight',
                controller: weightController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const Text('Height', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              InputField(
                hintText: 'Enter height',
                controller: heightController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const Text('Catatan Penting', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              InputField(
                hintText: 'Masukkan catatan penting',
                controller: importantNoteController,
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () async {
                    await ProgressServices()
                        .createProgress(selectedKidData, heightController.text, weightController.text, selectedMonth, importantNoteController.text);
                    await _loadChildDetails(selectedKidData!['id'].toString());
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailProgress(kidProfile: selectedKidData!,)),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Progress berhasil disimpan'), backgroundColor: Colors.green),
                    );
                    // Submit the progress
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    importantNoteController.dispose();
    super.dispose();
  }
}
