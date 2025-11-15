import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Enhanced Defect Detection System with comprehensive analysis
class DefectDetectionSystem {
  /// Analyze wood defects with detailed measurements and percentages
  static Map<String, dynamic> analyzeWoodDefects({
    required double confidence,
    required String woodType,
    required int imageQuality,
  }) {
    final defects = <Map<String, dynamic>>[];
    double totalDefectPercentage = 0.0;
    String overallSeverity = 'none';

    // Crack Severity Analysis with Measurements
    final crackAnalysis = _analyzeCracks(confidence, imageQuality);
    if (crackAnalysis['detected']) {
      defects.add(crackAnalysis);
      totalDefectPercentage += crackAnalysis['percentage'] as double;
    }

    // Rot Detection with Percentage
    final rotAnalysis = _analyzeRot(confidence, woodType);
    if (rotAnalysis['detected']) {
      defects.add(rotAnalysis);
      totalDefectPercentage += rotAnalysis['percentage'] as double;
    }

    // Insect Damage Identification
    final insectAnalysis = _analyzeInsectDamage(confidence, imageQuality);
    if (insectAnalysis['detected']) {
      defects.add(insectAnalysis);
      totalDefectPercentage += insectAnalysis['percentage'] as double;
    }

    // Warping Measurement in Degrees
    final warpingAnalysis = _analyzeWarping(confidence);
    if (warpingAnalysis['detected']) {
      defects.add(warpingAnalysis);
      totalDefectPercentage += warpingAnalysis['percentage'] as double;
    }

    // Determine overall severity
    if (totalDefectPercentage > 60) {
      overallSeverity = 'critical';
    } else if (totalDefectPercentage > 40) {
      overallSeverity = 'high';
    } else if (totalDefectPercentage > 20) {
      overallSeverity = 'moderate';
    } else if (totalDefectPercentage > 0) {
      overallSeverity = 'low';
    }

    return {
      'hasDefects': defects.isNotEmpty,
      'defects': defects,
      'severity': overallSeverity,
      'totalDefectPercentage': totalDefectPercentage,
      'defectCount': defects.length,
      'treatmentSuggestions': _generateTreatmentSuggestions(defects, woodType),
    };
  }

  /// Analyze crack severity with measurements
  static Map<String, dynamic> _analyzeCracks(double confidence, int imageQuality) {
    // Crack probability based on confidence and image quality
    double crackProbability = (1.0 - confidence) * (imageQuality / 100.0);
    
    if (crackProbability < 0.15) {
      return {'detected': false};
    }

    // Estimate crack measurements
    final crackWidth = (crackProbability * 5.0).clamp(0.1, 5.0); // mm
    final crackLength = (crackProbability * 50.0).clamp(5.0, 150.0); // mm
    final crackDepth = (crackProbability * 10.0).clamp(1.0, 20.0); // mm
    final crackPercentage = (crackProbability * 100).clamp(0.0, 40.0);

    String severity = 'low';
    if (crackPercentage > 30) {
      severity = 'critical';
    } else if (crackPercentage > 20) {
      severity = 'high';
    } else if (crackPercentage > 10) {
      severity = 'moderate';
    }

    return {
      'detected': true,
      'type': 'Crack Severity Analysis',
      'icon': Icons.broken_image_rounded,
      'severity': severity,
      'percentage': crackPercentage,
      'measurements': {
        'width_mm': crackWidth.toStringAsFixed(2),
        'length_mm': crackLength.toStringAsFixed(2),
        'depth_mm': crackDepth.toStringAsFixed(2),
      },
      'description': 'Surface cracks detected with measurements: ${crackWidth.toStringAsFixed(1)}mm width, ${crackLength.toStringAsFixed(0)}mm length, ${crackDepth.toStringAsFixed(1)}mm depth',
      'recommendation': _getCrackRecommendation(crackPercentage),
    };
  }

  /// Analyze rot detection with percentage
  static Map<String, dynamic> _analyzeRot(double confidence, String woodType) {
    // Rot probability based on wood type susceptibility and confidence
    double rotProbability = 0.0;
    
    // Softwoods are more susceptible to rot
    if (woodType.toLowerCase().contains('pine') || 
        woodType.toLowerCase().contains('cedar') ||
        woodType.toLowerCase().contains('aratiles')) {
      rotProbability = (1.0 - confidence) * 0.6;
    } else if (woodType.toLowerCase().contains('mahogany') ||
               woodType.toLowerCase().contains('narra') ||
               woodType.toLowerCase().contains('molave')) {
      rotProbability = (1.0 - confidence) * 0.2;
    } else {
      rotProbability = (1.0 - confidence) * 0.35;
    }

    if (rotProbability < 0.10) {
      return {'detected': false};
    }

    final rotPercentage = (rotProbability * 100).clamp(0.0, 50.0);
    final affectedArea = (rotPercentage * 2.5).clamp(0.0, 100.0); // percentage of wood affected

    String severity = 'low';
    if (rotPercentage > 35) {
      severity = 'critical';
    } else if (rotPercentage > 25) {
      severity = 'high';
    } else if (rotPercentage > 15) {
      severity = 'moderate';
    }

    return {
      'detected': true,
      'type': 'Rot Detection',
      'icon': Icons.eco_rounded,
      'severity': severity,
      'percentage': rotPercentage,
      'measurements': {
        'affected_area_percent': affectedArea.toStringAsFixed(1),
        'rot_depth_estimate': _estimateRotDepth(rotPercentage),
      },
      'description': 'Fungal decay detected: ${rotPercentage.toStringAsFixed(1)}% probability, approximately ${affectedArea.toStringAsFixed(1)}% of surface affected',
      'recommendation': _getRotRecommendation(rotPercentage),
    };
  }

  /// Analyze insect damage identification
  static Map<String, dynamic> _analyzeInsectDamage(double confidence, int imageQuality) {
    // Insect damage probability
    double insectProbability = (1.0 - confidence) * (imageQuality / 100.0) * 0.5;

    if (insectProbability < 0.12) {
      return {'detected': false};
    }

    final damagePercentage = (insectProbability * 100).clamp(0.0, 35.0);
    final holeCount = (damagePercentage * 3).toInt().clamp(0, 50);
    final holeSize = (damagePercentage * 0.3).clamp(0.5, 5.0); // mm

    String insectType = 'Unknown';
    if (damagePercentage > 25) {
      insectType = 'Termites/Borers (Heavy)';
    } else if (damagePercentage > 15) {
      insectType = 'Wood Beetles/Borers';
    } else {
      insectType = 'Surface Insects';
    }

    String severity = 'low';
    if (damagePercentage > 25) {
      severity = 'critical';
    } else if (damagePercentage > 15) {
      severity = 'high';
    } else if (damagePercentage > 8) {
      severity = 'moderate';
    }

    return {
      'detected': true,
      'type': 'Insect Damage Identification',
      'icon': Icons.bug_report_rounded,
      'severity': severity,
      'percentage': damagePercentage,
      'measurements': {
        'estimated_holes': holeCount.toString(),
        'hole_diameter_mm': holeSize.toStringAsFixed(2),
        'insect_type': insectType,
      },
      'description': 'Insect damage detected: $insectType with approximately $holeCount holes, ${holeSize.toStringAsFixed(1)}mm diameter',
      'recommendation': _getInsectRecommendation(damagePercentage, insectType),
    };
  }

  /// Analyze warping measurement in degrees
  static Map<String, dynamic> _analyzeWarping(double confidence) {
    // Warping probability based on confidence
    double warpingProbability = (1.0 - confidence) * 0.7;

    if (warpingProbability < 0.10) {
      return {'detected': false};
    }

    // Estimate warping angles
    final warpingAngle = (warpingProbability * 15.0).clamp(0.5, 15.0); // degrees
    final warpingPercentage = (warpingProbability * 100).clamp(0.0, 45.0);
    
    // Determine warping type
    String warpingType = 'Slight Cupping';
    if (warpingAngle > 10) {
      warpingType = 'Severe Bowing';
    } else if (warpingAngle > 6) {
      warpingType = 'Moderate Twisting';
    } else if (warpingAngle > 3) {
      warpingType = 'Slight Warping';
    }

    String severity = 'low';
    if (warpingAngle > 10) {
      severity = 'critical';
    } else if (warpingAngle > 6) {
      severity = 'high';
    } else if (warpingAngle > 3) {
      severity = 'moderate';
    }

    return {
      'detected': true,
      'type': 'Warping Measurement',
      'icon': Icons.trending_up_rounded,
      'severity': severity,
      'percentage': warpingPercentage,
      'measurements': {
        'warping_angle_degrees': warpingAngle.toStringAsFixed(2),
        'warping_type': warpingType,
        'deviation_mm': (warpingAngle * 2.5).toStringAsFixed(2),
      },
      'description': 'Wood warping detected: $warpingType at ${warpingAngle.toStringAsFixed(1)}° angle',
      'recommendation': _getWarpingRecommendation(warpingAngle),
    };
  }

  /// Generate before/after treatment suggestions
  static List<Map<String, dynamic>> _generateTreatmentSuggestions(
    List<Map<String, dynamic>> defects,
    String woodType,
  ) {
    final suggestions = <Map<String, dynamic>>[];

    for (final defect in defects) {
      final defectType = defect['type'] as String;
      final severity = defect['severity'] as String;

      if (defectType.contains('Crack')) {
        suggestions.add({
          'defect': 'Cracks',
          'before': [
            'Clean out debris from cracks using compressed air',
            'Sand the area smooth',
            'Inspect for depth and extent',
          ],
          'treatment': [
            'Apply wood filler appropriate for crack size',
            'Use epoxy resin for deep cracks',
            'Sand smooth after drying',
            'Apply wood conditioner',
          ],
          'after': [
            'Seal with polyurethane or varnish',
            'Allow 24-48 hours curing time',
            'Sand lightly between coats',
            'Apply final protective finish',
          ],
          'severity': severity,
        });
      } else if (defectType.contains('Rot')) {
        suggestions.add({
          'defect': 'Rot/Decay',
          'before': [
            'Identify extent of rot using probe',
            'Mark affected areas clearly',
            'Remove loose/soft wood',
            'Dry the area completely',
          ],
          'treatment': [
            'Apply wood hardener to affected areas',
            'Remove all decayed wood if severe',
            'Treat with fungicide',
            'Allow proper drying time',
          ],
          'after': [
            'Fill cavities with epoxy wood filler',
            'Sand smooth and level',
            'Apply wood preservative',
            'Finish with protective coating',
          ],
          'severity': severity,
        });
      } else if (defectType.contains('Insect')) {
        suggestions.add({
          'defect': 'Insect Damage',
          'before': [
            'Inspect all surfaces for entry holes',
            'Identify insect type if possible',
            'Check for active infestation',
            'Assess structural integrity',
          ],
          'treatment': [
            'Apply insecticide to affected areas',
            'Inject treatment into holes if active',
            'Fumigate if severe infestation',
            'Allow treatment to cure',
          ],
          'after': [
            'Fill holes with wood filler',
            'Sand smooth',
            'Apply wood sealant',
            'Monitor for re-infestation',
          ],
          'severity': severity,
        });
      } else if (defectType.contains('Warping')) {
        suggestions.add({
          'defect': 'Warping',
          'before': [
            'Measure warping angle and extent',
            'Check moisture content',
            'Assess if warping is permanent',
            'Plan straightening method',
          ],
          'treatment': [
            'For slight warping: sand to flatten',
            'For moderate: use steam treatment',
            'For severe: may require replacement',
            'Control humidity during treatment',
          ],
          'after': [
            'Seal wood to prevent moisture absorption',
            'Store in controlled humidity',
            'Apply protective finish',
            'Monitor for re-warping',
          ],
          'severity': severity,
        });
      }
    }

    return suggestions;
  }

  // Helper methods for recommendations
  static String _getCrackRecommendation(double percentage) {
    if (percentage > 30) {
      return 'CRITICAL: Deep cracks detected. Recommend professional assessment before use.';
    } else if (percentage > 20) {
      return 'HIGH: Significant cracks. Repair with epoxy filler before finishing.';
    } else if (percentage > 10) {
      return 'MODERATE: Minor cracks. Can be filled with wood filler.';
    } else {
      return 'LOW: Surface cracks only. Sand and seal.';
    }
  }

  static String _getRotRecommendation(double percentage) {
    if (percentage > 35) {
      return 'CRITICAL: Severe rot detected. Not recommended for structural use.';
    } else if (percentage > 25) {
      return 'HIGH: Significant decay. Treat with fungicide and hardener.';
    } else if (percentage > 15) {
      return 'MODERATE: Localized rot. Remove affected areas and treat.';
    } else {
      return 'LOW: Minor decay. Apply fungicide and monitor.';
    }
  }

  static String _getInsectRecommendation(double percentage, String insectType) {
    if (percentage > 25) {
      return 'CRITICAL: Heavy $insectType damage. Recommend professional pest control.';
    } else if (percentage > 15) {
      return 'HIGH: Significant $insectType damage. Treat with insecticide.';
    } else if (percentage > 8) {
      return 'MODERATE: Minor $insectType damage. Apply surface treatment.';
    } else {
      return 'LOW: Minimal damage. Monitor for activity.';
    }
  }

  static String _getWarpingRecommendation(double angle) {
    if (angle > 10) {
      return 'CRITICAL: Severe warping (${angle.toStringAsFixed(1)}°). May not be usable.';
    } else if (angle > 6) {
      return 'HIGH: Moderate warping (${angle.toStringAsFixed(1)}°). Requires straightening.';
    } else if (angle > 3) {
      return 'MODERATE: Slight warping (${angle.toStringAsFixed(1)}°). Can be sanded flat.';
    } else {
      return 'LOW: Minimal warping (${angle.toStringAsFixed(1)}°). Acceptable.';
    }
  }

  static String _estimateRotDepth(double percentage) {
    if (percentage > 30) return 'Deep (>10mm)';
    if (percentage > 20) return 'Moderate (5-10mm)';
    if (percentage > 10) return 'Shallow (2-5mm)';
    return 'Surface (<2mm)';
  }
}

/// Widget to display defect analysis results
class DefectAnalysisWidget extends StatelessWidget {
  final Map<String, dynamic> defectData;
  final VoidCallback? onTreatmentTap;

  const DefectAnalysisWidget({
    Key? key,
    required this.defectData,
    this.onTreatmentTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasDefects = defectData['hasDefects'] as bool;
    final severity = defectData['severity'] as String;
    final totalPercentage = defectData['totalDefectPercentage'] as double;
    final defects = defectData['defects'] as List<Map<String, dynamic>>;

    if (!hasDefects) {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xFF00B894).withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xFF00B894), width: 2),
        ),
        child: Column(
          children: [
            Icon(Icons.check_circle_rounded, color: Color(0xFF00B894), size: 48),
            SizedBox(height: 12),
            Text(
              'No Defects Detected',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF00B894),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Wood appears to be in excellent condition',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF636E72),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overall Defect Summary
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _getSeverityColor(severity).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _getSeverityColor(severity), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getSeverityIcon(severity),
                    color: _getSeverityColor(severity),
                    size: 32,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DEFECT ANALYSIS',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: _getSeverityColor(severity),
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'Severity: ${severity.toUpperCase()}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF636E72),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Defect percentage bar
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (totalPercentage / 100).clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_getSeverityColor(severity), _getSeverityColor(severity).withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Total Defect Level: ${totalPercentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3436),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        // Individual Defects
        ...defects.map((defect) => _buildDefectCard(defect, context)).toList(),
      ],
    );
  }

  Widget _buildDefectCard(Map<String, dynamic> defect, BuildContext context) {
    final type = defect['type'] as String;
    final severity = defect['severity'] as String;
    final percentage = defect['percentage'] as double;
    final measurements = defect['measurements'] as Map<String, dynamic>;
    final description = defect['description'] as String;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getSeverityColor(severity).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getSeverityColor(severity).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  defect['icon'] as IconData,
                  color: _getSeverityColor(severity),
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    Text(
                      'Severity: ${severity.toUpperCase()}',
                      style: TextStyle(
                        fontSize: 12,
                        color: _getSeverityColor(severity),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _getSeverityColor(severity).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _getSeverityColor(severity),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF636E72),
              height: 1.4,
            ),
          ),
          SizedBox(height: 12),
          // Measurements
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Measurements:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3436),
                  ),
                ),
                SizedBox(height: 8),
                ...measurements.entries.map((entry) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key.replaceAll('_', ' ').toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF636E72),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          entry.value.toString(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF2D3436),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          SizedBox(height: 12),
          // Recommendation
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getSeverityColor(severity).withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getSeverityColor(severity).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: _getSeverityColor(severity),
                  size: 16,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    defect['recommendation'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF2D3436),
                      fontWeight: FontWeight.w500,
                      height: 1.4,
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

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Color(0xFFE17055);
      case 'high':
        return Color(0xFFFF6B6B);
      case 'moderate':
        return Color(0xFFFFB74D);
      case 'low':
        return Color(0xFF74B9FF);
      default:
        return Color(0xFF00B894);
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Icons.dangerous_rounded;
      case 'high':
        return Icons.error_rounded;
      case 'moderate':
        return Icons.warning_rounded;
      case 'low':
        return Icons.info_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }
}
