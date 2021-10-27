import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/widgets/widgets.dart';

class ChoosePackBottomSheet extends StatefulWidget {
  const ChoosePackBottomSheet({
    Key? key,
    this.thresholdToFullyOpen = 80.0,
    this.thresholdToNormal = 80.0,
    this.thresholdToClose = 80.0,
    required this.fullyOpenHeight,
    required this.height,
    required this.child,
    required this.isBottomSheetShow,
    required this.onDragComplete,
  }) : super(key: key);

  final ValueChanged<BottomSheetState> onDragComplete;
  final bool isBottomSheetShow;
  final double thresholdToFullyOpen;
  final double thresholdToNormal;
  final double thresholdToClose;
  final double fullyOpenHeight;
  final double height;
  final Widget child;
  @override
  State<ChoosePackBottomSheet> createState() => _ChoosePackBottomSheetState();
}

enum BottomSheetState {
  fullyOpen,
  normal,
  close,
}

class _ChoosePackBottomSheetState extends State<ChoosePackBottomSheet> {
  bool isDraging = false;
  BottomSheetState bottomSheetState = BottomSheetState.normal;
  double bottomSheetHeight = 0.0;

  @override
  void initState() {
    super.initState();
    // NOTE: 初始化默认高度

    bottomSheetHeight = widget.height;
  }

  void onDrag(double offset) {
    print(offset);
    setState(() {
      isDraging = true;
      bottomSheetHeight = widget.height + offset;
    });
  }

  void dragComplete(double velocity) {
    setState(() {
      isDraging = false;
    });
    if (bottomSheetState == BottomSheetState.fullyOpen) {
      if (bottomSheetHeight <
              widget.fullyOpenHeight - widget.thresholdToNormal ||
          velocity > 650.0) {
        toNormalBottomSheet();
      } else {
        toFullyOpenBottomSheet();
      }
    } else if (bottomSheetState == BottomSheetState.normal) {
      if (bottomSheetHeight < widget.height - widget.thresholdToClose ||
          velocity > 650.0) {
        closeBottomSheet();
      } else if (bottomSheetHeight >
              widget.height + widget.thresholdToFullyOpen ||
          velocity < -650.0) {
        toFullyOpenBottomSheet();
      } else {
        toNormalBottomSheet();
      }
    }
  }

  void toNormalBottomSheet() {
    widget.onDragComplete(BottomSheetState.normal);
    setState(() {
      bottomSheetState = BottomSheetState.normal;
      bottomSheetHeight = widget.height;
    });
  }

  void toFullyOpenBottomSheet() {
    widget.onDragComplete(BottomSheetState.fullyOpen);
    setState(() {
      bottomSheetState = BottomSheetState.fullyOpen;
      bottomSheetHeight = Get.height * 0.9;
    });
  }

  void closeBottomSheet() {
    widget.onDragComplete(BottomSheetState.close);
    setState(() {
      bottomSheetHeight = widget.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      curve: Curves.easeOutCubic,
      bottom: widget.isBottomSheetShow ? 0.0 : -bottomSheetHeight,
      left: 0.0,
      right: 0.0,
      duration: const Duration(milliseconds: 300),
      child: FadeInScaleContainer(
        isShow: true,
        scaleDuration: isDraging
            ? const Duration(milliseconds: 1)
            : const Duration(milliseconds: 150),
        scaleCurve: Curves.ease,
        width: double.infinity,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
          ),
          color: AppColors.bottomSheetBackgoundColor,
        ),
        height: bottomSheetHeight,
        child: Column(
          // NOTE: 小把手
          children: [
            Draggable(
              feedback: SizedBox.shrink(),
              child: DragHandler(),
              onDragUpdate: (DragUpdateDetails dragUpdateDetails) {
                onDrag(context.height -
                    widget.height -
                    dragUpdateDetails.globalPosition.dy);
              },
              onDraggableCanceled: (Velocity velocity, Offset offset) {
                dragComplete(velocity.pixelsPerSecond.dy);
              },
            ),
            widget.child,
          ],
        ),
      ),
    );
  }
}

class DragHandler extends StatelessWidget {
  const DragHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: Container(
          decoration: ShapeDecoration(
            shape: StadiumBorder(),
            color: AppColors.bottomSheetHandlerColor,
          ),
          height: 6.0,
          width: 40.0,
        ),
      ),
    );
  }
}
