class AppConstants {
  // Run with: flutter run --dart-define=BASE_URL=http://10.0.2.2:8080
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue:
        'http://localhost:8080', // Default to Android Emulator Localhost
  );

  static const String uploadEndpoint = '/upload';
  static const String searchEndpoint = '/search';
  static const String homeEndpoint = '/home';
}
