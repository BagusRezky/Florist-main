import 'package:get/get.dart';

import '../modules/detail_sales_report/bindings/detail_sales_report_binding.dart';
import '../modules/detail_sales_report/views/detail_sales_report_view.dart';
import '../modules/flower_care_reminder/bindings/flower_care_reminder_binding.dart';
import '../modules/flower_care_reminder/views/flower_care_reminder_view.dart';
import '../modules/flower_detail/bindings/flower_detail_binding.dart';
import '../modules/flower_detail/views/flower_detail_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/navigation_bar/bindings/navigation_bar_binding.dart';
import '../modules/navigation_bar/views/navigation_bar_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/record_sales/bindings/record_sales_binding.dart';
import '../modules/record_sales/views/record_sales_view.dart';
import '../modules/sales_report/bindings/sales_report_binding.dart';
import '../modules/sales_report/views/sales_report_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.NAVIGATION_BAR,
      page: () => const NavigationBarView(),
      binding: NavigationBarBinding(),
    ),
    GetPage(
      name: _Paths.SALES_REPORT,
      page: () => const SalesReportView(),
      binding: SalesReportBinding(),
    ),
    GetPage(
      name: _Paths.RECORD_SALES,
      page: () => const RecordSalesView(),
      binding: RecordSalesBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.FLOWER_CARE_REMINDER,
      page: () => const FlowerCareReminderView(),
      binding: FlowerCareReminderBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_SALES_REPORT,
      page: () => const DetailSalesReportView(),
      binding: DetailSalesReportBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    // GetPage(
    //   name: _Paths.FLOWER_DETAIL,
    //   page: () => FlowerDetailView(flower: someFlowerInstance),

    //   binding: FlowerDetailBinding(),
    // ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
  ];
}
