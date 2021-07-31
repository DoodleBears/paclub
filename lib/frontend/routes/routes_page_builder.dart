// TOP:     Coming(Enter) page, from (1, 0) to (0, 0)
// BELOW:   Leaving(Exit) page, from (0, 0) to (-1, 0)
// OFFSET:  BOTH CENTER to LEFT
import 'package:flutter/widgets.dart';
import 'package:paclub/frontend/utils/transitions.dart';

class ShiftLeftRoute extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;
  ShiftLeftRoute({
    required this.exitPage,
    required this.enterPage,
  }) : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return enterPage;
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return Stack(
              children: <Widget>[
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.0),
                    end: const Offset(-1.0, 0.0),
                  ).animate(
                    CurvedAnimation(
                      parent: secondaryAnimation,
                      curve: Curves.easeInOutCubic,
                      reverseCurve: Curves.easeInOutCubic,
                    ),
                  ),
                  child: child,
                ),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOutCubic,
                      reverseCurve: Curves.easeInOutCubic,
                    ),
                  ),
                  child: child,
                )
              ],
            );
          },
        );
}

// TOP:     Coming(Enter) page, from (1, 0) to (0, 0)
// BELOW:   Leaving(Exit) page, from (0, 0) to (-0.33, 0)
// OFFSET:  BOTH CENTER to LEFT
class TopLeftMaskBelowleftRoute extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;
  TopLeftMaskBelowleftRoute({
    required this.exitPage,
    required this.enterPage,
  }) : super(
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return enterPage;
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return Stack(
              children: <Widget>[
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.0),
                    end: const Offset(-0.33, 0.0),
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                      reverseCurve: Curves.easeInCubic,
                    ),
                  ),
                  child: exitPage,
                ),
                DarkCurtainFade(
                  animation: animation,
                  begin: 0.0,
                  end: 1.0,
                ),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                      reverseCurve: Curves.easeInCubic,
                    ),
                  ),
                  child: enterPage,
                )
              ],
            );
          },
        );
}

// TOP:     Leaving(Exit) page, from (0, 0) to (1.0, 0)
// BELOW:   Coming(Enter) page, from (0, 0) to (0, 0)
// OFFSET:  TOP CENTER to DOWN, BELOW STAY
class BelowDownTopHoldRoute extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;
  BelowDownTopHoldRoute({
    required this.exitPage,
    required this.enterPage,
  }) : super(
          // super 是指套用 extends 继承的东西的参数，并对其中的个别做设置
          // opaque: false,
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          // barrierColor: Color(0xaa000000),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return enterPage;
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            // Stack 下方的children 呈现在越Top的child，会盖住Below下方的child

            return Stack(
              children: <Widget>[
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.0),
                    end: const Offset(0.0, 0.0),
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOutCubic,
                      reverseCurve: Curves.easeInOutCubic,
                    ),
                  ),
                  child: enterPage,
                ),
                DarkCurtainFade(animation: animation),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset.zero,
                    end: const Offset(0.0, 1.0),
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOutCubic,
                      reverseCurve: Curves.easeInOutCubic,
                    ),
                  ),
                  child: exitPage,
                )
              ],
            );
          },
        );
}
