import 'dart:convert';
import 'dart:io' show File; // Guarded usage (not executed on web)
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  /// Load scan history from local storage
  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedHistory = prefs.getStringList('scan_history') ?? [];

      final List<Map<String, dynamic>> parsed = [];
      for (final h in savedHistory) {
        try {
          final decoded = jsonDecode(h);
          if (decoded is Map<String, dynamic>) {
            parsed.add(_normalizeRecord(decoded));
          }
        } catch (_) {
          // Skip corrupt entry silently
          continue;
        }
      }

      setState(() {
        _history = parsed.reversed.toList(); // Latest first
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to load history: ${e.toString()}');
    }
  }

  /// Normalize legacy/new record formats into a unified shape for rendering
  Map<String, dynamic> _normalizeRecord(Map<String, dynamic> raw) {
    // Extract base fields with fallbacks
    final String woodType = (raw['wood_type'] ?? raw['predicted_class'] ?? raw['prediction'] ?? 'Unknown').toString();
    final double confidenceRaw = (raw['confidence'] is num)
        ? (raw['confidence'] as num).toDouble()
        : 0.0;
    // Some records store 0..1, convert to percentage
    final double confidence = confidenceRaw <= 1.0 ? confidenceRaw * 100.0 : confidenceRaw;

    // Timestamp can be ISO string or epoch milliseconds
    String? tsString;
    final ts = raw['timestamp'];
    if (ts is String) {
      tsString = ts;
    } else if (ts is int) {
      tsString = DateTime.fromMillisecondsSinceEpoch(ts).toIso8601String();
    }

    // Suggested use fallback
    final String suggested = (raw['suggested_use'] ?? _suggestUseFor(woodType)).toString();

    return {
      'wood_type': woodType,
      'prediction': (raw['prediction'] ?? woodType).toString(),
      'suggested_use': suggested,
      'confidence': confidence.clamp(0, 100),
      'imagePath': raw['imagePath'],
      'timestamp': tsString,
    };
  }

  String _suggestUseFor(String woodType) {
    final s = woodType.toLowerCase();
    if (s.contains('mahogany') || s.contains('narra') || s.contains('walnut') || s.contains('oak')) return 'Furniture';
    if (s.contains('pine') || s.contains('fir')) return 'Construction';
    if (s.contains('cedar') || s.contains('teak')) return 'Outdoor';
    return 'General';
  }

  /// Safe thumbnail builder that works on all platforms
  Widget _buildThumbnail(dynamic imagePath) {
    try {
      if (imagePath is String && imagePath.isNotEmpty) {
        if (kIsWeb) {
          return Image.network(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, color: Colors.grey, size: 30),
          );
        } else {
          final file = File(imagePath);
          if (file.existsSync()) {
            return Image.file(
              file,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.grey, size: 30),
            );
          }
        }
      }
    } catch (_) {}
    return const Icon(Icons.image_not_supported, color: Colors.grey, size: 30);
  }

  /// Safe detail image builder
  Widget _buildDetailImage(dynamic imagePath) {
    try {
      if (imagePath is String && imagePath.isNotEmpty) {
        if (kIsWeb) {
          return Image.network(
            imagePath,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
          );
        } else {
          final file = File(imagePath);
          if (file.existsSync()) {
            return Image.file(
              file,
              height: 200,
              fit: BoxFit.cover,
            );
          }
        }
      }
    } catch (_) {}
    return const Icon(Icons.image_not_supported, color: Colors.grey, size: 40);
  }

  /// Clear all scan history
  Future<void> _clearHistory() async {
    final confirmed = await _showConfirmationDialog();
    if (!confirmed) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('scan_history');
      setState(() {
        _history.clear();
      });
      _showSuccessSnackBar('History cleared successfully');
    } catch (e) {
      _showErrorSnackBar('Failed to clear history: ${e.toString()}');
    }
  }

  /// Show confirmation dialog for clearing history
  Future<bool> _showConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear all scan history? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    ) ?? false;
  }

  /// Show error message
  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// Show success message
  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Format timestamp for display
  String _formatTimestamp(String? timestamp) {
    if (timestamp == null) return 'Unknown time';
    
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown time';
    }
  }

  /// Get confidence color based on value
  Color _getConfidenceColor(double confidence) {
    if (confidence > 80) return Colors.green;
    if (confidence > 60) return Colors.lightGreen;
    if (confidence > 40) return Colors.orange;
    if (confidence > 20) return Colors.red;
    return Colors.red[700]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan History"),
        centerTitle: true,
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearHistory,
              tooltip: 'Clear all history',
            ),
        ],
      ),
      body: _isLoading
          ? _buildSkeletonList()
          : _history.isEmpty
              ? _buildEmptyState()
              : _buildHistoryList(),
    );
  }

  /// Build empty state widget
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No scan history yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start scanning wood to see your history here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.camera_alt),
            label: const Text('Start Scanning'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// Build history list
  Widget _buildHistoryList() {
    return RefreshIndicator(
      onRefresh: _loadHistory,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final item = _history[index];
          return _buildHistoryCard(item, index);
        },
      ),
    );
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: 6,
      itemBuilder: (_, __) => _buildSkeletonCard(),
    );
  }

  Widget _buildSkeletonCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 60,
                height: 60,
                color: Colors.grey[200],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _skeletonLine(width: 160),
                  const SizedBox(height: 8),
                  _skeletonLine(width: 220),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _skeletonDot(),
                      const SizedBox(width: 6),
                      _skeletonLine(width: 80),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _skeletonLine({double width = 120, double height = 12}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _skeletonDot() {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  /// Build individual history card
  Widget _buildHistoryCard(Map<String, dynamic> item, int index) {
    final confidence = (item['confidence'] ?? 0).toDouble();
    final confidenceColor = _getConfidenceColor(confidence);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showDetailDialog(item),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[200],
                  child: _buildThumbnail(item['imagePath']),
                ),
              ),
              const SizedBox(width: 12),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['wood_type'] ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: confidenceColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: confidenceColor, width: 1),
                          ),
                          child: Text(
                            '${confidence.toInt()}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: confidenceColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['prediction'] ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTimestamp(item['timestamp']),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Arrow icon
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show detailed view dialog
  void _showDetailDialog(Map<String, dynamic> item) {
    final confidence = (item['confidence'] ?? 0).toDouble();
    final confidenceColor = _getConfidenceColor(confidence);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.forest, color: Colors.brown, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Scan Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(height: 24),
              
              // Image
              if (item['imagePath'] != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildDetailImage(item['imagePath']),
                  ),
                ),
              const SizedBox(height: 16),
              
              // Details
              _buildDetailRow('Wood Type', item['wood_type'] ?? 'Unknown', Icons.category),
              const SizedBox(height: 12),
              _buildDetailRow('Prediction', item['prediction'] ?? 'Unknown', Icons.psychology),
              const SizedBox(height: 12),
              _buildDetailRow('Suggested Use', item['suggested_use'] ?? 'Unknown', Icons.build),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  const Icon(Icons.trending_up, size: 20, color: Colors.brown),
                  const SizedBox(width: 12),
                  Text(
                    'Confidence: ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: confidenceColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: confidenceColor, width: 1),
                    ),
                    child: Text(
                      '${confidence.toInt()}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: confidenceColor,
                      ),
                    ),
                  ),
                ],
              ),
              
              if (item['timestamp'] != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 20, color: Colors.brown),
                    const SizedBox(width: 12),
                    Text(
                      'Scanned ${_formatTimestamp(item['timestamp'])}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Build detail row for dialog
  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.brown),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
