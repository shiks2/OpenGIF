import 'package:go_router/go_router.dart';
import 'features/home_screen.dart';
import 'features/upload_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/upload', builder: (context, state) => const UploadScreen()),
  ],
);
