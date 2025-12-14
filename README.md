# EcoVerseX App

## Overview

This is the Flutter mobile application for EcoVerseX, a hyperlocal sustainability platform. It supports Android and iOS, featuring gamified eco-actions, carbon tracking, and EcoCoin rewards.

## Features

- Dashboard with Tree Growth Animation
- Activity Logging with Photo Verification
- Missions and Challenges
- EcoShop for Redeeming EcoCoins
- AgriTours Booking
- Carbon Calculator
- Community Leaderboards

## Setup Instructions

### Prerequisites

- Flutter SDK (version 3.0+)
- Dart SDK
- Android Studio or Xcode for emulators
- Firebase CLI for authentication

### Installation

1. Clone the repository:

   ```bash
   git clone <repo-url>
   cd EcoVerseX_App
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Configure Firebase:

   - Add your Firebase config files to `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist`
   - Enable Authentication (Google, Email/Password)

4. Run the app:
   ```bash
   flutter run
   ```

### Project Structure

- `lib/`: Main source code
  - `screens/`: UI screens (Dashboard, Missions, etc.)
  - `widgets/`: Reusable components
  - `models/`: Data models
  - `services/`: API and Firebase services
- `assets/`: Images, animations, icons

### Dependencies

- `firebase_auth`: Authentication
- `cloudinary_public`: Image uploads
- `lottie`: Animations
- `provider`: State management

## Development Notes

- Use Riverpod for state management.
- All images are uploaded to Cloudinary for verification.
- Offline mode is not supported in MVP.

## Contributing

Follow Flutter best practices. Run tests before committing.
