import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

// Coming(Enter), from (1, 0) to (0, 0)
// Leaving(Exit), from (0, 0) to (-0.33, 0)
// OFFSET:  BOTH CENTER to LEFT
class TopLeftBelowleftTransitions extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve curve,
      Alignment alignment,
      Animation<double> animation, // coming page
      Animation<double> secondaryAnimation, // leaving page
      Widget child) {
    return Align(
      alignment: Alignment.center,
      child: SlideTransition(
        // coming page from right to center
        position: Tween(begin: Offset(1.0, 0.0), end: Offset(0, 0))
            .chain(CurveTween(curve: Curves.easeInOutCubic))
            .animate(secondaryAnimation),
        child: SlideTransition(
          // leaving page from center to left
          position: Tween(begin: Offset.zero, end: Offset(-0.33, 0))
              .chain(CurveTween(curve: Curves.easeInOutCubic))
              .animate(animation),
          child: child,
        ),
      ),
    );
  }
}

// Coming(Enter), from (1, 0) to (0, 0)
// Leaving(Exit), from (0, 0) to (-1, 0)
// OFFSET:  BOTH CENTER to LEFT
class ShiftLeftTransitions extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve curve,
      Alignment alignment,
      Animation<double> animation, // coming page
      Animation<double> secondaryAnimation, // leaving page
      Widget child) {
    return Align(
      alignment: Alignment.center,
      child: SlideTransition(
        // coming page from right to center
        position: Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeInOutCubic))
            .animate(secondaryAnimation),
        child: SlideTransition(
          // leaving page from center to left
          position: Tween(begin: Offset.zero, end: Offset(-1.0, 0.0))
              .chain(CurveTween(curve: Curves.easeInOutCubic))
              .animate(animation),
          child: child,
        ),
      ),
    );
  }
}

// TOP:     Coming(Enter) page, from (1, 0) to (0, 0)
// BELOW:   Leaving(Exit) page, from (0, 0) to (-1, 0)
// OFFSET:  BOTH CENTER to LEFT
class ShiftLeftRoute extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;
  ShiftLeftRoute({this.exitPage, this.enterPage})
      : super(
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
class TopLeftBelowleftRoute extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;
  TopLeftBelowleftRoute({this.exitPage, this.enterPage})
      : super(
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
                      curve: Curves.easeInOutCubic,
                      reverseCurve: Curves.easeInOutCubic,
                    ),
                  ),
                  child: exitPage,
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
  BelowDownTopHoldRoute({this.exitPage, this.enterPage})
      : super(
          // super 是指套用 extends 继承的东西的参数，并对其中的个别做设置
          transitionDuration: const Duration(milliseconds: 450),
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
