import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'offline_manager.dart';

/// Widget to display offline status and sync information
class OfflineStatusWidget extends StatefulWidget {
  final VoidCallback? onSyncTap;
  final bool showDetails;

  const OfflineStatusWidget({
    Key? key,
    this.onSyncTap,
    this.showDetails = false,
  }) : super(key: key);

  @override
  State<OfflineStatusWidget> createState() => _OfflineStatusWidgetState();
}

class _OfflineStatusWidgetState extends State<OfflineStatusWidget> {
  final OfflineManager _offlineManager = OfflineManager();
  final SyncManager _syncManager = SyncManager();
  late Future<bool> _isOnlineFuture;
  late Future<Map<String, dynamic>> _syncStatusFuture;

  @override
  void initState() {
    super.initState();
    _refreshStatus();
  }

  void _refreshStatus() {
    setState(() {
      _isOnlineFuture = _offlineManager.isOnline();
      _syncStatusFuture = _syncManager.getSyncStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isOnlineFuture,
      builder: (context, snapshot) {
        final isOnline = snapshot.data ?? true;

        if (isOnline && !widget.showDetails) {
          return SizedBox.shrink();
        }

        return FutureBuilder<Map<String, dynamic>>(
          future: _syncStatusFuture,
          builder: (context, syncSnapshot) {
            final syncStatus = syncSnapshot.data ?? {};
            final queuedScans = syncStatus['queued_scans'] as int? ?? 0;
            final isSyncing = syncStatus['is_syncing'] as bool? ?? false;

            if (isOnline) {
              return _buildOnlineStatus(syncStatus, queuedScans, isSyncing);
            } else {
              return _buildOfflineStatus(syncStatus, queuedScans);
            }
          },
        );
      },
    );
  }

  Widget _buildOfflineStatus(Map<String, dynamic> syncStatus, int queuedScans) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE17055).withOpacity(0.1),
            Color(0xFFFF6B6B).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFFE17055),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFE17055).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.cloud_off_rounded,
                  color: Color(0xFFE17055),
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OFFLINE MODE',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFE17055),
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      'No internet connection',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF636E72),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (queuedScans > 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFFE17055),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$queuedScans pending',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xFFE17055).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFF636E72),
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Your scans are being saved locally and will sync when you\'re back online.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF636E72),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: Color(0xFF00B894),
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Wood species data is cached',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF00B894),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: Color(0xFF00B894),
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Furniture guides available offline',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF00B894),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnlineStatus(
    Map<String, dynamic> syncStatus,
    int queuedScans,
    bool isSyncing,
  ) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF00B894).withOpacity(0.1),
            Color(0xFF00D2A7).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFF00B894),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFF00B894).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.cloud_done_rounded,
                  color: Color(0xFF00B894),
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ONLINE',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF00B894),
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      isSyncing ? 'Syncing...' : 'Connected',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF636E72),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (queuedScans > 0)
                GestureDetector(
                  onTap: widget.onSyncTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFF00B894),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSyncing)
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        else
                          Icon(
                            Icons.cloud_upload_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        SizedBox(width: 6),
                        Text(
                          'Sync $queuedScans',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          if (queuedScans > 0) ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFF636E72),
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$queuedScans scan(s) ready to sync',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF636E72),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Detailed offline statistics screen
class OfflineStatsScreen extends StatefulWidget {
  @override
  State<OfflineStatsScreen> createState() => _OfflineStatsScreenState();
}

class _OfflineStatsScreenState extends State<OfflineStatsScreen> {
  final OfflineManager _offlineManager = OfflineManager();
  late Future<Map<String, dynamic>> _statsFuture;

  @override
  void initState() {
    super.initState();
    _refreshStats();
  }

  void _refreshStats() {
    setState(() {
      _statsFuture = _offlineManager.getCacheStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'OFFLINE DATA',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: Color(0xFF2D3436),
          ),
        ),
        backgroundColor: Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF636E72)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _statsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B894)),
              ),
            );
          }

          final stats = snapshot.data ?? {};

          return SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cache Overview
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.storage_rounded,
                            color: Color(0xFF74B9FF),
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Cache Overview',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      _buildStatRow(
                        'Wood Species Cached',
                        '${stats['wood_species_cached'] ?? 0}',
                        Icons.park_rounded,
                        Color(0xFF8B4513),
                      ),
                      SizedBox(height: 12),
                      _buildStatRow(
                        'Furniture Guides',
                        '${stats['furniture_guides_cached'] ?? 0}',
                        Icons.chair_rounded,
                        Color(0xFF6C5CE7),
                      ),
                      SizedBox(height: 12),
                      _buildStatRow(
                        'Cache Size',
                        '${stats['cache_size_estimate'] ?? 'Unknown'}',
                        Icons.sd_card_rounded,
                        Color(0xFF74B9FF),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Scan Queue
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.cloud_queue_rounded,
                            color: Color(0xFF00B894),
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Scan Queue',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      _buildStatRow(
                        'Queued Scans',
                        '${stats['queued_scans'] ?? 0}',
                        Icons.pending_actions_rounded,
                        Color(0xFFFFB74D),
                      ),
                      SizedBox(height: 12),
                      _buildStatRow(
                        'Synced Scans',
                        '${stats['synced_scans'] ?? 0}',
                        Icons.check_circle_rounded,
                        Color(0xFF00B894),
                      ),
                      SizedBox(height: 12),
                      _buildStatRow(
                        'Total Scans',
                        '${stats['total_scans'] ?? 0}',
                        Icons.image_rounded,
                        Color(0xFF74B9FF),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Actions
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.settings_rounded,
                            color: Color(0xFF636E72),
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Actions',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await _offlineManager.clearOldCacheEntries();
                          _refreshStats();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Cleared old cache entries'),
                              backgroundColor: Color(0xFF00B894),
                            ),
                          );
                        },
                        icon: Icon(Icons.delete_outline_rounded),
                        label: Text('Clear Old Cache (>30 days)'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFB74D),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await _offlineManager.clearAllOfflineData();
                          _refreshStats();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Cleared all offline data'),
                              backgroundColor: Color(0xFFE17055),
                            ),
                          );
                        },
                        icon: Icon(Icons.delete_forever_rounded),
                        label: Text('Clear All Data'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE17055),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF636E72),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
