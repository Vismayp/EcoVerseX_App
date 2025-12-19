import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/api.dart';

class ApiService {
  final Dio _dio = Dio();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ApiService() {
    // Base URL is handled in the full URL strings in ApiConfig,
    // but we can set a base option if we used relative paths.
    // Since ApiConfig has full URLs, we'll use them directly or override baseUrl here if we change ApiConfig to relative.
    // For now, ApiConfig has full URLs, so we'll just use them.

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add Auth Token
        final user = _auth.currentUser;
        if (user != null) {
          final token = await user.getIdToken();
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        // Handle errors globally if needed
        print('API Error: ${e.message}');
        return handler.next(e);
      },
    ));
  }

  // --- User ---

  Future<Map<String, dynamic>> getUserProfile() async {
    if (ApiConfig.useMockData) {
      await Future.delayed(
          const Duration(milliseconds: 500)); // Simulate latency
      return {
        'id': 'mock_user_123',
        'displayName': 'Eco Mock User',
        'email': 'mock@ecoverse.com',
        'photoURL': 'https://via.placeholder.com/150',
        'carbonSaved': 120.5,
        'ecoCoins': 500,
        'level': 5,
      };
    }
    final response = await _dio.get(ApiConfig.userProfile);
    return response.data;
  }

  Future<Map<String, dynamic>> syncUser() async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return {
        'id': 'mock_user_123',
        'status': 'synced',
      };
    }
    final response = await _dio.post(ApiConfig.userSync);
    return response.data;
  }

  Future<List<dynamic>> getLeaderboard() async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return [
        {'displayName': 'Alice', 'carbonSaved': 500.0, 'rank': 1},
        {'displayName': 'Bob', 'carbonSaved': 450.0, 'rank': 2},
        {'displayName': 'Charlie', 'carbonSaved': 400.0, 'rank': 3},
      ];
    }
    final response = await _dio.get(ApiConfig.leaderboard);
    return response.data;
  }

  // --- Activities ---

  Future<List<dynamic>> getMyActivities() async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return [
        {
          'id': 'act_1',
          'type': 'Transport',
          'description': 'Cycled to work',
          'carbonSaved': 2.5,
          'date': DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String(),
        },
        {
          'id': 'act_2',
          'type': 'Energy',
          'description': 'Used LED bulbs',
          'carbonSaved': 0.5,
          'date': DateTime.now()
              .subtract(const Duration(days: 2))
              .toIso8601String(),
        },
      ];
    }
    final response = await _dio.get(ApiConfig.activities);
    return response.data;
  }

  Future<Map<String, dynamic>> createActivity(Map<String, dynamic> data) async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return {
        'id': 'new_act_${DateTime.now().millisecondsSinceEpoch}',
        ...data,
        'carbonSaved': 1.0, // Mock calculation
      };
    }
    // Note: If uploading images, you'll need FormData
    final response = await _dio.post(ApiConfig.activities, data: data);
    return response.data;
  }

  // --- Missions ---

  Future<List<dynamic>> getMissions() async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return [
        {
          'id': 'mission_1',
          'title': 'Plastic Free Week',
          'description': 'Avoid single-use plastics for a week.',
          'reward': 100,
          'joined': false,
        },
        {
          'id': 'mission_2',
          'title': 'Plant a Tree',
          'description': 'Plant a tree in your neighborhood.',
          'reward': 500,
          'joined': true,
          'progress': 50,
        },
      ];
    }
    final response = await _dio.get(ApiConfig.missions);
    return response.data;
  }

  Future<void> joinMission(String id) async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      return;
    }
    await _dio.post(ApiConfig.joinMission(id));
  }

  // --- Shop ---

  Future<List<dynamic>> getShopItems() async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return [
        {
          'id': 'item_1',
          'name': 'Bamboo Toothbrush',
          'price': 50,
          'imageUrl': 'https://via.placeholder.com/100',
        },
        {
          'id': 'item_2',
          'name': 'Reusable Water Bottle',
          'price': 200,
          'imageUrl': 'https://via.placeholder.com/100',
        },
      ];
    }
    final response = await _dio.get(ApiConfig.shopItems);
    return response.data;
  }

  // --- AgriTours ---

  Future<List<dynamic>> getTours() async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return [
        {
          'id': 'tour_1',
          'name': 'Green Valley Farm',
          'location': 'California',
          'price': 50.0,
          'date': '2023-12-01',
        },
      ];
    }
    final response = await _dio.get(ApiConfig.tours);
    return response.data;
  }

  // --- Carbon ---

  Future<Map<String, dynamic>> getMyCredits() async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return {
        'totalCredits': 15.5,
        'history': [],
      };
    }
    final response = await _dio.get(ApiConfig.myCarbonCredits);
    return response.data;
  }

  // --- Community ---

  Future<List<dynamic>> getCircles() async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return [
        {
          'id': 'circle_1',
          'name': 'Eco Warriors NYC',
          'membersCount': 120,
        },
      ];
    }
    final response = await _dio.get(ApiConfig.circles);
    return response.data;
  }
}
