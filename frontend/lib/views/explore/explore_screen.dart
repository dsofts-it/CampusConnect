
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/widgets/update_card.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<dynamic> _allUpdates = [];
  List<dynamic> _filteredUpdates = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUpdates();
  }

  Future<void> _fetchUpdates() async {
    try {
      // Fetching all updates and filtering locally for now
      final response = await ApiService.getAllUpdates();
      if (mounted) {
        setState(() {
          _allUpdates = response['data'] ?? [];
          _filteredUpdates = _allUpdates;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading updates: $e')),
        );
      }
    }
  }

  void _filterUpdates(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredUpdates = _allUpdates;
      });
      return;
    }

    setState(() {
      _filteredUpdates = _allUpdates.where((update) {
        final title = (update['title'] ?? '').toString().toLowerCase();
        final description = (update['description'] ?? '').toString().toLowerCase();
        final category = (update['category'] ?? '').toString().toLowerCase();
        final q = query.toLowerCase();
        return title.contains(q) || description.contains(q) || category.contains(q);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterUpdates,
              decoration: InputDecoration(
                hintText: 'Search updates, events, exams...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredUpdates.isEmpty
                    ? Center(child: Text("No results found"))
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredUpdates.length,
                        itemBuilder: (context, index) {
                          return UpdateCard(update: _filteredUpdates[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
