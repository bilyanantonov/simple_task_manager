class ValidationMixin {
  String validateTextInput(String value) {
    if (value.length < 4) {
      return "This field must contain least 4 characters";
    }
    return null;
  }
}
