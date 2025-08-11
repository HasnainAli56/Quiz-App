# Firebase Setup Guide for Quiz App

## Prerequisites
- Flutter SDK installed
- Firebase project created
- Android Studio / Xcode for platform-specific setup

## Step 1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or select an existing project
3. Enter project name (e.g., "quiz-app")
4. Enable Google Analytics (optional)
5. Click "Create project"

## Step 2: Enable Authentication
1. In Firebase Console, go to "Authentication" → "Sign-in method"
2. Enable "Email/Password" authentication
3. Click "Save"

## Step 3: Enable Firestore Database
1. Go to "Firestore Database" → "Create database"
2. Choose "Start in test mode" for development
3. Select a location close to your users
4. Click "Done"

## Step 4: Android Setup
1. In Firebase Console, go to "Project settings" → "Your apps"
2. Click "Add app" → "Android"
3. Enter package name: `com.example.quiz_app`
4. Download `google-services.json`
5. Place it in `android/app/` directory
6. Update `android/build.gradle.kts` (already done)
7. Update `android/app/build.gradle.kts` (already done)

## Step 5: iOS Setup (if developing for iOS)
1. In Firebase Console, go to "Project settings" → "Your apps"
2. Click "Add app" → "iOS"
3. Enter bundle ID: `com.example.quizApp`
4. Download `GoogleService-Info.plist`
5. Place it in `ios/Runner/` directory
6. Add it to Xcode project

## Step 6: Web Setup (if developing for web)
1. In Firebase Console, go to "Project settings" → "Your apps"
2. Click "Add app" → "Web"
3. Copy the Firebase config object
4. Update `lib/firebase_options.dart` with your config

## Step 7: Update Firebase Options
Replace the placeholder values in `lib/firebase_options.dart` with your actual Firebase configuration:

```dart
// Replace these values with your actual Firebase config
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR-ANDROID-API-KEY',
  appId: 'YOUR-ANDROID-APP-ID',
  messagingSenderId: 'YOUR-SENDER-ID',
  projectId: 'YOUR-PROJECT-ID',
  storageBucket: 'YOUR-PROJECT-ID.appspot.com',
);
```

## Step 8: Firestore Security Rules
Update your Firestore security rules in Firebase Console:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Quiz scores are user-specific
    match /quizScores/{scoreId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
  }
}
```

## Step 9: Test the Setup
1. Run `flutter pub get` to install dependencies
2. Run the app on your device/emulator
3. Try to sign up with a new account
4. Verify that user data is created in Firestore
5. Take a quiz and verify score is saved

## Troubleshooting
- **Build errors**: Make sure `google-services.json` is in the correct location
- **Authentication errors**: Verify Email/Password is enabled in Firebase Console
- **Database errors**: Check Firestore security rules and database creation
- **Platform-specific issues**: Ensure platform-specific config files are properly placed

## Dependencies
The following Firebase packages are already added to `pubspec.yaml`:
- `firebase_core`: Core Firebase functionality
- `firebase_auth`: User authentication
- `cloud_firestore`: Firestore database

## Next Steps
After setup, you can:
1. Customize the UI and branding
2. Add more quiz categories
3. Implement user profiles and avatars
4. Add social features like leaderboards
5. Implement push notifications for quiz reminders 