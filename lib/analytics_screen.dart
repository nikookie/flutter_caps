import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  List<Map<String, dynamic>> _scanHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScanHistory();
  }

  Future<void> _loadScanHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('scan_history') ?? [];
    
    setState(() {
      _scanHistory = history
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList()
          .reversed
          .toList();
      _isLoading = false;
    });
  }

  Map<String, int> _getWoodTypeCount() {
    Map<String, int> count = {};
    for (var scan in _scanHistory) {
      final woodType = scan['predicted_class']?.toString() ?? 'Unknown';
      count[woodType] = (count[woodType] ?? 0) + 1;
    }
    return count;
  }

  double _getAverageConfidence() {
    if (_scanHistory.isEmpty) return 0.0;
    double total = 0;
    for (var scan in _scanHistory) {
      total += (scan['confidence'] ?? 0.0) as double;
    }
    return total / _scanHistory.length;
  }

  // Calculate average quality score based on confidence
  double _getAverageQualityScore() {
    if (_scanHistory.isEmpty) return 0.0;
    double total = 0;
    for (var scan in _scanHistory) {
      final confidence = (scan['confidence'] ?? 0.0) as double;
      // Convert confidence to quality score (0-100)
      total += confidence * 100;
    }
    return total / _scanHistory.length;
  }

  // Get most common wood type
  String _getMostCommonWoodType() {
    if (_scanHistory.isEmpty) return 'N/A';
    final counts = _getWoodTypeCount();
    if (counts.isEmpty) return 'N/A';
    
    String mostCommon = '';
    int maxCount = 0;
    counts.forEach((wood, count) {
      if (count > maxCount) {
        maxCount = count;
        mostCommon = wood;
      }
    });
    return mostCommon;
  }

  // Get scan accuracy trend data (last 7 scans)
  List<FlSpot> _getScanAccuracyTrend() {
    List<FlSpot> spots = [];
    final recentScans = _scanHistory.take(7).toList();
    
    for (int i = 0; i < recentScans.length; i++) {
      final confidence = (recentScans[i]['confidence'] ?? 0.0) as double;
      spots.add(FlSpot(i.toDouble(), confidence * 100));
    }
    
    return spots.reversed.toList();
  }

  // Get pie chart data for wood distribution
  List<PieChartSectionData> _getPieChartSections() {
    final woodCounts = _getWoodTypeCount();
    final colors = [
      Color(0xFF8B4513),
      Color(0xFF00B894),
      Color(0xFF74B9FF),
      Color(0xFF6C5CE7),
      Color(0xFFFFB74D),
      Color(0xFFE17055),
      Color(0xFF00D2A7),
      Color(0xFF0984E3),
    ];

    List<PieChartSectionData> sections = [];
    int colorIndex = 0;

    woodCounts.forEach((woodType, count) {
      final percentage = (_scanHistory.length > 0)
          ? (count / _scanHistory.length * 100)
          : 0.0;

      sections.add(
        PieChartSectionData(
          color: colors[colorIndex % colors.length],
          value: percentage,
          title: '${percentage.toStringAsFixed(0)}%',
          radius: 60,
          titleStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      );
      colorIndex++;
    });

    return sections;
  }

  // Get top 3 wood types
  List<MapEntry<String, int>> _getTopWoodTypes() {
    final counts = _getWoodTypeCount();
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ANALYTICS",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: Color(0xFF2D3436),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: Color(0xFF636E72),
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B894)),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary Cards
                      _buildSummaryCard(
                        title: "Total Scans",
                        value: _scanHistory.length.toString(),
                        icon: FontAwesomeIcons.chartLine,
                        color: Color(0xFF00B894),
                      ),
                      SizedBox(height: 16),
                      _buildSummaryCard(
                        title: "Average Confidence",
                        value: "${(_getAverageConfidence() * 100).toStringAsFixed(1)}%",
                        icon: FontAwesomeIcons.bullseye,
                        color: Color(0xFF74B9FF),
                      ),
                      SizedBox(height: 16),
                      _buildSummaryCard(
                        title: "Unique Species",
                        value: _getWoodTypeCount().length.toString(),
                        icon: FontAwesomeIcons.leaf,
                        color: Color(0xFF6C5CE7),
                      ),
                      SizedBox(height: 16),
                      _buildSummaryCard(
                        title: "Quality Score Average",
                        value: "${_getAverageQualityScore().toStringAsFixed(1)}/100",
                        icon: FontAwesomeIcons.star,
                        color: Color(0xFFFFB74D),
                      ),
                      SizedBox(height: 30),

                      // Wood Type Distribution Pie Chart
                      if (_getWoodTypeCount().isNotEmpty)
                        _buildPieChartSection(),
                      SizedBox(height: 30),

                      // Scan Accuracy Trends
                      if (_scanHistory.isNotEmpty)
                        _buildAccuracyTrendSection(),
                      SizedBox(height: 30),

                      // Most Common Wood Types
                      if (_getWoodTypeCount().isNotEmpty)
                        _buildMostCommonWoodSection(),
                      SizedBox(height: 30),

                      // Quality Score Breakdown
                      if (_scanHistory.isNotEmpty)
                        _buildQualityScoreSection(),
                      SizedBox(height: 30),

                      // Traditional Bar Chart Distribution
                      if (_getWoodTypeCount().isNotEmpty)
                        _buildBarChartDistribution(),
                      SizedBox(height: 30),

                      // Empty State
                      if (_scanHistory.isEmpty)
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.analytics_outlined,
                                size: 64,
                                color: Color(0xFFE2E8F0),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "No scan data available",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF636E72),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Start scanning wood samples to see analytics",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF95A5A6),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: FaIcon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF636E72),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChartSection() {
    final woodCounts = _getWoodTypeCount();
    final colors = [
      Color(0xFF8B4513),
      Color(0xFF00B894),
      Color(0xFF74B9FF),
      Color(0xFF6C5CE7),
      Color(0xFFFFB74D),
      Color(0xFFE17055),
      Color(0xFF00D2A7),
      Color(0xFF0984E3),
    ];

    return Container(
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
              Icon(Icons.pie_chart_rounded, color: Color(0xFF8B4513), size: 24),
              SizedBox(width: 12),
              Text(
                "Wood Type Distribution",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3436),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: PieChart(
              PieChartData(
                sections: _getPieChartSections(),
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
          SizedBox(height: 20),
          // Legend
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: List.generate(woodCounts.length, (index) {
              final entry = woodCounts.entries.toList()[index];
              final percentage = (_scanHistory.length > 0)
                  ? (entry.value / _scanHistory.length * 100)
                  : 0.0;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: colors[index % colors.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "${entry.key}: ${percentage.toStringAsFixed(1)}%",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF636E72),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAccuracyTrendSection() {
    final trendData = _getScanAccuracyTrend();
    
    return Container(
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
              Icon(Icons.trending_up_rounded, color: Color(0xFF00B894), size: 24),
              SizedBox(width: 12),
              Text(
                "Scan Accuracy Trends",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3436),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            "Last ${trendData.length} scans",
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF636E72),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 20,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Color(0xFFE2E8F0),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Color(0xFFE2E8F0),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: TextStyle(
                            color: Color(0xFF636E72),
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: TextStyle(
                            color: Color(0xFF636E72),
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
                minX: 0,
                maxX: (trendData.length - 1).toDouble(),
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: trendData,
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [Color(0xFF00B894), Color(0xFF00D2A7)],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF00B894).withOpacity(0.3),
                          Color(0xFF00B894).withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF00B894).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFF00B894), size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Accuracy improves with consistent scanning and proper lighting",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF636E72),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMostCommonWoodSection() {
    final topWoods = _getTopWoodTypes();
    
    return Container(
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
              Icon(Icons.location_on_rounded, color: Color(0xFF6C5CE7), size: 24),
              SizedBox(width: 12),
              Text(
                "Most Common Wood Types in Your Area",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3436),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ...List.generate(topWoods.length, (index) {
            final entry = topWoods[index];
            final percentage = (_scanHistory.length > 0)
                ? (entry.value / _scanHistory.length * 100)
                : 0.0;
            
            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: [Color(0xFF8B4513), Color(0xFF00B894), Color(0xFF74B9FF)][index].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: [Color(0xFF8B4513), Color(0xFF00B894), Color(0xFF74B9FF)][index],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2D3436),
                                ),
                              ),
                              Text(
                                '${entry.value} scans',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF636E72),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: [Color(0xFF8B4513), Color(0xFF00B894), Color(0xFF74B9FF)][index].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: [Color(0xFF8B4513), Color(0xFF00B894), Color(0xFF74B9FF)][index],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: percentage / 100,
                      child: Container(
                        decoration: BoxDecoration(
                          color: [Color(0xFF8B4513), Color(0xFF00B894), Color(0xFF74B9FF)][index],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildQualityScoreSection() {
    final avgQuality = _getAverageQualityScore();
    final woodCounts = _getWoodTypeCount();
    
    // Calculate quality score for each wood type
    Map<String, double> woodQualityScores = {};
    for (var scan in _scanHistory) {
      final woodType = scan['predicted_class']?.toString() ?? 'Unknown';
      final confidence = (scan['confidence'] ?? 0.0) as double;
      
      if (!woodQualityScores.containsKey(woodType)) {
        woodQualityScores[woodType] = 0;
      }
      woodQualityScores[woodType] = woodQualityScores[woodType]! + confidence;
    }
    
    // Average the scores
    woodQualityScores.forEach((key, value) {
      woodQualityScores[key] = (value / (woodCounts[key] ?? 1)) * 100;
    });

    return Container(
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
              Icon(Icons.grade_rounded, color: Color(0xFFFFB74D), size: 24),
              SizedBox(width: 12),
              Text(
                "Quality Score Averages",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3436),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            "Overall Average: ${avgQuality.toStringAsFixed(1)}/100",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF636E72),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: avgQuality / 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFB74D), Color(0xFF00B894)],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "By Wood Type",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D3436),
            ),
          ),
          SizedBox(height: 12),
          ...woodQualityScores.entries.map((entry) {
            final score = entry.value;
            Color scoreColor;
            if (score >= 80) {
              scoreColor = Color(0xFF00B894);
            } else if (score >= 60) {
              scoreColor = Color(0xFF74B9FF);
            } else if (score >= 40) {
              scoreColor = Color(0xFFFFB74D);
            } else {
              scoreColor = Color(0xFFE17055);
            }

            return Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: score / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            color: scoreColor,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '${score.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: scoreColor,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildBarChartDistribution() {
    final woodCounts = _getWoodTypeCount();
    final sortedEntries = woodCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
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
              Icon(Icons.bar_chart_rounded, color: Color(0xFF74B9FF), size: 24),
              SizedBox(width: 12),
              Text(
                "Scan Count by Wood Type",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3436),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ...sortedEntries.map((entry) {
            final percentage = (_scanHistory.length > 0)
                ? (entry.value / _scanHistory.length * 100)
                : 0.0;
            
            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3436),
                        ),
                      ),
                      Text(
                        "${entry.value} (${percentage.toStringAsFixed(1)}%)",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF636E72),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: percentage / 100,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF00B894), Color(0xFF00D2A7)],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
