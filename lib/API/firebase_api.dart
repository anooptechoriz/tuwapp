import 'package:firebase_messaging/firebase_messaging.dart';

import '../constants/constant.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void handleMsg(RemoteMessage? remoteMessage) {
    if (remoteMessage == null) return;
    //navigatorKey.currentState!.pushReplacementNamed(HomeScreen.routeName);
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

    FirebaseMessaging.instance.getInitialMessage().then(handleMsg);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMsg);
    FirebaseMessaging.onBackgroundMessage(handleBAckgroundMsg);
  }

  Future<void> handleBAckgroundMsg(RemoteMessage message) async {
    print("Title :${message.notification!.title}");
    print("Body :${message.notification!.body}");
    print("PayLoad :${message.data}");
    handleMsg(message);
  }

  Future<void> initNotifications() async {
    _firebaseMessaging.requestPermission();
    // _firebaseMessaging.getToken().then((token) {
    //   print("FCM Token: $token");
    // });
    final fCMToken = await _firebaseMessaging.getToken();
    fcmToken = fCMToken!;
    print("FCM Token: $fCMToken");
    initPushNotifications();
  }
}
