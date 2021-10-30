import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/utils/transitions.dart';
import 'package:paclub/frontend/views/auth/auth_binding.dart';
import 'package:paclub/frontend/views/auth/auth_page.dart';
import 'package:paclub/frontend/views/create_pack/create_pack_binding.dart';
import 'package:paclub/frontend/views/create_pack/create_pack_page.dart';
import 'package:paclub/frontend/views/main/card/card_binding.dart';
import 'package:paclub/frontend/views/main/card/card_page.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom/chatroom_binding.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom/chatroom_page.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom_list/chatroom_list_binding.dart';
import 'package:paclub/frontend/views/main/message/components/chatroom_list/chatroom_list_page.dart';
import 'package:paclub/frontend/views/main/message/components/user_search/user_search_binding.dart';
import 'package:paclub/frontend/views/main/message/components/user_search/user_search_page.dart';
import 'package:paclub/frontend/views/main/message/message_binding.dart';
import 'package:paclub/frontend/views/main/message/message_page.dart';
import 'package:paclub/frontend/views/main/notification/notification_binding.dart';
import 'package:paclub/frontend/views/main/notification/notification_page.dart';
import 'package:paclub/frontend/views/main/tabs/tabs_binding.dart';
import 'package:paclub/frontend/views/auth/login/login_binding.dart';
import 'package:paclub/frontend/views/auth/login/login_page.dart';
import 'package:paclub/frontend/views/main/user/edit_profile/edit_profile_binding.dart';
import 'package:paclub/frontend/views/main/user/edit_profile/edit_profile_page.dart';
import 'package:paclub/frontend/views/main/user/my_user_page.dart';
import 'package:paclub/frontend/views/main/user/user_binding.dart';
import 'package:paclub/frontend/views/main/user/user_page.dart';
import 'package:paclub/frontend/views/auth/register/account/register_account_binding.dart';
import 'package:paclub/frontend/views/auth/register/account/register_account_page.dart';
import 'package:paclub/frontend/views/auth/register/form/register_form_binding.dart';
import 'package:paclub/frontend/views/auth/register/form/register_form_page.dart';
import 'package:paclub/frontend/views/splash/splash_binding.dart';
import 'package:paclub/frontend/views/splash/splash_page.dart';
import 'package:paclub/frontend/views/main/tabs/tabs_page.dart';
import 'package:paclub/frontend/views/write_post/write_post_binding.dart';
import 'package:paclub/frontend/views/write_post/write_post_page.dart';

part './app_routes.dart';

double Function(BuildContext) gestureWidth(double width) {
  // 当前屏幕宽度减去 给定的 width（一般width设置为比手指的宽度短一些
  // 保证任何大小的屏幕，大拇指都可以从屏幕往右滑动而back
  return (BuildContext context) => context.width - width;
}

abstract class AppPages {
  // A list of <GetPage> 来表示不同页面的 name、binding 和 route 信息等
  // 之后可以用 GetX 的 name 相关的跳转方式
  static final pages = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashPage(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
        name: Routes.AUTH,
        page: () => AuthPage(),
        binding: AuthBinding(),
        customTransition: TopUpMaskBelowStayTransitions(),
        children: [
          GetPage(
            name: Routes.LOGIN,
            page: () => LoginPage(),
            binding: LoginBinding(),
            customTransition: ShiftLeftLinearTransitions(),
            popGesture: true,
            gestureWidth: gestureWidth(170),
            transitionDuration: const Duration(milliseconds: 200),
          ),
          GetPage(
            name: Routes.REGISTER_FORM,
            page: () => RegisterFormPage(),
            binding: RegisterFormBinding(),
            customTransition: ShiftLeftLinearTransitions(),
            popGesture: true,
            gestureWidth: gestureWidth(170),
            transitionDuration: const Duration(milliseconds: 200),
          ),
          GetPage(
            name: Routes.REGISTER_ACCOUNT,
            page: () => RegisterAccountPage(),
            binding: RegisterAccountBinding(),
            customTransition: ShiftLeftLinearTransitions(),
            popGesture: true,
            gestureWidth: gestureWidth(170),
            transitionDuration: const Duration(milliseconds: 200),
          ),
        ]),
    GetPage(
      name: Routes.TABS,
      binding: TabsBinding(),
      page: () => Tabs(),
      customTransition: TopUpMaskBelowStayTransitions(),
      transitionDuration: const Duration(milliseconds: 200),
      children: [
        GetPage(
          name: Routes.CARD,
          binding: CardBinding(),
          page: () => CardPage(),
          customTransition: TopLeftMaskBelowLeftTransitions(),
        ),
        GetPage(
          name: Routes.MESSAGE,
          binding: MessageBinding(),
          page: () => MessagePage(),
          customTransition: TopLeftMaskBelowLeftTransitions(),
          children: [
            GetPage(
              name: Routes.CHATROOMLIST,
              binding: ChatroomListBinding(),
              page: () => ChatroomListPage(),
              customTransition: TopLeftMaskBelowLeftTransitions(),
              children: [
                GetPage(
                  name: Routes.CHATROOM,
                  binding: ChatroomBinding(),
                  page: () => ChatroomPage(),
                  customTransition: TopLeftMaskBelowLeftLinearTransitions(),
                  transitionDuration: const Duration(milliseconds: 200),
                  gestureWidth: gestureWidth(170),
                ),
                GetPage(
                  name: Routes.USERSEARCH,
                  binding: UserSearchBinding(),
                  page: () => UserSearchPage(),
                  customTransition: TopLeftMaskBelowLeftLinearTransitions(),
                  transitionDuration: const Duration(milliseconds: 200),
                  gestureWidth: gestureWidth(170),
                ),
              ],
            ),
          ],
        ),
        GetPage(
          name: Routes.NOTIFICATION,
          binding: NotificationBinding(),
          page: () => NotificationPage(),
          customTransition: TopLeftMaskBelowLeftTransitions(),
        ),
        GetPage(
          name: Routes.USER,
          binding: UserBinding(),
          page: () => MyUserPage(),
          popGesture: true,
          gestureWidth: gestureWidth(170),
          customTransition: TopLeftMaskBelowLeftLinearTransitions(),
          transitionDuration: const Duration(milliseconds: 200),
          children: [
            GetPage(
              name: Routes.EDIT_PROFILE,
              binding: EditProfileBinding(),
              page: () => EditProfilePage(),
              customTransition: TopLeftMaskBelowLeftLinearTransitions(),
              popGesture: true,
              gestureWidth: gestureWidth(170),
              transitionDuration: const Duration(milliseconds: 200),
            ),
          ],
        ),
        GetPage(
          name: Routes.OTHERUSER,
          binding: UserBinding(),
          page: () => UserPage(),
          popGesture: true,
          gestureWidth: gestureWidth(170),
          customTransition: TopLeftMaskBelowLeftLinearTransitions(),
          transitionDuration: const Duration(milliseconds: 200),
        ),
      ],
    ),
    GetPage(
      name: Routes.WRITEPOST,
      page: () => WritePostPage(),
      binding: WritePostBinding(),
      customTransition: TopUpMaskBelowStayTransitions(),
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.CREATEPACK,
      page: () => CreatePackPage(),
      binding: CreatePackBinding(),
      customTransition: TopLeftMaskBelowLeftLinearTransitions(),
      popGesture: true,
      gestureWidth: gestureWidth(170),
      transitionDuration: const Duration(milliseconds: 200),
    ),
  ];
}
