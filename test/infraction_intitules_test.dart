import 'package:flutter_test/flutter_test.dart';
import 'package:droitpenalspecial/utils/infraction_suggestions.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('chargement des intitulés d\'infractions', () async {
    final intitules = await loadInfractionIntitules();
    expect(intitules, contains("Conduite en état alcoolique ou d'ivresse"));
    expect(intitules.isNotEmpty, true);
  });
}
