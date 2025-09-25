import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _apiController = TextEditingController();
  double _confidenceThreshold = 0.6; // 0.0..1.0
  bool _forceTestMode = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _apiController.text = prefs.getString('api_base') ?? 'http://10.0.2.2:5000';
      _confidenceThreshold = (prefs.getDouble('confidence_threshold') ?? 0.6).clamp(0.0, 1.0);
      _forceTestMode = prefs.getBool('force_test_mode') ?? false;
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_base', _apiController.text.trim());
    await prefs.setDouble('confidence_threshold', _confidenceThreshold);
    await prefs.setBool('force_test_mode', _forceTestMode);
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved')),
      );
    }
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Clear Scan History'),
            content: const Text('This will remove all locally saved scans.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Clear')),
            ],
          ),
        ) ??
        false;
    if (!confirmed) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('scan_history');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('History cleared')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('API', style: TextStyle(fontSize: 12, color: Color(0xFF636E72))),
          const SizedBox(height: 6),
          TextField(
            controller: _apiController,
            decoration: InputDecoration(
              labelText: 'API Base URL',
              hintText: 'http://<host>:<port>',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Force Test Mode'),
              Switch(
                value: _forceTestMode,
                onChanged: (v) => setState(() => _forceTestMode = v),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Confidence Threshold', style: TextStyle(fontSize: 12, color: Color(0xFF636E72))),
          Slider(
            value: _confidenceThreshold,
            min: 0.4,
            max: 0.9,
            divisions: 5,
            label: (_confidenceThreshold * 100).toStringAsFixed(0) + '%',
            onChanged: (v) => setState(() => _confidenceThreshold = v),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: const Icon(Icons.save),
                  label: Text(_saving ? 'Saving...' : 'Save Settings'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: _clearHistory,
            icon: const Icon(Icons.delete_sweep),
            label: const Text('Clear Scan History'),
          ),
        ],
      ),
    );
  }
}


