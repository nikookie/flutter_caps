import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Manages offline functionality including caching, queuing, and syncing
class OfflineManager {
  static const String _woodSpeciesCacheKey = 'wood_species_cache';
  static const String _scanQueueKey = 'scan_queue';
  static const String _furnitureGuidesKey = 'furniture_guides_cache';
  static const String _lastSyncKey = 'last_sync_timestamp';
  static const String _pendingSyncsKey = 'pending_syncs';

  static final OfflineManager _instance = OfflineManager._internal();

  factory OfflineManager() {
    return _instance;
  }

  OfflineManager._internal();

  late SharedPreferences _prefs;
  final Connectivity _connectivity = Connectivity();

  /// Initialize the offline manager
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Check if device is online
  Future<bool> isOnline() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      print('Error checking connectivity: $e');
      return false;
    }
  }

  /// Cache wood species data
  Future<void> cacheWoodSpeciesData(Map<String, dynamic> woodData) async {
    try {
      final cache = _getExistingCache(_woodSpeciesCacheKey);
      final woodType = woodData['name']?.toString().toLowerCase() ?? 'unknown';
      cache[woodType] = {
        ...woodData,
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      };
      await _prefs.setString(_woodSpeciesCacheKey, jsonEncode(cache));
      print('✅ Cached wood species: $woodType');
    } catch (e) {
      print('❌ Error caching wood species: $e');
    }
  }

  /// Get cached wood species data
  Future<Map<String, dynamic>?> getCachedWoodSpecies(String woodType) async {
    try {
      final cache = _getExistingCache(_woodSpeciesCacheKey);
      final normalized = woodType.toLowerCase();
      if (cache.containsKey(normalized)) {
        return cache[normalized] as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('❌ Error retrieving cached wood species: $e');
      return null;
    }
  }

  /// Cache all wood species data
  Future<void> cacheAllWoodSpecies(List<Map<String, dynamic>> allWoodData) async {
    try {
      final cache = <String, dynamic>{};
      for (final wood in allWoodData) {
        final woodType = wood['name']?.toString().toLowerCase() ?? 'unknown';
        cache[woodType] = {
          ...wood,
          'cached_at': DateTime.now().millisecondsSinceEpoch,
        };
      }
      await _prefs.setString(_woodSpeciesCacheKey, jsonEncode(cache));
      print('✅ Cached ${allWoodData.length} wood species');
    } catch (e) {
      print('❌ Error caching all wood species: $e');
    }
  }

  /// Queue a scan for later upload
  Future<void> queueScan(Map<String, dynamic> scanData) async {
    try {
      final queue = _getExistingQueue(_scanQueueKey);
      final scanId = DateTime.now().millisecondsSinceEpoch.toString();
      queue[scanId] = {
        ...scanData,
        'queued_at': DateTime.now().millisecondsSinceEpoch,
        'synced': false,
        'sync_attempts': 0,
      };
      await _prefs.setString(_scanQueueKey, jsonEncode(queue));
      print('✅ Queued scan: $scanId');
    } catch (e) {
      print('❌ Error queuing scan: $e');
    }
  }

  /// Get all queued scans
  Future<List<Map<String, dynamic>>> getQueuedScans() async {
    try {
      final queue = _getExistingQueue(_scanQueueKey);
      return queue.values
          .cast<Map<String, dynamic>>()
          .where((scan) => !(scan['synced'] as bool? ?? false))
          .toList();
    } catch (e) {
      print('❌ Error retrieving queued scans: $e');
      return [];
    }
  }

  /// Mark scan as synced
  Future<void> markScanAsSynced(String scanId) async {
    try {
      final queue = _getExistingQueue(_scanQueueKey);
      if (queue.containsKey(scanId)) {
        final scan = queue[scanId] as Map<String, dynamic>;
        scan['synced'] = true;
        scan['synced_at'] = DateTime.now().millisecondsSinceEpoch;
        await _prefs.setString(_scanQueueKey, jsonEncode(queue));
        print('✅ Marked scan as synced: $scanId');
      }
    } catch (e) {
      print('❌ Error marking scan as synced: $e');
    }
  }

  /// Increment sync attempts for a scan
  Future<void> incrementSyncAttempts(String scanId) async {
    try {
      final queue = _getExistingQueue(_scanQueueKey);
      if (queue.containsKey(scanId)) {
        final scan = queue[scanId] as Map<String, dynamic>;
        scan['sync_attempts'] = (scan['sync_attempts'] as int? ?? 0) + 1;
        await _prefs.setString(_scanQueueKey, jsonEncode(queue));
      }
    } catch (e) {
      print('❌ Error incrementing sync attempts: $e');
    }
  }

  /// Cache furniture guides
  Future<void> cacheFurnitureGuides(List<Map<String, dynamic>> guides) async {
    try {
      final cache = <String, dynamic>{};
      for (final guide in guides) {
        final guideId = guide['id']?.toString() ?? 'unknown';
        cache[guideId] = {
          ...guide,
          'cached_at': DateTime.now().millisecondsSinceEpoch,
        };
      }
      await _prefs.setString(_furnitureGuidesKey, jsonEncode(cache));
      print('✅ Cached ${guides.length} furniture guides');
    } catch (e) {
      print('❌ Error caching furniture guides: $e');
    }
  }

  /// Get cached furniture guides
  Future<List<Map<String, dynamic>>> getCachedFurnitureGuides() async {
    try {
      final cache = _getExistingCache(_furnitureGuidesKey);
      return cache.values.cast<Map<String, dynamic>>().toList();
    } catch (e) {
      print('❌ Error retrieving cached furniture guides: $e');
      return [];
    }
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    try {
      final woodCache = _getExistingCache(_woodSpeciesCacheKey);
      final scanQueue = _getExistingQueue(_scanQueueKey);
      final furnitureCache = _getExistingCache(_furnitureGuidesKey);

      final queuedScans = scanQueue.values
          .cast<Map<String, dynamic>>()
          .where((scan) => !(scan['synced'] as bool? ?? false))
          .length;

      final syncedScans = scanQueue.values
          .cast<Map<String, dynamic>>()
          .where((scan) => (scan['synced'] as bool? ?? false))
          .length;

      return {
        'wood_species_cached': woodCache.length,
        'furniture_guides_cached': furnitureCache.length,
        'queued_scans': queuedScans,
        'synced_scans': syncedScans,
        'total_scans': scanQueue.length,
        'last_sync': _prefs.getInt(_lastSyncKey) ?? 0,
        'cache_size_estimate': _estimateCacheSize(),
      };
    } catch (e) {
      print('❌ Error getting cache stats: $e');
      return {};
    }
  }

  /// Clear all offline data
  Future<void> clearAllOfflineData() async {
    try {
      await _prefs.remove(_woodSpeciesCacheKey);
      await _prefs.remove(_scanQueueKey);
      await _prefs.remove(_furnitureGuidesKey);
      await _prefs.remove(_lastSyncKey);
      await _prefs.remove(_pendingSyncsKey);
      print('✅ Cleared all offline data');
    } catch (e) {
      print('❌ Error clearing offline data: $e');
    }
  }

  /// Clear old cache entries (older than specified days)
  Future<void> clearOldCacheEntries({int olderThanDays = 30}) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final cutoffTime = now - (olderThanDays * 24 * 60 * 60 * 1000);

      // Clear old wood species cache
      final woodCache = _getExistingCache(_woodSpeciesCacheKey);
      woodCache.removeWhere((key, value) {
        final cachedAt = (value as Map<String, dynamic>)['cached_at'] as int? ?? 0;
        return cachedAt < cutoffTime;
      });
      await _prefs.setString(_woodSpeciesCacheKey, jsonEncode(woodCache));

      // Clear old furniture guides cache
      final furnitureCache = _getExistingCache(_furnitureGuidesKey);
      furnitureCache.removeWhere((key, value) {
        final cachedAt = (value as Map<String, dynamic>)['cached_at'] as int? ?? 0;
        return cachedAt < cutoffTime;
      });
      await _prefs.setString(_furnitureGuidesKey, jsonEncode(furnitureCache));

      print('✅ Cleared cache entries older than $olderThanDays days');
    } catch (e) {
      print('❌ Error clearing old cache entries: $e');
    }
  }

  /// Update last sync timestamp
  Future<void> updateLastSyncTime() async {
    try {
      await _prefs.setInt(_lastSyncKey, DateTime.now().millisecondsSinceEpoch);
      print('✅ Updated last sync time');
    } catch (e) {
      print('❌ Error updating last sync time: $e');
    }
  }

  /// Get pending syncs
  Future<List<String>> getPendingSyncs() async {
    try {
      final pendingSyncs = _prefs.getStringList(_pendingSyncsKey) ?? [];
      return pendingSyncs;
    } catch (e) {
      print('❌ Error getting pending syncs: $e');
      return [];
    }
  }

  /// Add pending sync
  Future<void> addPendingSync(String scanId) async {
    try {
      final pendingSyncs = _prefs.getStringList(_pendingSyncsKey) ?? [];
      if (!pendingSyncs.contains(scanId)) {
        pendingSyncs.add(scanId);
        await _prefs.setStringList(_pendingSyncsKey, pendingSyncs);
      }
    } catch (e) {
      print('❌ Error adding pending sync: $e');
    }
  }

  /// Remove pending sync
  Future<void> removePendingSync(String scanId) async {
    try {
      final pendingSyncs = _prefs.getStringList(_pendingSyncsKey) ?? [];
      pendingSyncs.remove(scanId);
      await _prefs.setStringList(_pendingSyncsKey, pendingSyncs);
    } catch (e) {
      print('❌ Error removing pending sync: $e');
    }
  }

  // Helper methods
  Map<String, dynamic> _getExistingCache(String key) {
    try {
      final cached = _prefs.getString(key);
      if (cached != null) {
        return jsonDecode(cached) as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error decoding cache: $e');
    }
    return {};
  }

  Map<String, dynamic> _getExistingQueue(String key) {
    try {
      final cached = _prefs.getString(key);
      if (cached != null) {
        return jsonDecode(cached) as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error decoding queue: $e');
    }
    return {};
  }

  String _estimateCacheSize() {
    try {
      final woodCache = _prefs.getString(_woodSpeciesCacheKey)?.length ?? 0;
      final scanQueue = _prefs.getString(_scanQueueKey)?.length ?? 0;
      final furnitureCache = _prefs.getString(_furnitureGuidesKey)?.length ?? 0;
      final totalBytes = woodCache + scanQueue + furnitureCache;
      
      if (totalBytes < 1024) {
        return '${totalBytes}B';
      } else if (totalBytes < 1024 * 1024) {
        return '${(totalBytes / 1024).toStringAsFixed(2)}KB';
      } else {
        return '${(totalBytes / (1024 * 1024)).toStringAsFixed(2)}MB';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}

/// Sync manager for handling offline data synchronization
class SyncManager {
  static final SyncManager _instance = SyncManager._internal();

  factory SyncManager() {
    return _instance;
  }

  SyncManager._internal();

  final OfflineManager _offlineManager = OfflineManager();
  bool _isSyncing = false;

  bool get isSyncing => _isSyncing;

  /// Attempt to sync all pending scans
  Future<Map<String, dynamic>> syncPendingScans({
    required Future<bool> Function(Map<String, dynamic>) uploadScan,
  }) async {
    if (_isSyncing) {
      return {'success': false, 'message': 'Sync already in progress'};
    }

    _isSyncing = true;
    int successCount = 0;
    int failureCount = 0;
    final failedScans = <String>[];

    try {
      final isOnline = await _offlineManager.isOnline();
      if (!isOnline) {
        return {
          'success': false,
          'message': 'Device is offline',
          'synced': 0,
          'failed': 0,
        };
      }

      final queuedScans = await _offlineManager.getQueuedScans();

      for (final scan in queuedScans) {
        try {
          final scanId = scan['queued_at'].toString();
          final success = await uploadScan(scan);

          if (success) {
            await _offlineManager.markScanAsSynced(scanId);
            await _offlineManager.removePendingSync(scanId);
            successCount++;
            print('✅ Synced scan: $scanId');
          } else {
            await _offlineManager.incrementSyncAttempts(scanId);
            failureCount++;
            failedScans.add(scanId);
            print('❌ Failed to sync scan: $scanId');
          }
        } catch (e) {
          failureCount++;
          print('❌ Error syncing scan: $e');
        }
      }

      await _offlineManager.updateLastSyncTime();

      return {
        'success': failureCount == 0,
        'message': 'Sync completed: $successCount synced, $failureCount failed',
        'synced': successCount,
        'failed': failureCount,
        'failed_scans': failedScans,
      };
    } catch (e) {
      print('❌ Sync error: $e');
      return {
        'success': false,
        'message': 'Sync failed: $e',
        'synced': successCount,
        'failed': failureCount,
      };
    } finally {
      _isSyncing = false;
    }
  }

  /// Get sync status
  Future<Map<String, dynamic>> getSyncStatus() async {
    final stats = await _offlineManager.getCacheStats();
    final isOnline = await _offlineManager.isOnline();

    return {
      'is_online': isOnline,
      'is_syncing': _isSyncing,
      'queued_scans': stats['queued_scans'] ?? 0,
      'synced_scans': stats['synced_scans'] ?? 0,
      'last_sync': stats['last_sync'] ?? 0,
      'cache_size': stats['cache_size_estimate'] ?? 'Unknown',
    };
  }
}
