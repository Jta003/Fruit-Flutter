import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:app_ar_v1/main.dart';
import 'package:app_ar_v1/providers/fruit_provider.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    cameras = [];

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FruitProvider()),
        ],
        child: const FruitNutritionArApp(),
      ),
    );

    await tester.pump();

    expect(find.text('Fruit Nutrition'), findsAtLeast(1));
  });
}
