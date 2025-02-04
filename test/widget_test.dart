import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_kasir_statis/main.dart';

void main() {
  testWidgets('Menambah counter ketika tombol + ditekan', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byKey(const Key('counter')), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byKey(const Key('incrementButton')));
    await tester.pumpAndSettle(); 

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}