String? validatePassword(String password) {
  var lengthTest = PasswordTest(RegExp(r'^.{12,}$'), 'Password must be at least 12 characters long.');
  var lowerCaseTest = PasswordTest(RegExp(r'[a-z]'), 'Password must contain at least one lowercase letter.');
  var upperCaseTest = PasswordTest(RegExp(r'[A-Z]'), 'Password must contain at least one uppercase letter.');
  var digitTest = PasswordTest(RegExp(r'[0-9]'), 'Password must contain at least one digit.');
  var specialCharacterTest = PasswordTest(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'), 'Password must contain at least one special character.');
  
  for (var test in [lengthTest, lowerCaseTest, upperCaseTest, digitTest, specialCharacterTest]) {
    if (!test.regexp.hasMatch(password)) {
      return test.message;
    }
  }
  return null;
}

class PasswordTest {
  PasswordTest(this.regexp, this.message);
  
  final RegExp regexp;
  final String message;
}
