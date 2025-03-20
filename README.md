# MyFinance - Personal Finance Tracker

## 📌 **Overview**
MyFinance is a Flutter-based mobile application that helps users manage their personal finances. The app allows users to add and categorize transactions, view financial summaries, generate reports, and monitor their spending habits. With secure authentication and notification features, MyFinance offers an efficient and user-friendly experience.

---

## 🛠 **Features**
- **Transaction Management:** Add, edit, and delete income and expense transactions.
- **Category Management:** Manage custom transaction categories.
- **Financial Dashboard:** View charts and summaries for better insights.
- **Reports:** Generate detailed reports for financial tracking.
- **User Authentication:** Sign up, sign in, and log out securely.
- **Notifications:** Get reminders for upcoming payments.
- **Profile Management:** Manage and update user details.

---

## 🚀 **Tech Stack**
- **Frontend:** Flutter (Dart)
- **Backend:** Firebase (Authentication and Database)
- **State Management:** Provider
- **Database:** Firestore
- **Notification Service:** Firebase Cloud Messaging (FCM)
- **Charts:** FL Chart

---

## 🧑‍💻 **Getting Started**

### Prerequisites
- Flutter SDK installed
- Dart installed
- Firebase account with a project set up

### Installation
1. Clone the repository:
    ```bash
    git clone https://github.com/manvip28/MyFinance.git
    cd MyFinance
    ```

2. Install dependencies:
    ```bash
    flutter pub get
    ```

3. Configure Firebase:
    - Add your `google-services.json` for Android or `GoogleService-Info.plist` for iOS.
    - Enable Email/Password authentication in Firebase.

4. Update **android/app/build.gradle** with the following:
    ```gradle
    dependencies {
        implementation platform('com.google.firebase:firebase-bom:32.7.0')
        implementation 'com.google.firebase:firebase-auth'
        implementation 'com.google.firebase:firebase-firestore'
        implementation 'com.google.firebase:firebase-messaging'
    }
    ```
    Ensure `apply plugin: 'com.google.gms.google-services'` is added at the bottom of `android/app/build.gradle`.

5. Update **android/build.gradle** with the following dependency in the `buildscript` section:
    ```gradle
    dependencies {
        classpath 'com.google.gms:google-services:4.4.1' // Ensure correct placement
    }
    ```

### Generating SHA Keys for Firebase
Firebase requires SHA-1 or SHA-256 keys for authentication and verification. Follow these steps to generate and add SHA keys:
1. Open a terminal and run the following command:
    ```bash
    keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
    ```
2. Copy the SHA1 or SHA256 key.
3. Go to your Firebase Console → Project Settings → Add Fingerprint → Paste the SHA key.

6. Run the app:
    ```bash
    flutter run
    ```

---

## 🏃 **How to Run**
1. Ensure you have an emulator or a physical device connected.
2. Run the following command to start the app:
    ```bash
    flutter run
    ```
3. For debugging or troubleshooting:
    ```bash
    flutter doctor
    ```
4. If using Firebase, ensure that the Firebase emulator or real-time services are active.

---

## 🛡 **Security**
- Secure authentication using Firebase Authentication.
- Data storage using Firestore with rules to ensure data privacy.

---

## 📦 **Project Structure**
```bash
lib
├── main.dart
├── models
│   ├── category.dart
│   ├── transaction.dart
├── providers
│   ├── category_provider.dart
│   ├── transaction_provider.dart
├── screens
│   ├── auth_screen.dart
│   ├── dashboard_screen.dart
│   ├── transaction_list_screen.dart
│   ├── category_management_screen.dart
│   ├── profile_screen.dart
│   ├── home_screen.dart
├── services
│   ├── auth_service.dart
│   ├── notification_service.dart
└── widgets
```

---

## 🤝 **Contributing**
Contributions are welcome! Please fork the repository and create a pull request.

---

## 📝 **License**
This project is licensed under the MIT License.

---


