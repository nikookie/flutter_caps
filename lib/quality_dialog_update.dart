// Add this to replace the existing _showQualityExplanationDialog method

void _showQualityExplanationDialog() {
  final woodQuality = _getWoodQuality();
  final defectsData = _detectWoodDefects();
  final isGoodWood = woodQuality['isGood'];
  final woodType = (_result?['predicted_class'] ?? 'Unknown').toUpperCase();
  final confidence = ((_result?['confidence'] ?? 0.0) * 100).toStringAsFixed(1);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isGoodWood ? Color(0xFF00B894) : Color(0xFFE17055)).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isGoodWood ? Icons.verified_rounded : Icons.warning_amber_rounded,
              color: isGoodWood ? Color(0xFF00B894) : Color(0xFFE17055),
              size: 28,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              isGoodWood ? 'Why Good Wood?' : 'Why Poor Wood?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D3436),
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wood Type Info
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.park_rounded, size: 20, color: Color(0xFF8B4513)),
                      SizedBox(width: 8),
                      Text(
                        'Detected Wood',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF636E72),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    woodType,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'AI Confidence: $confidence%',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF636E72),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Classification Reason
            Text(
              'Classification Criteria:',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3436),
              ),
            ),
            SizedBox(height: 12),
            
            ...woodQuality['reasons'].map<Widget>((reason) => Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isGoodWood ? Color(0xFF00B894) : Color(0xFFE17055),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      reason,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2D3436),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
            
            SizedBox(height: 20),
            
            // Defects Detection Section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getDefectSeverityColor(defectsData['severity']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getDefectSeverityColor(defectsData['severity']).withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getDefectSeverityIcon(defectsData['severity']),
                        color: _getDefectSeverityColor(defectsData['severity']),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Defects Detection',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D3436),
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getDefectSeverityColor(defectsData['severity']),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${defectsData['defectCount']} ${defectsData['defectCount'] == 1 ? 'Issue' : 'Issues'}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  ...defectsData['defects'].map<Widget>((defect) => Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          defect['icon'],
                          size: 18,
                          color: _getDefectSeverityColor(defect['severity']),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                defect['name'],
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2D3436),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                defect['description'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF636E72),
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ],
              ),
            ),
            
            SizedBox(height: 16),
            
            // Recommendation
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (isGoodWood ? Color(0xFF00B894) : Color(0xFFE17055)).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (isGoodWood ? Color(0xFF00B894) : Color(0xFFE17055)).withOpacity(0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: isGoodWood ? Color(0xFF00B894) : Color(0xFFE17055),
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recommendation',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2D3436),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          woodQuality['recommendation'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF2D3436),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Got it',
            style: TextStyle(
              color: Color(0xFF00B894),
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ],
    ),
  );
}
