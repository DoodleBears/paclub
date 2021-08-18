part of './app_pages.dart';

// 页面的 Routes 信息，即用来表示页面显示在 浏览器(Browser) 的链接内容
abstract class Routes {
  static const INITIAL = '/';
  static const UNKNOWN = '/404';
  static const SPLASH = '/splash';
  static const AUTH = '/auth';
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const PROFILE = '/profile';
  static const EDIT_PROFILE = '/edit_profile';
  static const REGISTER = '/register';
  static const REGISTER_FORM = '/register/form';
  static const REGISTER_ACCOUNT = '/register/account';
}
