class ApiConfig {
  // Configuration flags
  static const bool useMockData =
      false; // Set to true to use mock data for testing

  // Backend base URL - change this to your backend server URL
  static const String baseUrl =
      'http://192.168.0.6:3001/api'; // For Android emulator
  // static const String baseUrl = 'http://localhost:3000/api'; // For web or iOS simulator
  // static const String baseUrl = 'https://your-production-url.com/api'; // For production

  // User Endpoints
  static const String userProfile = '$baseUrl/user/profile';
  static const String userSync = '$baseUrl/user/sync';
  static const String userFcmToken = '$baseUrl/user/fcm-token';
  static const String userStats = '$baseUrl/user/stats';
  static const String leaderboard = '$baseUrl/user/leaderboard';

  // Activity Endpoints
  static const String activities =
      '$baseUrl/activities'; // GET (list), POST (create)

  // Mission Endpoints
  static const String missions = '$baseUrl/missions'; // GET (list)
  static String joinMission(String id) => '$baseUrl/missions/$id/join';
  static String updateMissionProgress(String id) =>
      '$baseUrl/missions/$id/progress';

  // Shop Endpoints
  static const String shopItems = '$baseUrl/shop/items';
  static const String shopOrders = '$baseUrl/shop/orders';

  // AgriTour Endpoints
  static const String tours = '$baseUrl/tours'; // GET (list)
  static const String bookTour = '$baseUrl/tours/book';

  // Carbon Endpoints
  static const String carbonCalculate = '$baseUrl/carbon/calculate';
  static const String myCarbonCredits = '$baseUrl/carbon/my-credits';

  // Community Endpoints
  static const String circles = '$baseUrl/circles'; // GET (list)
  static String joinCircle(String id) => '$baseUrl/circles/$id/join';

  // Notification Endpoints
  static const String sendNotification = '$baseUrl/notifications/send';
}
