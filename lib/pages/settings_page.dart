import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final Function(bool) toggleTheme;

  const SettingsPage({super.key, required this.toggleTheme});

  @override

  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();

    // ignore: deprecated_member_use
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    setState(() {
      isDarkMode = brightness == Brightness.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.teal[800], // AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Dark Mode:', style: TextStyle(fontSize: 18)),
                Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value;
                    });
                    widget.toggleTheme(isDarkMode);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
