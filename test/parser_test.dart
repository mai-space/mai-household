import 'package:flutter_test/flutter_test.dart';
import 'package:mai_household/domain/shopping/classifier.dart';
import 'package:mai_household/domain/shopping/departments.dart';
import 'package:mai_household/domain/shopping/voice_parser.dart';
import 'package:mai_household/domain/text/normalize.dart';
import 'package:mai_household/domain/text/quantity.dart';

void main() {
  final parser = VoiceParser(const [
    StoreAlias('store-aldi', ['aldi', 'aldi süd', 'aldi nord']),
    StoreAlias('store-hit', ['hit']),
    StoreAlias('store-rewe', ['rewe']),
    StoreAlias('store-netto', ['netto']),
  ]);

  group('VoiceParser', () {
    test('Beispielsatz aus dem Konzept', () {
      final items = parser.parse(
        'Zwei Liter Milch, ein Brot, Eier und drei Paprika, und Spülmittel bei Rewe',
      );
      expect(items.map((i) => i.name), [
        'Milch',
        'Brot',
        'Eier',
        'Paprika',
        'Spülmittel',
      ]);
      expect(items[0].amount, 2);
      expect(items[0].unit, 'l');
      expect(items[1].amount, 1);
      expect(items[2].amount, isNull);
      expect(items[3].amount, 3);
      expect(items[4].storeId, 'store-rewe');
      expect(items.take(4).every((i) => i.storeId == null), isTrue);
    });

    test('Laden am Anfang gilt für alle', () {
      final items = parser.parse('Bei Aldi: Bananen, Joghurt und Butter');
      expect(items, hasLength(3));
      expect(items.every((i) => i.storeId == 'store-aldi'), isTrue);
    });

    test('„alles bei“ am Ende gilt für alle', () {
      final items = parser.parse('Nudeln und Tomaten, alles bei Netto');
      expect(items.map((i) => i.name), ['Nudeln', 'Tomaten']);
      expect(items.every((i) => i.storeId == 'store-netto'), isTrue);
    });

    test('Füllwörter fallen weg', () {
      final items = parser.parse(
        'Wir brauchen noch Kaffee und kauf mal Klopapier bitte',
      );
      expect(items.map((i) => i.name), ['Kaffee', 'Klopapier']);
    });

    test('nachgestellte Mengen', () {
      final items = parser.parse('Hackfleisch 500g');
      expect(items.single.name, 'Hackfleisch');
      expect(items.single.amount, 500);
      expect(items.single.unit, 'g');
    });

    test('HIT als Laden, nicht als Wort im Namen', () {
      final items = parser.parse('Wasser bei HIT');
      expect(items.single.name, 'Wasser');
      expect(items.single.storeId, 'store-hit');
    });

    test('leere Eingaben', () {
      expect(parser.parse(''), isEmpty);
      expect(parser.parse(' und , noch '), isEmpty);
    });
  });

  group('Quantity', () {
    test('Rezeptzeilen', () {
      final a = Quantity.parse('200 g Mehl');
      expect([a.amount, a.unit, a.name], [200, 'g', 'Mehl']);
      final b = Quantity.parse('1/2 TL Salz');
      expect([b.amount, b.unit, b.name], [0.5, 'TL', 'Salz']);
      final c = Quantity.parse('1 1/2 EL Öl');
      expect([c.amount, c.unit], [1.5, 'EL']);
      final d = Quantity.parse('½ Zitrone');
      expect([d.amount, d.name], [0.5, 'Zitrone']);
      final e = Quantity.parse('Salz und Pfeffer');
      expect([e.amount, e.unit, e.name], [null, null, 'Salz und Pfeffer']);
      final f = Quantity.parse('2,5 kg Kartoffeln');
      expect([f.amount, f.unit], [2.5, 'kg']);
    });

    test('Skalieren', () {
      expect(Quantity.formatScaled(200, 'g', 1.5), '300');
      expect(Quantity.formatScaled(3, null, 0.5), '1–2');
      expect(Quantity.formatScaled(2, null, 1.5), '3');
      expect(Quantity.formatScaled(0.5, 'TL', 2), '1');
      expect(Quantity.formatAmount(1.5), '1½');
      expect(Quantity.formatAmount(0.25), '¼');
      expect(Quantity.label(2, 'l'), '2 l');
    });
  });

  group('Klassifikation', () {
    final c = ProductClassifier();
    String? dep(String s) => c.classify(s);

    test('Wörterbuch, Plural, Zusammensetzungen, Tippfehler', () {
      expect(dep('Milch'), BuiltinDepartment.dairy.id);
      expect(dep('Äpfel'), BuiltinDepartment.produce.id);
      expect(dep('Tomaten'), BuiltinDepartment.produce.id);
      expect(dep('Vollkorntoast'), BuiltinDepartment.bakery.id);
      expect(dep('Seelachsfilet'), BuiltinDepartment.fish.id);
      expect(dep('Hähnchenbrustfilet'), BuiltinDepartment.meat.id);
      expect(dep('Zahnpasta'), BuiltinDepartment.drugstore.id);
      expect(dep('Spülmittel'), BuiltinDepartment.household.id);
      expect(dep('Bio Hafermilch'), BuiltinDepartment.dairy.id);
      expect(dep('Joghurts'), BuiltinDepartment.dairy.id);
      expect(dep('Kartofeln'), BuiltinDepartment.produce.id);
      expect(dep('Reis'), BuiltinDepartment.pasta.id);
      expect(dep('Brötchen'), BuiltinDepartment.bakery.id);
      expect(dep('Klopapier'), BuiltinDepartment.drugstore.id);
      expect(dep('Xyzzy'), isNull);
    });

    test('eigene Historie gewinnt', () {
      final mine = ProductClassifier(
        memory: {TextNorm.key('Hafermilch'): BuiltinDepartment.drinks.id},
      );
      expect(mine.classify('hafermilch'), BuiltinDepartment.drinks.id);
    });
  });
}
