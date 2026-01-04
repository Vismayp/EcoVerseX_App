import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/api.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
    sendTimeout: const Duration(seconds: 60),
  ));
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

  // Generic methods for new endpoints
  Future<Response> get(String path) async {
    return await _dio.get('${ApiConfig.baseUrl}$path');
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post('${ApiConfig.baseUrl}$path', data: data);
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

  Future<Map<String, dynamic>> createActivity(Map<String, dynamic> data,
      {String? imagePath}) async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return {
        'id': 'new_act_${DateTime.now().millisecondsSinceEpoch}',
        ...data,
        'carbonSaved': 1.0, // Mock calculation
      };
    }

    dynamic body;
    if (imagePath != null) {
      body = FormData.fromMap({
        ...data,
        'image': await MultipartFile.fromFile(imagePath),
      });
    } else {
      body = data;
    }

    final response = await _dio.post(ApiConfig.activities, data: body);
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

  Future<void> logMissionProgress(String missionId, Map<String, dynamic> data,
      {String? imagePath}) async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return;
    }

    dynamic body;
    if (imagePath != null) {
      body = FormData.fromMap({
        ...data,
        'image': await MultipartFile.fromFile(imagePath),
      });
    } else {
      body = data;
    }

    await _dio.post(ApiConfig.logMissionProgress(missionId), data: body);
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

  Future<Map<String, dynamic>> createOrder(
      String itemId, int quantity, String mobileNumber) async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return {'status': 'success', 'orderId': 'mock_order_123'};
    }
    final response = await _dio.post(ApiConfig.shopOrders, data: {
      'itemId': itemId,
      'quantity': quantity,
      'mobileNumber': mobileNumber,
    });
    return response.data;
  }

  Future<List<dynamic>> getMyOrders() async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return [];
    }
    final response = await _dio.get(ApiConfig.myOrders);
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

  Future<Map<String, dynamic>> bookTour(String tourId, int tickets,
      DateTime bookingDate, String mobileNumber) async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return {'status': 'success', 'bookingId': 'mock_booking_123'};
    }
    final response = await _dio.post(ApiConfig.bookTour, data: {
      'tourId': tourId,
      'tickets': tickets,
      'bookingDate': bookingDate.toIso8601String(),
      'mobileNumber': mobileNumber,
    });
    return response.data;
  }

  Future<List<dynamic>> getMyBookings() async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return [
        {
          'id': 'booking_1',
          'tour': {'name': 'Organic Farm Visit', 'location': 'California'},
          'tickets': 2,
          'totalCost': 200,
          'status': 'PENDING',
          'createdAt': DateTime.now().toIso8601String(),
        }
      ];
    }
    final response = await _dio.get(ApiConfig.myBookings);
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

  Future<void> trackCircleClick(String id) async {
    if (ApiConfig.useMockData) return;
    await _dio.post(ApiConfig.trackCircleClick(id));
  }

  // --- Notifications ---

  Future<List<dynamic>> getNotifications() async {
    if (ApiConfig.useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return [
        {
          'id': 'notif_1',
          'title': 'Welcome to EcoVerse!',
          'body': 'Start your journey to a greener planet today.',
          'createdAt': DateTime.now()
              .subtract(const Duration(hours: 2))
              .toIso8601String(),
          'isRead': false,
        },
      ];
    }
    final response = await _dio.get(ApiConfig.notifications);
    return response.data;
  }

  Future<void> markNotificationAsRead(String id) async {
    if (ApiConfig.useMockData) return;
    await _dio.patch(ApiConfig.markNotificationRead(id));
  }

  // --- Carbon Market ---

  Future<List<dynamic>> getCarbonProjects() async {
    if (ApiConfig.useMockData) {
      return [];
    }
    try {
      final response = await _dio.get('${ApiConfig.baseUrl}/carbon/projects');
      return response.data;
    } catch (e) {
      print('Error fetching carbon projects: $e');
      return [];
    }
  }

  Future<void> buyCarbonCredits(String projectId, double credits) async {
    if (ApiConfig.useMockData) return;
    try {
      await _dio.post('${ApiConfig.baseUrl}/carbon/buy', data: {
        'projectId': projectId,
        'credits': credits,
      });
    } catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>> saveCarbonCalculation({
    required String projectName,
    required String treeSpecies,
    required int treeCount,
    required double annualSeq,
    required double totalSeq,
  }) async {
    if (ApiConfig.useMockData) {
      return {'id': 'mock_id', 'status': 'PENDING'};
    }
    try {
      final response = await _dio.post(ApiConfig.carbonCalculate, data: {
        'projectName': projectName,
        'treeSpecies': treeSpecies,
        'treeCount': treeCount,
        'annualSeq': annualSeq,
        'totalSeq': totalSeq,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
