import 'package:flutter_test/flutter_test.dart';
import 'package:ia_photo_booth_flutter/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const IcbeuPhotoBoothApp());
    expect(find.byType(IcbeuPhotoBoothApp), findsOneWidget);
  });
}
