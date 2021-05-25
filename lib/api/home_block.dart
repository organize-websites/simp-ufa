

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlocHome extends StatelessWidget{

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@override
  Widget build(BuildContext context) {

    return new MaterialApp(
    navigatorKey: navigatorKey
);
  }

  Future<void> initOneSignal() async {
    var settings = {
      OSiOSSettings.autoPrompt: true,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };
    await OneSignal.shared.init("f23a7bb4-e910-4230-8b8c-530d50587cb7", iOSSettings: settings);
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) async {
      print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });
    var status = await OneSignal.shared.getPermissionSubscriptionState();
    var url;
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
    
    OneSignal.shared.promptUserForPushNotificationPermission();

    OneSignal.shared.setNotificationReceivedHandler((OSNotification notification) { 
      
      url = notification.payload.additionalData["url"];
      /*Map mapResponse = json.decode(url);
      if(mapResponse["url"] != null){
        prefs.setString("urlpush", mapResponse["url"]);
      }*/
    }); 

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) async {
      /*var prefs = await SharedPreferences.getInstance();
      String url2 = (prefs.getString("urlpush") ?? "");
      print('Resultado:: $url2');*/
      print('Resultado: $url'); 
      
      if( url != null ) {
        var prefs = await SharedPreferences.getInstance();
        prefs.setString("urlpush", url);
        String u2 = prefs.getString("urlpush");
        print("Resultado:: $u2");
        }
    });


if (status.permissionStatus.hasPrompted)
  // we know that the user was prompted for push permission
  
if (status.permissionStatus.status == OSNotificationPermission.notDetermined)
  // boolean telling you if the user enabled notifications

if (status.subscriptionStatus.subscribed)
  // boolean telling you if the user is subscribed with OneSignal's backend

// the user's ID with OneSignal
String onesignalUserId = status.subscriptionStatus.userId;

// the user's APNS or FCM/GCM push token
String token = status.subscriptionStatus.pushToken;

String emailPlayerId = status.emailSubscriptionStatus.emailUserId;
String emailAddress = status.emailSubscriptionStatus.emailAddress;


  }





}