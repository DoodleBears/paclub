import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/widgets/widgets.dart';

class DraggableScrollableAttachableSheet extends StatefulWidget {
  const DraggableScrollableAttachableSheet({
    Key? key,
    this.thresholdToFullyOpen = 80.0,
    this.thresholdToNormal = 80.0,
    this.thresholdToClose = 80.0,
    this.isAllowFullyOpen = false,
    this.fullyOpenHeight,
    required this.height,
    required this.child,
    required this.onDragComplete,
    required this.onDrag,
    this.bottomSheetController,
  })  : assert(fullyOpenHeight != null || isAllowFullyOpen == false),
        super(key: key);
  final SheetController? bottomSheetController;
  final ValueChanged<SheetState> onDragComplete;
  final ValueChanged<double> onDrag;

  /// If you want to use fullyOpen sheet, you must set [isAllowFullyOpen] to true and give [fullyOpenHeight]
  final bool? isAllowFullyOpen;

  /// If you want to use fullyOpen sheet, you must set [isAllowFullyOpen] to true and give [fullyOpenHeight]
  final double? fullyOpenHeight;
  final double thresholdToFullyOpen;
  final double thresholdToNormal;
  final double thresholdToClose;
  final double height;
  final Widget child;
  @override
  State<DraggableScrollableAttachableSheet> createState() =>
      _DraggableScrollableAttachableSheetState();
}

class _DraggableScrollableAttachableSheetState
    extends State<DraggableScrollableAttachableSheet> {
  bool isDraging = false;
  SheetState bottomSheetState = SheetState.close;
  double bottomSheetHeight = 0.0;
  double bottomSheetStateHeight = 0.0;
  double dragStartDy = 0.0;

  @override
  void initState() {
    super.initState();
    // NOTE: 初始化默认高度
    widget.bottomSheetController?.controlerInit(this);
    bottomSheetHeight = widget.height;
    bottomSheetStateHeight = widget.height;
  }

  void drag(double offset) {
    if (widget.isAllowFullyOpen == false && offset > 0) {
      return;
    }
    setState(() {
      bottomSheetHeight = bottomSheetStateHeight + offset;
    });
    widget.onDrag(offset);
  }

  void dragComplete(double velocity) {
    // print(velocity);
    if (bottomSheetState == SheetState.fullyOpen) {
      if (bottomSheetHeight < widget.height - widget.thresholdToClose ||
          velocity > 1300.0) {
        closeBottomSheet();
      } else if (bottomSheetHeight <
              widget.fullyOpenHeight! - widget.thresholdToNormal ||
          velocity > 600.0) {
        toNormalBottomSheet();
      } else {
        toFullyOpenBottomSheet();
      }
    } else if (bottomSheetState == SheetState.normal) {
      if (bottomSheetHeight < widget.height - widget.thresholdToClose ||
          velocity > 600.0) {
        closeBottomSheet();
      } else if (bottomSheetHeight >
              widget.height + widget.thresholdToFullyOpen ||
          velocity < -600.0) {
        if (widget.isAllowFullyOpen!) {
          toFullyOpenBottomSheet();
        }
      } else {
        toNormalBottomSheet();
      }
    }
  }

  void toNormalBottomSheet() {
    setState(() {
      isDraging = false;
      bottomSheetState = SheetState.normal;
      bottomSheetHeight = widget.height;
      bottomSheetStateHeight = bottomSheetHeight;
    });
    widget.onDragComplete(SheetState.normal);
  }

  void toFullyOpenBottomSheet() {
    widget.onDragComplete(SheetState.fullyOpen);
    setState(() {
      isDraging = false;
      bottomSheetState = SheetState.fullyOpen;
      bottomSheetHeight = widget.fullyOpenHeight!;
      bottomSheetStateHeight = bottomSheetHeight;
    });
  }

  void closeBottomSheet() {
    setState(() {
      isDraging = false;
      bottomSheetState = SheetState.close;
      bottomSheetHeight = widget.height;
      bottomSheetStateHeight = bottomSheetHeight;
    });
    widget.onDragComplete(SheetState.close);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      curve: Curves.easeOutCubic,
      bottom: bottomSheetState != SheetState.close ? 0.0 : -bottomSheetHeight,
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
            GestureDetector(
              onVerticalDragDown: (DragDownDetails dragDownDetails) {
                dragStartDy = dragDownDetails.localPosition.dy;
                setState(() {
                  isDraging = true;
                });
              },
              onVerticalDragUpdate: (DragUpdateDetails dragUpdateDetails) {
                drag(dragStartDy - dragUpdateDetails.localPosition.dy);
              },
              onVerticalDragEnd: (DragEndDetails dragEndDetails) {
                dragComplete(dragEndDetails.velocity.pixelsPerSecond.dy);
              },
              child: DragHandler(),
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

enum SheetState {
  fullyOpen,
  normal,
  close,
}

class SheetController {
  _DraggableScrollableAttachableSheetState? bottomSheetState;
  void controlerInit(
      _DraggableScrollableAttachableSheetState _choosePackBottomSheetState) {
    this.bottomSheetState = _choosePackBottomSheetState;
  }

  void fullyOpen() {
    bottomSheetState!.toFullyOpenBottomSheet();
  }

  void normalOpen() {
    bottomSheetState!.toNormalBottomSheet();
  }

  void close() {
    bottomSheetState!.closeBottomSheet();
  }
}
