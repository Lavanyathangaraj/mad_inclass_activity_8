import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: PageView(
        children: [
          FadingTextAnimation(
            isDarkMode: _isDarkMode,
            onToggleTheme: toggleTheme,
            duration: const Duration(seconds: 1),
            title: 'Fading Text (1s)',
          ),
          FadingTextAnimation(
            isDarkMode: _isDarkMode,
            onToggleTheme: toggleTheme,
            duration: const Duration(seconds: 3),
            title: 'Fading Text (3s)',
          ),
        ],
      ),
    );
  }
}

class FadingTextAnimation extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final Duration duration;
  final String title;

  const FadingTextAnimation({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.duration,
    required this.title,
  });

  @override
  _FadingTextAnimationState createState() => _FadingTextAnimationState();
}

class _FadingTextAnimationState extends State<FadingTextAnimation> {
  bool _isVisible = true;
  Color _textColor = const Color.fromARGB(255, 15, 139, 240);

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void _showColorPicker() {
    Color pickerColor = _textColor;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a text color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (color) {
                pickerColor = color;
              },
              enableAlpha: false,
              labelTypes: const [],
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _textColor = pickerColor;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Select'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
            onPressed: widget.onToggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: _showColorPicker,
          ),
        ],
      ),
      body: Center(
        child: AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0.0,
          duration: widget.duration,
          curve: Curves.easeInOut,
          child: Text(
            'Hello, Flutter!',
            style: TextStyle(fontSize: 24, color: _textColor),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleVisibility,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
