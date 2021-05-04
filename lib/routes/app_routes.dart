part of './app_pages.dart';

// 页面的 Routes 信息，即用来表示页面显示在 浏览器(Browser) 的链接内容
abstract class Routes {
  static const INITIAL = '/';
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const PROFILE = '/profile';
  static const REGISTER = '/register';
  static const TASK = '/task';
  static const TASK_ADD = '/task-add';
  static const TASK_EDIT = '/task-edit';
  static const TASK_MOTHLY = '/task-mothly';
  static const TASK_DETAILS = '/task-details';
}
