import 'package:flutter/material.dart';

// API
const String kDefaultApiBase = 'http://10.0.2.2:5000';
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










