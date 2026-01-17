/// Validators for user input
class Validators {
  /// Validate email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validate password (min 8 characters)
  static bool isValidPassword(String password) {
    return password.length >= 8;
  }

  /// Validate 6-digit PIN
  static bool isValidPIN(String pin) {
    if (pin.length != 6) return false;
    return RegExp(r'^\d{6}$').hasMatch(pin);
  }

  /// Get password validation message
  static String? getPasswordError(String password) {
    if (password.isEmpty) return 'Password is required';
    if (password.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  /// Get PIN validation message
  static String? getPINError(String pin) {
    if (pin.isEmpty) return 'PIN is required';
    if (pin.length != 6) return 'PIN must be exactly 6 digits';
    if (!RegExp(r'^\d{6}$').hasMatch(pin)) return 'PIN must contain only numbers';
    return null;
  }

  /// Get email validation message
  static String? getEmailError(String email) {
    if (email.isEmpty) return 'Email is required';
    if (!isValidEmail(email)) return 'Please enter a valid email';
    return null;
  }
}
