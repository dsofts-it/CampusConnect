import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/services/api_service.dart';

class UpdateCard extends StatefulWidget {
  final Map<String, dynamic> update;

  const UpdateCard({Key? key, required this.update}) : super(key: key);

  @override
  _UpdateCardState createState() => _UpdateCardState();
}

class _UpdateCardState extends State<UpdateCard> {
  late int _likeCount;
  late bool _isLiked;
  bool _isLiking = false;

  @override
  void initState() {
    super.initState();
    _likeCount = (widget.update['likes'] is List) ? widget.update['likes'].length : 0;
    _isLiked = false; // You can check if current user has liked this
  }

  Future<void> _toggleLike() async {
    if (_isLiking) return; // Prevent multiple clicks
    
    setState(() {
      _isLiking = true;
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });

    try {
      final updateId = widget.update['_id'];
      await ApiService.likeUpdate(updateId);
    } catch (e) {
      // Revert on error
      setState(() {
        _isLiked = !_isLiked;
        _likeCount += _isLiked ? 1 : -1;
      });
      print('Error liking update: $e');
    } finally {
      setState(() {
        _isLiking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.update['title'] ?? 'No Title';
    final description = widget.update['description'] ?? '';
    final category = widget.update['category'] ?? 'General';
    final isImportant = widget.update['isImportant'] ?? false;
    
    // Safely handle createdBy
    String createdBy = 'Unknown';
    if (widget.update['createdBy'] != null) {
      if (widget.update['createdBy'] is Map) {
        createdBy = widget.update['createdBy']['name'] ?? 'Unknown';
      } else if (widget.update['createdBy'] is String) {
        createdBy = 'User'; 
      }
    }
    
    // Formatting dates
    String? dateRange;
    try {
      if (widget.update['startDate'] != null) {
        DateTime start = DateTime.parse(widget.update['startDate']);
        String startStr = "${start.day}/${start.month}/${start.year}";
        
        if (widget.update['endDate'] != null) {
          DateTime end = DateTime.parse(widget.update['endDate']);
          String endStr = "${end.day}/${end.month}/${end.year}";
          dateRange = "$startStr - $endStr";
        } else {
          dateRange = startStr;
        }
      }
    } catch (e) {
      print('Error parsing dates: $e');
      dateRange = null;
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  backgroundColor: _getCategoryColor(category),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                if (isImportant)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade300, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.priority_high, color: Colors.red, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'IMPORTANT',
                          style: GoogleFonts.poppins(
                            color: Colors.red.shade700,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
            if (dateRange != null)
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.deepPurple),
                    SizedBox(width: 6),
                    Text(
                      dateRange,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 10),
            Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 6),
                    Text(
                      "By $createdBy",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: _toggleLike,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                          size: 20,
                        ),
                        SizedBox(width: 6),
                        Text(
                          "$_likeCount Likes",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'exam': return Colors.red.shade600;
      case 'holiday': return Colors.green.shade600;
      case 'event': return Colors.blue.shade600;
      case 'assignment': return Colors.orange.shade600;
      case 'program': return Colors.deepPurple.shade600;
      case 'birthday': return Colors.pink.shade600;
      default: return Colors.grey.shade600;
    }
  }
}
