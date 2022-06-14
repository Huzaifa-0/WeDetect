import 'package:flutter/material.dart';
import 'package:we_detect/Pages/Authenticated%20user/authenticated_user_pages.dart';
import 'package:we_detect/Pages/main_lunch_page.dart';
import 'package:we_detect/Pages/study%20case%20page/study_page.dart';
import 'package:we_detect/route_name.dart';

class Routes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => MainLunchPage());
      case RouteName.Covid_Study:
        return MaterialPageRoute(builder: (_) => const CovidStudyUserPage());
      case RouteName.Studies:
        return MaterialPageRoute(builder: (_) => const StudyPage());
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
//                  Image.asset('assets/images/error.jpg'),
                  Text(
                    "${settings.name} does not exists!",
                    style: const TextStyle(fontSize: 24.0),
                  )
                ],
              ),
            ),
          ),
        );
    }
  }
}
