import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../controller/main_navigation_controller.dart';
import '../utils/theme.dart';
import 'view/order/order_view.dart';
import 'view/pos/view/pos_view.dart';
import 'view/profile/view/profile_view.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin? fltNotification;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notitficationPermission();
    initMessaging();
  }

  void notitficationPermission() async {
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  void initMessaging() async {
    var androiInit = const AndroidInitializationSettings('@mipmap/ic_launcher');

    var iosInit = const IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);

    fltNotification = FlutterLocalNotificationsPlugin();

    fltNotification!.initialize(initSetting);

    if (messaging != null) {
      print('vvvvvvv');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {});
  }

  void showNotification(RemoteMessage message) async {
    var androidDetails = AndroidNotificationDetails(
      '1',
      message.notification!.title ?? '',
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF0f90f3),
    );
    var iosDetails = IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await fltNotification!.show(0, message.notification!.title ?? '',
        message.notification!.body ?? '', generalNotificationDetails,
        payload: 'Notification');
  }

  @override
  Widget build(BuildContext context) {
    final MainNavigationController controller = Get.find();
    List<Widget> views = [OrderView(), PosView(), ProfileView()];

    return GetBuilder<MainNavigationController>(
      builder: (_) {
        var _index = controller.index;
        return Scaffold(
          body: views[_index],
          bottomNavigationBar: Container(
            height: 84,
            child: Column(
              children: [
                Container(
                  height: 2.0,
                  color: theme.primary.withOpacity(0.8),
                ),
                Container(
                  height: 4.0,
                  color: theme.primary.withOpacity(0.8),
                ),
                BottomNavigationBar(
                    showUnselectedLabels: true,
                    currentIndex: _index,
                    type: BottomNavigationBarType.fixed,
                    onTap: (int _index) {
                      controller.changeNavIndex(_index);
                    },
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: CircleAvatar(
                          backgroundColor:
                              _index == 0 ? Colors.white : theme.primary,
                          child: Icon(
                            Icons.history,
                            color: _index == 0 ? theme.primary : Colors.white,
                          ),
                          radius: _index == 0 ? 22 : 16.0,
                        ),
                        label: "Your Order",
                      ),
                      BottomNavigationBarItem(
                        icon: CircleAvatar(
                          backgroundColor:
                              _index == 1 ? Colors.white : theme.primary,
                          child: Icon(
                            FontAwesomeIcons.cashRegister,
                            color: _index == 1 ? theme.primary : Colors.white,
                          ),
                          radius: _index == 1 ? 22 : 16.0,
                        ),
                        label: "POS",
                      ),
                      BottomNavigationBarItem(
                        icon: CircleAvatar(
                          backgroundColor:
                              _index == 2 ? Colors.white : theme.primary,
                          child: Icon(
                            Icons.people,
                            color: _index == 2 ? theme.primary : Colors.white,
                          ),
                          radius: _index == 2 ? 22 : 16.0,
                        ),
                        label: "Profile",
                      ),
                    ]),
              ],
            ),
          ),
        );
      },
    );
  }
}
