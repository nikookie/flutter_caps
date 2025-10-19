import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'history_screen.dart';
import 'philippine_wood_species_data.dart';
import 'settings_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 900));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _scale = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();

    Future.delayed(Duration(milliseconds: 1600), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => WoodScanner()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 16),
                Text(
                  'CLEARCUT',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: Color(0xFF2D3436),
                  ),
                ),
                SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 140,
                    child: LinearProgressIndicator(
                      backgroundColor: Color(0xFFE2E8F0),
                      color: Color(0xFF00B894),
                      minHeight: 6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.green,
      fontFamily: 'SF Pro Display',
      scaffoldBackgroundColor: Color(0xFFF8F9FA),
    ),
    home: SplashScreen(),
  ));
}

class WoodScanner extends StatefulWidget {
  @override
  _WoodScannerState createState() => _WoodScannerState();
}

class _WoodScannerState extends State<WoodScanner>
    with TickerProviderStateMixin {
  File? _image;
  Map<String, dynamic>? _result;
  bool _isProcessing = false;
  bool _showProcessingScreen = false;
  bool _showUsabilityScreen = false;
  bool _showSummaryScreen = false;
  int _currentProcessingStep = 0;
  String _currentProcessingText = '';

  late AnimationController _animController;
  late AnimationController _pulseController;
  late AnimationController _processingController;
  late AnimationController _scanLineController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _pulseAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _processingFadeAnim;
  late Animation<double> _scanLineAnim;
  late Animation<double> _rotationAnim;

  @override
  void initState() {
    super.initState();

    // Main animation setup
    _animController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 800));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    _slideAnim = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    ));
    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: _animController, curve: Curves.elasticOut));

    // Pulse animation for camera button
    _pulseController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.1).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    // Processing animations
    _processingController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _processingFadeAnim = CurvedAnimation(
        parent: _processingController, curve: Curves.easeInOut);
    _rotationAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _processingController, curve: Curves.linear));

    // Scan line animation
    _scanLineController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000))
      ..repeat();
    _scanLineAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _scanLineController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animController.dispose();
    _pulseController.dispose();
    _processingController.dispose();
    _scanLineController.dispose();
    super.dispose();
  }

  Future<void> pickImage(bool fromCamera) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 85,
    );

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _result = null; // Clear previous result
        _showUsabilityScreen = false; // Reset screens
        _showProcessingScreen = false;
        _showSummaryScreen = false;
      });
    }
  }

  Future<void> scanWood() async {
    if (_image == null) return;

    // Check if demo mode is enabled
    final prefs = await SharedPreferences.getInstance();
    final demoMode = prefs.getBool('demoMode') ?? false;

    // Start processing screen
    setState(() {
      _showProcessingScreen = true;
      _currentProcessingStep = 0;
      _isProcessing = true;
    });

    // Start processing animation
    await _startProcessingAnimation();

    // If demo mode is enabled, use simulated scan
    if (demoMode) {
      await _simulateWoodScanDemo();
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("http://localhost:5000/predict"),
      );

      // Handle web vs mobile differently
      if (kIsWeb) {
        // For web: read file as bytes from the network URL
        final response = await http.get(Uri.parse(_image!.path));
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            response.bodyBytes,
            filename: 'upload.jpg',
          ),
        );
      } else {
        // For mobile/desktop: use file path
        request.files.add(
          await http.MultipartFile.fromPath('image', _image!.path),
        );
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var data = jsonDecode(responseData);
        
        // Debug: Print the actual response from backend
        print("🔍 Backend Response: $data");
        print("🌳 Predicted Class: ${data['predicted_class']}");
        print("📊 Confidence: ${data['confidence']}");
        
        // Validate the predicted class
        final predictedClass = data['predicted_class']?.toString() ?? 'Unknown';
        print("✅ Validated Predicted Class: $predictedClass");
        
        // Check if it's a valid wood species from our dataset
        final validSpecies = ['acacia', 'aratiles', 'coconut', 'dao', 'gmelina', 
                              'jackfruit', 'mahogany', 'mango', 'molave', 'narra'];
        final normalizedClass = predictedClass.toLowerCase().trim();
        
        if (!validSpecies.contains(normalizedClass) && normalizedClass != 'unknown') {
          print("⚠️ WARNING: Backend returned unexpected class: $predictedClass");
          print("⚠️ Expected one of: ${validSpecies.join(', ')}");
        }

        // Show "Done Scanning" message
        setState(() {
          _currentProcessingText = "Done scanning! ✅";
        });
        
        await Future.delayed(Duration(milliseconds: 1500));

        // Hide processing screen and show usability check screen
        setState(() {
          _showProcessingScreen = false;
          _result = data;
          _showUsabilityScreen = true;
          _isProcessing = false;
        });

        await saveScanHistory(data, _image!.path);
      } else {
        setState(() {
          _showProcessingScreen = false;
          _isProcessing = false;
        });
        _showErrorSnackBar("Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      setState(() {
        _showProcessingScreen = false;
        _isProcessing = false;
      });
      
      // Show the actual error instead of falling back to test mode
      print("❌ ERROR connecting to backend: $e");
      _showErrorSnackBar("❌ Backend connection failed: $e\n\nMake sure your backend is running at http://localhost:5000");
    }
  }

  // Demo mode method with enhanced sample data
  Future<void> _simulateWoodScanDemo() async {
    // Philippine wood species with realistic confidence scores
    final sampleWoodTypes = [
      {'name': 'Narra', 'confidence': 0.92},
      {'name': 'Mahogany', 'confidence': 0.88},
      {'name': 'Acacia', 'confidence': 0.85},
      {'name': 'Molave', 'confidence': 0.90},
      {'name': 'Dao', 'confidence': 0.87},
      {'name': 'Gmelina', 'confidence': 0.83},
      {'name': 'Mango', 'confidence': 0.86},
      {'name': 'Aratiles', 'confidence': 0.81},
    ];
    
    final random = DateTime.now().millisecondsSinceEpoch % sampleWoodTypes.length;
    final selectedWood = sampleWoodTypes[random];
    
    final simulatedData = {
      'predicted_class': selectedWood['name'],
      'confidence': selectedWood['confidence'],
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'demo_mode': true,
    };

    // Show "Done Scanning" message
    setState(() {
      _currentProcessingText = "Done scanning! ✅ (Demo Mode)";
    });
    
    await Future.delayed(Duration(milliseconds: 1500));

    // Hide processing screen and show usability check screen
    setState(() {
      _showProcessingScreen = false;
      _result = simulatedData;
      _showUsabilityScreen = true;
      _isProcessing = false;
    });

    await saveScanHistory(simulatedData, _image!.path);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("🎭 Demo Mode: Simulated ${selectedWood['name']} detection with ${((selectedWood['confidence'] as double) * 100).toStringAsFixed(1)}% confidence"),
        backgroundColor: Color(0xFF6C5CE7),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Test method to simulate wood scanning with sample data
  Future<void> _simulateWoodScan() async {
    // Updated to use only common wood species that are typically in training datasets
    // You can modify this list to match your exact trained wood species
    final sampleWoodTypes = [
      'Acacia',        // Very common in datasets
      'Aratiles',       // Very common in datasets  
      'Mahogany',      // Common hardwood
      'Mango',      // Common in many datasets
      'Narra',
      'Shorea astylosa',       // European datasets often include this
    ];
    
    final random = DateTime.now().millisecondsSinceEpoch % sampleWoodTypes.length;
    final selectedWood = sampleWoodTypes[random];
    
    // Generate random confidence between 0.65 and 0.92 (more realistic range)
    final confidence = 0.65 + (DateTime.now().millisecondsSinceEpoch % 27) / 100.0;
    
    final simulatedData = {
      'predicted_class': selectedWood,
      'confidence': confidence,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    // Show "Done Scanning" message
    setState(() {
      _currentProcessingText = "Done scanning! ✅ (Test Mode)";
    });
    
    await Future.delayed(Duration(milliseconds: 1500));

    // Hide processing screen and show usability check screen
    setState(() {
      _showProcessingScreen = false;
      _result = simulatedData;
      _showUsabilityScreen = true;
      _isProcessing = false;
    });

    await saveScanHistory(simulatedData, _image!.path);
    
    _showErrorSnackBar("Test mode: Simulated ${selectedWood} detection with ${(confidence * 100).toStringAsFixed(1)}% confidence");
  }

  Future<void> _startProcessingAnimation() async {
    final processingSteps = [
      "🔍 Wood scanning...",
      "🌲 Analyzing wood grain...", 
      "🔎 Looking for possible results...",
      "🎯 Detecting wood type...",
      "📊 Calculating quality score...",
    ];

    for (int i = 0; i < processingSteps.length; i++) {
      if (!_showProcessingScreen) break;
      
      setState(() {
        _currentProcessingStep = i;
        _currentProcessingText = processingSteps[i];
      });

      _processingController.forward(from: 0);
      await Future.delayed(Duration(milliseconds: 1000));
      
      if (i < processingSteps.length - 1) {
        await Future.delayed(Duration(milliseconds: 600));
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> saveScanHistory(
      Map<String, dynamic> result, String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('scan_history') ?? [];

    result['imagePath'] = imagePath;
    result['timestamp'] = DateTime.now().millisecondsSinceEpoch;
    history.add(jsonEncode(result));

    await prefs.setStringList('scan_history', history);
  }

  void checkUsability() {
    if (_result != null) {
      setState(() {
        _showUsabilityScreen = false;
        _showSummaryScreen = true;
      });
      _animController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showProcessingScreen) {
      return _buildProcessingScreen();
    } else if (_showUsabilityScreen) {
      return _buildUsabilityScreen();
    } else if (_showSummaryScreen) {
      return _buildSummaryScreen();
    } else {
      return _buildMainScreen();
    }
  }

  Widget _buildMainScreen() {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: _buildHeader(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              _buildMainContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "CLEARCUT",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: Color(0xFF2D3436),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
          },
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
            child: FaIcon(
              FontAwesomeIcons.gear,
              color: Color(0xFF636E72),
              size: 20,
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildMainContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildCameraScanArea(),
          SizedBox(height: 40),
          _buildMenuButtons(),
          SizedBox(height: 20),
          _buildPoweredBy(),
        ],
      ),
    );
  }

  Widget _buildCameraScanArea() {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFB8E6B8),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (_image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: kIsWeb
                  ? Image.network(
                      _image!.path,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Color(0xFFE2E8F0),
                          child: Icon(
                            Icons.image_outlined,
                            size: 50,
                            color: Color(0xFF636E72),
                          ),
                        );
                      },
                    )
                  : Image.file(
                      _image!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
          if (_image == null)
            Center(
              child: AnimatedBuilder(
                animation: _pulseAnim,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnim.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Color(0xFF74B9FF),
                          width: 3,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        size: 50,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                  );
                },
              ),
            ),
          // Scan corners overlay
          if (_image == null) _buildScanCorners(),
          // Camera/Gallery buttons overlay
          if (_image == null)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: FontAwesomeIcons.camera,
                    label: "Camera",
                    onTap: () => pickImage(true),
                    color: Color(0xFF00B894),
                  ),
                  _buildActionButton(
                    icon: FontAwesomeIcons.images,
                    label: "Gallery",
                    onTap: () => pickImage(false),
                    color: Color(0xFF74B9FF),
                  ),
                ],
              ),
            ),
          // Scan Wood button overlay when image is selected
          if (_image != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isProcessing ? null : scanWood,
                  icon: Icon(Icons.scanner, size: 24),
                  label: Text(
                    "SCAN WOODS",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00B894),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    shadowColor: Color(0xFF00B894).withOpacity(0.3),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScanCorners() {
    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Stack(
          children: [
            // Top left corner
            Positioned(
              top: 0,
              left: 0,
              child: _buildCorner(topLeft: true),
            ),
            // Top right corner
            Positioned(
              top: 0,
              right: 0,
              child: _buildCorner(topRight: true),
            ),
            // Bottom left corner
            Positioned(
              bottom: 0,
              left: 0,
              child: _buildCorner(bottomLeft: true),
            ),
            // Bottom right corner
            Positioned(
              bottom: 0,
              right: 0,
              child: _buildCorner(bottomRight: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorner({
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border(
          top: (topLeft || topRight)
              ? BorderSide(color: Color(0xFF2D3436), width: 3)
              : BorderSide.none,
          left: (topLeft || bottomLeft)
              ? BorderSide(color: Color(0xFF2D3436), width: 3)
              : BorderSide.none,
          right: (topRight || bottomRight)
              ? BorderSide(color: Color(0xFF2D3436), width: 3)
              : BorderSide.none,
          bottom: (bottomLeft || bottomRight)
              ? BorderSide(color: Color(0xFF2D3436), width: 3)
              : BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Color(0xFF2D3436),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButtons() {
    return Column(
      children: [
        _buildMenuButton(
          title: "SCAN HISTORY",
          icon: FontAwesomeIcons.clockRotateLeft,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryScreen()),
            );
          },
        ),
        SizedBox(height: 16),
        _buildMenuButton(
          title: "WOOD QUALITY",
          icon: FontAwesomeIcons.award,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WoodQualityScreen()),
            );
          },
        ),
        SizedBox(height: 16),
        _buildMenuButton(
          title: "USABILITY GUIDELINES",
          icon: FontAwesomeIcons.listCheck,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UsabilityGuidelinesScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMenuButton({required String title, required IconData icon, required VoidCallback onTap}) {
    return Container(
      width: double.infinity,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFFE2E8F0), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Color(0xFF636E72),
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3436),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPoweredBy() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text(
        "Powered by AI Wood Recognition",
        style: TextStyle(
          fontSize: 12,
          color: Color(0xFF636E72),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildProcessingScreen() {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF74B9FF).withOpacity(0.1),
              Color(0xFFF8F9FA),
              Color(0xFF00B894).withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "CLEARCUT",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    // Removed close button - users should wait for processing to complete
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        color: Color(0xFF00B894),
                        size: 24,
                      ),
                    ),
                  ],
                ),
                
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image preview with scan overlay
                      Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Stack(
                            children: [
                              if (_image != null)
                                kIsWeb
                                    ? Image.network(
                                        _image!.path,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            color: Color(0xFFE2E8F0),
                                            child: Icon(
                                              Icons.image_outlined,
                                              size: 50,
                                              color: Color(0xFF636E72),
                                            ),
                                          );
                                        },
                                      )
                                    : Image.file(
                                        _image!,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                              
                              // Animated scan line overlay
                              AnimatedBuilder(
                                animation: _scanLineAnim,
                                builder: (context, child) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Color(0xFF00B894).withOpacity(0.4),
                                          Colors.transparent,
                                        ],
                                        stops: [
                                          _scanLineAnim.value - 0.1,
                                          _scanLineAnim.value,
                                          _scanLineAnim.value + 0.1,
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              
                              // Processing overlay
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              
                              // Scanning grid overlay
                              Center(
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  child: CustomPaint(
                                    painter: ScanningGridPainter(
                                      progress: _processingFadeAnim.value,
                                      currentStep: _currentProcessingStep,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 60),
                      
                      // Processing status
                      AnimatedBuilder(
                        animation: _processingFadeAnim,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _processingFadeAnim,
                            child: Column(
                              children: [
                                // Rotating analysis icon
                                AnimatedBuilder(
                                  animation: _rotationAnim,
                                  builder: (context, child) {
                                    return Transform.rotate(
                                      angle: _rotationAnim.value * 2 * 3.14159,
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF00B894).withOpacity(0.1),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Color(0xFF00B894),
                                            width: 3,
                                          ),
                                        ),
                                        child: FaIcon(
                                        FontAwesomeIcons.magnifyingGlass,
                                        size: 40,
                                        color: Color(0xFF00B894),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                
                                SizedBox(height: 30),
                                
                                // Processing text
                                Text(
                                  _currentProcessingText,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2D3436),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                
                                SizedBox(height: 20),
                                
                                // Progress dots
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(5, (index) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(horizontal: 4),
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: index <= _currentProcessingStep
                                            ? Color(0xFF00B894)
                                            : Color(0xFFE2E8F0),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      
                      SizedBox(height: 60),
                      
                      // Fun facts while processing
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
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              color: Color(0xFF74B9FF),
                              size: 32,
                            ),
                            SizedBox(height: 12),
                            Text(
                              "Did you know?",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2D3436),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Wood grain patterns can reveal the age, growth conditions, and strength characteristics of the timber.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF636E72),
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
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
        ),
      ),
    );
  }

  Widget _buildUsabilityScreen() {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "CHECK USABILITY",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showUsabilityScreen = false;
                          _result = null;
                        });
                      },
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

              // Image preview
              if (_image != null)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: kIsWeb
                        ? Image.network(
                            _image!.path,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Color(0xFFE2E8F0),
                                child: Icon(
                                  Icons.image_outlined,
                                  size: 50,
                                  color: Color(0xFF636E72),
                                ),
                              );
                            },
                          )
                        : Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),

              SizedBox(height: 30),

              // Results
              if (_result != null)
                FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: ScaleTransition(
                      scale: _scaleAnim,
                      child: _buildResultCard(),
                    ),
                  ),
                ),

              SizedBox(height: 30),

              // Check Usability Button
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: checkUsability,
                  icon: Icon(Icons.check_circle_outline, size: 24),
                  label: Text(
                    "CHECK USABILITY",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF74B9FF),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    shadowColor: Color(0xFF74B9FF).withOpacity(0.3),
                  ),
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    if (_result == null) return SizedBox.shrink();

    final woodType = _result!['predicted_class'] ?? 'Unknown';
    final confidence = (_result!['confidence'] ?? 0.0) * 100;
    final woodQuality = _getWoodQuality();
    final isGoodWood = woodQuality['isGood'];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PRIMARY: Wood Species Display (Most Prominent)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF8B4513),
                  Color(0xFFA0522D),
                  Color(0xFF8B4513).withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF8B4513).withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                // Wood icon with background
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                  ),
                  child: Icon(
                    Icons.park_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Wood Species Detected",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.verified_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text(
                        woodType.toUpperCase(),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1.2,
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _getWoodSpeciesInfo(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.95),
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // SECONDARY: Wood Quality Indicator (Smaller, less prominent)
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (isGoodWood ? Color(0xFF00B894) : Color(0xFFE17055)).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (isGoodWood ? Color(0xFF00B894) : Color(0xFFE17055)).withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (isGoodWood ? Color(0xFF00B894) : Color(0xFFE17055)).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isGoodWood ? Icons.verified_rounded : Icons.warning_amber_rounded,
                    color: isGoodWood ? Color(0xFF00B894) : Color(0xFFE17055),
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Quality: ",
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF636E72),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            isGoodWood ? "GOOD WOOD" : "POOR WOOD",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: isGoodWood ? Color(0xFF00B894) : Color(0xFFE17055),
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            isGoodWood ? Icons.thumb_up_rounded : Icons.thumb_down_rounded,
                            color: isGoodWood ? Color(0xFF00B894) : Color(0xFFE17055),
                            size: 16,
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        woodQuality['description'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF636E72),
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Enhanced Confidence Section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFE2E8F0), width: 1),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFF74B9FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.psychology_rounded,
                        color: Color(0xFF74B9FF),
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "AI Confidence Level",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF636E72),
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getConfidenceColor(confidence).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _getConfidenceColor(confidence), width: 1),
                      ),
                      child: Text(
                        "${confidence.toStringAsFixed(1)}%",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _getConfidenceColor(confidence),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                
                // Enhanced Progress bar with animation
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: confidence / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _getConfidenceGradient(confidence),
                        ),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: _getConfidenceColor(confidence).withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  _getConfidenceDescription(confidence),
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF636E72),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for confidence colors
  Color _getConfidenceColor(double confidence) {
    if (confidence > 80) return Color(0xFF00B894);
    if (confidence > 60) return Color(0xFF74B9FF);
    if (confidence > 40) return Color(0xFFFFB74D);
    return Color(0xFFE17055);
  }

  // Helper method for confidence gradient
  List<Color> _getConfidenceGradient(double confidence) {
    if (confidence > 80) return [Color(0xFF00B894), Color(0xFF00D2A7)];
    if (confidence > 60) return [Color(0xFF74B9FF), Color(0xFF0984E3)];
    if (confidence > 40) return [Color(0xFFFFB74D), Color(0xFFFF9F43)];
    return [Color(0xFFE17055), Color(0xFFFF6B6B)];
  }

  // Helper method for confidence description
  String _getConfidenceDescription(double confidence) {
    if (confidence >= 90) return 'Excellent accuracy - Very reliable result';
    if (confidence >= 80) return 'High accuracy - Reliable identification';
    if (confidence >= 70) return 'Good accuracy - Generally reliable';
    if (confidence >= 60) return 'Moderate accuracy - Consider verification';
    return 'Low accuracy - Manual verification recommended';
  }

  // Helper methods for wood quality assessment
  Map<String, dynamic> _getWoodQuality() {
    if (_result == null) return {
      'isGood': false, 
      'description': 'No data available',
      'reasons': ['No scan data available'],
      'recommendation': 'Please scan a wood sample first'
    };

    final confidence = _result!['confidence'] ?? 0.0;
    final woodType = (_result!['predicted_class'] ?? '').toLowerCase();

    // Good wood criteria: primarily based on AI confidence
    bool isGoodWood = false;
    String description = '';
    List<String> reasons = [];
    String recommendation = '';

    // Check if it's a known wood species (not unknown/unidentified)
    bool isKnownSpecies = !woodType.contains('unknown') && 
                          woodType.isNotEmpty && 
                          woodType != 'unidentified';

    if (confidence >= 0.75 && isKnownSpecies) {
      // High confidence with known species = GOOD WOOD
      isGoodWood = true;
      
      // Check for premium hardwoods
      if (woodType.contains('mahogany') || woodType.contains('narra') ||
          woodType.contains('oak') || woodType.contains('teak') ||
          woodType.contains('walnut') || woodType.contains('molave')) {
        description = 'Premium hardwood with excellent structural properties';
        reasons = [
          'High AI confidence: ${(confidence * 100).toStringAsFixed(1)}%',
          'Recognized as premium hardwood species',
          'Known for excellent durability and strength',
          'Suitable for high-quality furniture and construction'
        ];
        recommendation = 'Excellent choice for furniture making, flooring, and structural applications. This wood is highly valued for its strength and aesthetic appeal.';
      } 
      // Check for common hardwoods
      else if (woodType.contains('acacia') || woodType.contains('mango') ||
               woodType.contains('dao') || woodType.contains('gmelina')) {
        description = 'Good quality hardwood suitable for various applications';
        reasons = [
          'High AI confidence: ${(confidence * 100).toStringAsFixed(1)}%',
          'Identified as quality hardwood species',
          'Good workability and structural properties',
          'Suitable for furniture and construction projects'
        ];
        recommendation = 'Great for furniture making, construction, and general woodworking projects. Offers good durability and workability.';
      }
      // Check for softwoods and fruit woods
      else if (woodType.contains('pine') || woodType.contains('cedar') ||
               woodType.contains('aratiles') || woodType.contains('jackfruit') ||
               woodType.contains('coconut')) {
        description = 'Good quality wood suitable for various applications';
        reasons = [
          'High AI confidence: ${(confidence * 100).toStringAsFixed(1)}%',
          'Successfully identified wood species',
          'Good workability and availability',
          'Suitable for many woodworking projects'
        ];
        recommendation = 'Suitable for general construction, indoor furniture, and crafting projects. Easy to work with and versatile.';
      }
      // Any other known species with high confidence
      else {
        description = 'High-quality wood with good identification accuracy';
        reasons = [
          'High AI confidence: ${(confidence * 100).toStringAsFixed(1)}%',
          'Wood species successfully identified',
          'Clear wood characteristics detected',
          'Suitable for general woodworking use'
        ];
        recommendation = 'Suitable for general woodworking projects. The high confidence indicates reliable identification. Verify specific properties for your intended use.';
      }
    } 
    else if (confidence >= 0.60 && confidence < 0.75 && isKnownSpecies) {
      // Moderate confidence = MODERATE QUALITY (still mark as poor for safety)
      isGoodWood = false;
      description = 'Moderate quality - verification recommended';
      reasons = [
        'Moderate AI confidence: ${(confidence * 100).toStringAsFixed(1)}%',
        'Wood species identified but with lower certainty',
        'May require additional inspection',
        'Quality assessment is less reliable'
      ];
      recommendation = 'Consider professional verification before use in critical applications. May be suitable for non-structural projects.';
    }
    else if (confidence >= 0.50 && confidence < 0.60) {
      // Low confidence = POOR WOOD
      isGoodWood = false;
      description = 'Questionable quality - requires professional assessment';
      reasons = [
        'Low AI confidence: ${(confidence * 100).toStringAsFixed(1)}%',
        'Identification accuracy is below optimal threshold',
        'Wood quality cannot be reliably determined',
        'May have defects or unusual characteristics'
      ];
      recommendation = 'Not recommended for critical applications without professional inspection. Consider using for non-structural projects only.';
    } 
    else {
      // Very low confidence or unknown species = POOR WOOD
      isGoodWood = false;
      description = 'Poor quality or unidentifiable wood - not recommended';
      reasons = [
        'Very low AI confidence: ${(confidence * 100).toStringAsFixed(1)}%',
        'Poor identification accuracy indicates issues',
        'Likely damaged, treated, or composite material',
        'Not suitable for reliable wood applications'
      ];
      recommendation = 'Do not use for structural or furniture applications. This wood may be damaged, heavily treated, or not suitable for typical woodworking.';
    }

    return {
      'isGood': isGoodWood, 
      'description': description,
      'reasons': reasons,
      'recommendation': recommendation
    };
  }

  String _getWoodSpeciesInfo() {
    final woodType = (_result?['predicted_class'] ?? '').toLowerCase();
    return PhilippineWoodSpeciesData.getWoodDescription(woodType);
  }

  // Detect wood defects based on confidence and wood type
  Map<String, dynamic> _detectWoodDefects() {
    if (_result == null) return {
      'hasDefects': false,
      'defects': [],
      'severity': 'none'
    };

    final confidence = _result!['confidence'] ?? 0.0;
    final woodType = (_result!['predicted_class'] ?? '').toLowerCase();
    
    List<Map<String, dynamic>> detectedDefects = [];
    String severity = 'none';

    // Low confidence indicates potential issues
    if (confidence < 0.6) {
      severity = 'critical';
      detectedDefects.addAll([
        {
          'name': 'Poor Image Quality',
          'description': 'Image may be blurry, poorly lit, or obstructed',
          'icon': Icons.image_not_supported_rounded,
          'severity': 'high'
        },
        {
          'name': 'Unidentifiable Wood',
          'description': 'Wood species cannot be reliably identified',
          'icon': Icons.help_outline_rounded,
          'severity': 'high'
        },
      ]);
    } else if (confidence < 0.7) {
      severity = 'moderate';
      detectedDefects.add({
        'name': 'Uncertain Classification',
        'description': 'Wood characteristics are unclear or ambiguous',
        'icon': Icons.warning_amber_rounded,
        'severity': 'medium'
      });
    }

    // Simulate defect detection based on confidence patterns
    if (confidence >= 0.6 && confidence < 0.85) {
      detectedDefects.addAll([
        {
          'name': 'Surface Irregularities',
          'description': 'Possible knots, cracks, or uneven grain patterns detected',
          'icon': Icons.texture_rounded,
          'severity': 'medium'
        },
        {
          'name': 'Color Variation',
          'description': 'Inconsistent coloring may indicate weathering or treatment',
          'icon': Icons.palette_rounded,
          'severity': 'low'
        },
      ]);
      if (severity == 'none') severity = 'moderate';
    }

    // Check for specific wood type issues
    if (woodType.contains('unknown') || woodType.isEmpty) {
      detectedDefects.add({
        'name': 'Unknown Species',
        'description': 'Wood species not in database or heavily modified',
        'icon': Icons.question_mark_rounded,
        'severity': 'high'
      });
      severity = 'critical';
    }

    // Good wood with high confidence
    if (confidence >= 0.85 && detectedDefects.isEmpty) {
      severity = 'none';
      detectedDefects.add({
        'name': 'No Defects Detected',
        'description': 'Wood appears to be in good condition with clear characteristics',
        'icon': Icons.check_circle_rounded,
        'severity': 'none'
      });
    }

    return {
      'hasDefects': detectedDefects.isNotEmpty && severity != 'none',
      'defects': detectedDefects,
      'severity': severity,
      'defectCount': detectedDefects.where((d) => d['severity'] != 'none').length
    };
  }

  Color _getDefectSeverityColor(String severity) {
    switch (severity) {
      case 'critical':
        return Color(0xFFE17055);
      case 'high':
        return Color(0xFFFF6B6B);
      case 'medium':
        return Color(0xFFFFB74D);
      case 'low':
        return Color(0xFF74B9FF);
      default:
        return Color(0xFF00B894);
    }
  }

  IconData _getDefectSeverityIcon(String severity) {
    switch (severity) {
      case 'critical':
        return Icons.dangerous_rounded;
      case 'high':
        return Icons.error_rounded;
      case 'medium':
        return Icons.warning_rounded;
      case 'low':
        return Icons.info_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }

  Widget _buildSummaryScreen() {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "WOOD ANALYSIS SUMMARY",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: Color(0xFF2D3436),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showSummaryScreen = false;
                            _result = null;
                            _image = null;
                          });
                        },
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
                            Icons.home,
                            color: Color(0xFF636E72),
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Image preview
                if (_image != null)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: kIsWeb
                          ? Image.network(
                              _image!.path,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Color(0xFFE2E8F0),
                                  child: Icon(
                                    Icons.image_outlined,
                                    size: 50,
                                    color: Color(0xFF636E72),
                                  ),
                                );
                              },
                            )
                          : Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),

                SizedBox(height: 30),

                // Wood Type Card with enhanced icon
                _buildSummaryCard(
                  title: "🌳 Wood Species",
                  value: _result?['predicted_class'] ?? 'Unknown',
                  icon: Icons.nature_rounded,
                  color: Color(0xFF8B4513), // Wood brown color
                  subtitle: _getWoodSpeciesInfo(),
                ),

                SizedBox(height: 16),

                // Wood Quality Indicator Card
                _buildQualityIndicatorCard(),

                SizedBox(height: 16),

                // Confidence Card with AI brain icon
                _buildSummaryCard(
                  title: "🤖 AI Confidence",
                  value: "${((_result?['confidence'] ?? 0.0) * 100).toStringAsFixed(1)}%",
                  icon: Icons.psychology_rounded,
                  color: Color(0xFF74B9FF),
                  subtitle: _getConfidenceDescription(((_result?['confidence'] ?? 0.0) * 100)),
                ),

                SizedBox(height: 16),

                // Quality Score Card with premium icons
                _buildSummaryCard(
                  title: "⭐ Quality Grade",
                  value: _getQualityScore(),
                  icon: _getQualityIcon(),
                  color: _getQualityColor(),
                  subtitle: "Based on grain analysis",
                ),

                SizedBox(height: 30),

                // Usability Analysis
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.assessment_rounded,
                            color: Color(0xFF6C5CE7),
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Usability Analysis",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Enhanced Furniture Making Focus
                      _buildFurnitureAnalysisSection(),
                      
                      SizedBox(height: 20),
                      
                      // Other usability items with enhanced icons
                      _buildUsabilityItem(
                        "🏗️ Construction Use",
                        _getUsabilityRating("construction"),
                        Icons.foundation_rounded,
                        color: Color(0xFF74B9FF),
                      ),
                      SizedBox(height: 12),
                      _buildUsabilityItem(
                        "🌲 Outdoor Projects",
                        _getUsabilityRating("outdoor"),
                        Icons.nature_people_rounded,
                        color: Color(0xFF00B894),
                      ),
                      SizedBox(height: 12),
                      _buildUsabilityItem(
                        "🎨 General Crafting",
                        _getUsabilityRating("crafting"),
                        Icons.handyman_rounded,
                        color: Color(0xFFFFB74D),
                      ),
                      SizedBox(height: 12),
                      _buildUsabilityItem(
                        "🪵 Wood Working",
                        _getUsabilityRating("woodworking"),
                        Icons.carpenter_rounded,
                        color: Color(0xFF8B4513),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                // Recommendations
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF74B9FF).withOpacity(0.1),
                        Color(0xFF00B894).withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Color(0xFF74B9FF).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline_rounded,
                            color: Color(0xFF74B9FF),
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Recommendations",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        _getRecommendations(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF636E72),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                // Action Buttons
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _showSummaryScreen = false;
                              _result = null;
                              _image = null;
                            });
                          },
                          icon: Icon(Icons.camera_alt_rounded, size: 20),
                          label: Text(
                            "SCAN AGAIN",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF00B894),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HistoryScreen()),
                            );
                          },
                          icon: Icon(Icons.history_rounded, size: 20),
                          label: Text(
                            "VIEW HISTORY",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF74B9FF),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),
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
    String? subtitle,
  }) {
    // Check if this is the wood species card to give it special styling
    bool isWoodSpeciesCard = title.contains('Wood Species') || title.contains('🌳');
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isWoodSpeciesCard 
            ? Border.all(color: Color(0xFF8B4513).withOpacity(0.3), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
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
              border: isWoodSpeciesCard 
                  ? Border.all(color: color.withOpacity(0.3), width: 1)
                  : null,
            ),
            child: Icon(
              icon,
              color: color,
              size: isWoodSpeciesCard ? 28 : 24,
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
                    fontSize: 14,
                    color: Color(0xFF636E72),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isWoodSpeciesCard ? 20 : 18,
                    fontWeight: isWoodSpeciesCard ? FontWeight.w900 : FontWeight.w700,
                    color: isWoodSpeciesCard ? Color(0xFF8B4513) : Color(0xFF2D3436),
                    letterSpacing: isWoodSpeciesCard ? 0.5 : 0,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF636E72).withOpacity(0.7),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQualityIndicatorCard() {
    final woodQuality = _getWoodQuality();
    final isGoodWood = woodQuality['isGood'];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showQualityExplanationDialog(),
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isGoodWood
                    ? [Color(0xFF00B894).withOpacity(0.1), Color(0xFF00D2A7).withOpacity(0.1)]
                    : [Color(0xFFE17055).withOpacity(0.1), Color(0xFFFF6B6B).withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isGoodWood ? Color(0xFF00B894).withOpacity(0.3) : Color(0xFFE17055).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (isGoodWood ? Color(0xFF00B894) : Color(0xFFE17055)).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isGoodWood ? Icons.verified_user_rounded : Icons.warning_amber_rounded,
                    color: isGoodWood ? Color(0xFF00B894) : Color(0xFFE17055),
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            isGoodWood ? "GOOD WOOD" : "POOR WOOD",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isGoodWood ? Color(0xFF00B894) : Color(0xFFE17055),
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            isGoodWood ? Icons.thumb_up_rounded : Icons.thumb_down_rounded,
                            color: isGoodWood ? Color(0xFF00B894) : Color(0xFFE17055),
                            size: 16,
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        woodQuality['description'],
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF636E72),
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 14,
                            color: Color(0xFF74B9FF),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Tap to see why',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF74B9FF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Color(0xFF636E72),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showQualityExplanationDialog() {
    final woodQuality = _getWoodQuality();
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

  // Replace this method in your _WoodScannerState class
Widget _buildUsabilityItem(String title, String rating, IconData icon, {Color? color}) {
  Color ratingColor;
  switch (rating.toLowerCase()) {
    case 'excellent':
      ratingColor = const Color(0xFF00B894);
      break;
    case 'good':
      ratingColor = const Color(0xFF74B9FF);
      break;
    case 'fair':
      ratingColor = const Color(0xFFFFB74D);
      break;
    default:
      ratingColor = const Color(0xFFE17055);
  }

  return Row(
    children: [
      Icon(
        icon,
        color: color ?? const Color(0xFF636E72),
        size: 20,
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D3436),
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: ratingColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          rating,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: ratingColor,
          ),
        ),
      ),
    ],
  );
}

  String _getQualityScore() {
    if (_result == null) return "N/A";
    
    final confidence = _result!['confidence'] ?? 0.0;
    if (confidence > 0.9) return "A+ (Premium)";
    if (confidence > 0.8) return "A (High)";
    if (confidence > 0.7) return "B+ (Good)";
    if (confidence > 0.6) return "B (Fair)";
    return "C (Poor)";
  }

  IconData _getQualityIcon() {
    final confidence = _result?['confidence'] ?? 0.0;
    if (confidence > 0.9) return Icons.diamond_rounded;
    if (confidence > 0.8) return Icons.star_rounded;
    if (confidence > 0.7) return Icons.star_border_rounded;
    if (confidence > 0.6) return Icons.circle_rounded;
    return Icons.error_outline_rounded;
  }

  Color _getQualityColor() {
    final confidence = _result?['confidence'] ?? 0.0;
    if (confidence > 0.9) return Color(0xFF9C27B0); // Purple for premium
    if (confidence > 0.8) return Color(0xFFFFD700); // Gold for high
    if (confidence > 0.7) return Color(0xFF74B9FF); // Blue for good
    if (confidence > 0.6) return Color(0xFFFFB74D); // Orange for fair
    return Color(0xFFE17055); // Red for poor
  }

  String _getUsabilityRating(String category) {
    final woodType = (_result?['predicted_class'] ?? '').toLowerCase();
    
    // Simple logic - in real app, this would come from a comprehensive database
    switch (category) {
      case 'construction':
        if (woodType.contains('oak') || woodType.contains('pine')) return 'Excellent';
        if (woodType.contains('maple') || woodType.contains('birch')) return 'Good';
        return 'Fair';
      case 'furniture':
        if (woodType.contains('mahogany') || woodType.contains('walnut')) return 'Excellent';
        if (woodType.contains('oak') || woodType.contains('cherry')) return 'Good';
        return 'Fair';
      case 'outdoor':
        if (woodType.contains('cedar') || woodType.contains('teak')) return 'Excellent';
        if (woodType.contains('pine') || woodType.contains('fir')) return 'Good';
        return 'Fair';
      case 'crafting':
        if (woodType.contains('basswood') || woodType.contains('pine')) return 'Excellent';
        if (woodType.contains('poplar') || woodType.contains('maple')) return 'Good';
        return 'Fair';
      default:
        return 'Fair';
    }
  }

  // Enhanced Furniture Analysis Section
  Widget _buildFurnitureAnalysisSection() {
    final furnitureProjects = _getFurnitureProjects();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF8B4513).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.chair_rounded,
                color: Color(0xFF8B4513),
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Text(
              "Furniture Making Potential",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3436),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        
        // Furniture project cards
        ...furnitureProjects.map((project) => _buildFurnitureProjectCard(project)).toList(),
      ],
    );
  }

  Widget _buildFurnitureProjectCard(Map<String, dynamic> project) {
    final suitability = project['suitability'] as String;
    Color suitabilityColor;
    
    switch (suitability.toLowerCase()) {
      case 'excellent':
        suitabilityColor = Color(0xFF00B894);
        break;
      case 'good':
        suitabilityColor = Color(0xFF74B9FF);
        break;
      case 'fair':
        suitabilityColor = Color(0xFFFFB74D);
        break;
      default:
        suitabilityColor = Color(0xFFE17055);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: suitabilityColor.withOpacity(0.2), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showFurnitureGuide(project),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: suitabilityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    project['icon'] as IconData,
                    color: suitabilityColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project['name'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3436),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        project['description'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF636E72),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: suitabilityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    suitability,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: suitabilityColor,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xFF636E72),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFurnitureProjects() {
    final woodType = (_result?['predicted_class'] ?? '').toLowerCase();
    final confidence = _result?['confidence'] ?? 0.0;
    
    List<Map<String, dynamic>> projects = [
      {
        'name': 'Dining Table',
        'icon': Icons.table_restaurant_rounded,
        'description': 'Perfect for family gatherings',
        'suitability': _getFurnitureSuitability(woodType, 'table', confidence),
        'difficulty': 'Intermediate',
        'timeEstimate': '2-3 weeks',
        'materials': ['Wood planks', 'Wood glue', 'Screws', 'Wood finish'],
        'tools': ['Table saw', 'Router', 'Drill', 'Sander', 'Clamps'],
        'steps': [
          'Cut wood to required dimensions',
          'Create table top by joining planks',
          'Build table legs and apron',
          'Assemble the table frame',
          'Attach table top to frame',
          'Sand entire table smooth',
          'Apply wood finish and protective coating'
        ],
        'tips': _getTableMakingTips(woodType),
      },
      {
        'name': 'Chair Set',
        'icon': Icons.chair_rounded,
        'description': 'Comfortable seating solution',
        'suitability': _getFurnitureSuitability(woodType, 'chair', confidence),
        'difficulty': 'Advanced',
        'timeEstimate': '3-4 weeks',
        'materials': ['Wood boards', 'Dowels', 'Wood glue', 'Screws', 'Cushion foam'],
        'tools': ['Miter saw', 'Drill press', 'Chisel set', 'Router', 'Jigsaw'],
        'steps': [
          'Cut all chair components to size',
          'Create joinery for seat and backrest',
          'Shape the chair legs and rails',
          'Dry fit all components',
          'Glue and clamp chair assembly',
          'Sand and finish the chair',
          'Add cushioning if desired'
        ],
        'tips': _getChairMakingTips(woodType),
      },
      {
        'name': 'Coffee Table',
        'icon': Icons.coffee_rounded,
        'description': 'Stylish living room centerpiece',
        'suitability': _getFurnitureSuitability(woodType, 'coffee_table', confidence),
        'difficulty': 'Beginner',
        'timeEstimate': '1-2 weeks',
        'materials': ['Wood slabs', 'Metal brackets', 'Wood stain', 'Polyurethane'],
        'tools': ['Circular saw', 'Orbital sander', 'Drill', 'Router'],
        'steps': [
          'Select and prepare wood slabs',
          'Cut to desired coffee table size',
          'Create or attach legs/base',
          'Sand progressively to fine grit',
          'Apply stain evenly',
          'Finish with protective coating',
          'Install any hardware or accessories'
        ],
        'tips': _getCoffeeTableTips(woodType),
      },
      {
        'name': 'Bookshelf',
        'icon': Icons.menu_book_rounded,
        'description': 'Organize your book collection',
        'suitability': _getFurnitureSuitability(woodType, 'bookshelf', confidence),
        'difficulty': 'Intermediate',
        'timeEstimate': '2-3 weeks',
        'materials': ['Plywood/boards', 'Wood screws', 'Back panel', 'Adjustable shelves'],
        'tools': ['Table saw', 'Drill', 'Level', 'Clamps', 'Router'],
        'steps': [
          'Cut all shelf components',
          'Create dados for shelf supports',
          'Assemble the main frame',
          'Install adjustable shelf system',
          'Attach back panel for stability',
          'Sand and apply finish',
          'Mount or position bookshelf'
        ],
        'tips': _getBookshelfTips(woodType),
      },
    ];

    // Sort by suitability (excellent first)
    projects.sort((a, b) {
      final suitabilityOrder = {'excellent': 0, 'good': 1, 'fair': 2, 'poor': 3};
      return suitabilityOrder[a['suitability'].toLowerCase()]!
          .compareTo(suitabilityOrder[b['suitability'].toLowerCase()]!);
    });

    return projects;
  }

  String _getFurnitureSuitability(String woodType, String furnitureType, double confidence) {
    // Base suitability on wood type and confidence
    if (confidence < 0.6) return 'Poor';
    
    switch (furnitureType) {
      case 'table':
        if (woodType.contains('oak') || woodType.contains('maple') || woodType.contains('walnut')) {
          return confidence > 0.8 ? 'Excellent' : 'Good';
        } else if (woodType.contains('pine') || woodType.contains('birch')) {
          return confidence > 0.8 ? 'Good' : 'Fair';
        }
        break;
      case 'chair':
        if (woodType.contains('oak') || woodType.contains('maple') || woodType.contains('beech')) {
          return confidence > 0.8 ? 'Excellent' : 'Good';
        } else if (woodType.contains('birch') || woodType.contains('ash')) {
          return confidence > 0.8 ? 'Good' : 'Fair';
        }
        break;
      case 'coffee_table':
        if (woodType.contains('walnut') || woodType.contains('cherry') || woodType.contains('mahogany')) {
          return confidence > 0.8 ? 'Excellent' : 'Good';
        } else if (woodType.contains('pine') || woodType.contains('oak')) {
          return confidence > 0.8 ? 'Good' : 'Fair';
        }
        break;
      case 'bookshelf':
        if (woodType.contains('pine') || woodType.contains('oak') || woodType.contains('birch')) {
          return confidence > 0.8 ? 'Excellent' : 'Good';
        } else if (woodType.contains('maple') || woodType.contains('poplar')) {
          return confidence > 0.8 ? 'Good' : 'Fair';
        }
        break;
    }
    
    return confidence > 0.8 ? 'Good' : 'Fair';
  }

  List<String> _getTableMakingTips(String woodType) {
    return PhilippineWoodSpeciesData.getWoodTips(woodType);
  }

  List<String> _getChairMakingTips(String woodType) {
    return PhilippineWoodSpeciesData.getWoodTips(woodType);
  }

  List<String> _getCoffeeTableTips(String woodType) {
    return PhilippineWoodSpeciesData.getWoodTips(woodType);
  }

  List<String> _getBookshelfTips(String woodType) {
    return PhilippineWoodSpeciesData.getWoodTips(woodType);
  }

  void _showFurnitureGuide(Map<String, dynamic> project) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFurnitureGuideModal(project),
    );
  }

  Widget _buildFurnitureGuideModal(Map<String, dynamic> project) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF8B4513).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    project['icon'] as IconData,
                    color: Color(0xFF8B4513),
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How to Make a ${project['name']}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2D3436),
                        ),
                      ),
                      Text(
                        project['description'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF636E72),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Project info cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard('Difficulty', project['difficulty'], Icons.bar_chart_rounded),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard('Time', project['timeEstimate'], Icons.schedule_rounded),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Materials needed
                  _buildGuideSection(
                    'Materials Needed',
                    Icons.inventory_2_rounded,
                    (project['materials'] as List<String>).map((material) => '• $material').toList(),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Tools required
                  _buildGuideSection(
                    'Tools Required',
                    Icons.build_rounded,
                    (project['tools'] as List<String>).map((tool) => '• $tool').toList(),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Step-by-step guide
                  _buildStepsSection(project['steps'] as List<String>),
                  
                  SizedBox(height: 20),
                  
                  // Tips specific to this wood type
                  _buildGuideSection(
                    'Tips for ${(_result?['predicted_class'] ?? 'This Wood').toUpperCase()}',
                    Icons.lightbulb_outline_rounded,
                    project['tips'] as List<String>,
                  ),
                  
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: Color(0xFF8B4513), size: 24),
          SizedBox(height: 8),
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
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D3436),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGuideSection(String title, IconData icon, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Color(0xFF8B4513), size: 20),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3436),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items.map((item) => Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF636E72),
                  height: 1.4,
                ),
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStepsSection(List<String> steps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.list_alt_rounded, color: Color(0xFF8B4513), size: 20),
            SizedBox(width: 8),
            Text(
              'Step-by-Step Guide',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3436),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        ...steps.asMap().entries.map((entry) {
          int index = entry.key;
          String step = entry.value;
          
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFE2E8F0), width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Color(0xFF8B4513),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    step,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2D3436),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  String _getRecommendations() {
    final woodType = (_result?['predicted_class'] ?? '').toLowerCase();
    final confidence = _result?['confidence'] ?? 0.0;
    final woodData = PhilippineWoodSpeciesData.getWoodData(woodType);

    String baseRecommendation = "Based on the analysis, this ${_result?['predicted_class'] ?? 'wood'} sample ";

    if (confidence > 0.8) {
      baseRecommendation += "shows high quality characteristics and is excellent for furniture making. ";
    } else if (confidence > 0.6) {
      baseRecommendation += "shows moderate quality characteristics and can be used for furniture with proper preparation. ";
    } else {
      baseRecommendation += "may require additional inspection for quality verification before furniture making. ";
    }

    if (woodData != null) {
      final bestUses = PhilippineWoodSpeciesData.getBestUses(woodType);
      final priceRange = PhilippineWoodSpeciesData.getPriceRange(woodType);
      final sustainability = PhilippineWoodSpeciesData.getSustainability(woodType);
      
      baseRecommendation += "${woodData['name']} is ${woodData['workability'].toLowerCase()} to work with and is best suited for: ${bestUses.take(3).join(', ')}. ";
      baseRecommendation += "Price range: $priceRange. Sustainability: $sustainability.";
    } else {
      baseRecommendation += "Research the specific properties of this wood type to determine the best furniture applications for your projects.";
    }

    return baseRecommendation;
  }
}

// Custom painter for scanning grid overlay
class ScanningGridPainter extends CustomPainter {
final double progress;
final int currentStep;

ScanningGridPainter({required this.progress, required this.currentStep});

@override
void paint(Canvas canvas, Size size) {
final paint = Paint()
..color = Color(0xFF00B894).withOpacity(0.6)
..strokeWidth = 2
..style = PaintingStyle.stroke;

// Draw scanning grid
for (int i = 0; i <= 4; i++) {
double x = (size.width / 4) * i;
double y = (size.height / 4) * i;

// Vertical lines
canvas.drawLine(
Offset(x, 0),
Offset(x, size.height * progress),
paint,
);

// Horizontal lines
canvas.drawLine(
Offset(0, y),
Offset(size.width * progress, y),
paint,
);
}
}

@override
bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Wood Quality Screen
class WoodQualityScreen extends StatelessWidget {
@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Color(0xFFF8F9FA),
appBar: AppBar(
title: Text(
"WOOD QUALITY GUIDE",
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
body: SingleChildScrollView(
padding: EdgeInsets.all(24),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// Introduction Card
Container(
padding: EdgeInsets.all(24),
decoration: BoxDecoration(
gradient: LinearGradient(
begin: Alignment.topLeft,
end: Alignment.bottomRight,
colors: [
Color(0xFF74B9FF).withOpacity(0.1),
Color(0xFF00B894).withOpacity(0.1),
],
),
borderRadius: BorderRadius.circular(20),
border: Border.all(
color: Color(0xFF74B9FF).withOpacity(0.3),
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
color: Color(0xFF74B9FF),
size: 28,
),
SizedBox(width: 12),
Text(
"Understanding Wood Quality",
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.w800,
color: Color(0xFF2D3436),
),
),
],
),
SizedBox(height: 16),
Text(
"Wood quality determines the strength, durability, and suitability of timber for different applications. Learn how to identify high-quality wood for your projects.",
style: TextStyle(
fontSize: 14,
color: Color(0xFF636E72),
height: 1.5,
),
),
],
),
),

SizedBox(height: 30),

// Quality Factors
_buildQualitySection(
"Key Quality Factors",
Icons.checklist_rounded,
[
_buildQualityFactor("Grain Pattern", "Straight, consistent grain indicates strength", Icons.grain_rounded, Color(0xFF8B4513)),
_buildQualityFactor("Moisture Content", "Properly dried wood (6-12% moisture)", Icons.water_drop_outlined, Color(0xFF74B9FF)),
_buildQualityFactor("Defects", "Minimal knots, cracks, or warping", Icons.search_rounded, Color(0xFFE17055)),
_buildQualityFactor("Density", "Higher density usually means stronger wood", Icons.fitness_center_rounded, Color(0xFF00B894)),
],
),

SizedBox(height: 30),

// Wood Grades
_buildGradeSection(),

SizedBox(height: 30),

// Common Wood Types
_buildWoodTypesSection(),

SizedBox(height: 30),

// Good vs Bad Wood Reference Section
_buildGoodVsBadWoodSection(),

SizedBox(height: 30),

// Quality Assessment Tips
_buildTipsSection(),
],
),
),
);
}

Widget _buildQualitySection(String title, IconData icon, List<Widget> children) {
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Icon(icon, color: Color(0xFF8B4513), size: 24),
SizedBox(width: 12),
Text(
title,
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.w700,
color: Color(0xFF2D3436),
),
),
],
),
SizedBox(height: 16),
...children,
],
);
}

Widget _buildQualityFactor(String title, String description, IconData icon, Color color) {
return Container(
margin: EdgeInsets.only(bottom: 12),
padding: EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(12),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.05),
blurRadius: 10,
offset: Offset(0, 4),
),
],
),
child: Row(
children: [
Container(
padding: EdgeInsets.all(8),
decoration: BoxDecoration(
color: color.withOpacity(0.1),
borderRadius: BorderRadius.circular(8),
),
child: Icon(icon, color: color, size: 20),
),
SizedBox(width: 16),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
title,
style: TextStyle(
fontSize: 14,
fontWeight: FontWeight.w600,
color: Color(0xFF2D3436),
),
),
SizedBox(height: 4),
Text(
description,
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
);
}

Widget _buildGradeSection() {
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 24),
SizedBox(width: 12),
Text(
"Wood Grades",
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.w700,
color: Color(0xFF2D3436),
),
),
],
),
SizedBox(height: 16),
_buildGradeCard("A+ Premium", "Perfect grain, no defects, premium applications", Color(0xFF9C27B0), Icons.diamond_rounded),
_buildGradeCard("A High Quality", "Minor defects, excellent for furniture", Color(0xFFFFD700), Icons.star_rounded),
_buildGradeCard("B+ Good", "Some defects, suitable for most projects", Color(0xFF74B9FF), Icons.star_border_rounded),
_buildGradeCard("B Fair", "Visible defects, utility applications", Color(0xFFFFB74D), Icons.circle_rounded),
_buildGradeCard("C Poor", "Major defects, limited use", Color(0xFFE17055), Icons.error_outline_rounded),
],
);
}

Widget _buildGradeCard(String grade, String description, Color color, IconData icon) {
return Container(
margin: EdgeInsets.only(bottom: 12),
padding: EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(12),
border: Border.all(color: color.withOpacity(0.3), width: 1),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.05),
blurRadius: 10,
offset: Offset(0, 4),
),
],
),
child: Row(
children: [
Container(
padding: EdgeInsets.all(8),
decoration: BoxDecoration(
color: color.withOpacity(0.1),
borderRadius: BorderRadius.circular(8),
),
child: Icon(icon, color: color, size: 20),
),
SizedBox(width: 16),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
grade,
style: TextStyle(
fontSize: 14,
fontWeight: FontWeight.w700,
color: color,
),
),
SizedBox(height: 4),
Text(
description,
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
);
}

Widget _buildWoodTypesSection() {
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Icon(Icons.park_rounded, color: Color(0xFF8B4513), size: 24),
SizedBox(width: 12),
Text(
"Common Wood Types",
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.w700,
color: Color(0xFF2D3436),
),
),
],
),
SizedBox(height: 16),
_buildWoodTypeCard("Oak", "Premium hardwood, excellent strength and durability", "Furniture, flooring, construction", Color(0xFF8B4513)),
_buildWoodTypeCard("Pine", "Versatile softwood, easy to work with", "Construction, furniture, crafts", Color(0xFF228B22)),
_buildWoodTypeCard("Maple", "Hard, fine-grained wood with smooth finish", "Furniture, cabinets, flooring", Color(0xFFD2691E)),
_buildWoodTypeCard("Walnut", "Premium hardwood with beautiful grain", "High-end furniture, decorative items", Color(0xFF654321)),
_buildWoodTypeCard("Cedar", "Weather-resistant softwood", "Outdoor projects, siding, decking", Color(0xFFB22222)),
],
);
}

Widget _buildWoodTypeCard(String name, String description, String uses, Color color) {
return Container(
margin: EdgeInsets.only(bottom: 12),
padding: EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(12),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.05),
blurRadius: 10,
offset: Offset(0, 4),
),
],
),
child: Row(
children: [
Container(
width: 4,
height: 40,
decoration: BoxDecoration(
color: color,
borderRadius: BorderRadius.circular(2),
),
),
SizedBox(width: 16),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
name,
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.w700,
color: Color(0xFF2D3436),
),
),
SizedBox(height: 4),
Text(
description,
style: TextStyle(
fontSize: 12,
color: Color(0xFF636E72),
height: 1.3,
),
),
SizedBox(height: 6),
Text(
"Best for: $uses",
style: TextStyle(
fontSize: 11,
color: color,
fontWeight: FontWeight.w600,
),
),
],
),
),
],
),
);
}

Widget _buildGoodVsBadWoodSection() {
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Icon(Icons.compare_arrows_rounded, color: Color(0xFF6C5CE7), size: 24),
SizedBox(width: 12),
Text(
"Good vs Bad Wood Reference",
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.w700,
color: Color(0xFF2D3436),
),
),
],
),
SizedBox(height: 16),

// Good Wood Section
Container(
padding: EdgeInsets.all(20),
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
color: Color(0xFF00B894).withOpacity(0.3),
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
color: Color(0xFF00B894),
borderRadius: BorderRadius.circular(10),
),
child: Icon(
Icons.thumb_up_rounded,
color: Colors.white,
size: 24,
),
),
SizedBox(width: 12),
Text(
"GOOD WOOD Characteristics",
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.w800,
color: Color(0xFF00B894),
letterSpacing: 0.5,
),
),
],
),
SizedBox(height: 16),
_buildCharacteristicItem(
"✓ Straight & Consistent Grain",
"Uniform grain pattern running parallel to the length",
Color(0xFF00B894),
true,
),
_buildCharacteristicItem(
"✓ Proper Moisture Content",
"6-12% moisture level, properly dried and seasoned",
Color(0xFF00B894),
true,
),
_buildCharacteristicItem(
"✓ Minimal Defects",
"Few or no knots, cracks, splits, or warping",
Color(0xFF00B894),
true,
),
_buildCharacteristicItem(
"✓ Uniform Color",
"Consistent coloring throughout without dark stains",
Color(0xFF00B894),
true,
),
_buildCharacteristicItem(
"✓ High Density",
"Feels solid and heavy for its size, indicating strength",
Color(0xFF00B894),
true,
),
_buildCharacteristicItem(
"✓ Clean Surface",
"No insect holes, fungal growth, or decay",
Color(0xFF00B894),
true,
),
_buildCharacteristicItem(
"✓ Tight Growth Rings",
"Close growth rings indicate slow growth and strength",
Color(0xFF00B894),
true,
),
],
),
),

SizedBox(height: 16),

// Bad Wood Section
Container(
padding: EdgeInsets.all(20),
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
color: Color(0xFFE17055).withOpacity(0.3),
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
color: Color(0xFFE17055),
borderRadius: BorderRadius.circular(10),
),
child: Icon(
Icons.thumb_down_rounded,
color: Colors.white,
size: 24,
),
),
SizedBox(width: 12),
Text(
"BAD WOOD Warning Signs",
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.w800,
color: Color(0xFFE17055),
letterSpacing: 0.5,
),
),
],
),
SizedBox(height: 16),
_buildCharacteristicItem(
"✗ Twisted or Irregular Grain",
"Grain runs at angles or spirals, weakening structure",
Color(0xFFE17055),
false,
),
_buildCharacteristicItem(
"✗ High Moisture Content",
"Above 15% moisture, prone to warping and shrinking",
Color(0xFFE17055),
false,
),
_buildCharacteristicItem(
"✗ Large Knots & Cracks",
"Structural weak points that can split or break",
Color(0xFFE17055),
false,
),
_buildCharacteristicItem(
"✗ Discoloration & Stains",
"Dark patches indicating rot, mold, or water damage",
Color(0xFFE17055),
false,
),
_buildCharacteristicItem(
"✗ Low Density",
"Feels light and hollow, indicating weakness or decay",
Color(0xFFE17055),
false,
),
_buildCharacteristicItem(
"✗ Insect Damage",
"Small holes, tunnels, or sawdust indicating infestation",
Color(0xFFE17055),
false,
),
_buildCharacteristicItem(
"✗ Warping or Bowing",
"Bent, twisted, or cupped shape from improper drying",
Color(0xFFE17055),
false,
),
],
),
),

SizedBox(height: 16),

// Quick Reference Card
Container(
padding: EdgeInsets.all(20),
decoration: BoxDecoration(
color: Color(0xFF6C5CE7).withOpacity(0.1),
borderRadius: BorderRadius.circular(16),
border: Border.all(
color: Color(0xFF6C5CE7).withOpacity(0.3),
width: 1,
),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Icon(Icons.info_outline_rounded, color: Color(0xFF6C5CE7), size: 20),
SizedBox(width: 8),
Text(
"Quick Reference Guide",
style: TextStyle(
fontSize: 14,
fontWeight: FontWeight.w700,
color: Color(0xFF2D3436),
),
),
],
),
SizedBox(height: 12),
Text(
"When scanning wood with CLEARCUT, the AI analyzes these characteristics to determine quality. "
"Good wood (75%+ confidence) shows most positive traits, while bad wood (below 75%) exhibits warning signs. "
"Always verify critical applications with professional inspection.",
style: TextStyle(
fontSize: 12,
color: Color(0xFF636E72),
height: 1.5,
),
),
],
),
),
],
);
}

Widget _buildCharacteristicItem(String title, String description, Color color, bool isGood) {
return Container(
margin: EdgeInsets.only(bottom: 12),
padding: EdgeInsets.all(12),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(10),
border: Border.all(
color: color.withOpacity(0.2),
width: 1,
),
),
child: Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Container(
padding: EdgeInsets.all(6),
decoration: BoxDecoration(
color: color.withOpacity(0.1),
borderRadius: BorderRadius.circular(6),
),
child: Icon(
isGood ? Icons.check_circle_rounded : Icons.cancel_rounded,
color: color,
size: 18,
),
),
SizedBox(width: 12),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
title,
style: TextStyle(
fontSize: 13,
fontWeight: FontWeight.w700,
color: Color(0xFF2D3436),
),
),
SizedBox(height: 4),
Text(
description,
style: TextStyle(
fontSize: 11,
color: Color(0xFF636E72),
height: 1.3,
),
),
],
),
),
],
),
);
}

Widget _buildTipsSection() {
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
Icon(Icons.lightbulb_outline_rounded, color: Color(0xFF74B9FF), size: 24),
SizedBox(width: 12),
Text(
"Quality Assessment Tips",
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.w700,
color: Color(0xFF2D3436),
),
),
],
),
SizedBox(height: 16),
_buildTip("Check for straight grain patterns - avoid twisted or irregular grain"),
_buildTip("Look for consistent color throughout the wood piece"),
_buildTip("Avoid wood with large knots, cracks, or splits"),
_buildTip("Test moisture content with a moisture meter (ideal: 6-12%)"),
_buildTip("Check for insect damage or fungal stains"),
_buildTip("Ensure the wood feels solid and doesn't sound hollow when tapped"),
],
),
);
}

Widget _buildTip(String tip) {
return Padding(
padding: EdgeInsets.only(bottom: 8),
child: Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Icon(Icons.check_circle_rounded, color: Color(0xFF00B894), size: 16),
SizedBox(width: 8),
Expanded(
child: Text(
tip,
style: TextStyle(
fontSize: 13,
color: Color(0xFF636E72),
height: 1.4,
),
),
),
],
),
);
}
}

// Usability Guidelines Screen
class UsabilityGuidelinesScreen extends StatelessWidget {
@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Color(0xFFF8F9FA),
appBar: AppBar(
title: Text(
"USABILITY GUIDELINES",
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
body: SingleChildScrollView(
padding: EdgeInsets.all(24),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// Introduction Card
Container(
padding: EdgeInsets.all(24),
decoration: BoxDecoration(
gradient: LinearGradient(
begin: Alignment.topLeft,
end: Alignment.bottomRight,
colors: [
Color(0xFF00B894).withOpacity(0.1),
Color(0xFF74B9FF).withOpacity(0.1),
],
),
borderRadius: BorderRadius.circular(20),
border: Border.all(
color: Color(0xFF00B894).withOpacity(0.3),
width: 1,
),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Icon(
Icons.rule_rounded,
color: Color(0xFF00B894),
size: 28,
),
SizedBox(width: 12),
Text(
"Wood Usability Guide",
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.w800,
color: Color(0xFF2D3436),
),
),
],
),
SizedBox(height: 16),
Text(
"Learn how to select the right wood for your specific project needs. Different applications require different wood characteristics.",
style: TextStyle(
fontSize: 14,
color: Color(0xFF636E72),
height: 1.5,
),
),
],
),
),

SizedBox(height: 30),

// Application Categories
_buildApplicationSection("🪑 Furniture Making", FontAwesomeIcons.couch, Color(0xFF8B4513), [
_buildUsabilityItem("🍽️ Dining Tables", "Oak, Maple, Walnut", "High strength, beautiful grain", "excellent", FontAwesomeIcons.utensils),
_buildUsabilityItem("🪑 Chairs", "Oak, Beech, Maple", "Strong joints, durability", "excellent", FontAwesomeIcons.chair),
_buildUsabilityItem("🗄️ Cabinets", "Cherry, Maple, Oak", "Stability, fine finish", "good", FontAwesomeIcons.boxArchive),
_buildUsabilityItem("📚 Shelving", "Pine, Oak, Birch", "Load-bearing capacity", "good", FontAwesomeIcons.bookOpen),
]),

SizedBox(height: 30),

_buildApplicationSection("🏗️ Construction", FontAwesomeIcons.hardHat, Color(0xFF74B9FF), [
_buildUsabilityItem("🏠 Framing", "Pine, Fir, Spruce", "Structural strength", "excellent", FontAwesomeIcons.house),
_buildUsabilityItem("🪵 Flooring", "Oak, Maple, Hickory", "Hardness, wear resistance", "excellent", FontAwesomeIcons.layerGroup),
_buildUsabilityItem("🏘️ Siding", "Cedar, Pine, Redwood", "Weather resistance", "good", FontAwesomeIcons.building),
_buildUsabilityItem("🏡 Decking", "Cedar, Teak, Pressure-treated Pine", "Moisture resistance", "good", FontAwesomeIcons.houseChimney),
]),

SizedBox(height: 30),

_buildApplicationSection("🌳 Outdoor Projects", FontAwesomeIcons.tree, Color(0xFF00B894), [
_buildUsabilityItem("🪴 Garden Furniture", "Teak, Cedar, Eucalyptus", "Weather resistance", "excellent", FontAwesomeIcons.seedling),
_buildUsabilityItem("🚧 Fencing", "Cedar, Pine, Redwood", "Durability outdoors", "good", FontAwesomeIcons.shield),
_buildUsabilityItem("🏛️ Pergolas", "Cedar, Redwood, Pressure-treated lumber", "Structural integrity", "good", FontAwesomeIcons.columns),
_buildUsabilityItem("🌱 Planters", "Cedar, Redwood, Teak", "Rot resistance", "excellent", FontAwesomeIcons.leaf),
]),

SizedBox(height: 30),

_buildApplicationSection("🎨 Crafting & Hobbies", FontAwesomeIcons.paintBrush, Color(0xFFFFB74D), [
_buildUsabilityItem("🔨 Carving", "Basswood, Pine, Butternut", "Easy to work", "excellent", FontAwesomeIcons.hammer),
_buildUsabilityItem("🌀 Turning", "Maple, Cherry, Walnut", "Smooth finish", "excellent", FontAwesomeIcons.circleNotch),
_buildUsabilityItem("📦 Small Projects", "Poplar, Pine, Basswood", "Affordable, workable", "good", FontAwesomeIcons.cube),
_buildUsabilityItem("🧸 Toys", "Maple, Birch, Beech", "Safe, durable", "good", FontAwesomeIcons.baby),
]),

SizedBox(height: 30),

// Selection Guidelines
_buildSelectionGuidelines(),

SizedBox(height: 30),

// Safety Considerations
_buildSafetySection(),
],
),
),
);
}

Widget _buildApplicationSection(String title, IconData icon, Color color, List<Widget> items) {
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Icon(icon, color: color, size: 24),
SizedBox(width: 12),
Text(
title,
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.w700,
color: Color(0xFF2D3436),
),
),
],
),
SizedBox(height: 16),
Container(
padding: EdgeInsets.all(16),
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
children: items,
),
),
],
);
}

Widget _buildUsabilityItem(String project, String woodTypes, String reason, String rating, [IconData? icon]) {
Color ratingColor;
switch (rating.toLowerCase()) {
case 'excellent':
ratingColor = Color(0xFF00B894);
break;
case 'good':
ratingColor = Color(0xFF74B9FF);
break;
case 'fair':
ratingColor = Color(0xFFFFB74D);
break;
default:
ratingColor = Color(0xFFE17055);
}

return Container(
margin: EdgeInsets.only(bottom: 12),
padding: EdgeInsets.all(12),
decoration: BoxDecoration(
color: Color(0xFFF8F9FA),
borderRadius: BorderRadius.circular(8),
border: Border.all(color: ratingColor.withOpacity(0.2), width: 1),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
if (icon != null) ...[
Container(
padding: EdgeInsets.all(6),
decoration: BoxDecoration(
color: ratingColor.withOpacity(0.1),
borderRadius: BorderRadius.circular(6),
),
child: FaIcon(
icon,
color: ratingColor,
size: 16,
),
),
SizedBox(width: 8),
],
Expanded(
child: Text(
project,
style: TextStyle(
fontSize: 14,
fontWeight: FontWeight.w600,
color: Color(0xFF2D3436),
),
),
),
Container(
padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
decoration: BoxDecoration(
color: ratingColor.withOpacity(0.1),
borderRadius: BorderRadius.circular(8),
),
child: Text(
rating.toUpperCase(),
style: TextStyle(
fontSize: 10,
fontWeight: FontWeight.w700,
color: ratingColor,
),
),
),
],
),
SizedBox(height: 6),
Text(
"Best woods: $woodTypes",
style: TextStyle(
fontSize: 12,
color: Color(0xFF8B4513),
fontWeight: FontWeight.w600,
),
),
SizedBox(height: 4),
Text(
reason,
style: TextStyle(
fontSize: 11,
color: Color(0xFF636E72),
height: 1.3,
),
),
],
),
);
}

Widget _buildSelectionGuidelines() {
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
Icon(Icons.checklist_rounded, color: Color(0xFF6C5CE7), size: 24),
SizedBox(width: 12),
Text(
"Selection Guidelines",
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.w700,
color: Color(0xFF2D3436),
),
),
],
),
SizedBox(height: 16),
_buildGuideline("Consider the environment", "Indoor vs outdoor, humidity levels, temperature changes"),
_buildGuideline("Match strength requirements", "Load-bearing vs decorative applications"),
_buildGuideline("Budget considerations", "Premium hardwoods vs affordable softwoods"),
_buildGuideline("Workability", "Hand tools vs power tools, skill level required"),
_buildGuideline("Finish requirements", "Natural beauty vs paint-grade applications"),
_buildGuideline("Sustainability", "Choose responsibly sourced or reclaimed wood"),
],
),
);
}

Widget _buildGuideline(String title, String description) {
return Padding(
padding: EdgeInsets.only(bottom: 12),
child: Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Container(
margin: EdgeInsets.only(top: 2),
width: 6,
height: 6,
decoration: BoxDecoration(
color: Color(0xFF6C5CE7),
shape: BoxShape.circle,
),
),
SizedBox(width: 12),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
title,
style: TextStyle(
fontSize: 14,
fontWeight: FontWeight.w600,
color: Color(0xFF2D3436),
),
),
SizedBox(height: 2),
Text(
description,
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
);
}

Widget _buildSafetySection() {
return Container(
padding: EdgeInsets.all(20),
decoration: BoxDecoration(
gradient: LinearGradient(
begin: Alignment.topLeft,
end: Alignment.bottomRight,
colors: [
Color(0xFFE17055).withOpacity(0.1),
Color(0xFFFF6B6B).withOpacity(0.1),
],
),
borderRadius: BorderRadius.circular(16),
border: Border.all(
color: Color(0xFFE17055).withOpacity(0.3),
width: 1,
),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Icon(Icons.warning_amber_rounded, color: Color(0xFFE17055), size: 24),
SizedBox(width: 12),
Text(
"Safety Considerations",
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.w700,
color: Color(0xFF2D3436),
),
),
],
),
SizedBox(height: 16),
_buildSafetyTip("Always wear appropriate PPE when working with wood"),
_buildSafetyTip("Check for treated lumber warnings and handle accordingly"),
_buildSafetyTip("Be aware of wood allergies (cedar, exotic woods)"),
_buildSafetyTip("Ensure proper ventilation when sanding or finishing"),
_buildSafetyTip("Test structural integrity before load-bearing applications"),
_buildSafetyTip("Use appropriate fasteners for wood type and application"),
],
),
);
}

Widget _buildSafetyTip(String tip) {
return Padding(
padding: EdgeInsets.only(bottom: 8),
child: Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Icon(Icons.warning_rounded, color: Color(0xFFE17055), size: 16),
SizedBox(width: 8),
Expanded(
child: Text(
tip,
style: TextStyle(
fontSize: 13,
color: Color(0xFF636E72),
height: 1.4,
),
),
),
],
),
);
}
}