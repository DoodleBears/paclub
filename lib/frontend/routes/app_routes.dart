part of './app_pages.dart';

// 页面的 Routes 信息，即用来表示页面显示在 浏览器(Browser) 的链接内容
abstract class Routes {
  static const INITIAL = '/';
  static const UNKNOWN = '/404';
  static const SPLASH = '/splash';
  static const AUTH = '/auth';
  static const LOGIN = '/login';
  // static const REGISTER = '/register';
  static const REGISTER_FORM = '/register/form';
  static const REGISTER_ACCOUNT = '/register/account';
  static const WRITEPOST = '/wtire_post';
  static const TABS = '/tabs';
  static const HOME = '/home';
  static const CARD = '/card';
  static const MESSAGE = '/message';
  static const CHATROOMLIST = '/chatroom_list';
  static const CHATROOM = '/chatroom';
  static const USERSEARCH = '/user_search';
  static const NOTIFICATION = '/notification';
  static const OTHERUSER = '/user/:uid';
  static const USER = '/user/';
  static const EDIT_PROFILE = '/edit_profile';
}
