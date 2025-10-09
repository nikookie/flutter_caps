class ScanResult {
  final String predictedClass;
  final double confidence; // 0..1
  final int timestampMs;
  final String? imagePath;

  const ScanResult({
    required this.predictedClass,
    required this.confidence,
    required this.timestampMs,
    this.imagePath,
  });

  factory ScanResult.fromApi(dynamic data, {String? imagePath}) {
    String predicted;
    double conf;
    if (data is Map && data.containsKey('predicted_class')) {
      predicted = (data['predicted_class'] ?? 'Unknown').toString();
      final c = data['confidence'];
      conf = (c is num) ? c.toDouble() : 0.0;
    } else if (data is Map && data['predictions'] is List && (data['predictions'] as List).isNotEmpty) {
      final first = (data['predictions'] as List).first;
      predicted = (first['label'] ?? 'Unknown').toString();
      final c = first['score'];
      conf = (c is num) ? c.toDouble() : 0.0;
    } else {
      predicted = 'Unknown';
      conf = 0.0;
    }
    return ScanResult(
      predictedClass: predicted,
      confidence: conf,
      timestampMs: DateTime.now().millisecondsSinceEpoch,
      imagePath: imagePath,
    );
  }

  Map<String, dynamic> toJson() => {
        'predicted_class': predictedClass,
        'confidence': confidence,
        'timestamp': timestampMs,
        'imagePath': imagePath,
      };

  factory ScanResult.fromJson(Map<String, dynamic> json) => ScanResult(
        predictedClass: (json['predicted_class'] ?? json['wood_type'] ?? json['prediction'] ?? 'Unknown').toString(),
        confidence: (json['confidence'] is num)
            ? (json['confidence'] as num).toDouble()
            : 0.0,
        timestampMs: json['timestamp'] is int
            ? json['timestamp'] as int
            : DateTime.now().millisecondsSinceEpoch,
        imagePath: json['imagePath']?.toString(),
      );
}
























