import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fading_text_animation_example/main.dart';  // Ensure this matches pubspec.yaml

void main() {
  testWidgets('Fading Text Animation Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Hello, Flutter!'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Hello, Flutter!'), findsOneWidget);
    
    await tester.tap(find.byIcon(Icons.brightness_3));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.brightness_7));
    await tester.pump();

    expect(find.byIcon(Icons.color_lens), findsOneWidget);
  });
}
