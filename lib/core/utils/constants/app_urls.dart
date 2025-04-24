class AppUrls {
  AppUrls._();

  // static const String _baseUrl = 'https://employee-beryl.vercel.app/api/v1';
  static const String _baseUrl = 'http://10.0.20.19:5000/api/v1';
  static const String login = '$_baseUrl/auth/login';
  static const String singUp = '$_baseUrl/users/register';
  static const String forgotPassword = '$_baseUrl/auth/forgot-password';
}
