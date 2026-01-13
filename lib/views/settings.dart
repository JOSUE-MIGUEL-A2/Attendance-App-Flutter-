
// ==================== pages/settings_page.dart ====================
import 'package:flutter/material.dart';
import 'package:thesis_attendance/theme/app_theme.dart';
import 'package:thesis_attendance/theme/theme_notifier.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Settings'),
      ),
      body: ValueListenableBuilder<ThemeSettings>(
        valueListenable: themeSettingsNotifier,
        builder: (context, settings, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Appearance Section
                Text(
                  'Appearance',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),

                // Dark Mode Toggle
                Card(
                  child: SwitchListTile(
                    secondary: Icon(
                      settings.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    ),
                    title: const Text(
                      'Dark Mode',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('Enable dark theme'),
                    value: settings.isDarkMode,
                    onChanged: (value) {
                      themeSettingsNotifier.value = settings.copyWith(
                        isDarkMode: value,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Color Theme Selector
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.palette),
                            const SizedBox(width: 12),
                            Text(
                              'Color Theme',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            // ISAT-U Colors - Featured First
                            ...['ISAT-U'].map((themeName) {
                              final isSelected = settings.colorTheme == themeName;
                              final colorScheme = settings.isDarkMode
                                  ? AppTheme.darkColorSchemes[themeName]!
                                  : AppTheme.colorSchemes[themeName]!;

                              return GestureDetector(
                                onTap: () {
                                  themeSettingsNotifier.value = settings.copyWith(
                                    colorTheme: themeName,
                                  );
                                },
                                child: Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                colorScheme.primary,
                                                colorScheme.secondary,
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isSelected
                                                  ? colorScheme.secondary
                                                  : Colors.transparent,
                                              width: 4,
                                            ),
                                            boxShadow: isSelected
                                                ? [
                                                    BoxShadow(
                                                      color: colorScheme.primary.withOpacity(0.4),
                                                      blurRadius: 12,
                                                      spreadRadius: 3,
                                                    ),
                                                  ]
                                                : null,
                                          ),
                                          child: isSelected
                                              ? Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 35,
                                                )
                                              : null,
                                        ),
                                        if (!isSelected)
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: colorScheme.secondary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.star,
                                                color: colorScheme.onSecondary,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'ISAT-U',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.school,
                                          size: 14,
                                          color: colorScheme.primary,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Gold & Blue',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            // Other themes
                            ...AppTheme.colorSchemes.keys
                                .where((name) => name != 'ISAT-U')
                                .map((themeName) {
                              final isSelected = settings.colorTheme == themeName;
                              final colorScheme = settings.isDarkMode
                                  ? AppTheme.darkColorSchemes[themeName]!
                                  : AppTheme.colorSchemes[themeName]!;

                              return GestureDetector(
                                onTap: () {
                                  themeSettingsNotifier.value = settings.copyWith(
                                    colorTheme: themeName,
                                  );
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? colorScheme.secondary
                                              : Colors.transparent,
                                          width: 3,
                                        ),
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: colorScheme.primary.withOpacity(0.4),
                                                  blurRadius: 8,
                                                  spreadRadius: 2,
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: isSelected
                                          ? Icon(
                                              Icons.check,
                                              color: colorScheme.onPrimary,
                                              size: 30,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      themeName.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Typography Section
                Text(
                  'Typography',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),

                // Font Family Selector
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.font_download),
                            const SizedBox(width: 12),
                            Text(
                              'Font Style',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: settings.fontFamily,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          items: AppTheme.fontFamilies
                              .map((font) => DropdownMenuItem(
                                    value: font,
                                    child: Text(
                                      font,
                                      style: TextStyle(fontFamily: font),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              themeSettingsNotifier.value = settings.copyWith(
                                fontFamily: value,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Font Size Slider
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.format_size),
                                const SizedBox(width: 12),
                                Text(
                                  'Font Size',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${settings.fontSize.toInt()}px',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                            themeSettingsNotifier.value = settings.copyWith(
                              fontSize: value,
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Small (10px)',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              'Large (24px)',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Preview Section
                Text(
                  'Preview',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.preview,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Sample Text',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Text(
                          'Welcome Tradeans!',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This is how your text will appear throughout the app. '
                          'The quick brown fox jumps over the lazy dog.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Present',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
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
                      themeSettingsNotifier.value = ThemeSettings();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Settings reset to default'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset to Default'),
                  ),
                ),
                const SizedBox(height: 16),

                // Info Footer
                Center(
                  child: Text(
                    ' Changes are applied instantly',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}