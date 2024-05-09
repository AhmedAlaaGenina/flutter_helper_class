extension CapExtension on String {
  String get capitalizeFirst => '${this[0].toUpperCase()}${substring(1)}';

  String get allInCapitalize => toUpperCase();

  String get capitalizeFirstOfEach =>
      split(" ").map((str) => str.capitalizeFirst).join(" ");
}

extension ValidatedString on String? {
  bool get isNotNull {
    return this != null;
  }
}
