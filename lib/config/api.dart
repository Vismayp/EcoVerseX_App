class ApiConfig {
  // Configuration flags
  static const bool useMockData =
      false; // Set to true to use mock data for testing

  // Backend base URL configurations
  static const String baseUrl =
      'http://192.168.0.102:3001/api'; // Physical device IP
  // static const String baseUrl = 'http://10.0.2.2:3001/api'; // Emulator
  // static const String baseUrl = 'http://localhost:3001/api'; // For iOS simulator or web
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
  static String logMissionProgress(String id) => '$baseUrl/missions/$id/log';
  static String updateMissionProgress(String id) =>
      '$baseUrl/missions/$id/progress';

  // Shop Endpoints
  static const String shopItems = '$baseUrl/shop/items';
  static const String shopOrders = '$baseUrl/shop/orders';
  static const String myOrders = '$baseUrl/shop/my-orders';

  // AgriTour Endpoints
  static const String tours = '$baseUrl/agritour'; // GET (list)
  static const String bookTour = '$baseUrl/agritour/book';
  static const String myBookings = '$baseUrl/agritour/my-bookings';

  // Carbon Endpoints
  static const String carbonCalculate = '$baseUrl/carbon/calculate';
  static const String myCarbonCredits = '$baseUrl/carbon/my-credits';

  // Community Endpoints
  static const String circles = '$baseUrl/circles'; // GET (list)
  static String joinCircle(String id) => '$baseUrl/circles/$id/join';
  static String trackCircleClick(String id) =>
      '$baseUrl/circles/$id/track-click';

  // Notification Endpoints
  static const String notifications = '$baseUrl/notifications';
  static const String sendNotification = '$baseUrl/notifications/send';
  static String markNotificationRead(String id) =>
      '$baseUrl/notifications/$id/read';
}
