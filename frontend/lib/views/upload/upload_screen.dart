import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/widgets/custom_textfield.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:frontend/services/api_service.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  bool _isLoading = false;
  String _selectedCategory = 'Assignment';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isImportant = false;

  void _upload() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ApiService.createUpdate({
        'title': _titleController.text,
        'category': _selectedCategory,
        'description': _descriptionController.text,
        'isImportant': _isImportant,
        'startDate': _startDate?.toIso8601String(),
        'endDate': _endDate?.toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update Created Successfully!')),
      );

      // Clear form
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedCategory = 'Assignment';
        _startDate = null;
        _endDate = null;
        _isImportant = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Update', style: GoogleFonts.poppins()),
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CustomTextField(
              controller: _titleController,
              labelText: 'Title',
              prefixIcon: Icons.title,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: [
                'Assignment', 'Exam', 'Event', 'General', 'Holiday', 
                'Program', 'News', 'Function', 'Birthday', 'Test', 
                'Speech', 'Competition', 'Workshop', 'Seminar'
              ].map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(context, true),
                    icon: Icon(Icons.calendar_today),
                    label: Text(_startDate == null 
                        ? 'Start Date' 
                        : "${_startDate!.day}/${_startDate!.month}/${_startDate!.year}"),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(context, false),
                    icon: Icon(Icons.calendar_today),
                    label: Text(_endDate == null 
                        ? 'End Date' 
                        : "${_endDate!.day}/${_endDate!.month}/${_endDate!.year}"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text("Mark as Important"),
              value: _isImportant,
              onChanged: (val) {
                setState(() {
                  _isImportant = val!;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 32),
            CustomButton(
              text: 'Create Update',
              onPressed: _upload,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}


