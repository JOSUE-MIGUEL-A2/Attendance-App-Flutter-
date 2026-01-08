import 'package:flutter/material.dart';
import 'package:thesis_attendance/data/notifiers.dart';

class Settings extends StatelessWidget {
  const Settings({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder(
          valueListenable: appSettingsNotifier,
          builder: (context, settings, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Appearance Section
                const Text(
                  "App Appearance",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Font Size Control
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Font Size",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${settings.fontSize.toInt()}px',
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Slider(
                          value: settings.fontSize,
                          min: 10,
                          max: 24,
                          divisions: 14,
                          label: '${settings.fontSize.round()}px',
                          onChanged: (value) {
                            appSettingsNotifier.value = AppSettings(
                              fontSize: value,
                              fontFamily: settings.fontFamily,
                              showAnimations: settings.showAnimations,
                              language: settings.language,
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Small (10px)',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              'Large (24px)',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Font Family Dropdown
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Font Style",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: settings.fontFamily,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.font_download),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: ['Roboto', 'OpenSans', 'Lato', 'Poppins', 'Montserrat']
                              .map((font) => DropdownMenuItem(
                                    value: font,
                                    child: Text(font, style: TextStyle(fontFamily: font)),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              appSettingsNotifier.value = AppSettings(
                                fontSize: settings.fontSize,
                                fontFamily: value,
                                showAnimations: settings.showAnimations,
                                language: settings.language,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Card(
                  child: SwitchListTile(
                    secondary: Icon(
                      settings.showAnimations ? Icons.animation : Icons.block,
                      color: settings.showAnimations ? Colors.green : Colors.grey,
                    ),
                    title: const Text(
                      'Show Animations',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('Enable Lottie animations and transitions'),
                    value: settings.showAnimations,
                    onChanged: (value) {
                      appSettingsNotifier.value = AppSettings(
                        fontSize: settings.fontSize,
                        fontFamily: settings.fontFamily,
                        showAnimations: value,
                        language: settings.language,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                Card(
                  child: ValueListenableBuilder(
                    valueListenable: isDarkNotifier,
                    builder: (context, isDark, child) {
                      return SwitchListTile(
                        secondary: Icon(
                          isDark ? Icons.dark_mode : Icons.light_mode,
                          color: isDark ? Colors.blue : Colors.orange,
                        ),
                        title: const Text(
                          'Dark Mode',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text('Reduce eye strain at night'),
                        value: isDark,
                        onChanged: (value) {
                          isDarkNotifier.value = value;
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  "Language & Region",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "App Language",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: settings.language,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.language),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: ['English', 'Filipino', 'Spanish', 'Chinese']
                              .map((lang) => DropdownMenuItem(
                                    value: lang,
                                    child: Text(lang),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              appSettingsNotifier.value = AppSettings(
                                fontSize: settings.fontSize,
                                fontFamily: settings.fontFamily,
                                showAnimations: settings.showAnimations,
                                language: value,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Preview Section
                const Text(
                  "Preview",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sample Text',
                          style: TextStyle(
                            fontSize: settings.fontSize + 4,
                            fontFamily: settings.fontFamily,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Wala ako m7 pass . '
                          'Kuta Natanggal',
                          style: TextStyle(
                            fontSize: settings.fontSize,
                            fontFamily: settings.fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Reset Button
                Center(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Reset Settings'),
                          content: const Text(
                            'Reset all settings to default values?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                appSettingsNotifier.value = AppSettings(
                                  fontSize: 14.0,
                                  fontFamily: 'Roboto',
                                  showAnimations: true,
                                  language: 'English',
                                );
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Settings reset to default'),
                                  ),
                                );
                              },
                              child: const Text('Reset'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset to Default'),
                  ),
                ),

                const SizedBox(height: 16),

                // Footer
                Center(
                  child: Text(
                    '💡 Changes are saved automatically',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}