class Validators {
  static String? notEmptyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  static String? numberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    final n = num.tryParse(value);
    if (n == null) {
      return 'Please enter a valid number';
    }
    return null;
  }
}
