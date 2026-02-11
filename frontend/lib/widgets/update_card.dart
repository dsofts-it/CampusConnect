
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateCard extends StatelessWidget {
  final Map<String, dynamic> update;

  const UpdateCard({Key? key, required this.update}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = update['title'] ?? 'No Title';
    final description = update['description'] ?? '';
    final category = update['category'] ?? 'General';
    final isImportant = update['isImportant'] ?? false;
    
    // Safely handle createdBy which could be a Map, String (ID), or null
    String createdBy = 'Unknown';
    if (update['createdBy'] != null) {
      if (update['createdBy'] is Map) {
        createdBy = update['createdBy']['name'] ?? 'Unknown';
      } else if (update['createdBy'] is String) {
        // Fallback if population failed and we just have ID
        createdBy = 'User'; 
      }
    }

    final likes = (update['likes'] is List) ? update['likes'].length : 0;
    
    // Formatting dates if available (using simple string logic for brevity/consistency)
    String? dateRange;
    try {
      if (update['startDate'] != null) {
        DateTime start = DateTime.parse(update['startDate']);
        String startStr = "${start.day}/${start.month}/${start.year}";
        
        if (update['endDate'] != null) {
          DateTime end = DateTime.parse(update['endDate']);
          String endStr = "${end.day}/${end.month}/${end.year}";
          dateRange = "$startStr - $endStr";
        } else {
          dateRange = startStr;
        }
      }
    } catch (e) {
      dateRange = null; // Fallback if date parsing fails
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    category.toUpperCase(),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: _getCategoryColor(category),
                  padding: EdgeInsets.zero,
                ),
                if (isImportant)
                  Icon(Icons.warning_amber_rounded, color: Colors.orange),
              ],
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (dateRange != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      dateRange,
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 8),
            Text(
              description,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[800]),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      "By $createdBy",
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.red, size: 20),
                    SizedBox(width: 4),
                    Text(
                      "$likes Likes",
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[800]),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Exam': return Colors.red;
      case 'Holiday': return Colors.green;
      case 'Event': return Colors.blue;
      case 'Assignment': return Colors.orange;
      case 'Program': return Colors.deepPurple;
      case 'Birthday': return Colors.pink;
      default: return Colors.grey;
    }
  }
}
