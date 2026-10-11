import 'package:flutter/material.dart';

import '../data/app_database.dart';
import '../domain/chores/templates.dart';
import '../domain/shopping/departments.dart';
import '../l10n/l10n.dart';

/// Anzeigenamen und Symbole für eingebaute Einträge.
extension DisplayNames on AppLocalizations {
  String departmentName(Department d) =>
      d.name ?? builtinDepartmentName(BuiltinDepartment.fromId(d.id));

  String builtinDepartmentName(BuiltinDepartment? d) => switch (d) {
    BuiltinDepartment.produce => depProduce,
    BuiltinDepartment.bakery => depBakery,
    BuiltinDepartment.dairy => depDairy,
    BuiltinDepartment.meat => depMeat,
    BuiltinDepartment.fish => depFish,
    BuiltinDepartment.frozen => depFrozen,
    BuiltinDepartment.pasta => depPasta,
    BuiltinDepartment.canned => depCanned,
    BuiltinDepartment.baking => depBaking,
    BuiltinDepartment.spices => depSpices,
    BuiltinDepartment.breakfast => depBreakfast,
    BuiltinDepartment.sweets => depSweets,
    BuiltinDepartment.drinks => depDrinks,
    BuiltinDepartment.drugstore => depDrugstore,
    BuiltinDepartment.household => depHousehold,
    BuiltinDepartment.baby => depBaby,
    BuiltinDepartment.pet => depPet,
    BuiltinDepartment.other || null => depOther,
  };

  String areaName(Area a) => a.name ?? builtinAreaName(BuiltinArea.fromId(a.id));

  String builtinAreaName(BuiltinArea? a) => switch (a) {
    BuiltinArea.general || null => areaGeneral,
    BuiltinArea.kitchen => areaKitchen,
    BuiltinArea.bath => areaBath,
    BuiltinArea.living => areaLiving,
    BuiltinArea.bedroom => areaBedroom,
    BuiltinArea.laundry => areaLaundry,
    BuiltinArea.outside => areaOutside,
  };

  String choreTemplateName(String key) => switch (key) {
    'vacuum' => tplVacuum,
    'mop' => tplMop,
    'dust' => tplDust,
    'trash' => tplTrash,
    'dishwasher' => tplDishwasher,
    'fridge' => tplFridge,
    'stove' => tplStove,
    'bathroom' => tplBathroom,
    'towels' => tplTowels,
    'drain' => tplDrain,
    'bedding' => tplBedding,
    'laundry' => tplLaundry,
    'plants' => tplPlants,
    'glass' => tplGlass,
    'windows' => tplWindows,
    _ => key,
  };
}

abstract final class AppIcons {
  static IconData department(String id) =>
      switch (BuiltinDepartment.fromId(id)) {
        BuiltinDepartment.produce => Icons.eco_outlined,
        BuiltinDepartment.bakery => Icons.bakery_dining_outlined,
        BuiltinDepartment.dairy => Icons.egg_outlined,
        BuiltinDepartment.meat => Icons.kebab_dining_outlined,
        BuiltinDepartment.fish => Icons.set_meal_outlined,
        BuiltinDepartment.frozen => Icons.ac_unit,
        BuiltinDepartment.pasta => Icons.ramen_dining_outlined,
        BuiltinDepartment.canned => Icons.inventory_2_outlined,
        BuiltinDepartment.baking => Icons.cake_outlined,
        BuiltinDepartment.spices => Icons.soup_kitchen_outlined,
        BuiltinDepartment.breakfast => Icons.free_breakfast_outlined,
        BuiltinDepartment.sweets => Icons.cookie_outlined,
        BuiltinDepartment.drinks => Icons.local_drink_outlined,
        BuiltinDepartment.drugstore => Icons.sanitizer_outlined,
        BuiltinDepartment.household => Icons.cleaning_services_outlined,
        BuiltinDepartment.baby => Icons.child_friendly_outlined,
        BuiltinDepartment.pet => Icons.pets_outlined,
        BuiltinDepartment.other || null => Icons.category_outlined,
      };

  static IconData area(String id) => switch (BuiltinArea.fromId(id)) {
    BuiltinArea.general || null => Icons.home_outlined,
    BuiltinArea.kitchen => Icons.kitchen_outlined,
    BuiltinArea.bath => Icons.bathtub_outlined,
    BuiltinArea.living => Icons.weekend_outlined,
    BuiltinArea.bedroom => Icons.bed_outlined,
    BuiltinArea.laundry => Icons.local_laundry_service_outlined,
    BuiltinArea.outside => Icons.yard_outlined,
  };
}
