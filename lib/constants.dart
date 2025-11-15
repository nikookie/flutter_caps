import 'package:flutter/material.dart';

// API
// IMPORTANT: For mobile network connectivity, use your backend server's IP address
// Replace 'YOUR_BACKEND_IP' with your actual backend server IP (e.g., http://192.168.1.100:5000)
// For Android Emulator use: http://10.0.2.2:5000
// For physical device on same WiFi: http://YOUR_BACKEND_IP:5000
// For mobile network: http://YOUR_BACKEND_IP:5000 (must be publicly accessible or use VPN)
const String kDefaultApiBase = 'http://localhost:5000'; // Change this to your backend IP
const Duration kApiTimeout = Duration(seconds: 12);

// Compression
const int kImageQuality = 70; // 0..100
const int kImageMinWidth = 800;
const int kImageMinHeight = 800;

// UI
const Color kBrandColor = Colors.brown;
const Duration kShortDelay = Duration(milliseconds: 1500);

// Preferences keys
const String kPrefApiBase = 'api_base';
const String kPrefConfidence = 'confidence_threshold';
const String kPrefForceTest = 'force_test_mode';
const String kPrefHistory = 'scan_history';
































