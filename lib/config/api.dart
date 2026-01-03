class ApiConfig {
  // Configuration flags
  static const bool useMockData =
      false; // Set to true to use mock data for testing

  // Backend base URL - change this to your backend server URL
  // For Android emulator, use 10.0.2.2
  // For physical devices, use your machine's local IP (e.g., 192.168.0.101)
  // IMPORTANT:
  // 1. Ensure Windows Firewall allows port 3001.
  // 2. Ensure your Wi-Fi is set to "Private" (not "Public") in Windows Settings.
  // 3. Ensure phone and PC are on the SAME Wi-Fi network.
  static const String baseUrl =
      'http://192.168.0.100:3001/api'; // Physical device IP
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
