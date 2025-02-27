\\Venkata Saileenath Reddy Jampala and Foungnigue Hassan 
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  Color _textColor = Colors.black;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ✅ Removes debug banner
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Multi-Fading Text Animation'),
            actions: [
              IconButton(
                icon: Icon(_isDarkMode ? Icons.brightness_7 : Icons.brightness_3),
                onPressed: () {
                  setState(() {
                    _isDarkMode = !_isDarkMode;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.color_lens),
                onPressed: () => _showColorPicker(context),
              ),
            ],
          ),
          body: Listener(
            onPointerDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragUpdate: (details) {
                if (details.primaryDelta! > 0) {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: PageView(
                controller: _pageController,
                children: [
                  FadingTextAnimationPage(
                    textColor: _textColor,
                    words: const ['Hello, Flutter!', 'Welcome to Flutter!', 'Enjoy Coding!'],
                    durationSeconds: 1,
                  ),
                  FadingTextWithFramePage(
                    textColor: _textColor,
                    words: const ['Develop Apps!', 'UI with Flutter!', 'Dart Programming!'],
                    durationSeconds: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ✅ Fixed: Color Picker Now Works Without Errors
  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color tempColor = _textColor;
        return Builder(
          builder: (BuildContext innerContext) {
            return AlertDialog(
              title: const Text('Pick a text color'),
              content: StatefulBuilder(
                builder: (context, setStateDialog) {
                  return SingleChildScrollView(
                    child: Material(
                      child: BlockPicker(
                        pickerColor: tempColor,
                        onColorChanged: (Color color) {
                          setStateDialog(() {
                            tempColor = color;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              actions: [
                TextButton(
                  child: const Text('CANCEL'),
                  onPressed: () => Navigator.of(innerContext).pop(),
                ),
                ElevatedButton(
                  child: const Text('SELECT'),
                  onPressed: () {
                    setState(() {
                      _textColor = tempColor;
                    });
                    Navigator.of(innerContext).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// ---------------------------------------------------------------------
// ✅ Define `FadingTextAnimationPage`
// ---------------------------------------------------------------------
class FadingTextAnimationPage extends StatefulWidget {
  final Color textColor;
  final List<String> words;
  final int durationSeconds;

  const FadingTextAnimationPage({
    super.key,
    required this.textColor,
    required this.words,
    required this.durationSeconds,
  });

  @override
  FadingTextAnimationPageState createState() => FadingTextAnimationPageState();
}

class FadingTextAnimationPageState extends State<FadingTextAnimationPage> {
  int _currentIndex = 0;
  bool _isVisible = true;

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
      if (!_isVisible) {
        Future.delayed(Duration(seconds: widget.durationSeconds), () {
          setState(() {
            _currentIndex = (_currentIndex + 1) % widget.words.length;
            _isVisible = true;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0.0,
          duration: Duration(seconds: widget.durationSeconds),
          curve: Curves.easeInOut,
          child: Text(
            widget.words[_currentIndex],
            style: TextStyle(fontSize: 28, color: widget.textColor),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleVisibility,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}

// ---------------------------------------------------------------------
// ✅ Define `FadingTextWithFramePage`
// ---------------------------------------------------------------------
class FadingTextWithFramePage extends StatefulWidget {
  final Color textColor;
  final List<String> words;
  final int durationSeconds;

  const FadingTextWithFramePage({
    super.key,
    required this.textColor,
    required this.words,
    required this.durationSeconds,
  });

  @override
  FadingTextWithFramePageState createState() =>
      FadingTextWithFramePageState();
}

class FadingTextWithFramePageState extends State<FadingTextWithFramePage> {
  int _currentIndex = 0;
  bool _isVisible = true;
  bool _showFrame = false;

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
      if (!_isVisible) {
        Future.delayed(Duration(seconds: widget.durationSeconds), () {
          setState(() {
            _currentIndex = (_currentIndex + 1) % widget.words.length;
            _isVisible = true;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: Duration(seconds: widget.durationSeconds),
              curve: Curves.easeInOut,
              child: Text(
                widget.words[_currentIndex],
                style: TextStyle(fontSize: 28, color: widget.textColor),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              decoration: _showFrame
                  ? BoxDecoration(
                      border: Border.all(color: Colors.red, width: 4),
                      borderRadius: BorderRadius.circular(8),
                    )
                  : null,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_showFrame ? 8 : 0),
                child: Image.asset(
                  'assets/image1.jpeg', // ✅ Using Local Image
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
