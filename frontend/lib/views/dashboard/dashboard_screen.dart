import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/widgets/update_card.dart';
import 'package:frontend/services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<dynamic> _updates = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUpdates();
  }

  Future<void> _fetchUpdates() async {
    try {
      print('📡 Fetching updates from API...');
      final response = await ApiService.getAllUpdates();
      print('✅ Response received: ${response.toString()}');
      
      if (mounted) {
        setState(() {
          _updates = response['data'] ?? [];
          _isLoading = false;
          print('📊 Total updates loaded: ${_updates.length}');
        });
      }
    } catch (e) {
      print('❌ Error fetching updates: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load updates: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Campus Updates',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false, // Don't show back button
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _updates.isEmpty
                ? ListView(
                    children: [
                      SizedBox(height: 100),
                      Icon(
                        Icons.inbox_outlined,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: Text(
                          "No updates available",
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Center(
                        child: Text(
                          "Pull down to refresh",
                          style: GoogleFonts.poppins(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _updates.length,
                    itemBuilder: (context, index) {
                      final update = _updates[index];
                      return UpdateCard(update: update);
                    },
                  ),
      ),
    );
  }
}
