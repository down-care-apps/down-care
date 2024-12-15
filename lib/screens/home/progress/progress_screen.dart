import 'package:down_care/api/progress_services.dart';
import 'package:flutter/material.dart';
import 'package:down_care/widgets/input_field.dart';
import 'package:down_care/screens/home/progress/detail_progress.dart';
import 'package:down_care/api/childrens_service.dart';
import 'package:down_care/widgets/custom_button.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  ProgressScreenState createState() => ProgressScreenState();
}

class ProgressScreenState extends State<ProgressScreen> {
  final ChildrensService _childrensService = ChildrensService();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController importantNoteController = TextEditingController();

  String? selectedKid;
  Map<String, dynamic>? selectedKidData;
  String? selectedMonth;

  List<Map<String, dynamic>> children = [];
  List<String> months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    try {
      final data = await _childrensService.getAllChildrens();
      setState(() {
        children = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      _showSnackBar('Failed to load children: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
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
      _showSnackBar('Failed to load child details: $e');
    }
  }

  Future<void> _submitProgress() async {
    if (selectedKidData == null) {
      _showSnackBar('Please select a kid before submitting progress');
      return;
    }

    try {
      await ProgressServices().createProgress(
        selectedKidData,
        heightController.text,
        weightController.text,
        selectedMonth,
        importantNoteController.text,
      );

      await _loadChildDetails(selectedKidData!['id'].toString());
      _navigateToDetailProgress(selectedKidData!);
      _showSnackBar('Progress berhasil disimpan');
    } catch (e) {
      _showSnackBar('Failed to save progress: $e');
    }
  }

  void _navigateToDetailProgress(Map<String, dynamic> kidProfile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailProgress(kidProfile: kidProfile),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildField(String label, TextEditingController controller, {TextInputType? keyboardType, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        InputField(
          hintText: 'Masukkan $label',
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Colors.transparent),
          ),
          child: DropdownButtonFormField<T>(
            value: value,
            hint: Text(
              'Pilih $label',
              style: TextStyle(color: Colors.black.withOpacity(0.4)),
            ),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
            ),
            items: items,
            onChanged: onChanged,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            dropdownColor: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pertumbuhan', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Show loading spinner while fetching data
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: children.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_alt, size: 80, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text("Belum ada data anak", style: TextStyle(color: Colors.grey.shade600, fontSize: 18)),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDropdown<String>(
                                  label: 'Profil Anak',
                                  value: selectedKid,
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
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedKid = newValue;
                                      if (newValue != null) {
                                        _loadChildDetails(newValue);
                                      }
                                    });
                                  },
                                ),
                                if (selectedKidData != null) ...[
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () => _navigateToDetailProgress(selectedKidData!),
                                      child: const Text('View Details'),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildDropdown<String>(
                                    label: 'Bulan',
                                    value: selectedMonth,
                                    items: months.map((month) {
                                      return DropdownMenuItem<String>(
                                        value: month,
                                        child: Text(month),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) => setState(() => selectedMonth = newValue),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildField('Berat', weightController, keyboardType: TextInputType.number),
                                  const SizedBox(height: 16),
                                  _buildField('Tinggi', heightController, keyboardType: TextInputType.number),
                                  const SizedBox(height: 16),
                                  _buildField('Catatan Penting', importantNoteController, maxLines: 6),
                                ],
                              ],
                            ),
                          ),
                        ),
                        CustomButton(
                          text: 'Submit',
                          onPressed: _submitProgress,
                          widthFactor: 1.0,
                        ),
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
