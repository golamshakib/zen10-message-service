class AppUrls {
  AppUrls._();

  // static const String _baseUrl = 'https://employee-beryl.vercel.app/api/v1';
  static const String _baseUrl = 'http://10.0.20.36:8013/api/v1';
  static const String baseUrl = 'http://10.0.20.36:8013/api/v1';
  static const String login = '$_baseUrl/auth/login';
  static const String singUp = '$_baseUrl/auth/register-user';
  static const String forgotPassword = '$_baseUrl/auth/forgot-password';
  static const String verifyOtp = '$_baseUrl/auth/verify-reset-password-otp';
  static const String changePassword = '$_baseUrl/auth/reset-password';
  static const String fetchProfile = '$_baseUrl/users/me';
  static const String getNearByLocations = '$_baseUrl/locations/get-nearby-locations';
  static const String getUpcomingLocations = '$_baseUrl/locations/get-upcoming-locations';
}
