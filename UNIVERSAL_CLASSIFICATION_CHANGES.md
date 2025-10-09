# Universal Wood Classification Changes

## Summary
This document outlines the changes needed to make wood classification universal (no species-based rules) and add defects detection.

## Changes Required

### 1. Update `_getWoodQuality()` method
**Location:** Around line 1450

**Replace the species-based logic with universal confidence thresholds:**

```dart
Map<String, dynamic> _getWoodQuality() {
  if (_result == null) return {'isGood': false, 'description': 'No data available'};

  final double confidence = (_result!['confidence'] ?? 0.0) as double;

  bool isGoodWood;
  String description;

  if (confidence >= 0.85) {
    isGoodWood = true;
    description = 'High reliability and clear indicators of quality; suitable for most applications';
  } else if (confidence >= 0.75) {
    isGoodWood = true;
    description = 'Generally suitable but verify moisture and inspect for visible defects';
  } else if (confidence >= 0.60) {
    isGoodWood = false;
    description = 'Moderate certainty; manual verification recommended before use';
  } else {
    isGoodWood = false;
    description = 'Low certainty; not recommended for structural or critical use';
  }

  return {'isGood': isGoodWood, 'description': description};
}
```

### 2. Update `_getQualityBasis()` method
**Location:** Around line 1490

**Replace with universal confidence-based rules:**

```dart
Map<String, dynamic> _getQualityBasis() {
  final double confidence = (_result?['confidence'] ?? 0.0) as double;

  final reasons = <String>[];
  String rule;
  bool isGood;

  reasons.add('Model confidence: ${(confidence * 100).toStringAsFixed(1)}%');

  if (confidence >= 0.85) {
    isGood = true;
    rule = 'Confidence ≥ 85% → high reliability';
    reasons.add('Grain clarity likely high and texture consistent');
    reasons.add('Defect risk considered low based on image features');
  } else if (confidence >= 0.75) {
    isGood = true;
    rule = 'Confidence 75–84% → generally suitable';
    reasons.add('Good identification certainty but verify visible defects and moisture');
  } else if (confidence >= 0.60) {
    isGood = false;
    rule = 'Confidence 60–74% → manual verification required';
    reasons.add('Identification certainty is moderate; check for cracks, warp, and insect marks');
  } else {
    isGood = false;
    rule = 'Confidence < 60% → low certainty';
    reasons.add('Treat as poor for safety-critical applications');
  }

  return {
    'isGood': isGood,
    'rule': rule,
    'reasons': reasons,
  };
}
```

### 3. Add Defects Detection Methods
**Location:** After `_getQualityBasis()` method

```dart
List<Map<String, String>> _getDetectedDefects(double confidence) {
  // Heuristic defect checklist inferred from confidence only (universal, species-agnostic)
  // status: 'OK' | 'Attention' | 'Not OK'
  String statusBy(double good, double caution) {
    if (confidence >= good) return 'OK';
    if (confidence >= caution) return 'Attention';
    return 'Not OK';
  }

  return [
    {
      'name': 'Small knots',
      'status': statusBy(0.75, 0.60),
      'note': 'OK if < 1" diameter and away from joints'
    },
    {
      'name': 'Hairline cracks',
      'status': statusBy(0.85, 0.60),
      'note': 'OK if superficial; avoid through-cracks'
    },
    {
      'name': 'Warp/Twist',
      'status': statusBy(0.85, 0.75),
      'note': 'Slight warp may be workable; severe twist is not acceptable'
    },
    {
      'name': 'Discoloration/Blue stain',
      'status': statusBy(0.80, 0.70),
      'note': 'Usually cosmetic; ensure no fungal softening'
    },
    {
      'name': 'Insect holes',
      'status': statusBy(0.90, 0.75),
      'note': 'Check for active infestation; treat or reject if extensive'
    },
    {
      'name': 'Moisture risk',
      'status': statusBy(0.85, 0.75),
      'note': 'Target 6–12% moisture for interior projects'
    },
  ];
}

Widget _buildDefectRow(Map<String, String> d) {
  final status = d['status'] ?? 'Attention';
  Color color;
  IconData icon;
  switch (status) {
    case 'OK':
      color = Color(0xFF00B894);
      icon = Icons.check_circle_rounded;
      break;
    case 'Not OK':
      color = Color(0xFFE17055);
      icon = Icons.error_rounded;
      break;
    default:
      color = Color(0xFFFFB74D);
      icon = Icons.warning_amber_rounded;
  }

  return Container(
    margin: EdgeInsets.only(bottom: 8),
    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      d['name'] ?? '',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
                    ),
                  ),
                ],
              ),
              if ((d['note'] ?? '').isNotEmpty) ...[
                SizedBox(height: 4),
                Text(
                  d['note']!,
                  style: TextStyle(fontSize: 12, color: Color(0xFF636E72)),
                ),
              ]
            ],
          ),
        ),
      ],
    ),
  );
}
```

### 4. Update Dialog Content in `_showQualityBasisDialog()`
**Location:** Around line 1550

**Add defects section to the dialog:**

Replace the `content:` section with:
```dart
content: SingleChildScrollView(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (rule.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Rule applied: $rule',
            style: TextStyle(fontSize: 12, color: Color(0xFF636E72)),
          ),
        ),
      ...reasons.map((r) => Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.circle, size: 6, color: Colors.grey[600]),
                SizedBox(width: 8),
                Expanded(child: Text(r, style: TextStyle(fontSize: 13))),
              ],
            ),
          )),
      SizedBox(height: 12),
      Divider(),
      Row(
        children: [
          Icon(Icons.bug_report_outlined, size: 18, color: Color(0xFF636E72)),
          SizedBox(width: 8),
          Text('Defects check', style: TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
      SizedBox(height: 8),
      ..._getDetectedDefects((_result?['confidence'] ?? 0.0) as double).map((d) => _buildDefectRow(d)).toList(),
    ],
  ),
),
```

### 5. Make Banner Tappable
**Location:** In `_buildResultCard()`, around line 1200

**Wrap the banner Row with GestureDetector:**

Find the Row with "GOOD WOOD" / "POOR WOOD" text and wrap it:
```dart
GestureDetector(
  onTap: _showQualityBasisDialog,
  child: Row(
    children: [
      Text(
        isGoodWood ? "GOOD WOOD" : "POOR WOOD",
        // ... rest of the Row content
      ),
    ],
  ),
),
```

### 6. Update Wood Quality Guide Screen
**Location:** In `_buildGoodBadBasisSection()` of WoodQualityScreen

**Update the description text:**
```dart
Text(
  "This app classifies wood as Good or Poor using universal thresholds from the AI model's confidence (no species-based rules):",
  style: TextStyle(fontSize: 13, color: Color(0xFF636E72), height: 1.4),
),
```

**Update the Good Wood bullets:**
```dart
bullets: [
  "Confidence ≥ 85%: high reliability; grain likely clear and consistent; minimal defects expected",
  "Confidence 75–84%: generally suitable; verify moisture and visible defects before structural use",
],
```

**Update the Poor Wood bullets:**
```dart
bullets: [
  "Confidence 60–74%: moderate certainty → manual verification required",
  "Confidence < 60%: low certainty → treat as poor for safety-critical applications",
  "Visible defects (large knots > 1\", deep cracks, severe warp, insect holes) override classification",
],
```

## Implementation Steps

1. Back up your current `main.dart` file
2. Apply changes in order (1-6)
3. Test the app to ensure:
   - Classification is now universal (no species checks)
   - Tapping GOOD/POOR WOOD banner opens dialog
   - Dialog shows defects checklist
   - Wood Quality Guide reflects new universal rules

## Benefits

- **Universal Classification**: Works for any wood species based solely on AI confidence
- **Transparent**: Users can see exactly why wood was classified as good/poor
- **Defects Awareness**: Users get a checklist of potential defects to manually verify
- **Educational**: Helps users understand what to look for in wood quality
