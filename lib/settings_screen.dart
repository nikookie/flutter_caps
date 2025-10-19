import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'about_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _autoSaveScans = true;
  bool _highQualityImages = true;
  bool _darkMode = false;
  bool _demoMode = false;
  String _selectedLanguage = 'English';
  double _confidenceThreshold = 0.7;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _autoSaveScans = prefs.getBool('autoSave') ?? true;
      _highQualityImages = prefs.getBool('highQuality') ?? true;
      _darkMode = prefs.getBool('darkMode') ?? false;
      _demoMode = prefs.getBool('demoMode') ?? false;
      _selectedLanguage = prefs.getString('language') ?? 'English';
      _confidenceThreshold = prefs.getDouble('confidenceThreshold') ?? 0.7;
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    }
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFE17055), size: 28),
            SizedBox(width: 12),
            Text('Clear History?'),
          ],
        ),
        content: Text(
          'This will permanently delete all your scan history. This action cannot be undone.',
          style: TextStyle(fontSize: 14, color: Color(0xFF636E72)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: Color(0xFF636E72))),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE17055),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('scan_history');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Scan history cleared successfully'),
          backgroundColor: Color(0xFF00B894),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF2D3436)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: Color(0xFF2D3436),
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            color: Color(0xFFE2E8F0),
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            // General Settings Section
            _buildSectionHeader('General'),
            _buildSettingCard(
              icon: FontAwesomeIcons.bell,
              iconColor: Color(0xFF74B9FF),
              title: 'Notifications',
              subtitle: 'Receive scan completion alerts',
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() => _notificationsEnabled = value);
                  _saveSetting('notifications', value);
                },
                activeColor: Color(0xFF00B894),
              ),
            ),
            _buildSettingCard(
              icon: FontAwesomeIcons.floppyDisk,
              iconColor: Color(0xFF00B894),
              title: 'Auto-save Scans',
              subtitle: 'Automatically save scan results to history',
              trailing: Switch(
                value: _autoSaveScans,
                onChanged: (value) {
                  setState(() => _autoSaveScans = value);
                  _saveSetting('autoSave', value);
                },
                activeColor: Color(0xFF00B894),
              ),
            ),
            _buildSettingCard(
              icon: FontAwesomeIcons.language,
              iconColor: Color(0xFF6C5CE7),
              title: 'Language',
              subtitle: _selectedLanguage,
              trailing: Icon(Icons.chevron_right, color: Color(0xFF636E72)),
              onTap: () => _showLanguageDialog(),
            ),

            SizedBox(height: 20),

            // Scanning Settings Section
            _buildSectionHeader('Scanning'),
            _buildSettingCard(
              icon: FontAwesomeIcons.flask,
              iconColor: Color(0xFF6C5CE7),
              title: 'Demo Mode',
              subtitle: _demoMode ? 'Using sample data (No backend needed)' : 'Connect to backend for real scans',
              trailing: Switch(
                value: _demoMode,
                onChanged: (value) {
                  setState(() => _demoMode = value);
                  _saveSetting('demoMode', value);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(value 
                        ? '🎭 Demo Mode ON - Using sample data' 
                        : '🌐 Demo Mode OFF - Using real backend'),
                      backgroundColor: value ? Color(0xFF6C5CE7) : Color(0xFF00B894),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                activeColor: Color(0xFF6C5CE7),
              ),
            ),
            _buildSettingCard(
              icon: FontAwesomeIcons.image,
              iconColor: Color(0xFFFFB74D),
              title: 'High Quality Images',
              subtitle: 'Use higher resolution for better accuracy',
              trailing: Switch(
                value: _highQualityImages,
                onChanged: (value) {
                  setState(() => _highQualityImages = value);
                  _saveSetting('highQuality', value);
                },
                activeColor: Color(0xFF00B894),
              ),
            ),
            _buildSettingCard(
              icon: FontAwesomeIcons.gaugeHigh,
              iconColor: Color(0xFFE17055),
              title: 'Confidence Threshold',
              subtitle: 'Minimum confidence: ${(_confidenceThreshold * 100).toInt()}%',
              trailing: SizedBox.shrink(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Slider(
                      value: _confidenceThreshold,
                      min: 0.5,
                      max: 0.95,
                      divisions: 9,
                      activeColor: Color(0xFF00B894),
                      inactiveColor: Color(0xFFE2E8F0),
                      label: '${(_confidenceThreshold * 100).toInt()}%',
                      onChanged: (value) {
                        setState(() => _confidenceThreshold = value);
                      },
                      onChangeEnd: (value) {
                        _saveSetting('confidenceThreshold', value);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('50%', style: TextStyle(fontSize: 12, color: Color(0xFF636E72))),
                        Text('95%', style: TextStyle(fontSize: 12, color: Color(0xFF636E72))),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Appearance Section
            _buildSectionHeader('Appearance'),
            _buildSettingCard(
              icon: FontAwesomeIcons.moon,
              iconColor: Color(0xFF2D3436),
              title: 'Dark Mode',
              subtitle: 'Coming soon',
              trailing: Switch(
                value: _darkMode,
                onChanged: null, // Disabled for now
                activeColor: Color(0xFF00B894),
              ),
            ),

            SizedBox(height: 20),

            // Data & Storage Section
            _buildSectionHeader('Data & Storage'),
            _buildSettingCard(
              icon: FontAwesomeIcons.trashCan,
              iconColor: Color(0xFFE17055),
              title: 'Clear Scan History',
              subtitle: 'Delete all saved scan results',
              trailing: Icon(Icons.chevron_right, color: Color(0xFF636E72)),
              onTap: _clearHistory,
            ),
            _buildSettingCard(
              icon: FontAwesomeIcons.download,
              iconColor: Color(0xFF74B9FF),
              title: 'Export Data',
              subtitle: 'Download your scan history as CSV',
              trailing: Icon(Icons.chevron_right, color: Color(0xFF636E72)),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Export feature coming soon!'),
                    backgroundColor: Color(0xFF74B9FF),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
            ),

            SizedBox(height: 20),

            // About Section
            _buildSectionHeader('About'),
            // Temporarily disabled - About screen
            // _buildSettingCard(
            //   icon: FontAwesomeIcons.infoCircle,
            //   iconColor: Color(0xFF00B894),
            //   title: 'About CLEARCUT',
            //   subtitle: 'Model info, dataset, and methodology',
            //   trailing: Icon(Icons.chevron_right, color: Color(0xFF636E72)),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const AboutScreen()),
            //     );
            //   },
            // ),
            _buildSettingCard(
              icon: FontAwesomeIcons.circleInfo,
              iconColor: Color(0xFF6C5CE7),
              title: 'App Version',
              subtitle: '1.0.0',
              trailing: SizedBox.shrink(),
            ),
            _buildSettingCard(
              icon: FontAwesomeIcons.fileLines,
              iconColor: Color(0xFF00B894),
              title: 'Terms & Conditions',
              subtitle: 'Read our terms of service',
              trailing: Icon(Icons.chevron_right, color: Color(0xFF636E72)),
              onTap: () {
                // Navigate to terms screen
              },
            ),
            _buildSettingCard(
              icon: FontAwesomeIcons.shield,
              iconColor: Color(0xFF74B9FF),
              title: 'Privacy Policy',
              subtitle: 'How we handle your data',
              trailing: Icon(Icons.chevron_right, color: Color(0xFF636E72)),
              onTap: () {
                // Navigate to privacy screen
              },
            ),

            SizedBox(height: 30),

            // App Info Footer
            Center(
              child: Column(
                children: [
                  Icon(Icons.eco, color: Color(0xFF00B894), size: 32),
                  SizedBox(height: 8),
                  Text(
                    'CLEARCUT',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2D3436),
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'AI-Powered Wood Recognition',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF636E72),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF636E72),
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
    Widget? child,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FaIcon(
                        icon,
                        color: iconColor,
                        size: 20,
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
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF636E72),
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing,
                  ],
                ),
              ),
            ),
          ),
          if (child != null) child,
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    final languages = ['English', 'Filipino', 'Spanish', 'Chinese', 'Japanese'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(FontAwesomeIcons.language, color: Color(0xFF6C5CE7), size: 24),
            SizedBox(width: 12),
            Text(
              'Select Language',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) {
            return RadioListTile<String>(
              title: Text(lang),
              value: lang,
              groupValue: _selectedLanguage,
              activeColor: Color(0xFF00B894),
              onChanged: (value) {
                setState(() => _selectedLanguage = value!);
                _saveSetting('language', value!);
                Navigator.pop(context);
                
                if (value != 'English') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$value language support coming soon!'),
                      backgroundColor: Color(0xFF74B9FF),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
