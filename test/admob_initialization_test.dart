import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('initialisation AdMob ne lance pas d\'erreur', () async {
    final future = MobileAds.instance.initialize();
    expect(future, completes);
  });
}
