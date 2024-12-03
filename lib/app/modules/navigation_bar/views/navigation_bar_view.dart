import 'package:florist/app/modules/flower_care_reminder/views/flower_care_reminder_view.dart';
import 'package:florist/app/modules/sales_report/views/sales_report_view.dart';
import 'package:flutter/material.dart';
import '../../../data/model/nav_bar.dart';
import '../../../data/model/nav_model.dart';
import '../../home/views/home_view.dart';
import '../../profile/views/profile_view.dart';

class NavigationBarView extends StatefulWidget {
  
  const NavigationBarView({Key? key}) : super(key: key);

  @override
  State<NavigationBarView> createState() => _NavigationBarViewState();
}

class _NavigationBarViewState extends State<NavigationBarView> {
  
  final homeNavKey = GlobalKey<NavigatorState>();
  final searchNavKey = GlobalKey<NavigatorState>();
  final notificationNavKey = GlobalKey<NavigatorState>();
  final profileNavKey = GlobalKey<NavigatorState>();
  
  int selectedTab = 0;
  late List<NavModel> items;

  @override
  void initState() {
    super.initState();
    items = [
      NavModel(page: const HomeView(), navKey: homeNavKey),
      NavModel(page:  SalesReportView(), navKey: searchNavKey),
      NavModel(page: const FlowerCareReminderView(), navKey: notificationNavKey),
      NavModel(page: const ProfileView(), navKey: profileNavKey),
    ];
  }

   @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () {
        if (items[selectedTab].navKey.currentState?.canPop() ?? false) {
          items[selectedTab].navKey.currentState?.pop();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: selectedTab,
          children: items
              .map((page) => Navigator(
                    key: page.navKey,
                    onGenerateInitialRoutes: (navigator, initialRoute) {
                      return [
                        MaterialPageRoute(builder: (context) => page.page),
                      ];
                    },
                  ))
              .toList(),
        ),
        bottomNavigationBar: NavBar(
          pageIndex: selectedTab,
          onTap: (index) {
            if (index == selectedTab) {
              items[index].navKey.currentState?.popUntil((route) => route.isFirst);
            } else {
              setState(() {
                selectedTab = index;
              });
            }
          },
        ),
      ),
    );
  }
}
