class AppValidator {
  AppValidator._();

static String? validateInput(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required.';
  }

  // Regular expression for email validation
  final emailRegExp = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');

  // Regular expression for phone number validation (10-15 digits, allows + at the start)
  final phoneRegExp = RegExp(r'^\+?[0-9]{10,15}$');

  if (emailRegExp.hasMatch(value)) {
    return null; // Valid email
  } else if (phoneRegExp.hasMatch(value)) {
    return null; // Valid phone number
  } else {
    return 'Enter a valid email or phone number.';
  }
}


  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    // Check for minimum password length
    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }
// Check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }

// Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number.';
    }

// Check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character.';
    }
    return null;

  }

  
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    }

    // Regular expression for phone number validation (assuming a 10-digit US phone number format)
    final phoneRegExp = RegExp(r'^\d{10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number format (10 digits required).';
    }

    return null;
  }


}
