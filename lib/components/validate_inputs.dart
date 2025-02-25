class ValidateInputs{
  static bool validateEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }
  static bool validatePassword(String password) {
    return password.length >= 6; // Example: Password must be at least 6 characters
  }
}