import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../core/service_locator.dart';
import '../../core/constants.dart';
import '../../core/utilities.dart';

// The Data Model
class GifModel {
  final String id;
  final String title;
  final String url;

  GifModel({required this.id, required this.title, required this.url});

  factory GifModel.fromJson(Map<String, dynamic> json) {
    return GifModel(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Untitled',
      url: json['url'] ?? '',
    );
  }
}

// The State Notifier (Logic)
class GifNotifier extends StateNotifier<AsyncValue<List<GifModel>>> {
  GifNotifier() : super(const AsyncValue.loading()) {
    loadHomeFeed(); // Load home feed on startup
  }

  final Dio _dio = getIt<Dio>();

  /// Loads the home feed (all GIFs)
  Future<void> loadHomeFeed() async {
    try {
      state = const AsyncValue.loading();
      final response = await _dio.get(AppConstants.homeEndpoint);

      final List data = response.data;
      final gifs = data.map((e) => GifModel.fromJson(e)).toList();

      state = AsyncValue.data(gifs);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      logger.e("Failed to load home feed", error: e);
    }
  }

  Future<void> searchGifs(String query) async {
    try {
      state = const AsyncValue.loading();
      final response = await _dio.get(
        AppConstants.searchEndpoint,
        queryParameters: {'q': query},
      );

      final List data = response.data;
      final gifs = data.map((e) => GifModel.fromJson(e)).toList();

      state = AsyncValue.data(gifs);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      logger.e("Search failed", error: e);
    }
  }

  Future<bool> uploadGif(Map<String, dynamic> formData) async {
    try {
      await _dio.post(AppConstants.uploadEndpoint, data: formData);
      return true;
    } catch (e) {
      logger.e("Upload failed", error: e);
      return false;
    }
  }
}

// The Riverpod Provider
final gifProvider =
    StateNotifierProvider<GifNotifier, AsyncValue<List<GifModel>>>((ref) {
      return GifNotifier();
    });
