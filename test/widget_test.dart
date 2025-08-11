// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, verify widget properties, etc.
//
// For more information, see: https://flutter.dev/docs/cookbook/testing/widget/introduction

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/main.dart';

void main() {
  testWidgets('MyApp displays splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the splash screen is displayed with the app title.
    expect(find.text('Quiz App'), findsOneWidget);
    expect(find.byIcon(Icons.quiz), findsOneWidget);

    // Optionally, simulate the splash screen duration and check navigation.
    // Since SplashScreen navigates after 3 seconds, we can advance the timer.
    await tester.pump(const Duration(seconds: 3));

    // Trigger a frame to allow navigation to QuizScreen.
    await tester.pumpAndSettle();

    // Verify that the QuizScreen is displayed by checking for the 'Quiz' app bar title.
    expect(find.text('Quiz'), findsOneWidget);
  });
}