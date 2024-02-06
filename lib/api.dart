import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart' ;
import 'package:firebase_messaging/firebase_messaging.dart' ;

class FirebaseApi{
  // instance
  final _FirebaseMessaging  = FirebaseMessaging.instance ;

  Future <void> initNotification() async {
    await _FirebaseMessaging.requestPermission();
    String? fCMToken = await _FirebaseMessaging.getToken()  ;
    print("ghh");
    print( '$fCMToken' );
    print( _FirebaseMessaging.getToken());
  }
}