import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../feature/contact/presentation/screen/contact_list/contact_list_screen.dart';
import '../feature/contact/presentation/screen/contact_manage/contact_manage_screen.dart';
import '../feature/error/presentation/screen/error/error_screen.dart';

// The route configuration.
final GoRouter appRouter = GoRouter(
  errorPageBuilder: customPageBuilder(const ErrorScreen()), // 에러 페이지 핸들러 추가
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      pageBuilder: customPageBuilder(const ContactListScreen()),
      routes: <RouteBase>[
        GoRoute(
          path: 'contact-manage',
          pageBuilder: (context, state) => customPageBuilder(
                  ContactManageScreen(
                      arguments: state.extra as ContactManageScreenArguments))(
              context, state),
        ),
        // GoRoute(
        //   path: 'sample',
        //   pageBuilder: customPageBuilder(const SampleScreen()),
        // ),
      ],
    ),
  ],
);

Page<dynamic> Function(BuildContext, GoRouterState) customPageBuilder<T>(
  Widget child,
) =>
    (BuildContext context, GoRouterState state) {
      return CupertinoPage(child: child);
    };
