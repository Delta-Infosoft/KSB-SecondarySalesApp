import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../firebase_options.dart';
import 'notification_service.dart';

/// Runs in a separate isolate when a message arrives while the app is in the
/// background or terminated. Must be a top-level function.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('FCM background message: ${message.messageId} ${message.data}');

  // "Notification" messages (e.g. from the Firebase console) are already shown
  // by the system tray in the background. Only data-only messages need us.
  if (message.notification == null) {
    await LocalNotificationService.initialize();
    await LocalNotificationService.showRemoteMessage(message);
  }
}

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static String? fcmToken;

  static bool _listenersAttached = false;

  /// Shows notifications while the app is open and handles notification taps.
  static Future<void> _attachListeners() async {
    if (_listenersAttached) return;
    _listenersAttached = true;

    // iOS: let the system show the banner itself while the app is open.
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Android never shows FCM notifications while the app is in the
    // foreground, so show them ourselves via flutter_local_notifications.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('FCM foreground message: ${message.messageId} '
          '${message.notification?.title} ${message.data}');
      if (Platform.isAndroid) {
        LocalNotificationService.showRemoteMessage(message);
      }
    });

    // User tapped a notification while the app was in the background.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification opened app: ${message.data}');
      // Handle navigation here if required.
    });

    // User tapped a notification while the app was terminated.
    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      debugPrint('App launched from notification: ${initial.data}');
    }
  }

  /// Waits up to [timeout] for iOS to hand over the APNs token. iOS gives it
  /// only after the app registered for remote notifications, and FCM can't
  /// issue a token before that. Returns false if it never arrived.
  static Future<bool> _waitForApns(Duration timeout) async {
    if (!Platform.isIOS) return true;
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      try {
        if (await _messaging.getAPNSToken() != null) return true;
      } catch (_) {}
      await Future.delayed(const Duration(milliseconds: 500));
    }
    return false;
  }

  /// Fetches the FCM token (after the APNs token on iOS) and stores it.
  static Future<String?> _fetchToken(Duration apnsTimeout) async {
    try {
      if (!await _waitForApns(apnsTimeout)) {
        debugPrint('APNs token not available yet');
        return null;
      }
      final token = await _messaging.getToken();
      if (token != null && token.isNotEmpty) {
        fcmToken = token;
        debugPrint('FCM Token: $token');
      }
      return token;
    } catch (e) {
      debugPrint('FCM getToken error: $e');
      return null;
    }
  }

  /// The device's FCM registration token, for sending to the backend (e.g.
  /// as `FCMId` at login). Uses the token fetched at startup, otherwise
  /// fetches it now (waiting a few seconds for APNs on iOS). Never throws:
  /// returns '' if Firebase can't provide a token (no permission, no
  /// network, push not set up).
  static Future<String> getToken() async {
    if (fcmToken != null && fcmToken!.isNotEmpty) return fcmToken!;
    final token = await _fetchToken(const Duration(seconds: 6))
        .timeout(const Duration(seconds: 10), onTimeout: () => null);
    return token ?? fcmToken ?? '';
  }

  // Initialize FCM and get token
  static Future<String?> initialize() async {
    try {
      await _attachListeners();

      // Keep the token current, including one that arrives late on iOS.
      _messaging.onTokenRefresh.listen((newToken) {
        fcmToken = newToken;
        debugPrint('FCM Token Refreshed: $newToken');
        // Update your backend API here
      });

      // Request notification permission
      final NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('Notification Permission: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        // The token still works for data messages; just no visible alerts.
        debugPrint('Notification permission denied');
      }

      // Don't hold up app start: give APNs a few seconds, then keep trying
      // in the background (login also retries via getToken()).
      final token = await _fetchToken(const Duration(seconds: 4));
      if (token == null) {
        unawaited(_fetchToken(const Duration(seconds: 30)));
      }
      return token;
    } catch (e) {
      debugPrint('FCM Initialization Error: $e');
      return null;
    }
  }
}
